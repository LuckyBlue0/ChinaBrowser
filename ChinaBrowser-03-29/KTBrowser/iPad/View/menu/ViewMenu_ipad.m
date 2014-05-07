//
//  ViewMenu_ipad.m
//

#import "ViewMenu_ipad.h"

#import "ViewIndicator.h"

#import "ViewSlider_ipad.h"

#import "ADOFavorite.h"

#import "WKSync.h"

@implementation ViewMenu_ipad

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIView *viewTools = [[[NSBundle mainBundle] loadNibNamed:@"ViewTools_ipad" owner:self options:nil] objectAtIndex:0];
    CGRect rc = viewTools.frame;
    rc.origin.x = _svMenu.bounds.size.width;
    viewTools.frame = rc;
    [_svMenu addSubview:viewTools];
    _svMenu.delegate = self;
    _svMenu.contentSize = CGSizeMake(_svMenu.bounds.size.width*2, _svMenu.bounds.size.height);

    _viewSlider = [[ViewSlider_ipad alloc] initWithFrame:_sliderBrightness.frame];
    [_viewBrightness addSubview:_viewSlider];

    [_btnSetting setTitle:GetTextFromKey(@"settings") forState:UIControlStateNormal];
    [_btnTools setTitle:GetTextFromKey(@"tools") forState:UIControlStateNormal];
    
    _lbClearHis.text = GetTextFromKey(@"QingChuJiLu");
    _lbNoImgMode.text = GetTextFromKey(@"noImgMode");
    _lbFontSize.text = GetTextFromKey(@"fontsize");
    
    _lbScreenshot.text = GetTextFromKey(@"screenshot");
    _lb2dCode.text = GetTextFromKey(@"qrcode");
    _lbFindInPage.text = GetTextFromKey(@"find_in_page");
    
    _lbSkin.text = GetTextFromKey(@"skin");
    _lbShare.text = GetTextFromKey(@"share");
    _lbUpdate.text = GetTextFromKey(@"GengXin");
    _lbFeedback.text = GetTextFromKey(@"PingFen");
    
    [_imgFontSize setHighlightedImage:getMenuImageWithName(@"Set-font-1")];
    [_imgScreenshot setHighlightedImage:getMenuImageWithName(@"Set-8-1")];
    [_img2dCode setHighlightedImage:getMenuImageWithName(@"Set-12-1")];
    [_imgFindInPage setHighlightedImage:getMenuImageWithName(@"Set-11-1")];
    
    [_imgSkin setHighlightedImage:getMenuImageWithName(@"Set-7-1")];
    [_imgShare setHighlightedImage:getMenuImageWithName(@"Set-9-1")];
    [_imgUpdate setHighlightedImage:getMenuImageWithName(@"Set-6-1")];
    [_imgFeedback setHighlightedImage:getMenuImageWithName(@"Set-5-1")];
    
    // -------------
    BOOL screenLocked = [AppManager screenLocked];
    _lbScreenLock.text = GetTextFromKey(screenLocked?@"PingMuJieSuo":@"ScreenLocked");
    [_imgScreenLock setImage:getMenuImageWithName(screenLocked?@"Set-3-1":@"Set-3-0")];

    BOOL stealthMode = [AppManager stealthMode];
    _lbStealthMode.text = GetTextFromKey(@"no_history");
    [_imgStealthMode setImage:getMenuImageWithName(stealthMode?@"Set-1-1":@"Set-1-0")];
    
    BOOL noImgMode = [AppManager noImgMode];
    [_imgNoImgMode setImage:getMenuImageWithName(noImgMode?@"Set-2-1":@"Set-2-0")];
    
    [self whenDayModeChanged];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(whenNoImgModeChanged) name:kNotifNoImgModeChanged object:nil];
}

- (void)setAlpha:(CGFloat)alpha {
    [super setAlpha:alpha];

    [self fixSubviews];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifViewMenuShowed object:nil];
}

- (void)fixSubviews {
    BOOL dayMode = isDayMode;

    [_imgSunZero setImage:getMenuImageWithName(dayMode?@"Set-15-0":@"Set-15-1")];
    [_imgSunFull setImage:getMenuImageWithName(dayMode?@"Set-14-0":@"Set-14-1")];
    
    [_imgFontSize setImage:getMenuImageWithName(dayMode?@"Set-font-0":@"Set-font-2")];
    [_imgScreenshot setImage:getMenuImageWithName(dayMode?@"Set-8-0":@"Set-8-2")];
    [_img2dCode setImage:getMenuImageWithName(dayMode?@"Set-12-0":@"Set-12-2")];
    [_imgFindInPage setImage:getMenuImageWithName(dayMode?@"Set-11-0":@"Set-11-2")];
    
    [_imgSkin setImage:getMenuImageWithName(dayMode?@"Set-7-0":@"Set-7-2")];
    [_imgShare setImage:getMenuImageWithName(dayMode?@"Set-9-0":@"Set-9-2")];
    [_imgUpdate setImage:getMenuImageWithName(dayMode?@"Set-6-0":@"Set-6-2")];
    [_imgFeedback setImage:getMenuImageWithName(dayMode?@"Set-5-0":@"Set-5-2")];
    
    
    [_imgBackground setImage:[getMenuImageWithName(dayMode?@"bg-set-bai":@"bg-set-ye") stretchableImageWithLeftCapWidth:32 topCapHeight:32]];
    [_imgClearHis setImage:ImageFromSkinByName(@"setting-0-0.png")];
    [_imgClearHis setHighlightedImage:ImageFromSkinByName(@"setting-0-1.png")];
    [_imgDayMode setImage:getMenuImageWithName(dayMode?@"Set-0-0":@"Set-0-1")];

    CGFloat brightness = [AppManager brightness];
    [_viewSlider setValue:brightness];
    [self setSlider:_sliderBrightness];
    _sliderBrightness.value = brightness;

    _lbDayMode.text = GetTextFromKey(dayMode?@"YeJian":@"BaiTian");
    
    UIColor *textColor = dayMode?kTextColorDay:kTextColorNight;
    [_btnSetting setTitleColor:textColor forState:UIControlStateNormal];
    [_btnTools setTitleColor:textColor forState:UIControlStateNormal];
}

