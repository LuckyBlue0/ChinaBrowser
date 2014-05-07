//
//  UIViewSetFont.m
//  KTBrowser
//
//  Created by David on 14-3-4.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewSetFont.h"

#import <QuartzCore/QuartzCore.h>

@interface UIViewSetFont ()

- (IBAction)onValueChanaged:(UISlider *)slider;

- (IBAction)onTouchUP;

@end

@implementation UIViewSetFont

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
滑动滑杆改变网页字体大小
(字体过大或过小可能会影响网页美观)
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _labelContent.layer.cornerRadius = 4;
    _labelContent.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _labelContent.layer.borderWidth = 0.4;
}

+ (UIViewSetFont *)viewSetFontFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:@"UIViewSetFont" owner:nil options:nil][0];
}

- (void)setFontsize:(CGFloat)fontsize
{
    _fontsizeOld = roundf(fontsize);
    
    _labelContent.font = [UIFont systemFontOfSize:_fontsizeOld];
    _slider.value = _fontsizeOld;
    
    NSString *suffix = @"";
    if ((NSInteger)fontsize==kWebFontSizeDefault) {
        suffix = NSLocalizedString(@"font_size_default", @" 默认");
    }
    else if (fontsize<kWebFontSizeDefault-3) {
        suffix = NSLocalizedString(@"font_size_small", @" 偏小");
    }
    else if (fontsize>kWebFontSizeDefault+3) {
        suffix = NSLocalizedString(@"font_size_big", @" 偏大");
    }
    _labelFontsize.text = [NSLocalizedString(@"font_size", @"字体大小") stringByAppendingFormat:@"：%.0f %@", fontsize, suffix];
}

- (IBAction)onValueChanaged:(UISlider *)slider
{
    CGFloat fontsize = roundf(slider.value);
    _labelContent.font = [UIFont systemFontOfSize:fontsize];
    NSString *suffix = @"";
    if ((NSInteger)fontsize==kWebFontSizeDefault) {
        suffix = NSLocalizedString(@"font_size_default", @" 默认");
    }
    else if (fontsize<kWebFontSizeDefault-3) {
        suffix = NSLocalizedString(@"font_size_small", @" 偏小");
    }
    else if (fontsize>kWebFontSizeDefault+3) {
        suffix = NSLocalizedString(@"font_size_big", @" 偏大");
    }
    _labelFontsize.text = [NSLocalizedString(@"font_size", @"字体大小") stringByAppendingFormat:@"：%.0f %@", fontsize, suffix];
}

- (IBAction)onTouchUP
{
    CGFloat fontsize = roundf(_slider.value);
    if (fontsize!=_fontsizeOld) {
        _fontsizeOld = fontsize;
        [_delegate viewSetFont:self setFontSize:fontsize];
    }
}

- (void)dismissWithCompletion:(void (^)(void))completion
{
//    CGFloat fontsize = roundf(_slider.value);
//    [_delegate viewSetFont:self setFontSize:fontsize];
    [super dismissWithCompletion:completion];
}

@end
