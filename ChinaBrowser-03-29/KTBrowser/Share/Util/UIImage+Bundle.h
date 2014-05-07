//
//  UIImage+Bundle.h
//  KTBrowser
//
//  Created by David on 14-2-14.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Bundle)

/**
 *  从bundle加载绝对路径图片
 *
 *  @param bundle   eg “Default/ToolBar” or "Bg"
 *  @param filename 文件名
 *
 *  @return UIImage
 */
+ (UIImage *)imageWithBundle:(NSString *)bundle filename:(NSString *)filename;

/**
 *  绝对路径图片
 *
 *  @param filename 文件名
 *
 *  @return UIImage
 */
+ (UIImage *)imageWithFilename:(NSString *)filename;

+ (UIImage *)imageFromView:(UIView *)view;

+ (UIImage *)imageFromView:(UIView *)view rect:(CGRect)rect;

@end
