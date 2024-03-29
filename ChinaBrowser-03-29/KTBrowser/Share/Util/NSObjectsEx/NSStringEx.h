//
//  NSStringEx.h
//  JiaoKaoTong
//
//  Created by David on 2011-11-11.
//  Copyright 2011 VeryApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSStringEx)

BOOL IsValidMobilePhoneNum(NSString *phoneNum);
BOOL IsValidEmail(NSString *emailStr, BOOL strictFilter);

NSString * UnicodeStrToUtf8Str(NSString *unicodeStr);
NSString * Utf8StrToUnicodeStr(NSString *utf8Str);

+ (NSString *)signWithParams:(NSDictionary *)dic;

+ (NSString *)sha1:(NSString *)str;

- (NSString*)md5;

- (NSString*)trimSpaceAndReturn;

+ (NSString *)stringWithTimeInterval:(NSTimeInterval)timeInterval;

+ (NSString *)stringInEngilshWithTimeInterval:(NSTimeInterval)timeInterval;

- (NSString*)fileNameMD5WithExtension:(NSString*)extension;

- (NSInteger)lengthOfZhCn;

@end

