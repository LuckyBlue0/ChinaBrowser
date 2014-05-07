//
//  UIViewBrushSet.m
//  KTBrowser
//
//  Created by David on 14-2-26.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewBrushSet.h"

#import <QuartzCore/QuartzCore.h>

#import "BlockUI.h"

@interface UIViewBrushSet ()

- (void)setup;

@end

@implementation UIViewBrushSet

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}

+ (UIViewBrushSet *)viewBrushSetFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:@"UIViewBrushSet" owner:self options:nil][0];
}

- (void)setColor:(UIColor *)color width:(CGFloat)width
{
    _slider.value = width;
    
    CGRect rc = _viewBrush.bounds;
    rc.size.width = rc.size.height = _slider.value;
    _viewBrush.bounds = rc;
    _viewBrush.layer.cornerRadius = rc.size.width/2;
    
    _viewBrush.backgroundColor = color;
    
//    [_delegate viewBrushSetLineColor:color];
//    [_delegate viewBrushSetLineWidth:width];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - private
- (void)setup
{
    CGPoint center = _slider.center;
    center.y = _viewWrap.center.y;
    _slider.center = center;
    
    _arrColor = @[@"#FFFFFF", @"#FFFF00",
                  @"#FF00FF", @"#00FFFF",
                  @"#FF0000", @"#00FF00",
                  @"#0000FF", @"#000000",
                  @"#258B2A", @"#7B4117",
                  @"#5E5E5E", @"#BBBBBB"];
    
    _viewWrap.layer.cornerRadius =
    _viewBrush.layer.cornerRadius = _viewBrush.bounds.size.width/2;
    
    _viewWrap.layer.borderWidth =
    _viewBrush.layer.borderWidth = 0.5;
    _viewWrap.layer.borderColor =
    _viewBrush.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [_viewContent.subviews enumerateObjectsUsingBlock:^(UIView* subView, NSUInteger idx, BOOL *stop) {
        if ([subView isKindOfClass:[UISlider class]]) {
            [(UISlider *)subView setMinimumValue:1];
            [(UISlider *)subView setMaximumValue:MIN(_viewWrap.bounds.size.height, _viewWrap.bounds.size.width)];
            
            [(UISlider *)subView handleControlEvent:UIControlEventValueChanged withBlock:^(UISlider* sender) {
                CGRect rc = _viewBrush.bounds;
                rc.size.width = rc.size.height = sender.value;
                _viewBrush.bounds = rc;
                _viewBrush.layer.cornerRadius = rc.size.width/2;
                
                if ([_delegate respondsToSelector:@selector(viewBrushSetLineWidth:)]) {
                    [_delegate viewBrushSetLineWidth:_slider.value];
                }
            }];
        }
        else if ([subView isKindOfClass:[UIButton class]]) {
            subView.layer.borderWidth = _viewWrap.layer.borderWidth;
            subView.layer.borderColor = _viewWrap.layer.borderColor;
            
            subView.backgroundColor = [UIColor colorWithHexString:_arrColor[subView.tag]];
            [(UIButton *)subView handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton* sender) {
                sender.backgroundColor = [UIColor colorWithHexString:_arrColor[sender.tag]];
                _viewBrush.backgroundColor = sender.backgroundColor;
                
                if ([_delegate respondsToSelector:@selector(viewBrushSetLineColor:)]) {
                    [_delegate viewBrushSetLineColor:_viewBrush.backgroundColor];
                }
            }];
            [(UIButton *)subView handleControlEvent:UIControlEventTouchUpOutside withBlock:^(UIButton* sender) {
                sender.backgroundColor = [UIColor colorWithHexString:_arrColor[sender.tag]];
            }];
            [(UIButton *)subView handleControlEvent:UIControlEventTouchDown withBlock:^(UIButton* sender) {
                sender.backgroundColor = [sender.backgroundColor colorWithAlphaComponent:0.6];
            }];
        }
    }];
}

@end
