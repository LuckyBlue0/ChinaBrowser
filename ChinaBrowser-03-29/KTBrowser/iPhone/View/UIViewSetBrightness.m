//
//  UIViewSetBrightness.m
//  KTBrowser
//
//  Created by David on 14-3-4.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewSetBrightness.h"

@interface UIViewSetBrightness ()

- (IBAction)onValueChanaged:(UISlider *)slider;

@end

@implementation UIViewSetBrightness

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
    
    for (UIView *subView in _viewContent.subviews) {
        CGPoint center = subView.center;
        center.y = _viewContent.bounds.size.height/2;
        subView.center = center;
    }
    
    //    [_slider setThumbImage:[UIImage imageNamed:@"bs_3.png"] forState:UIControlStateNormal];
    //    _slider.minimumValueImage = nil;
    //    _slider.maximumValueImage = nil;
    //    _slider.minimumTrackTintColor = [UIColor clearColor];
    //    _slider.maximumTrackTintColor = [UIColor clearColor];
    
    //    CGRect rc = CGRectInset(_slider.frame, 10, 0);
    //    rc.size.height = 5;
    //    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rc];
    //    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //    imageView.center = _slider.center;
    //    imageView.image = [[UIImage imageNamed:@"bs_5.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    //    [_viewBottom insertSubview:imageView atIndex:0];
}

+ (UIViewSetBrightness *)viewSetBrightnessFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:@"UIViewSetBrightness" owner:nil options:nil][0];
}
- (void)setBrightness:(CGFloat)brightness
{
    _slider.value = brightness;
}

- (IBAction)onValueChanaged:(UISlider *)slider
{
    if (UIModeDay==[AppConfig config].uiMode) {
        [AppConfig config].brightnessDay = slider.value;
    }
    else {
        [AppConfig config].brightnessNight = slider.value;
    }
}

@end
