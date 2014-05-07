//
//  ViewIndicator.m
//
//  Created by Glex on 13-5-30.
//  Copyright (c) 2013年 VeryApps. All rights reserved.
//

#import "ViewIndicator.h"

#import <QuartzCore/QuartzCore.h>

#ifndef degreesToRadians
    #define degreesToRadians(x) (M_PI*(x)/180.0)
#endif

@interface ViewIndicator ()  {
    id  _targetCustom;
    SEL _selCustom;

    UIWindow        *_maskWindow;
    ASIHTTPRequest  *_request;
    
    UIView          *_viewProgress;
    UIActivityIndicatorView *_viewLoading;
    UIImageView     *_imgViewIcon;
    UILabel         *_labelMsg;
    UILabel         *_labelProgress;
    UIButton        *_btnClose;
}

@end

@implementation ViewIndicator

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    _request = nil;
}

#pragma mark - Instance Methods
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		self.alpha = 0;
        self.backgroundColor  = [UIColor colorWithWhite:0.05 alpha:0.85];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        self.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
        self.layer.borderWidth = 0;
        self.layer.shadowColor = [UIColor grayColor].CGColor;
        self.layer.shadowOpacity = 0.8;
        self.layer.shadowRadius = 1;
        self.layer.shadowOffset = CGSizeZero;
        
        // subviews
        CGRect rc = self.bounds;
        rc.size.width = 0;
        
        _viewProgress = [[UIView alloc] initWithFrame:rc];
        _viewProgress.backgroundColor = RGB_COLOR(38, 200, 33);
        _viewProgress.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        rc.size.width = rc.size.height;
        _viewLoading = [[UIActivityIndicatorView alloc] initWithFrame:rc];
        _viewLoading.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        _viewLoading.backgroundColor  = [UIColor colorWithWhite:0.1 alpha:1];
        _viewLoading.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        _imgViewIcon = [[UIImageView alloc] initWithFrame:rc];
        _imgViewIcon.contentMode = UIViewContentModeCenter;
        _imgViewIcon.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        rc.origin.x = self.bounds.size.width-rc.size.width;
        _btnClose = [[UIButton alloc] initWithFrame:rc];
        [_btnClose setBackgroundColor:RGBCOLOR(255, 50, 50)];
        [_btnClose setImage:[UIImage imageNamed:@"indicator-error.png"] forState:UIControlStateNormal];
        _btnClose.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleHeight;
        
        UIFont *font = [UIFont systemFontOfSize:UIUserInterfaceIdiomPad==UI_USER_INTERFACE_IDIOM()?15:10];
        
        _labelMsg = [[UILabel alloc] init];
        _labelMsg.textAlignment   = CustomTextAlignmentCenter;
        _labelMsg.backgroundColor = [UIColor clearColor];
        _labelMsg.textColor = [UIColor whiteColor];
        _labelMsg.font = font;
        _labelMsg.numberOfLines = 0;
        
        _labelProgress = [[UILabel alloc] init];
        _labelProgress.textAlignment   = CustomTextAlignmentCenter;
        _labelProgress.backgroundColor = [UIColor clearColor];
        _labelProgress.textColor = [UIColor whiteColor];
        _labelProgress.font = font;
        
        [self addSubview:_viewProgress];
        [self addSubview:_viewLoading];
        [self addSubview:_imgViewIcon];
        [self addSubview:_labelMsg];
        [self addSubview:_labelProgress];
        [self addSubview:_btnClose];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    if (_viewLoading.hidden) { return; }
    
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 1);
    
    UIView *subView = _imgViewIcon;
    CGRect rc = subView.frame;
    if (rc.origin.x+rc.size.width+self.bounds.size.height<=self.bounds.size.width) {
        CGFloat x = rc.origin.x+rc.size.width;
        CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
        CGContextMoveToPoint(ctx, x, 0);
        CGContextAddLineToPoint(ctx, x, self.bounds.size.height);
        CGContextStrokePath(ctx);
        
        x+=1;
        CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithWhite:0.2 alpha:1].CGColor);
        CGContextMoveToPoint(ctx, x, 0);
        CGContextAddLineToPoint(ctx, x, self.bounds.size.height);
        CGContextStrokePath(ctx);
    }
}

+ (ViewIndicator *)sharedView {
    static dispatch_once_t once;
    static ViewIndicator *_sharedView;
    dispatch_once(&once, ^ {
    	CGRect rcSelf   = CGRectMake(0, 0, 200, 50);
    	CGRect rcScreen = [[UIScreen mainScreen] bounds];
	    rcSelf.origin.x = (rcScreen.size.width-rcSelf.size.width)/2;
	    rcSelf.origin.y = (rcScreen.size.height-rcSelf.size.height)/2;
        _sharedView = [[ViewIndicator alloc] initWithFrame:rcSelf];
    });
    
    return _sharedView;
}

