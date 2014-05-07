//
//  UIViewEraserSet.m
//  KTBrowser
//
//  Created by David on 14-2-26.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewEraserSet.h"

#import "BlockUI.h"
#import <QuartzCore/QuartzCore.h>

@interface UIViewEraserSet ()

- (void)setup;

@end

@implementation UIViewEraserSet

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

+ (UIViewEraserSet *)viewEraserSetFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:@"UIViewEraserSet" owner:self options:nil][0];
}

- (void)setEraserWidth:(CGFloat)width
{
    _slider.value = MAX(width, _slider.minimumValue);
    CGRect rc = _viewWrap.bounds;
    rc.size.width = rc.size.height = _slider.value;
    _viewWrap.bounds = rc;
    _viewWrap.layer.cornerRadius = rc.size.width/2;
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
    
    _viewWrap.layer.cornerRadius = _viewWrap.bounds.size.width/2;
    _viewWrap.layer.borderWidth = 0.5;
    _viewWrap.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [_viewContent.subviews enumerateObjectsUsingBlock:^(UIView* subView, NSUInteger idx, BOOL *stop) {
        if ([subView isKindOfClass:[UISlider class]]) {
            [(UISlider *)subView setMinimumValue:4];
            [(UISlider *)subView setMaximumValue:MIN(_viewWrap.bounds.size.height, _viewWrap.bounds.size.width)];
            
            [(UISlider *)subView handleControlEvent:UIControlEventValueChanged withBlock:^(UISlider* sender) {
                CGRect rc = _viewWrap.bounds;
                rc.size.width = rc.size.height = sender.value;
                _viewWrap.bounds = rc;
                _viewWrap.layer.cornerRadius = rc.size.width/2;
                
                if ([_delegate respondsToSelector:@selector(viewEraserSetWidth:)]) {
                    [_delegate viewEraserSetWidth:_slider.value];
                }
            }];
        }
    }];
}

@end
