//
//  NSStringEx.m
//  JiaoKaoTong
//
//  Created by David on 2011-11-11.
//  Copyright 2011 VeryApps. All rights reserved.
//

#import "NSStringEx.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (NSStringEx)

// 手机号码验证
BOOL IsValidMobilePhoneNum(NSString *phoneNum) {
    NSString *phoneRegex = @"^1(3[0-9]|4[57]|5[0-35-9]|8[025-9])\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    return [phoneTest evaluateWithObject:phoneNum];
}

// 邮箱格式验证
//  strictFilter 是否严格
BOOL IsValidEmail(NSString *emailStr, BOOL strictFilter) {
    NSString *emailRegex;
    if (strictFilter) {
        emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    }
    else {
        emailRegex = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    }
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:emailStr];
}

// Unicode 转换成中文
NSString * UnicodeStrToUtf8Str(NSString *unicodeStr) {
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData   *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

// 中文转换成 Unicode
NSString * Utf8StrToUnicodeStr(NSString *utf8Str) {
    NSMutableString *returnStr = [NSMutableString string];
    for (int i = 0;i < utf8Str.length; i++) {
        unichar _char = [utf8Str characterAtIndex:i];
        //判断是否为英文和数字
        if ((_char=='.') || (_char<='9' && _char>='0')
            || (_char>='a' && _char<='z')
            || (_char>='A' && _char<='Z')) {
            [returnStr appendFormat:@"%C", _char];
        }
        else {
            [returnStr appendFormat:@"\\u%x", _char];
        }
    }
    
    return returnStr;
}

// 生成参数签名
+ (NSString *)signWithParams:(NSDictionary *)dic {
    NSMutableString *str = [NSMutableString string];
    NSArray *keys = [[dic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (NSString *key in keys) {
        id value = [dic objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            [str appendString:value];
        }
        else {
            [str appendString:[value stringValue]];
        }
    }
    
    return [str md5];
}

+ (NSString *)sha1:(NSString *)str {
    const char *cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:str.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

- (NSString *)md5 {
	const char *cStr = [self?self:@"" UTF8String];
	unsigned char result[16];
	CC_MD5( cStr, strlen(cStr), result );
	return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]] lowercaseString];
}

- (NSString *)trimSpaceAndReturn {
	if ([self length]==0) {
		return @"";
	}
	int index = [self length]-1;
	NSRange range = {index, 1};
	NSString *tmp=nil;
	do {
		range.location = index;
		tmp = [self substringWithRange:range];
		if ([tmp isEqualToString:@" "]||[tmp isEqualToString:@"\r"]||[tmp isEqualToString:@"\n"]){
			index--;
			if (index<0)
				return @"";
		}
		else
			break;
	} while (YES);
	return [self substringToIndex:index+1];
}

/*
 根据时间戳，得到 与当前时间间隔的字符串
 秒：
 00 00:00:01 - 00 00:00:03：刚刚
 00 00:00:04 - 00 00:00:59：4-59 秒前
 分：
 00 00:01:00 - 00 00:59:59：1-59:59 分钟前
 时：
 00 01:00:00 - 00 23:59:59：1-23 小时前
 天：
 01 00:00:00 - 01 23:59:59：昨天
 02 00:00:00 - 03 23:59:59：2-3 天前
 04 00:00:00 - ...：2012-02-23 20:45:09（显示具体时间）
 */
+ (NSString *)stringWithTimeInterval:(NSTimeInterval)timeInterval {
    NSString *result = @"";
    NSTimeInterval current = [[NSDate date] timeIntervalSince1970];
    
    NSInteger dis = current-timeInterval;
    
    if (dis<=3) {
        result = @"刚刚";
    }
    else if (dis>=4 && dis<=59) {
        result = [NSString stringWithFormat:@"%d秒前", dis];
    }
    else if (dis>=1*60 && dis<=1*60*60-1) {
        result = [NSString stringWithFormat:@"%d分钟前", dis/60];
    }
    else if (dis>=1*60*60 && dis<=24*60*60-1) {
        result = [NSString stringWithFormat:@"%d小时前", dis/60/60];
    }
    else if (dis>=24*60*60 && dis<=2*24*60*60-1) {
        result = @"昨天";
    }
    else if (dis>=2*24*60*60 && dis<=3*24*60*60-1) {
        result = [NSString stringWithFormat:@"%d天前", dis/24/60/60];
    }
    else {
        NSDateFormatter *dfmt = [[NSDateFormatter alloc] init];
        [dfmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        result = [dfmt stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    }
    
    return result;
}

+ (NSString *)stringInEngilshWithTimeInterval:(NSTimeInterval)timeInterval {
    NSString *result = @"";
    NSTimeInterval current = [[NSDate date] timeIntervalSince1970];
    
    NSInteger dis = current-timeInterval;
    
    
    if (dis<=1) {
        result = [NSString stringWithFormat:@"1 sec ago"];
    }
    else if (dis>1 && dis<=59) {
        result = [NSString stringWithFormat:@"%d secs ago", dis];
    }
    else if (dis>=1*60 && dis<=1*60*60-1) {
        result = [NSString stringWithFormat:@"%d mins ago", dis/60];
    }
    else if (dis>=1*60*60 && dis<=24*60*60-1) {
        result = [NSString stringWithFormat:@"%d hours ago", dis/60/60];
    }
    else if (dis>=24*60*60 && dis<=2*24*60*60-1) {
        result = @"yesterday";
    }
    else if (dis>=2*24*60*60 && dis<=3*24*60*60-1) {
        result = [NSString stringWithFormat:@"%d days ago", dis/24/60/60];
    }
    else if (dis>=3*24*60*60-1 && dis<=24*60*60*31) {
        result = [NSString stringWithFormat:@"%d weeks ago", dis/24/60/60/7 + 1];
    }
    else {
        NSDateFormatter *dfmt = [[NSDateFormatter alloc] init];
        [dfmt setDateFormat:@"yyyy-MM-dd"];
        result = [dfmt stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    }
    
    return result;
}

// md5 加密 得到制定的 后缀名 的文件名
- (NSString *)fileNameMD5WithExtension:(NSString *)extension {
    NSString *filename = [[self md5] stringByAppendingPathExtension:extension?extension:extension?extension:@""];
    return filename;
}

- (NSInteger)lengthOfZhCn {
    int strlength = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    int len = [self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0; i<len; i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
}

@end
