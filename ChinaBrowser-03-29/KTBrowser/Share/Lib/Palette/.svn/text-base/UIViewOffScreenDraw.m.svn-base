//
//  UIViewOffScreenDraw.m
//  KTBrowser
//
//  Created by David on 14-2-22.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewOffScreenDraw.h"

#import <QuartzCore/QuartzCore.h>

@interface UIViewOffScreenDraw ()

@end

@implementation UIViewOffScreenDraw

- (UIImage *)image
{
    return [UIImage imageFromView:self];
}

- (BOOL)isClearModal
{
    return _clearModal;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
//        [self setupBuffer];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    [self setupBuffer];
}

-(void)setupBuffer {
    
    if (_bufferContext!=NULL) {
        CGContextRelease(_bufferContext);
    }
    
    self.clearModal = NO;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat scaleFactor = [[UIScreen mainScreen] scale];
//    scaleFactor = 1;
    
    CGContextRef context = CGBitmapContextCreate(NULL,
                                           self.bounds.size.width*scaleFactor,
                                           self.bounds.size.height*scaleFactor,
                                           8,
                                           self.bounds.size.width*4*scaleFactor,
                                           colorSpace,
                                           (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    
    CGContextTranslateCTM(context, 0, self.bounds.size.height*scaleFactor);
    CGContextScaleCTM(context, scaleFactor, -scaleFactor);
    
    _bufferContext = context;
}

- (void)drawPointFrom:(CGPoint)pointFrom pointTo:(CGPoint)pointTo
{
    CGContextBeginPath(_bufferContext);
    if (_clearModal) {
        CGContextSetBlendMode(_bufferContext, kCGBlendModeClear);
        CGContextSetLineWidth(_bufferContext, _eraserWidth);
    }
    else {
        CGContextSetBlendMode(_bufferContext, kCGBlendModeCopy);
        CGContextSetLineWidth(_bufferContext, _lineWidth);
    }
    CGContextSetLineCap(_bufferContext, kCGLineCapRound);
    CGContextSetLineJoin(_bufferContext, kCGLineJoinRound);
    CGContextSetStrokeColorWithColor(_bufferContext, [_lineColor CGColor]);
    
    CGContextMoveToPoint(_bufferContext, pointFrom.x,pointFrom.y);
    CGContextAddLineToPoint(_bufferContext, pointTo.x,pointTo.y);
//    CGContextDrawPath(_bufferContext, kCGPathStroke);
    CGContextStrokePath(_bufferContext);
}

- (void)drawRect:(CGRect)rect {
    if (_image) [_image drawInRect:self.bounds];
    
    CGImageRef cgImage = CGBitmapContextCreateImage(_bufferContext);
    UIImage *image = [[UIImage alloc] initWithCGImage:cgImage];
    CGImageRelease(cgImage);
    [image drawInRect:self.bounds];
}

@end
