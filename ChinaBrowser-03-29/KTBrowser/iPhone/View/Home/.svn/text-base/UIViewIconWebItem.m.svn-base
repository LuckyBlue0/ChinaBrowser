//
//  UIViewIconWebItem.m
//  KTBrowser
//
//  Created by David on 14-2-19.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewIconWebItem.h"

#import <QuartzCore/QuartzCore.h>

@interface UIViewIconWebItem ()

- (UIImage *)delImageWithSize:(CGSize)size;

@end

@implementation UIViewIconWebItem

- (UIImage *)delImageWithSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    
    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, size.width, size.height));
    CGContextFillPath(ctx);
    
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetLineWidth(ctx, 2);
    CGContextMoveToPoint(ctx, 5, size.height/2);
    CGContextAddLineToPoint(ctx, size.width-5, size.height/2);
    CGContextStrokePath(ctx);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return image;
}

- (void)setEdit:(BOOL)edit
{
    _edit = edit;
    if (_edit) {
        _btnDel.transform = CGAffineTransformIdentity;
        CGRect rc = _btnDel.frame;
//        rc.size = CGSizeMake(24, 24);
        rc.origin.x = self.frame.origin.x+self.frame.size.width-rc.size.width/2;
        rc.origin.y = self.frame.origin.y-rc.size.height/2;
        _btnDel.frame = rc;
        
        [self.superview addSubview:_btnDel];
        _btnDel.transform = CGAffineTransformMakeScale(0, 0);
        
        [UIView animateWithDuration:0.2 animations:^{
            _btnDel.transform = CGAffineTransformIdentity;
        }];
    }
    else {
        [UIView animateWithDuration:0.2  animations:^{
            _btnDel.transform = CGAffineTransformMakeScale(0, 0);
        } completion:^(BOOL finished) {
            [_btnDel removeFromSuperview];
            _btnDel.transform = CGAffineTransformIdentity;
        }];
    }
}

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
    
    CGRect rc = _btnDel.frame;
    rc.origin.x = self.frame.origin.x+self.frame.size.width-rc.size.width/2;
    rc.origin.y = self.frame.origin.y-rc.size.height/2;
    _btnDel.frame = rc;
}

- (void)updateUIMode
{
    if ([AppConfig config].uiMode==UIModeDay) {
        _labelTitle.textColor = [UIColor colorWithWhite:0.1 alpha:1];
    }
    else {
        _labelTitle.textColor = [UIColor whiteColor];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+ (UIViewIconWebItem *)viewIconWebItemFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:@"UIViewIconWebItem" owner:nil options:nil][0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [_btnDel removeFromSuperview];
    _btnDel.bounds = CGRectMake(0, 0, 24, 24);
    [_btnDel setImage:[self delImageWithSize:_btnDel.bounds.size] forState:UIControlStateNormal];
    
    _labelTitle.backgroundColor = [UIColor clearColor];

    [self updateUIMode];
}

@end