- (void)fixedPosition:(NSNotification *)notification {
    CGFloat degrees;
    switch ([UIApplication sharedApplication].statusBarOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            degrees = 180.0;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            degrees = -90.0;
            break;
        case UIInterfaceOrientationLandscapeRight:
            degrees = 90.0;
            break;
        default: // UIInterfaceOrientationPortrait
            degrees = 0.0;
            break;
    }
    self.transform = CGAffineTransformMakeRotation(degreesToRadians(degrees));    
	[self setNeedsDisplay];
}

- (void)showWithStatus:(NSString *)status indicatorType:(IndicatorType)indicatorType {
    for (UIView *view in self.subviews) {
        if (view == _labelMsg) { continue; }
        
        view.hidden = YES;
    }
    _imgViewIcon.backgroundColor = [UIColor clearColor];
    
    // ===================================================================================
    self.transform = CGAffineTransformIdentity; // 太他妈重要了, transform会影响frame、bounds
    // ===================================================================================
    
    CGRect rc = CGRectMake(0, 0, 200, 50);
    self.bounds = rc;
    
    rc.size.width -= _btnClose.bounds.size.width;
    _labelMsg.bounds = rc;
    _labelMsg.text = status;

    switch (indicatorType) {
        case IndicatorTypeProgress:
        {
            _viewProgress.hidden = _labelProgress.hidden = _btnClose.hidden = NO;
            
            rc.size.height   = 20;
            _labelProgress.frame = rc;

            rc.origin.y = rc.size.height;
            rc.size.height = 30;
            _labelMsg.frame = rc;
        }
            break;
        case IndicatorTypeLoading:
        {
            [_viewLoading startAnimating];
            _viewLoading.hidden = NO;
            _btnClose.hidden = NO;
            
            rc.size.width = 250;
            self.bounds = rc;
            
            rc = _labelMsg.bounds;
        }
            break;
        case IndicatorTypeSuccess:
        {
            [_imgViewIcon setImage:[UIImage imageNamed:@"indicator-success.png"]];
            _imgViewIcon.backgroundColor = RGB_COLOR(38, 200, 33);
            _imgViewIcon.hidden = NO;
        }
            break;
        case IndicatorTypeError:
        {
            [_imgViewIcon setImage:[UIImage imageNamed:@"indicator-error.png"]];
            _imgViewIcon.backgroundColor = RGB_COLOR(255, 50, 50);
            _imgViewIcon.hidden = NO;
        }
            break;
        case IndicatorTypeWarning:
        {
            [_imgViewIcon setImage:[UIImage imageNamed:@"indicator-warning.png"]];
            _imgViewIcon.backgroundColor = RGB_COLOR(255, 155, 0);
            _imgViewIcon.hidden = NO;
        }
            break;
            
        default: // IndicatorTypeDefault
        {
            [_viewLoading startAnimating];
            _viewLoading.hidden = NO;
        }
            break;
    }

    [_labelMsg sizeToFit];
    CGSize sz = _labelMsg.bounds.size;
    if (sz.height > rc.size.height) {
        rc = self.frame;
        rc.size.height = sz.height+10;
        if (indicatorType == IndicatorTypeProgress) {
            rc.size.height += 15;
        }
        self.frame = CGRectIntegral(rc);
    }
    rc = _labelMsg.bounds;
    CGFloat tmpW = _btnClose.bounds.size.width;
    rc.origin.x = (self.bounds.size.width-rc.size.width+tmpW)/2;
    rc.origin.y = (self.bounds.size.height-rc.size.height)/2;
    if (indicatorType == IndicatorTypeLoading) {
        rc.origin.x -= tmpW/2;
    }
    else if (indicatorType == IndicatorTypeProgress) {
        rc.origin.x -= tmpW;
        rc.origin.y = 20;
    }
    _labelMsg.frame = CGRectIntegral(rc);
    
    // _maskWindow
    if (!_maskWindow) {
        _maskWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskWindow.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        _maskWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _maskWindow.windowLevel = UIWindowLevelStatusBar+1;
    }
    [self addSelfAction];
    
    if (!self.superview) {
        rc = self.frame;
        rc.origin.x = (_maskWindow.bounds.size.width-rc.size.width)/2;
        rc.origin.y = (_maskWindow.bounds.size.height-rc.size.height)/2;
        self.frame = CGRectIntegral(rc);
        
        [_maskWindow addSubview:self];
    }
    [self fixedPosition:nil];
    
    [_maskWindow makeKeyAndVisible];
    
    if (self.alpha != 1) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(fixedPosition:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
        
        [UIView animateWithDuration:0.35
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             _maskWindow.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.07];
                             self.alpha = 1;
                         }
                         completion:nil];
    }
}

