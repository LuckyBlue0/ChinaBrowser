//
//  ViewGuide_ipad.m
//  BrowserApp
//
//  Created by Glex on 14-3-05.
//  Copyright (c) 2014年 arBao. All rights reserved.
//

#import "ViewGuide_ipad.h"

#import "ControllerNav_ipad.h"

#import "CustomPageControl.h"

@interface ViewGuide_ipad () {
    UIScrollView      *_scrollView;
    CustomPageControl *_pageControl;
    
    NSArray *_arrImgNames;
}

- (void)handlePageControl:(id)sender;
- (void)tapLastImageView:(UIGestureRecognizer *)gestureRecognizer;

@end

@implementation ViewGuide_ipad

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _arrImgNames = [NSArray arrayWithObjects:@"iPad-guide-0", @"iPad-guide-1", @"iPad-guide-2", @"iPad-guide-3", nil];
        NSInteger imgNamesCount = _arrImgNames.count;
        self.backgroundColor = isIOS(7)?RGB_COLOR(200, 200, 200):[UIColor scrollViewTexturedBackgroundColor];

        // _scrollView
        CGRect rc = self.bounds;
        CGFloat spaceX = 20;
        rc.size.width += spaceX;
        rc.origin.x = -rc.size.width*(imgNamesCount-1);
        _scrollView = [[UIScrollView alloc] initWithFrame:rc];
        _scrollView.delegate = self;
        _scrollView.clipsToBounds = NO;
        _scrollView.contentSize = CGSizeMake(rc.size.width*imgNamesCount, rc.size.height);
        _scrollView.showsVerticalScrollIndicator = _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled = _scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView];
        
        rc.size.width -= spaceX;
        for (int i=0; i<imgNamesCount; i++) {
            rc.origin.x = (rc.size.width+spaceX)*i;
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:rc];
            imgView.clipsToBounds = YES;
            imgView.contentMode = UIViewContentModeCenter;
            [imgView setImageWithName:[_arrImgNames objectAtIndex:i] ofType:@"png"];
            [_scrollView addSubview:imgView];
            
            if (i == imgNamesCount-1) {
                imgView.userInteractionEnabled = YES;
                
                CGRect rcBtn = rc;
                rcBtn.size = CGSizeMake(110, 33);
                rcBtn.origin.x = (rc.size.width-rcBtn.size.width)*0.5;
                rcBtn.origin.y = rc.size.height-rcBtn.size.height-90;
                UIButton *btnEnter = [[UIButton alloc] initWithFrame:rcBtn];
                btnEnter.userInteractionEnabled = NO;
                [btnEnter setBackgroundImageWithName:@"ipad-enter"];
                [btnEnter setTitle:@"马上体验" forState:UIControlStateNormal];
                [btnEnter setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [imgView addSubview:btnEnter];
                
                UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLastImageView:)];
                [imgView addGestureRecognizer:tapGes];
            }
        }
        
        // _pageControl
        _pageControl = [[CustomPageControl alloc] initWithFrame:CGRectMake((rc.size.width-25*imgNamesCount)/2, rc.size.height-70, 25*imgNamesCount, 38)];
        _pageControl.currentPage   = 0;
        _pageControl.numberOfPages = imgNamesCount;
        [_pageControl setImgNameNormal:@"dot-normal" imgNameSelected:@"dot-selected"];
        [_pageControl addTarget:self action:@selector(handlePageControl:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_pageControl];
        
        // 动画过程禁用转屏
        [ControllerNav_ipad allowAutorotate:NO];
        
        rc = _scrollView.bounds;
        _scrollView.transform = CGAffineTransformMakeScale(0.6, 0.6);
        [UIView animateWithDuration:0.6 animations:^{
            _scrollView.transform = CGAffineTransformMakeTranslation(rc.size.width*(imgNamesCount-1)+30, 0);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                _scrollView.transform = CGAffineTransformMakeTranslation(rc.size.width*(imgNamesCount-1), 0);
            }];
        }];
    }
    
    return self;
}

- (void)tapLastImageView:(UIGestureRecognizer *)gestureRecognizer {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kReadAppGuide];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([_delegate respondsToSelector:@selector(viewGuideDismiss:)]) {
        [UIView animateWithDuration:0.5
                         animations:^{
                             self.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             if ([_delegate respondsToSelector:@selector(viewGuideDismiss:)]) {
                                 [_delegate viewGuideDismiss:self];
                             }
                             [self removeFromSuperview];
                         }
         ];
    }
}

- (void)handlePageControl:(id)sender {
    NSInteger currPage = _pageControl.currentPage;
    [UIView animateWithDuration:0.5
                     animations:^{
                         _scrollView.contentOffset = CGPointMake(_scrollView.bounds.size.width*currPage, 0);
                     }
     ];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageControl.currentPage = _scrollView.contentOffset.x/_scrollView.bounds.size.width;
    [_pageControl updateDots];
}

@end
