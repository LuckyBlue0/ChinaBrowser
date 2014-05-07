//
//  UIViewOffScreenDraw.h
//  KTBrowser
//
//  Created by David on 14-2-22.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewOffScreenDraw : UIView
{
    CGContextRef _bufferContext;
}

@property (nonatomic, assign, getter = isClearModal) BOOL clearModal;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat eraserWidth;


- (void)setupBuffer;
- (void)drawPointFrom:(CGPoint)pointFrom pointTo:(CGPoint)pointTo;

@end
