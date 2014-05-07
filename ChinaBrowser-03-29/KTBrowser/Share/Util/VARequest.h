//
//  VARequest.h
//  Hulaee
//
//  Created by David on 13-5-2.
//  Copyright (c) 2013年 VeryApps. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASIHTTPRequest.h"

@interface ASIHTTPRequest (VARequest)

+ (ASIHTTPRequest *)requestSignWithUrl:(NSURL *)url dicParam:(NSDictionary *)dicParam;

+ (ASIHTTPRequest *)getRequestWithURL:(NSURL *)url dicParam:(NSDictionary *)dicParam;
+ (ASIHTTPRequest *)postRequestWithURL:(NSURL *)url dicParam:(NSDictionary *)dicParam;

+ (ASIHTTPRequest *)jsonRequestWithURL:(NSURL *)url dicParam:(NSDictionary *)dicParam;
+ (ASIHTTPRequest *)uploadRequestWithURL:(NSURL *)url filename:(NSString *)filename data:(NSData *)data;

+ (ASIHTTPRequest *)requestWithURL:(NSURL *)url dicParams:(NSDictionary *)dicParams;
- (void)addImageData:(NSData *)imgData fileName:(NSString *)fileName forKey:(NSString *)key;
- (void)addSoundData:(NSData *)soundData fileName:(NSString *)fileName forKey:(NSString *)key;

@end
