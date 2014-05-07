//
//  UIScrollViewWindowItem.m
//  ChinaBrowser
//
//  Created by David on 14-3-20.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIScrollViewWindowItem.h"

#import <QuartzCore/QuartzCore.h>

#import "KTAnimationKit.h"

@implementation UIScrollViewWindowItem

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    if (selected) {
        _imageViewMask.image = [[UIImage imageWithFilename:@"wnd.bundle/wnd_kuang_1.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:40];
    }
    else {
        _imageViewMask.image = [[UIImage imageWithFilename:@"wnd.bundle/wnd_kuang_0.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:40];
    }
    
    [KTAnimationKit animationEaseIn:_imageViewMask];
}

- (void)setLayoutDirection:(UILayoutDirection)layoutDirection
{
    CGRect rc = self.bounds;
    rc.origin = CGPointZero;
    if (UILayoutDirectionHorizontal==layoutDirection) {
        // 横向布局
        rc = CGRectInset(rc, 20, 5);
        rc.origin.x += self.bounds.size.width;
        _viewWindItem.frame = rc;
        
        self.contentSize = CGSizeMake(self.bounds.size.width*3, self.bounds.size.height);
        self.contentOffset = CGPointMake(self.bounds.size.width, 0);
    }
    else {
        // 纵向布局
        rc = CGRectInset(rc, 0, floorf((self.bounds.size.height-self.bounds.size.width)/2));

        rc.origin.y += self.bounds.size.height;
        _viewWindItem.frame = rc;
        
        self.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height*3);
        self.contentOffset = CGPointMake(0, self.bounds.size.height);
    }
    
    _layoutDirection = layoutDirection;
}

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
    
    _imageViewMask.image = [[UIImage imageWithFilename:@"wnd.bundle/wnd_kuang.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:40];
    [_btnDel setImage:[UIImage imageWithFilename:@"wnd.bundle/wnd_close.png"] forState:UIControlStateNormal];
    
    self.pagingEnabled = YES;
}

+ (UIScrollViewWindowItem *)scrollViewWindowItemFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:@"UIScrollViewWindowItem" owner:nil options:nil][0];
}

@end
