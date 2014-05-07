//
//  NSString+URLEncoding.m
//  taobaokehuduan
//
//  Created by arBao on 7/18/13.
//  Copyright (c) 2013 arBao. All rights reserved.
//

#import "NSString+URLEncoding.h"

@implementation NSString (URLEncoding)

- (NSString *)urlEncodeString {
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                           (CFStringRef)self,
                                                                           NULL,
                                                                           (CFStringRef)@";/?:@&=$+{}<>,",
                                                                           kCFStringEncodingUTF8));
    return result;
}

@end
