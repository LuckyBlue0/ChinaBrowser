//
//  View2dCode.m
//

#import "View2dCode.h"

@interface View2dCode () {
    UILabel *_lbTitle;
    UIView *_viewScanCrop;
    UIView *_viewH;
    
    NSTimer *_timer;
}

@end

@implementation View2dCode

- (void)dealloc {
    [self stopTimer];
    [_viewBarCode stop];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGRect rc = self.bounds;
        rc.origin.y = 15;
        rc.size.height = 45;
        rc.origin.x = 6;
        rc.size.width -= rc.origin.x*2;
        _lbTitle = [[UILabel alloc] initWithFrame:rc];
        _lbTitle.backgroundColor = [UIColor clearColor];
        _lbTitle.text = GetTextFromKey(@"ScanQRCode");
        _lbTitle.font = [UIFont systemFontOfSize:15];
        _lbTitle.textAlignment = CustomTextAlignmentCenter;
        [self addSubview:_lbTitle];

        _viewBarCode = [[ZBarReaderView alloc] init];
        rc = self.bounds;
        rc.origin.x = 21;
        rc.size.width -= rc.origin.x*2-2;
        rc.size.height = 300;
        rc.origin.y = self.bounds.size.height-rc.size.height-rc.origin.x;
        _viewBarCode.frame = rc;
        [self addSubview:_viewBarCode];
        //关闭闪光灯
//        _viewBarCode.torchMode = 0;
        // 扫描区域计算
        rc = _viewBarCode.bounds;
        rc.origin.x = 45;
        rc.size.width -= rc.origin.x*2-1;
        rc.size.height = rc.size.width;
        rc.origin.y = _viewBarCode.bounds.size.height-rc.size.height-rc.origin.x+1;
        _viewBarCode.scanCrop = [self getScanCrop:rc readerViewBounds:_viewBarCode.bounds];
        [_viewBarCode willRotateToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]
                                              duration:[[UIApplication sharedApplication] statusBarOrientationAnimationDuration]];
        
        // 扫描区域
        _viewScanCrop = [[UIView alloc] initWithFrame:rc];
        [_viewBarCode addSubview:_viewScanCrop];

        rc = _viewScanCrop.bounds;
        rc.size.height = 2;
        _viewH = [[UIView alloc] initWithFrame:rc];
        _viewH.backgroundColor = RGB_COLOR(35, 141, 240);
        CALayer *layer = _viewH.layer;
        layer.shadowColor = RGB_COLOR(35, 141, 240).CGColor;
        layer.shadowOffset = CGSizeZero;
        layer.shadowRadius = 3.0;
        layer.shadowOpacity = 1;
        layer.shadowPath = [UIBezierPath bezierPathWithRect:layer.bounds].CGPath;
        [_viewScanCrop addSubview:_viewH];
        
        rc = self.bounds;
        rc.origin.y = 75;
        rc.size.height = 42;
        rc.origin.x = 64;
        rc.size.width -= rc.origin.x*2;
        UILabel *lbSubTitle = [[UILabel alloc] initWithFrame:rc];
        lbSubTitle.numberOfLines = 0;
        lbSubTitle.backgroundColor = [UIColor clearColor];
        lbSubTitle.text = GetTextFromKey(@"ScanDesc");
        lbSubTitle.textColor = [UIColor whiteColor];
        lbSubTitle.shadowOffset = CGSizeZero;
        lbSubTitle.shadowColor = [UIColor grayColor];
        lbSubTitle.font = [UIFont systemFontOfSize:15];
        lbSubTitle.textAlignment = CustomTextAlignmentCenter;
        [self addSubview:lbSubTitle];
        
        [self whenDayModeChanged];
    }
    
    return self;
}

- (void)setAlpha:(CGFloat)alpha {
    [super setAlpha:alpha];
    
    if (alpha == 0) {
        [self stopTimer];
        [_viewBarCode stop];
    }
    else {
        [self fireTimer];
        [_viewBarCode start];
    }
}

- (void)fireTimer {
    if (!_timer) {
        _timer =  [NSTimer scheduledTimerWithTimeInterval:1.8
                                                   target:self
                                                 selector:@selector(handleTimer:)
                                                 userInfo:nil
                                                  repeats:YES];
    }
    
    [_timer fire];
}

- (void)stopTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)handleTimer:(NSTimer *)timer {
    [UIView animateWithDuration:1.5 animations:^{
        CGRect rc = _viewH.frame;
        rc.origin.y = rc.origin.y==0?_viewScanCrop.bounds.size.height-rc.size.height:0;
        _viewH.frame = rc;
    }];
}

- (CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds {
    CGFloat x, y, width, height;
    
    x = rect.origin.x/readerViewBounds.size.width;
    y = rect.origin.y/readerViewBounds.size.height;
    width = rect.size.width/readerViewBounds.size.width;
    height = rect.size.height/readerViewBounds.size.height;
    
    return CGRectMake(x, y, width, height);
}

#pragma mark - notif
- (void)whenDayModeChanged {
    BOOL dayMode = isDayMode;
    
    _lbTitle.textColor = dayMode?kTextColorDay:kTextColorNight;
    [self setBgImageWithStretchImage:[BundlePngImageForHome(dayMode?@"scan-bg-bai":@"scan-bg-ye") stretchableImageWithLeftCapWidth:30 topCapHeight:30]];
    [self sendSubviewToBack:_viewBarCode];
}

@end
