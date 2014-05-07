//
//  UIViewSetFontDelegate.h
//  ChinaBrowser
//
//  Created by David on 14-3-19.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIViewSetFont;

@protocol UIViewSetFontDelegate <NSObject>

- (void)viewSetFont:(UIViewSetFont *)viewSetFont setFontSize:(CGFloat)fontSize;

@end
