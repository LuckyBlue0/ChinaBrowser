//
//  UIColorEx.m
//
//  Created by David on 2012-02-08.
//  Copyright 2012年 VeryApps. All rights reserved.
//

#import "UIColorEx.h"


@implementation UIColor (UIColorEx)

+ (UIColor *)randomColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRed:rand()%256/255.0
                           green:rand()%256/255.0
                            blue:rand()%256/255.0
                           alpha:alpha];
}

+ (UIColor *)randomColor {
    return [self randomColorWithAlpha:rand()%256/255.0];
}

+ (UIColor *)colorWithHex:(NSString *)hexStr alpha:(CGFloat)alphaValue {
    unsigned long hexValue = strtoul([hexStr UTF8String], 0, 16);
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:alphaValue];
}

+ (UIColor *)colorWithHex:(NSString *)hexStr {
    return [self colorWithHex:hexStr alpha:1.0f];
}

@end
