//
//  UIViewSNSItem.m
//  KTBrowser
//
//  Created by David on 14-3-3.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewSNSItem.h"

#import <QuartzCore/QuartzCore.h>

@implementation UIViewSNSItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
    
//    self.backgroundColor = [UIColor randomColor];
    self.layer.cornerRadius = 4;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

+ (UIViewSNSItem *)viewSNSItemFromItem
{
    return [[NSBundle mainBundle] loadNibNamed:@"UIViewSNSItem" owner:nil options:nil][0];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    BOOL b = [super beginTrackingWithTouch:touch withEvent:event];
    if (self.enabled) {
        //        self.layer.cornerRadius = 4;
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
    }
    return b;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.1 animations:^{
        //        self.layer.cornerRadius = 0;
        self.backgroundColor = [UIColor colorWithWhite:0.96 alpha:0];
    } completion:nil];
    [super endTrackingWithTouch:touch withEvent:event];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.1 animations:^{
        //        self.layer.cornerRadius = 0;
        self.backgroundColor = [UIColor colorWithWhite:0.96 alpha:0];
    } completion:nil];
    
    [super cancelTrackingWithEvent:event];
}

@end
