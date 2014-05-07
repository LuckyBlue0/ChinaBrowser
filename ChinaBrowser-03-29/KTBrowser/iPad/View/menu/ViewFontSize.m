//
//  ViewFontSize.m
//

#import "ViewFontSize.h"

#import <QuartzCore/QuartzCore.h>

@interface ViewFontSize ()

- (IBAction)onValueChanaged:(UISlider *)slider;

- (IBAction)onTouchUP;

@end

@implementation ViewFontSize

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _labelContent.layer.cornerRadius = 5;
    _labelContent.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _labelContent.layer.borderWidth = 0.6;
    
    _labelFontsize.textColor = _labelContent.textColor = kTextColorDay;
}

+ (ViewFontSize *)viewFontSizeFromXib {
    return [[NSBundle mainBundle] loadNibNamed:@"ViewFontSize" owner:nil options:nil][0];
}

- (void)setFontAdjust:(CGFloat)fontAdjust {
    _fontAdjust = fontAdjust;
    
    CGFloat fontSize = _fontAdjust*22;
    _labelContent.font = [UIFont systemFontOfSize:fontSize];
    _slider.value = fontSize;
    
    NSString *suffix = @"";
    if ((NSInteger)fontSize == 22) {
        suffix = NSLocalizedString(@"font_size_default", @" 默认");
    }
    else if (fontSize < 19) {
        suffix = NSLocalizedString(@"font_size_small", @" 偏小");
    }
    else if (fontSize > 25) {
        suffix = NSLocalizedString(@"font_size_big", @" 偏大");
    }
    _labelFontsize.text = [NSLocalizedString(@"font_size", @"字体大小") stringByAppendingFormat:@"：%.0f %@", fontSize, suffix];
}

- (IBAction)onValueChanaged:(UISlider *)slider {
    CGFloat fontsize = roundf(slider.value);
    _labelContent.font = [UIFont systemFontOfSize:fontsize];
    NSString *suffix = @"";
    if ((NSInteger)fontsize == 22) {
        suffix = NSLocalizedString(@"font_size_default", @" 默认");
    }
    else if (fontsize < 19) {
        suffix = NSLocalizedString(@"font_size_small", @" 偏小");
    }
    else if (fontsize > 25) {
        suffix = NSLocalizedString(@"font_size_big", @" 偏大");
    }
    _labelFontsize.text = [NSLocalizedString(@"font_size", @"字体大小") stringByAppendingFormat:@"：%.0f %@", fontsize, suffix];
}

- (IBAction)onTouchUP {
    CGFloat fontsize = roundf(_slider.value);
    if (fontsize != _fontAdjust*22) {
        _fontAdjust = fontsize/22.0;
        [_delegate viewFontSize:self setFontAdjust:_fontAdjust];
    }
}

- (void)dismissWithCompletion:(void (^)(void))completion {
//    CGFloat fontsize = roundf(_slider.value);
//    [_delegate viewSetFont:self setFontSize:fontsize];
    [super dismissWithCompletion:completion];
}

@end
