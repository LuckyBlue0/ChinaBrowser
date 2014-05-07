//
//  UIViewBar.m
//  ChinaBrowser
//
//  Created by David on 14-3-14.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewBar.h"

@implementation UIViewBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _borderColor = [UIColor whiteColor];
        _borderWidth = 1;
        self.backgroundColor = [UIColor colorWithWhite:0.97 alpha:0.5];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _borderColor = [UIColor whiteColor];
    _borderWidth = 1;
    self.backgroundColor = [UIColor colorWithWhite:0.85 alpha:0.5];
}

- (void)setBorder:(UIBorder)border
{
    _border = border;
    [self setNeedsDisplay];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    [self setNeedsDisplay];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    [self setNeedsDisplay];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, _borderColor.CGColor);
    CGContextSetLineWidth(ctx, _borderWidth);
    
    if (UIBorderTop&_border) {
        CGContextMoveToPoint(ctx, 0, 0);
        CGContextAddLineToPoint(ctx, self.bounds.size.width, 0);
    }
    if (UIBorderBottom&_border) {
        CGContextMoveToPoint(ctx, 0, self.bounds.size.height);
        CGContextAddLineToPoint(ctx, self.bounds.size.width, self.bounds.size.height);
    }
    if (UIBorderLeft&_border)
    {
        CGContextMoveToPoint(ctx, 0, 0);
        CGContextAddLineToPoint(ctx, 0, self.bounds.size.height);
    }
    if (UIBorderRight&_border) {
        CGContextMoveToPoint(ctx, self.bounds.size.width, 0);
        CGContextAddLineToPoint(ctx, self.bounds.size.width, self.bounds.size.height);
    }
    
    CGContextStrokePath(ctx);
}

@end
