//
//  VAGuideView.h
//  WKBrowser
//
//  Created by David on 13-8-30.
//  Copyright (c) 2013年 VeryApps. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SMPageControl.h"

typedef void (^AnimationComplecation) (void);
typedef void (^DidDismiss) (void);

@interface VAGuideView : UIView <UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    SMPageControl *_pageControl;
    
    NSMutableArray *_arrViews;
    
    AnimationComplecation _animationComplecation;
    DidDismiss _didDismiss;
    
    CGRect _rcButton;
    UIButton *_button;
    CGFloat _paddingBottom;
}

// item space
@property (nonatomic, assign) CGFloat space;
@property (nonatomic, assign) UIViewContentMode imageContentMode;
@property (nonatomic, retain) UIColor *bgColor;

- (id)initWithFrame:(CGRect)frame arrImages:(NSArray *)arrImages space:(CGFloat)space;
+ (id)guideViewWithFrame:(CGRect)frame arrImages:(NSArray *)arrImages space:(CGFloat)space;
+ (BOOL)shouldShowGuide;

- (void)addButtonAtLastPage:(UIButton *)button;

- (void)startAnimation:(AnimationComplecation)animationComplecation
            didDismiss:(DidDismiss)didDismiss;
- (void)startAnimationWithDuration:(NSTimeInterval)duration
             animationComplecation:(AnimationComplecation)animationComplecation
                        didDismiss:(DidDismiss)didDismiss;

- (void)dismiss:(DidDismiss)block;

@end