- (void)showWithStatus:(NSString*)status indicatorType:(IndicatorType)indicatorType request:(ASIHTTPRequest *)request {
    _request = request;
    if (indicatorType == IndicatorTypeProgress) {
        _request.uploadProgressDelegate = self;
        _request.downloadProgressDelegate = self;
    }
    [self showWithStatus:status indicatorType:indicatorType];
}

- (void)showWithStatus:(NSString*)status indicatorType:(IndicatorType)indicatorType duration:(NSTimeInterval)duration {
    _request = nil;
    [self showWithStatus:status indicatorType:indicatorType];
    
    if (duration) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:duration];
    }
}

- (void)dismiss {
    if(self.alpha != 0) {
        [UIView animateWithDuration:0.25
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             _maskWindow.backgroundColor = [UIColor clearColor];
                             self.alpha = 0;
                         }
                         completion:^(BOOL finished){
                             if(self.alpha == 0) {
                                 [[NSNotificationCenter defaultCenter] removeObserver:self];
                                 
                                 [_viewLoading stopAnimating];
                                 [self removeFromSuperview];
                                 _maskWindow = nil;
                                 
                                 [[UIApplication sharedApplication].windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
                                     if([window isKindOfClass:[UIWindow class]] && window.windowLevel == UIWindowLevelNormal) {
                                         [window makeKeyWindow];
                                         *stop = YES;
                                     }
                                 }];
                             }
                         }];
    }
}

- (void)onTouchBtnClose {
    if (_request) { [_request cancel]; }
    else { [self dismiss]; }
}

- (void)removeBtnCloseAllTargets {
    NSArray *arrActionSelf = [_btnClose actionsForTarget:self forControlEvent:UIControlEventTouchUpInside];
    for (NSString *selStr in arrActionSelf) {
        [_btnClose removeTarget:self action:NSSelectorFromString(selStr) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (_targetCustom && _selCustom) {
        NSArray *arrActionCustom = [_btnClose actionsForTarget:_targetCustom forControlEvent:UIControlEventTouchUpInside];
        for (NSString *selStr in arrActionCustom) {
            [_btnClose removeTarget:_targetCustom action:NSSelectorFromString(selStr) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)addSelfAction {
    [self removeBtnCloseAllTargets];
    [_btnClose addTarget:self action:@selector(onTouchBtnClose) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addCustomAction:(SEL)action target:(id)target {
    [self removeBtnCloseAllTargets];
    [_btnClose addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    _selCustom    = action;
    _targetCustom = target;
}

#pragma mark - show/dismiss methods
+ (void)showWithStatus:(NSString *)status {
    [[ViewIndicator sharedView] showWithStatus:status indicatorType:IndicatorTypeDefault duration:0];
}

+ (void)showWithStatus:(NSString*)status indicatorType:(IndicatorType)indicatorType {
    switch (indicatorType) {
        case IndicatorTypeSuccess:
        {
            [ViewIndicator showSuccessWithStatus:status duration:0];
        }
            break;
        case IndicatorTypeError:
        {
            [ViewIndicator showErrorWithStatus:status duration:0];
        }
            break;
        case IndicatorTypeWarning:
        {
            [ViewIndicator showWarningWithStatus:status duration:0];
        }
            break;
        case IndicatorTypeDefault:
        {
            [ViewIndicator showWithStatus:status];
        }
            break;
            
        default:
            break;
    }
}

+ (void)showProgressWithStatus:(NSString *)status request:(ASIHTTPRequest *)request {
    [[ViewIndicator sharedView] showWithStatus:status indicatorType:IndicatorTypeProgress request:request];
}

+ (void)showLoadingWithStatus:(NSString *)status request:(ASIHTTPRequest *)request {
    [[ViewIndicator sharedView] showWithStatus:status indicatorType:IndicatorTypeLoading request:request];
}

+ (void)showSuccessWithStatus:(NSString *)status duration:(NSTimeInterval)duration {
    [[ViewIndicator sharedView] showWithStatus:status indicatorType:IndicatorTypeSuccess duration:duration];
}

+ (void)showErrorWithStatus:(NSString *)status duration:(NSTimeInterval)duration {
    [[ViewIndicator sharedView] showWithStatus:status indicatorType:IndicatorTypeError duration:duration];
}

+ (void)showWarningWithStatus:(NSString *)status duration:(NSTimeInterval)duration {
    [[ViewIndicator sharedView] showWithStatus:status indicatorType:IndicatorTypeWarning duration:duration];
}

+ (void)dismiss {
    [[ViewIndicator sharedView] dismiss];
}

#pragma mark - ASIProgressDelegate method
- (void)setProgress:(float)newProgress {
    if (newProgress > 1) { return; }
    
    _labelProgress.text = [NSString stringWithFormat:@"%d%%", (int)(newProgress*100)];
    
    CGRect rc     = _viewProgress.frame;
    rc.size.width = newProgress*(self.bounds.size.width-_btnClose.bounds.size.width);
    _viewProgress.frame = rc;
}

@end