- (void)setSlider:(UISlider *)slider {
    // 左右轨的图片
    UIImage *stetchLeftTrack= [getMenuImageWithName(@"switch-1-bg-1") stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    UIImage *stetchRightTrack = [getMenuImageWithName(@"switch-1-bg-0") stretchableImageWithLeftCapWidth:90 topCapHeight:0];
    // 滑块图片
    UIImage *thumbImage = getMenuImageWithName(@"switch-1-btn-0");
    
    slider.backgroundColor = [UIColor clearColor];
    slider.value = 0;
    slider.minimumValue = 0.2;
    slider.maximumValue = 0.8;
    
    [slider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
    [slider setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
    // 注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
    [slider setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [slider setThumbImage:getMenuImageWithName(@"switch-1-btn-0")  forState:UIControlStateNormal];
    
    if(slider == _sliderBrightness) {
        slider.userInteractionEnabled = YES;
    }
}

- (IBAction)onTouchSetting {
    _btnSetting.selected = YES;
    _btnTools.selected = NO;
    [_svMenu setContentOffset:CGPointZero animated:YES];
}

- (IBAction)onTouchTools {
    _btnTools.selected = YES;
    _btnSetting.selected = NO;
    [_svMenu setContentOffset:CGPointMake(_svMenu.bounds.size.width, 0) animated:YES];
}

- (IBAction)onTouchCtrlClearHis {
    [ADOFavorite deleteWithDataType:WKSyncDataTypeHistory uid:[WKSync shareWKSync].modelUser.uid];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kNotifClearHis" object:nil];
    
    [ViewIndicator showSuccessWithStatus:GetTextFromKey(@"QingChuJiLuChengGong") duration:1.0];
}

- (IBAction)onTouchCtrlScreenLock {
    [AppManager changeScreenLocked];

    BOOL screenLocked = [AppManager screenLocked];
    _lbScreenLock.text = GetTextFromKey(screenLocked?@"PingMuJieSuo":@"ScreenLocked");
    [_imgScreenLock setImage:getMenuImageWithName(screenLocked?@"Set-3-1":@"Set-3-0")];
    
    [ViewIndicator showSuccessWithStatus:GetTextFromKey(screenLocked?@"PingMuXuanZhuanYiSuoDing":@"PingMuXuanZhuanYiJiSuo") duration:1.0];
}

- (IBAction)onTouchCtrlStealthMode {
    [AppManager changeStealthMode];

    BOOL stealthMode = [AppManager stealthMode];
    [_imgStealthMode setImage:getMenuImageWithName(stealthMode?@"Set-1-1":@"Set-1-0") ];
    
    [ViewIndicator showSuccessWithStatus:GetTextFromKey(stealthMode?@"YiJinRuYinShenMoShi":@"YiJieChuYinShen") duration:1.0];
}

- (IBAction)onTouchCtrlDayMode {
    [AppManager changeBrightness:(CGFloat)!isDayMode];
    [DayModeManager_ipad switchDayMode];
}

- (void)whenNoImgModeChanged {    
    [_imgNoImgMode setImage:getMenuImageWithName([AppManager noImgMode]?@"Set-2-1":@"Set-2-0")];
}

- (IBAction)onTouchCtrlUpdate {
    NSString *url = [NSString stringWithFormat:@"itms-apps://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=596346080"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (IBAction)onTouchCtrlFeedback {
    NSString *url = [NSString stringWithFormat:
                     @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=596346080"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

#pragma mark - notif
//重写该方法来更改多语言选项  在父类增加的监听通知
- (void)whenLangChanged {
}

//重写该方法来接收旋转  在父类增加的监听通知
- (void)whenDeviceDidRotate {
}

//重写该方法来更改日间黑夜模式  在父类增加的监听通知
- (void)whenDayModeChanged {
    [self fixSubviews];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    BOOL showTools = scrollView.contentOffset.x>0;
    _btnSetting.selected = !showTools;
    _btnTools.selected = showTools;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat svWidth = scrollView.bounds.size.width;
    CGFloat offsetX = MIN(svWidth, MAX(0, scrollView.contentOffset.x));
    CGFloat ratio = offsetX/svWidth;
    CGFloat rawX = 26;
    CGRect rc = _ivSign.frame;
    rc.origin.x = rawX+(self.bounds.size.width-2*rawX-rc.size.width)*ratio;
    _ivSign.frame = rc;
}

@end
