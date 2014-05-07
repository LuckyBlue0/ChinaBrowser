//
//  UIViewMenuItem.m
//  KTBrowser
//
//  Created by David on 14-2-20.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewMenuItem.h"

#import <QuartzCore/QuartzCore.h>

@implementation UIViewMenuItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    _imageViewIcon.alpha = _labelTitle.alpha = enabled?1:0.2;
}


- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    _imageViewIcon.highlighted = selected;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    BOOL b = [super beginTrackingWithTouch:touch withEvent:event];
    if (self.enabled) {
        self.layer.cornerRadius = 4;
        self.backgroundColor = [UIColor colorWithWhite:0.96 alpha:0.1];
    }
    return b;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.1 animations:^{
        self.layer.cornerRadius = 0;
        self.backgroundColor = [UIColor colorWithWhite:0.96 alpha:0];
    } completion:nil];
    [super endTrackingWithTouch:touch withEvent:event];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.1 animations:^{
        self.layer.cornerRadius = 0;
        self.backgroundColor = [UIColor colorWithWhite:0.96 alpha:0];
    } completion:nil];
    
    [super cancelTrackingWithEvent:event];
}

+ (UIViewMenuItem *)viewMenuItemFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:@"UIViewMenuItem" owner:nil options:nil][0];
}

@end
