//
//  UIViewSearchLeft.m
//  KTBrowser
//
//  Created by David on 14-2-18.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewSearchLeft.h"

#import <QuartzCore/QuartzCore.h>

@implementation UIViewSearchLeft

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
    
    [self updateUIMode];
}

- (void)updateUIMode
{
    [super updateUIMode];
    
    NSInteger key = [AppConfig config].uiMode==UIModeDay?0:1;
    
    _imageViewArrow.image = [UIImage imageWithFilename:@"top.bundle/1_search_arrow.png"];
    _imageViewSearch.image = [UIImage imageWithFilename:[NSString stringWithFormat:@"top.bundle/%d_btn_search.png", key]];
    _imageViewArrow.contentMode = UIViewContentModeCenter;
    
    [_imageViewArrow sizeToFit];
    [_imageViewSearch sizeToFit];
    
    CGRect rc = _imageViewSearch.frame;
    rc.origin.x = 0;
    rc.origin.y = floorf(self.bounds.size.height-rc.size.height)/2;
    _imageViewSearch.frame = rc;
    
    rc = _imageViewArrow.frame;
    rc.size.width+=4;
    rc.origin.x = _btnIcon.frame.origin.x+_btnIcon.frame.size.width;
    rc.origin.y = floorf(self.bounds.size.height-rc.size.height)/2;
    _imageViewArrow.frame = rc;
}

- (void)showMagnifierIcon
{
    _imageViewSearch.alpha = 1;
    _btnIcon.alpha = _imageViewArrow.alpha = 0;
    
    self.bounds = _imageViewSearch.bounds;
}

- (void)showOptionIcon
{
    _imageViewSearch.alpha = 0;
    _btnIcon.alpha = _imageViewArrow.alpha = 1;
    
    CGRect rc = self.bounds;
    rc.size.width = _btnIcon.bounds.size.width+_imageViewArrow.bounds.size.width;
    self.bounds = rc;
}

@end
