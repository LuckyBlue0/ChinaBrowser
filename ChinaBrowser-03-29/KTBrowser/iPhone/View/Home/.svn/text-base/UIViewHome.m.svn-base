//
//  UIViewHome.m
//  KTBrowser
//
//  Created by David on 14-3-8.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewHome.h"

#import <QuartzCore/QuartzCore.h>

@interface UIViewHome ()

- (IBAction)updatePage:(SMPageControl *)pageControl;

@end

@implementation UIViewHome

- (IBAction)updatePage:(SMPageControl *)pageControl
{
    [_scrollViewCenter setContentOffset:CGPointMake(pageControl.currentPage*_scrollViewCenter.bounds.size.width, 0) animated:YES];
}

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
    
//    CGFloat height = (self.bounds.size.height-_scrollViewCenter.bounds.size.height)/2;
//    CGPoint center = _pageControl.center;
//    center.y = self.bounds.size.height-height;
//    _pageControl.center = center;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //    return;
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    size_t locationsCount = 2;
    CGFloat locations[2] = {0.0f, 1.0f};
    CGFloat colors[8] = {
        0.9, 0.9, 0.9, 0.4,
        0.9, 0.9, 0.9, 0.1
    };
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
    
    // 线性
    CGContextDrawLinearGradient(ctx,
                                gradient,
                                CGPointMake(self.bounds.size.width/2, 0),
                                CGPointMake(self.bounds.size.width/2, self.bounds.size.height),
                                kCGGradientDrawsAfterEndLocation);
    
    // 四周扩散
    /*
     CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
     CGContextDrawRadialGradient(ctx,
     gradient,
     center,
     0,
     center,
     MIN(self.bounds.size.width, self.bounds.size.height),
     kCGGradientDrawsAfterEndLocation);
     */
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage = roundf(scrollView.contentOffset.x/scrollView.bounds.size.width);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        _pageControl.currentPage = roundf(scrollView.contentOffset.x/scrollView.bounds.size.width);
    }
}

@end
