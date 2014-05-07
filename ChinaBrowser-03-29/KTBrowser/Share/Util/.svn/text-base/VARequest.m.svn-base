 //
//  VARequest.m
//  Hulaee
//
//  Created by David on 13-5-2.
//  Copyright (c) 2013年 VeryApps. All rights reserved.
//

#import "VARequest.h"

#import <AGCommon/NSString+Common.h>

#import "ASIFormDataRequest.h"
#import "CJSONSerializer.h"

#import "NSString+URL.h"

@implementation ASIHTTPRequest (VARequest)

+ (ASIHTTPRequest *)requestWithURL:(NSURL *)url dicParams:(NSDictionary *)dicParams {
    ASIFormDataRequest *req = [ASIFormDataRequest requestWithURL:url];
    [dicParams enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            [req addPostValue:obj forKey:key];
        }
        else if ([obj isKindOfClass:[NSNumber class]]) {
            [req addPostValue:[obj stringValue] forKey:key];
        }
        else if ([obj isKindOfClass:[NSArray class]]) {
            for (NSInteger idx=0; idx<[obj count]; idx++) {
                id item = [obj objectAtIndex:idx];
                if ([item isKindOfClass:[NSString class]]) {
                    [req addPostValue:item forKey:[NSString stringWithFormat:@"%@[%d]", key, idx]];
                }
                else if ([item isKindOfClass:[NSNumber class]]) {
                    [req addPostValue:[item stringValue] forKey:[NSString stringWithFormat:@"%@[%d]", key, idx]];
                }
            }
        }
    }];
    
    return req;
}

+ (ASIHTTPRequest *)requestSignWithUrl:(NSURL *)url dicParam:(NSDictionary *)dicParam {
    NSMutableString *str = [NSMutableString string];
    NSArray *keys = [[dicParam allKeys] sortedArrayUsingSelector:@selector(compare:)];
    _DEBUG_LOG(@"-------%@", NSStringFromSelector(_cmd));
    for (NSString *key in keys) {
        id value = [dicParam objectForKey:key];
        _DEBUG_LOG(@"%@=%@", key, value);
        if ([value isKindOfClass:[NSString class]]) {
            [str appendString:value];
        }
        else {
            [str appendString:[value stringValue]];
        }
    }
    NSString *sign = [str md5HexDigestString];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dicParam];
    [dic setObject:sign forKey:@"sign"];
    
    return [ASIHTTPRequest postRequestWithURL:url dicParam:dic];
}

+ (ASIHTTPRequest *)getRequestWithURL:(NSString *)url dicParam:(NSDictionary *)dicParam {
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@?", url];
    NSArray *keys = [[dicParam allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (NSString *key in keys) {
        [str appendString:key];
        [str appendString:@"="];
        id value = [dicParam objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            [str appendString:[value urlEncode]];
        }
        else {
            [str appendString:[value stringValue]];
        }
        [str appendString:@"&"];
    }
    [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    return request;
}

+ (ASIHTTPRequest *)postRequestWithURL:(NSURL *)url dicParam:(NSDictionary *)dicParam {
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [dicParam enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request setValue:obj forKey:key];
    }];
    return request;
}

+ (ASIHTTPRequest *)jsonRequestWithURL:(NSURL *)url dicParam:(NSDictionary *)dicParam {
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    if (dicParam && dicParam.allKeys.count) {
        [request setRequestMethod:@"POST"];
        request.timeOutSeconds = 10;
        [request addRequestHeader:@"Accept" value:@"application/json"];
        [request appendPostData:[[CJSONSerializer serializer] serializeDictionary:dicParam error:nil]];
    }
    
    return request;
}

+ (ASIHTTPRequest *)uploadRequestWithURL:(NSURL *)url filename:(NSString *)filename data:(NSData *)data {
    NSString *boundary = @"---KOTO---";
    NSMutableString *reqStr = [NSMutableString stringWithFormat:@"--%@\r\n", boundary];
    [reqStr appendFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@\"\r\nContent-Type: image/jpeg\r\n\r\n", filename];
    NSMutableData *reqData = [NSMutableData dataWithData:[reqStr dataUsingEncoding:NSUTF8StringEncoding]];
    [reqData appendData:data];
    [reqData appendData:[[NSString stringWithFormat:@"\r\n--%@--", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableDictionary *dicHeader = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary], @"Content-Type",
                                      [NSString stringWithFormat:@"%d", [reqData length]], @"Content-Length", nil];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostBody:reqData];
    request.timeOutSeconds = 30;
    request.showAccurateProgress = YES;
    [request setRequestHeaders:dicHeader];
    return request;
}

- (void)addImageData:(NSData *)imgData fileName:(NSString *)fileName forKey:(NSString *)key {
    if ([self isKindOfClass:[ASIFormDataRequest class]]) {
        ASIFormDataRequest *formRequest = (ASIFormDataRequest *)self;
        [formRequest setData:imgData withFileName:fileName andContentType:@"image/jpeg" forKey:key];
    }
}

- (void)addSoundData:(NSData *)soundData fileName:(NSString *)fileName forKey:(NSString *)key {
    if ([self isKindOfClass:[ASIFormDataRequest class]]) {
        ASIFormDataRequest *formRequest = (ASIFormDataRequest *)self;
        [formRequest setData:soundData withFileName:fileName andContentType:nil forKey:key];
    }
}

@end
