//
//  UIViewNavBar.m
//  ChinaBrowser
//
//  Created by David on 14-3-26.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewNavBar.h"

@implementation UIViewNavBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithWhite:0.8 alpha:1].CGColor);
    CGContextSetLineWidth(ctx, 1);
    
    CGContextMoveToPoint(ctx, 0, self.bounds.size.height);
    CGContextAddLineToPoint(ctx, self.bounds.size.width, self.bounds.size.height);
    
    CGContextStrokePath(ctx);
}


+ (UIViewNavBar *)viewNavBarFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:@"UIViewNavBar" owner:nil options:nil][0];
}

@end
