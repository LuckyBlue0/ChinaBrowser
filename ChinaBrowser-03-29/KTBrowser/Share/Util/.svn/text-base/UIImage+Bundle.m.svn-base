//
//  UIImage+Bundle.m
//  KTBrowser
//
//  Created by David on 14-2-14.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIImage+Bundle.h"

#import <QuartzCore/QuartzCore.h>

@implementation UIImage (Bundle)

/**
 *  从bundle加载绝对路径图片
 *
 *  @param bundle   eg “Default/ToolBar” or "Bg"
 *  @param filename 文件名
 *
 *  @return UIImage
 */
+ (UIImage *)imageWithBundle:(NSString *)bundle filename:(NSString *)filename
{
    NSMutableString *path= [NSMutableString string];
    NSArray *arrBundle = [bundle componentsSeparatedByString:@"/"];
    if (arrBundle.count>=2) {
        for (NSString *item in arrBundle) {
            if (item.length>0) {
                [path appendString:item];
                [path appendString:@".bundle/"];
            }
        }
        [path appendString:filename];
    }
    else {
        [path appendFormat:@"%@.bundle/%@", bundle, filename];
    }
    
    return [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:path]];
}

/**
 *  绝对路径图片
 *
 *  @param filename 文件名
 *
 *  @return UIImage
 */
+ (UIImage *)imageWithFilename:(NSString *)filename
{
    return [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filename]];
}

+ (UIImage *)imageFromView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageFromView:(UIView *)view rect:(CGRect)rect
{
    UIImage *imageOrigent = [UIImage imageFromView:view];
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(imageOrigent.CGImage,CGRectApplyAffineTransform(rect, CGAffineTransformMakeScale([UIScreen mainScreen].scale, [UIScreen mainScreen].scale)));
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    return image;
}

@end
