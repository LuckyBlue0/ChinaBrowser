
#import "ControllerRoot_ipad.h"

#import <AVFoundation/AVFoundation.h>

#import "ControllerNav_ipad.h"

#import "ControllerScrawl.h"

#import "CustomURLCache.h"

#import "UIView+Genie.h"
#import "UIImage+Resize.h"
#import "UIWebView+Clean.h"
#import "UIImage+ImageEffects.h"

#import "CtrlTag_ipad.h"

#import "UIImageView+MYSDWebImage.h"
#import "ShareSDKPackage.h"
#import "WebViewEx_ipad.h"
#import "ViewIndicator.h"

#import "ViewTopMenu_ipad.h"
#import "ViewTagsBar_ipad.h"
#import "ViewDots_ipad.h"

#import "ViewMenu_ipad.h"
#import "ViewFindInPage_ipad.h"
#import "ViewHomeItem_ipad.h"
#import "ViewCommonSites.h"
#import "ViewSkin.h"

#import "ModelUrl_ipad.h"
#import "ADOFavorite.h"

#import "WKSync.h"

#define kBrightnessMin 0.3
#define kWidthViewHistory 398

@interface ControllerRoot_ipad () {
    ControllerHistory *_vcHistory;
    ControllerAddSite *_vcAddSite;
    
    UIScrollView  *_svIndex;
    ViewHome_ipad *_viewHome;
    ViewDots_ipad *_viewDots;
    ViewMenu_ipad *_viewMenu;
    ViewFindInPage_ipad *_viewFindInPage;
    
    WebViewEx_ipad   *_webViewCurrent;
    ViewTopMenu_ipad *_viewTopMenu;
    ViewCommonSites *_viewCommonSites;
    View2dCode      *_view2dCode;
    UIButton        *_btnShowSkin;
    ViewSkin        *_viewSkin;
    
    UIImageView *_ivBg;
    UIView   *_viewMain;
    UIView   *_viewMask;
    UIWindow *_brightnessWindow;
    
    NSString *_currUrl;
    NSString *_selectedImageURL;
    UIImage  *_imgShare;
    CAGradientLayer *_layerBg;
    AVAudioPlayer   *_audioPlayer;
    
    BOOL _stateHaveUrl;
    BOOL _stateHaveImg;
    
    BOOL _isDragging;
    BOOL _isFullscreen;
    BOOL _showViewFind;
    BOOL _showView2dCode;
    BOOL _showViewScrawl;
    BOOL _showViewSkin;
}

@end

@implementation ControllerRoot_ipad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createCustomCache];
    
    ////////////////////
    [self performSelectorOnMainThread:@selector(installBrightnessWindow) withObject:nil waitUntilDone:NO];

    NSNotificationCenter *notifCenter = [NSNotificationCenter defaultCenter];
    [notifCenter addObserver:self selector:@selector(whenNewTagAdded:) name:kNotifNewTagAdded object:nil];
    [notifCenter addObserver:self selector:@selector(whenTagSelected:) name:kNotifTagSelected object:nil];
    [notifCenter addObserver:self selector:@selector(contextualMenuAction:) name:@"TapAndHoldNotification" object:nil];
    [notifCenter addObserver:self selector:@selector(whenTopSearchWidthChanged:) name:kNotifTopSearchWidthChanged object:nil];
    
    self.viewContent.alpha = 0;
    [WebviewsManager setObjDelegate:self];
    BOOL dayMode = isDayMode;
    self.view.backgroundColor = dayMode?kMainBgColorDay:kMainBgColorNight;
    
    CGRect rc = self.view.bounds;
    _ivBg = [[UIImageView alloc] initWithFrame:rc];
    _ivBg.contentMode = UIViewContentModeScaleAspectFill;
    _ivBg.backgroundColor = [UIColor clearColor];
    [_ivBg setImage:[AppManager currentSkin]];
    _ivBg.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view insertSubview:_ivBg belowSubview:self.viewContent];
    
    rc = _ivBg.frame;
    _viewMain = [[UIView alloc] initWithFrame:rc];
    _viewMain.backgroundColor = [UIColor clearColor];
    _viewMain.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapViewMain:)];
    tapGes.delegate = self;
    [_viewMain addGestureRecognizer:tapGes];
    [self.viewContent addSubview:_viewMain];
    
    _viewTopMenu = [[[NSBundle mainBundle] loadNibNamed:@"ViewTopMenu_ipad" owner:self options:nil] objectAtIndex:0];
    rc = _viewTopMenu.frame;
    rc.size.width = _viewMain.bounds.size.width;
    _viewTopMenu.frame = rc;
    [_viewTopMenu setBtnsEnable:NO];
    _viewTopMenu.txtUrl.delegate = self;
    [_viewMain addSubview:_viewTopMenu];
    _viewTopMenu.viewTopSearch.objDelegate = self;
    
    [_viewTopMenu.btnMenu addTarget:self action:@selector(onTouchSetting:) forControlEvents:UIControlEventTouchUpInside];
    [_viewTopMenu.btnPageBack addTarget:self action:@selector(onClickPageBack) forControlEvents:UIControlEventTouchUpInside];
    [_viewTopMenu.btnPageFront addTarget:self action:@selector(onClickPageFront) forControlEvents:UIControlEventTouchUpInside];
    [_viewTopMenu.btnAddFav addTarget:self action:@selector(onTouchFav:) forControlEvents:UIControlEventTouchUpInside];
    [_viewTopMenu.btnHome addTarget:self action:@selector(onTouchHome) forControlEvents:UIControlEventTouchUpInside];
    [_viewTopMenu.btnRefresh addTarget:self action:@selector(onTouchRefresh) forControlEvents:UIControlEventTouchUpInside];
    [_viewTopMenu.btnBookmarker addTarget:self action:@selector(onTouchHis:) forControlEvents:UIControlEventTouchUpInside];
    [_viewTopMenu.btnQRCode addTarget:self action:@selector(onTouchQRCode:) forControlEvents:UIControlEventTouchUpInside];
    
    rc.origin.y += rc.size.height;
    rc.size.height = _viewMain.bounds.size.height-rc.origin.y;
    _svIndex = [[UIScrollView alloc] initWithFrame:rc];
    _svIndex.delegate = self;
    _svIndex.pagingEnabled = YES;
    _svIndex.backgroundColor = [UIColor clearColor];
    _svIndex.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _svIndex.showsHorizontalScrollIndicator = _svIndex.showsVerticalScrollIndicator = NO;
    [_viewMain addSubview:_svIndex];
    
    _viewHome = [[[NSBundle mainBundle] loadNibNamed:@"ViewHome_ipad" owner:self options:nil] objectAtIndex:0];
    _viewHome.frame = _svIndex.bounds;
    [_svIndex addSubview:_viewHome];
    _viewHome.objDelegate = self;
    _viewHome.viewHomeSearch.objDelegate = self;

    rc = _viewHome.frame;
    rc.origin.x += rc.size.width;
    _viewCommonSites = [[ViewCommonSites alloc] initWithFrame:rc];
    _viewCommonSites.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    _viewCommonSites.objDelegate = self;
    [_svIndex addSubview:_viewCommonSites];
    
    _viewDots = [[[NSBundle mainBundle] loadNibNamed:@"ViewDots_ipad" owner:self options:Nil] objectAtIndex:0];
    [_viewMain addSubview:_viewDots];
    rc = _viewDots.frame;
    rc.origin.y = _viewMain.bounds.size.height-rc.size.height-20;
    rc.origin.x = (_viewMain.bounds.size.width-rc.size.width)*0.5;
    _viewDots.frame = rc;
    [_viewDots setPage:0];
    _viewDots.userInteractionEnabled = NO;

    rc = _viewMain.bounds;
    //_viewMask
    _viewMask = [[UIView alloc] initWithFrame:rc];
    _viewMask.alpha = 0;
    _viewMask.backgroundColor = [UIColor clearColor];
    _viewMask.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [_viewMain addSubview:_viewMask];
    
    // _btnShowSkin
    rc.size = CGSizeMake(60, 60);
    rc.origin.y = _viewMain.bounds.size.height-rc.size.height;
    _btnShowSkin = [[UIButton alloc] initWithFrame:rc];
    _btnShowSkin.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [_btnShowSkin setImageWithName:isDayMode?@"ipad-icon-skin-bai":@"ipad-icon-skin-ye"];
    [_btnShowSkin addTarget:self action:@selector(onTouchShowSkin) forControlEvents:UIControlEventTouchDown];
    [_viewMain addSubview:_btnShowSkin];
}

- (void)viewDidAppear:(BOOL)animated {
#ifdef __IPHONE_7_0
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
#endif
    double delayInSeconds = 0.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self whenDeviceDidRotate];
    });

    [RotateManager_ipad toScreenOrientation:(isPortrait?ScreenOrientationPortrait:ScreenOrientationLandscape)];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifDidRotate object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifLangChanged object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifDayModeChanged object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(whenDayModeChanged) name:kNotifDayModeChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(whenSkinChanged:) name:kNotifSkinChanged object:nil];
    
    // 向导图
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kReadAppGuide]) {
        ViewGuide_ipad *viewGuide = [[ViewGuide_ipad alloc] initWithFrame:self.view.bounds];
        viewGuide.delegate = self;
        [self.view addSubview:viewGuide];
        
        return;
    }

    [self readGuideFinished];
}

- (void)readGuideFinished {
    [ControllerNav_ipad allowAutorotate:YES];
    
    if (!_layerBg) {
        BOOL dayMode = isDayMode;
        
        _layerBg = [CAGradientLayer layer];
        _layerBg.backgroundColor=[UIColor clearColor].CGColor;
        _layerBg.locations = @[@(0.55), @(1)];
        _layerBg.startPoint = CGPointMake(0.5, 0);
        _layerBg.endPoint = CGPointMake(0.5, 1);
        UIColor *layerColor = (dayMode?kMainBgColorDay:kMainBgColorNight);
        _layerBg.colors = @[(id)layerColor.CGColor, (id)[layerColor colorWithAlphaComponent:0].CGColor];
        CGRect rcBg = _layerBg.bounds;
        rcBg.size = CGSizeMake(isPortrait?768:1024, 370);
        _layerBg.frame = rcBg;
        [_ivBg.layer addSublayer:_layerBg];
    }
    
    self.viewContent.alpha = 1;
    [KTAnimationKit animationEaseIn:self.viewContent];
}

- (void)showFullscreen:(BOOL)fullscreen {
    if (_isFullscreen == fullscreen) {
        return;
    }
    _isFullscreen = fullscreen;

    if (fullscreen) {
        CGRect rc = _webViewCurrent.frame;
        rc.size.height = _viewMain.bounds.size.height;
        _webViewCurrent.frame = rc;
    }

    [UIView animateWithDuration:0.25 animations:^{
        CGRect rc = _viewTopMenu.frame;
        rc.origin.y = fullscreen?-rc.size.height:0;
        _viewTopMenu.frame = rc;
        
        rc = _webViewCurrent.frame;
        rc.origin.y = fullscreen?0:_viewTopMenu.bounds.size.height;
        _webViewCurrent.frame = rc;
    } completion:^(BOOL finished) {
        if (!fullscreen) {
            CGRect rc = _webViewCurrent.frame;
            rc.size.height = _viewMain.bounds.size.height-rc.origin.y;
            _webViewCurrent.frame = rc;
        }
    }];
}

- (void)setFavStarState {
    if(_webViewCurrent) {
        BOOL exists = [ADOFavorite isExistsWithDataType:WKSyncDataTypeFavorite link:_webViewCurrent.link uid:[WKSync shareWKSync].modelUser.uid withGuest:NO];
        _viewTopMenu.btnAddFav.selected = exists;
    }
}

- (void)setBtnRefreshstate {
    if(_webViewCurrent.isLoading) {
        [_viewTopMenu.btnRefresh setImage:BundleImageForSearch(isDayMode?@"btn-stop-bai":@"btn-stop-ye") forState:UIControlStateNormal];
    }
    else {
        [_viewTopMenu.btnRefresh setImage:BundleImageForSearch(isDayMode?@"btn-refresh-bai":@"btn-refresh-ye") forState:UIControlStateNormal];
    }
}

- (void)setViewTopMenuState {
    UIView *txtUrl = _viewTopMenu.txtUrl;
    if (txtUrl.isFirstResponder) {
        return;
    }
    
    BOOL showHome = _svIndex.alpha==1;
    
    _viewTopMenu.viewTools.backgroundColor = showHome?[UIColor clearColor]:(isDayMode?kMainBgColorDay:kMainBgColorNight);
    
    UIView *btnQRCode = _viewTopMenu.btnQRCode;
    UIView *btnRefresh = _viewTopMenu.btnRefresh;
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat tx = (showHome ? 0:-btnQRCode.bounds.size.width);
        btnQRCode.transform = CGAffineTransformMakeTranslation(tx, 0);
        btnRefresh.alpha = !showHome;
        
        CGRect rc = txtUrl.frame;
        rc.size.width = btnQRCode.frame.origin.x-rc.origin.x-1;
        txtUrl.frame = rc;
    }];
}

- (void)setSubviewsState {
    BOOL showHome;
    if (_viewTopMenu.clickedAddTag) {
        _viewTopMenu.clickedAddTag = NO;
        
        showHome = YES;
    }
    else {
        showHome = _svIndex.alpha==1;
    }

    _svIndex.alpha = _viewDots.alpha = showHome;
    _currUrl = showHome?@"":_currUrl;
    [WebviewsManager changeCacheWithUrl:_currUrl webview:_webViewCurrent];
    
    [_viewTopMenu setBtnsEnable:!showHome];
    _viewTopMenu.txtUrl.text = _currUrl;
    
    int index = [[WebviewsManager arrWebViews] indexOfObject:_webViewCurrent];
    CtrlTag_ipad *tag = [_viewTopMenu.viewTagsTab.arrTags objectAtIndex:index];
    NSString *title = _webViewCurrent.title;
    if (showHome) {
        tag.labTitle.text = GetTextFromKey(@"homePage");
    }
    else if (title.length) {
        tag.labTitle.text = title;
    }
    else {
        tag.labTitle.text = _currUrl;
    }

    if (showHome) {
        [tag.imgIcon setImage:ImageFromSkinByName(@"biaoqian.png")];
        tag.iconHaveSet = NO;
    }
    else {
        if(_currUrl.length > 15) {
            NSString *host = [[NSURL URLWithString:_currUrl] host];
            [tag.imgIcon setImageWithUrl:[@"http://www.google.com/s2/favicons?domain=" stringByAppendingString:host]];
            tag.iconHaveSet = YES;
        }
        if(_webViewCurrent.shouldReload) {
            NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:_currUrl] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:120];
            [_webViewCurrent loadRequest:req];
            
            _webViewCurrent.shouldReload = NO;
        }
        
        [_viewMain insertSubview:_webViewCurrent belowSubview:_viewTopMenu];
    }

    [self setFavStarState];
    [self setViewTopMenuState];
    
    _btnShowSkin.alpha = showHome;
}

- (void)hideViewMask {
    UIButton *btn2dCode     = _viewTopMenu.btnQRCode;
    UIButton *btnBookmarker = _viewTopMenu.btnBookmarker;
    UIButton *btnMenu       = _viewTopMenu.btnMenu;
    UIControl *ctrlFind     = _viewMenu.ctrlFindInPage;
    if (btn2dCode.isSelected) {
        [self onTouchQRCode:btn2dCode];
    }
    else if (btnBookmarker.isSelected) {
        [self onTouchHis:btnBookmarker];
    }
    else if (btnMenu.isSelected) {
        [self onTouchSetting:btnMenu];
    }
    else if (ctrlFind.isSelected) {
        [self onTouchFindInPage];
    }
    else if (_btnShowSkin.isSelected) {
        [self showViewSkin:NO];
    }
}

- (void)fixLayerBgWidthToPortrait:(BOOL)toPortrait {
    CGRect rcBg = _layerBg.frame;
    rcBg.size.width = toPortrait?768:1024;
    _layerBg.frame = rcBg;
}

- (UIImage *)getSkinBlurImage {
    CGRect rc = _ivBg.bounds;
    rc.size.height = kViewSkinH;
    rc.origin.y = _ivBg.bounds.size.height-rc.size.height;
    UIImage *blurImg = [UIImage imageFromView:_ivBg rect:rc];
    
    blurImg = [blurImg applyBlurWithRadius:25
                                 tintColor:[UIColor colorWithWhite:1 alpha:0.3]
                     saturationDeltaFactor:1.2 maskImage:nil];
    
    return blurImg;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    UIView *viewTouch = touch.view;
    if (![viewTouch isKindOfClass:[ViewHomeItem_ipad class]]
        && ![viewTouch isKindOfClass:[BtnItemClose class]]) {
        _viewHome.editing = NO;
    }
    
    if([viewTouch isKindOfClass:[UIControl class]]) {
        return NO;
    }

    return YES;
}

#pragma mark - ViewGuideDelegate_iPad
- (void)viewGuideDismiss:(ViewGuide_ipad *)viewGuide {
    [self readGuideFinished];
}

#pragma mark - notif
- (void)whenDeviceDidRotate {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifDidRotate object:nil];
    
    self.view.backgroundColor = isDayMode?kMainBgColorDay:kMainBgColorNight;
    
    _svIndex.contentSize = CGSizeMake(SCREEN_SIZE_IPAD.width*2, 0);
    if(_svIndex.contentOffset.x > 0) {
        _svIndex.contentOffset = CGPointMake(_svIndex.bounds.size.width, 0);
    }
    
    CGRect rc = _view2dCode.frame;
    rc.origin.x = [_viewTopMenu.btnQRCode convertRect:_viewTopMenu.btnQRCode.bounds toView:_viewMain].origin.x;
    rc.origin.x -= rc.size.width*0.735;
    _view2dCode.frame = rc;
}

- (void)whenDayModeChanged {
    BOOL dayMode = isDayMode;
    
    [KTAnimationKit animationEaseOut:self.view];

    CGFloat brightness = dayMode?1:0;
    [AppManager changeBrightness:brightness];
    _brightnessWindow.alpha = (1.0-brightness)*kBrightnessMin;
    [AppManager setCurrentSkinKey:(dayMode?@"0":@"1")];
    [AppManager setCurrentSkin:BundleImageForHome(dayMode?@"bg-0-bai":@"bg-0-ye", @"jpg")];
    [_ivBg setImage:[AppManager currentSkin]];
    [_layerBg removeFromSuperlayer];
    UIColor *layerColor = (dayMode?kMainBgColorDay:kMainBgColorNight);
    _layerBg.colors = @[(id)layerColor.CGColor, (id)[layerColor colorWithAlphaComponent:0].CGColor];
    
    BOOL showHome = _svIndex.alpha==1;
    _viewTopMenu.viewTools.backgroundColor = showHome?[UIColor clearColor]:(dayMode?kMainBgColorDay:kMainBgColorNight);
    
    [_btnShowSkin setImageWithName:isDayMode?@"ipad-icon-skin-bai":@"ipad-icon-skin-ye"];
    
    [self setBtnRefreshstate];

    [KTAnimationKit animationEaseIn:self.view];

    double delayInSeconds = 0.35;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_ivBg.layer addSublayer:_layerBg];
    });
}

- (void)whenNewTagAdded:(NSNotification *)notif {
    if (!_svIndex) {
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self whenNewTagAdded:notif];
        });
        
        return;
    }

    [WebviewsManager addWebview];
    
    [_webViewCurrent removeFromSuperview];
    _webViewCurrent = [[WebviewsManager arrWebViews] lastObject];
    _webViewCurrent.shouldReload = YES;
    _webViewCurrent.scrollView.delegate = self;
    
    [self setSubviewsState];
}

- (void)whenTagSelected:(NSNotification *)notif {
    NSInteger index = [notif.object integerValue];
    _currUrl = [[WebviewsManager arrURLCaches] objectAtIndex:index];
    _viewTopMenu.txtUrl.text = _currUrl;
    
    [_webViewCurrent removeFromSuperview];
    _webViewCurrent = [[WebviewsManager arrWebViews] objectAtIndex:index];
    
    BOOL showHome = _currUrl.length==0;
    _svIndex.alpha = showHome;

    [self setSubviewsState];
}

- (void)whenTopSearchWidthChanged:(NSNotification *)notif {
    BOOL wider = [notif.object boolValue];
    [UIView animateWithDuration:0.25 animations:^{
        _viewTopMenu.viewUrl.alpha = !wider;
    }];
}

- (void)whenSkinChanged:(NSNotification *)notif {
    _ivBg.image = [AppManager currentSkin];
}

#pragma mark - autorotate
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    BOOL toPortrait = UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
    if (!toPortrait) {
        [self fixLayerBgWidthToPortrait:NO];
    }

    [RotateManager_ipad toScreenOrientation:(toPortrait?ScreenOrientationPortrait:ScreenOrientationLandscape)];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if (isPortrait) {
        [self fixLayerBgWidthToPortrait:YES];
    }

    [self whenDeviceDidRotate];
}

#pragma mark - user actions
- (void)onTapViewMain:(UITapGestureRecognizer *)tapGes {
    [_viewTopMenu hideKeyboard];
    [_viewHome hideKeyboard];
}

- (void)changeLanguage {
    static int a = 0;
    [LangManager_ipad changeLanguageTo:a];
    a++;
}

- (void)onTouchQRCode:(UIButton *)btn {
    if (!_view2dCode) {
        CGRect rc = _viewTopMenu.bounds;
        rc.origin.y = rc.size.height-10;
        rc.size = CGSizeMake(320, 395);
        rc.origin.x = [_viewTopMenu.btnQRCode convertRect:_viewTopMenu.btnQRCode.bounds toView:_viewMain].origin.x;
        rc.origin.x -= rc.size.width*0.735;
        _view2dCode = [[View2dCode alloc] initWithFrame:rc];
        
        CALayer *layer = _view2dCode.layer;
        CGPoint oldAnchorPoint = layer.anchorPoint;
        layer.anchorPoint = CGPointMake(0.78, 0);
        layer.position = CGPointMake(layer.position.x+layer.bounds.size.width*(layer.anchorPoint.x-oldAnchorPoint.x), layer.position.y+layer.bounds.size.height*(layer.anchorPoint.y-oldAnchorPoint.y));
        
        [_viewMain addSubview:_view2dCode];
        
        _view2dCode.viewBarCode.readerDelegate = self;
    }
 
    btn.selected = !btn.isSelected;
    
    if (btn.isSelected) {
        _viewMask.alpha = _view2dCode.alpha = 1;
        
        CGRect rc = _view2dCode.frame;
        rc.origin.x = [_viewTopMenu.btnQRCode convertRect:_viewTopMenu.btnQRCode.bounds toView:_viewMain].origin.x;
        rc.origin.x -= rc.size.width*0.735;
        _view2dCode.frame = rc;
        
        [_viewMain bringSubviewToFront:_viewMask];
    }
    CGFloat scale = btn.isSelected?0.001:1;
    _view2dCode.transform = CGAffineTransformMakeScale(scale, scale);
    scale = btn.isSelected?1:0.001;
    [UIView animateWithDuration:0.25 animations:^{
        if (btn.isSelected) {
            _view2dCode.transform = CGAffineTransformMakeScale(scale+0.06, scale+0.06);
        }
        else {
            _view2dCode.transform = CGAffineTransformMakeScale(scale, scale);
        }
    } completion:^(BOOL finished) {
        if (btn.isSelected) {
            [UIView animateWithDuration:0.2 animations:^{
                _view2dCode.transform = CGAffineTransformMakeScale(scale, scale);
            }];
        }
        else {
            _viewMask.alpha = _view2dCode.alpha = 0;
            [_viewMain sendSubviewToBack:_viewMask];
            
            _view2dCode.transform = CGAffineTransformIdentity;
        }
    }];
}

- (void)onClickPageBack {
    [_webViewCurrent goBack];
}

- (void)onClickPageFront {
    [_webViewCurrent goForward];
}

- (void)onTouchFav:(UIButton *)btn {
    if (!_webViewCurrent) {
        return;
    }
    
    NSString *title = _webViewCurrent.title;
    NSString *link = _webViewCurrent.link;
    if ([ADOFavorite isExistsWithDataType:WKSyncDataTypeFavorite link:link uid:[WKSync shareWKSync].modelUser.uid withGuest:NO]) {
        if ([ADOFavorite deleteWithDataType:WKSyncDataTypeFavorite link:link uid:[WKSync shareWKSync].modelUser.uid]) {
            btn.selected = NO;
            
            [ViewIndicator showSuccessWithStatus:GetTextFromKey(@"ShanChuShouCangChengGong") duration:1.0];
        }
    }
    else {
        ModelFavorite *model = [ModelFavorite modelFavorite];
        model.title = title;
        if (!title.length) { // 没标题咱不存了
            return;
        }
        
        model.link = link;
        model.dataType = WKSyncDataTypeFavorite;
        model.time = [[NSDate date] timeIntervalSince1970];
        if ([ADOFavorite addModel:model]) {
            __block UIImageView *imageView = [[UIImageView alloc] initWithFrame:_webViewCurrent.frame];
            imageView.image = [UIImage imageFromView:_webViewCurrent];
            imageView.layer.borderWidth = 0.8;
            imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
            [_viewMain addSubview:imageView];
            
            CGRect rc = [btn convertRect:btn.bounds toView:_viewMain];
            [imageView genieInTransitionWithDuration:0.8 destinationRect:CGRectInset(rc, (rc.size.width-4)/2, (rc.size.height-4)/2) destinationEdge:BCRectEdgeBottom completion:^{
                [imageView removeFromSuperview];
                btn.selected = YES;
                
                [ViewIndicator showSuccessWithStatus:GetTextFromKey(@"YiChengGongBaoCunDaoShouCang") duration:1.0];
            }];
            _webViewCurrent.alpha = 0;
            [UIView animateWithDuration:1 delay:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
                _webViewCurrent.alpha = 1;
            } completion:nil];
        }
    }

    [self setFavStarState];
}

- (void)onTouchHome {
    [_viewTopMenu hideKeyboard];
    [_viewHome hideKeyboard];
    [_viewHome.viewHomeSearch fixSubviews];
    [UIView animateWithDuration:0.25 animations:^{
        _viewTopMenu.frame = _viewTopMenu.bounds;
    }];
    
    _svIndex.alpha = 1;
    [_webViewCurrent removeFromSuperview];
    [self setSubviewsState];
    
    _svIndex.contentSize = CGSizeMake(SCREEN_SIZE_IPAD.width*2, 0);
    if(_svIndex.contentOffset.x > 0) {
        _svIndex.contentOffset = CGPointMake(_svIndex.bounds.size.width, 0);
    }
    
    [KTAnimationKit animationEaseIn:_svIndex];
}

- (void)onTouchRefresh {
    if(_webViewCurrent.isLoading) {
        [_webViewCurrent stopLoading];
    }
    else {
        [_webViewCurrent reload];
    }
    
    [self setBtnRefreshstate];
}

- (void)onTouchShare {
    [_viewMain bringSubviewToFront:_viewMask];
    
}

- (void)onTouchHis:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    
    if (!_vcHistory) {
        _vcHistory = [[ControllerHistory alloc] init];
        _vcHistory.delegate = self;
        
        UIView *viewHistory = _vcHistory.view;
        CGRect rc = _viewMain.bounds;
        rc.size.width = kWidthViewHistory;
        rc.origin.x = -rc.size.width;
        viewHistory.frame = rc;
        viewHistory.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        [self.viewContent addSubview:viewHistory];
    }
    
    UIView *viewHistory = _vcHistory.view;
    [UIView animateWithDuration:0.25
                     animations:^{
                         CGAffineTransform transform = CGAffineTransformMakeTranslation(btn.isSelected?kWidthViewHistory+10:-10, 0);
                         viewHistory.transform = _viewMain.transform = transform;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.25 animations:^{
                             CGAffineTransform transform = CGAffineTransformMakeTranslation(btn.isSelected?kWidthViewHistory:0, 0);
                             viewHistory.transform = _viewMain.transform = transform;
                         }];
                         _viewMask.alpha = btn.isSelected;
                         if (btn.isSelected) {
                             [_vcHistory reloadData];
                             [_viewMain bringSubviewToFront:_viewMask];
                         }
                         else {
                             [_viewMain sendSubviewToBack:_viewMask];
                         }
                     }
     ];
}

- (void)showViewSkin:(BOOL)show {
    if (!_viewSkin) {
        CGRect rc = _viewMask.bounds;
        rc.size.height = kViewSkinH;
        rc.origin.y = _viewMask.bounds.size.height;
        _viewSkin = [[ViewSkin alloc] initWithFrame:rc];
        [_viewMask addSubview:_viewSkin];
    }

    _btnShowSkin.selected = show;
    if (show) {
        _viewSkin.alpha = _viewMask.alpha = 1;
        [_viewMain bringSubviewToFront:_viewMask];
        
        [_viewSkin changeBlurImage];
    }
    
    [UIView animateWithDuration:0.35 animations:^{
        if (show) {
            _btnShowSkin.transform = CGAffineTransformMakeScale(0.1, 0.1);
        }
        else {
            _btnShowSkin.transform = CGAffineTransformIdentity;
            _viewSkin.transform    = CGAffineTransformIdentity;
        }
    } completion:^(BOOL finished) {
        if (show) {
            [_viewSkin animateItems];
            [UIView animateWithDuration:0.35 animations:^{
                _viewSkin.transform = CGAffineTransformMakeTranslation(0, -_viewSkin.bounds.size.height);
            }];
        }
        else {
            _viewSkin.editing = NO;
            _viewSkin.alpha = _viewMask.alpha = 0;
            [_viewMain sendSubviewToBack:_viewMask];
        }
    }];
}

- (void)onTouchShowSkin {
    [self showViewSkin:YES];
}

// =============================
// -------  menu bar  ----------
// =============================
- (void)onTouchSetting:(UIButton *)btn {
    if (!_viewMenu) {
        //添加选项界面
        _viewMenu = [[[NSBundle mainBundle] loadNibNamed:@"ViewMenu_ipad" owner:self options:nil] objectAtIndex:0];
        _viewMenu.alpha = 0;
        _viewMenu.viewSlider.delegate = self;
        CGRect rc = _viewMenu.frame;
        rc.origin.x = _viewMask.bounds.size.width-rc.size.width+6;
        rc.origin.y = _viewTopMenu.bounds.size.height-20;
        _viewMenu.frame = rc;
        
        CALayer *layer = _viewMenu.layer;
        CGPoint oldAnchorPoint = layer.anchorPoint;
        layer.anchorPoint = CGPointMake(220/_viewMenu.bounds.size.width, 0.0);
        layer.position = CGPointMake(layer.position.x+layer.bounds.size.width*(layer.anchorPoint.x-oldAnchorPoint.x), layer.position.y+layer.bounds.size.height*(layer.anchorPoint.y-oldAnchorPoint.y));
        
        _viewMenu.autoresizesSubviews = UIViewAutoresizingFlexibleLeftMargin;
        [_viewMenu.ctrlScreenshot addTarget:self action:@selector(onTouchCtrlScreenshot) forControlEvents:UIControlEventTouchUpInside];
        [_viewMenu.ctrl2dCode addTarget:self action:@selector(onTouchCtrl2dCode) forControlEvents:UIControlEventTouchUpInside];
        [_viewMenu.ctrlFindInPage addTarget:self action:@selector(onTouchFindInPage) forControlEvents:UIControlEventTouchUpInside];
        [_viewMenu.ctrlSkin addTarget:self action:@selector(onTouchCtrlSkin) forControlEvents:UIControlEventTouchUpInside];
        [_viewMenu.ctrlShare addTarget:self action:@selector(onTouchCtrlShare) forControlEvents:UIControlEventTouchUpInside];
        [_viewMenu.sliderBrightness addTarget:self action:@selector(sliderBrightnessValueChange) forControlEvents:UIControlEventValueChanged];
        [_viewMask addSubview:_viewMenu];
    }
    
    btn.selected = !btn.isSelected;

    BOOL atWeb = !(_svIndex.alpha==1);  // 非首页
    _viewMenu.ctrlFontSize.userInteractionEnabled = atWeb;
    _viewMenu.ctrlFindInPage.userInteractionEnabled = atWeb;
    
    if (btn.isSelected) {
        _viewMask.alpha = _viewMenu.alpha = 1;
        [_viewMain bringSubviewToFront:_viewMask];
    }
    CGFloat scale = btn.isSelected?0.001:1;
    _viewMenu.transform = CGAffineTransformMakeScale(scale, scale);
    scale = btn.isSelected?1:0.001;
    [UIView animateWithDuration:0.25 animations:^{
        if (btn.isSelected) {
            _viewMenu.transform = CGAffineTransformMakeScale(scale+0.06, scale+0.06);
        }
        else {
            _viewMenu.transform = CGAffineTransformMakeScale(scale, scale);
        }
    } completion:^(BOOL finished) {
        if (btn.isSelected) {
            [UIView animateWithDuration:0.2 animations:^{
                _viewMenu.transform = CGAffineTransformMakeScale(scale, scale);
            }];
        }
        else {
            _viewMask.alpha = _viewMenu.alpha = 0;
            [_viewMain sendSubviewToBack:_viewMask];
            
            _viewMenu.transform = CGAffineTransformIdentity;
            
            if (_showViewFind) {
                _showViewFind = NO;
                [self switchFindInPageDisplay];
            }
            else if (_showView2dCode) {
                _showView2dCode = NO;
                
                UIButton *btnQRCode = _viewTopMenu.btnQRCode;
                btnQRCode.selected = NO;
                [self onTouchQRCode:btnQRCode];
            }
            else if (_showViewScrawl) {
                _showViewScrawl = NO;
                [self onTouchCtrlScreenshot];
            }
            else if (_showViewSkin) {
                _showViewSkin = NO;
                [self onTouchShowSkin];
            }
        }
    }];
}

- (IBAction)onTouchCtrlNoImgMode {
    [AppManager changeNoImgMode];

    BOOL noImgMode = [AppManager noImgMode];
    if (!noImgMode) {
        CustomURLCache *urlCache = (CustomURLCache *)[NSURLCache sharedURLCache];
        [urlCache removeAllCachedResponses];
    }
    
    NSString *js = [NSString stringWithFormat:@"imgVisibility(%d); jQuery('iframe').each(function(index) { jQuery(this).attr('src', jQuery(this).attr('src')); });", !noImgMode];
    [_webViewCurrent stringByEvaluatingJavaScriptFromString:js];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifNoImgModeChanged object:_webViewCurrent];
    
    NSString *msg = GetTextFromKey(noImgMode?@"noImgModeOpen":@"noImgModeClose");
    [ViewIndicator showSuccessWithStatus:msg duration:1.0];
}

- (IBAction)onTouchCtrlFontSize {
    ViewFontSize *viewFont = [ViewFontSize viewFontSizeFromXib];
    viewFont.delegate = self;
//    [viewFont setFontAdjust:[AppManager fontAdjust]];
    [viewFont setFontAdjust:_webViewCurrent.textSizeAdjust];
    [viewFont showInView:self.view completion:nil];
}

- (void)onTouchCtrlScreenshot {
    if (_viewTopMenu.btnMenu.isSelected) {
        _showViewScrawl = YES;
        [self onTouchSetting:_viewTopMenu.btnMenu];
        
        return;
    }
    
    [self createShareImg];

    ControllerScrawl *vcScrawl = [[ControllerScrawl alloc] init];
    vcScrawl.view.frame = self.view.bounds;
    [vcScrawl setScreenshot:_imgShare];
    [self presentViewController:vcScrawl animated:NO completion:nil];
}

- (void)onTouchCtrlShare {
    
    //    actionSheet.tag = kTagShareSheet;
}

- (void)onTouchCtrl2dCode {
    UIButton *btnMenu = _viewTopMenu.btnMenu;
    if (btnMenu.isSelected) {
        _showView2dCode = YES;
        [self onTouchSetting:btnMenu];
    }
    else {
        UIButton *btn2dCode = _viewTopMenu.btnQRCode;
        btn2dCode.selected = NO;
        [self onTouchQRCode:btn2dCode];
    }
}

- (void)onTouchCtrlSkin {
    _showViewSkin = YES;
    [self onTouchSetting:_viewTopMenu.btnMenu];
}

#pragma mark - find in page
- (void)switchFindInPageDisplay {
    UIControl *ctrl = _viewMenu.ctrlFindInPage;
    ctrl.selected = !ctrl.isSelected;
    
    BOOL selected = ctrl.isSelected;
    if (selected) {
        _viewMask.alpha = _viewFindInPage.alpha = 1;
        [_viewMain bringSubviewToFront:_viewMask];
    }
    CGFloat scale = selected?0.001:1;
    _viewFindInPage.transform = CGAffineTransformMakeScale(scale, scale);
    scale = selected?1:0.001;
    [UIView animateWithDuration:0.25 animations:^{
        if (selected) {
            _viewFindInPage.transform = CGAffineTransformMakeScale(scale+0.06, scale+0.06);
        }
        else {
            _viewFindInPage.transform = CGAffineTransformMakeScale(scale, scale);
        }
    } completion:^(BOOL finished) {
        if (selected) {
            [UIView animateWithDuration:0.2 animations:^{
                _viewFindInPage.transform = CGAffineTransformMakeScale(scale, scale);
            }];
        }
        else {
            _viewMask.alpha = _viewFindInPage.alpha = 0;
            [_viewMain sendSubviewToBack:_viewMask];
            
            _viewFindInPage.transform = CGAffineTransformIdentity;
            
            [_webViewCurrent stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"jQuery('body').removeHighlight();"]];
        }
    }];
}

- (void)onTouchFindInPage {
    if (!_viewFindInPage) {
        _viewFindInPage = [[[NSBundle mainBundle] loadNibNamed:@"ViewFindInPage_ipad" owner:self options:nil] objectAtIndex:0];
        _viewFindInPage.alpha = 0;
        _viewFindInPage.txtWord.delegate = self;
        CGRect rc = _viewFindInPage.frame;
        rc.origin.x = _viewMask.bounds.size.width-rc.size.width+6;
        rc.origin.y = _viewTopMenu.bounds.size.height-20;
        _viewFindInPage.frame = rc;
        
        CALayer *layer = _viewFindInPage.layer;
        CGPoint oldAnchorPoint = layer.anchorPoint;
        layer.anchorPoint = CGPointMake(290/_viewFindInPage.bounds.size.width, 0.0);
        layer.position = CGPointMake(layer.position.x+layer.bounds.size.width*(layer.anchorPoint.x-oldAnchorPoint.x), layer.position.y+layer.bounds.size.height*(layer.anchorPoint.y-oldAnchorPoint.y));
        
        _viewFindInPage.autoresizesSubviews = UIViewAutoresizingFlexibleLeftMargin;
        [_viewFindInPage.txtWord addTarget:self action:@selector(whenFindInPageWordChanged:) forControlEvents:UIControlEventEditingChanged];
        [_viewMask addSubview:_viewFindInPage];
    }
    
    UIButton *btnMenu = _viewTopMenu.btnMenu;
    if (btnMenu.isSelected) {
        _showViewFind = YES;
        [self onTouchSetting:btnMenu];
    }
    else {
        [self switchFindInPageDisplay];
    }
}

/**
 *  滚动到指定位置
 */
- (void)focusToFindIndex:(NSInteger)findIndex {
    NSString *js = [NSString stringWithFormat:@"scrollToFindIdx(%d);", findIndex];
    CGFloat offset = [[_webViewCurrent stringByEvaluatingJavaScriptFromString:js] floatValue];
    
    CGFloat contentHeight = _webViewCurrent.scrollView.contentSize.height;
    offset = MIN(offset, contentHeight-_webViewCurrent.scrollView.bounds.size.height);
    [_webViewCurrent.scrollView setContentOffset:CGPointMake(0, offset) animated:YES];
}

- (IBAction)onTouchPrev {
    NSInteger index = _viewFindInPage.findIndex;
    index = MAX(0, index-1);
    _viewFindInPage.findIndex = index;
    
    [self focusToFindIndex:index];
}

- (IBAction)onTouchNext {
    NSInteger index = _viewFindInPage.findIndex;
    index = MIN(_viewFindInPage.findCount-1, index+1);
    _viewFindInPage.findIndex = index;
    
    [self focusToFindIndex:index];
}

- (IBAction)onTouchFindInPageClose {
    UIControl *ctrl = _viewMenu.ctrlFindInPage;
    if (ctrl.isSelected) {
        [self onTouchFindInPage];
    }
}

#pragma mark - viewShareChoose
- (void)createShareImg {
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    _imgShare = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

#pragma mark - ViewFontSizeDelegate
- (void)viewFontSize:(ViewFontSize *)viewFontSize setFontAdjust:(CGFloat)fontAdjust {
//    [AppManager changeFontAdjust:fontAdjust];
    _webViewCurrent.textSizeAdjust = fontAdjust;
    
    NSString *js = [NSString stringWithFormat:@"jQuery('body').css('webkitTextSizeAdjust', '%f%%');", fontAdjust*100];
    [_webViewCurrent stringByEvaluatingJavaScriptFromString:js];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _webViewCurrent.scrollView) {
        static CGFloat lastOffsetY = 0;
        
        CGFloat currOffsetY = scrollView.contentOffset.y;
        BOOL toUp = currOffsetY>lastOffsetY; // 向上滚动
        
//        CGFloat maybeToY = -(currOffsetY+scrollView.contentInset.top);
//        CGRect rc = _viewTopMenu.frame;
//        if (currOffsetY < 0) {
//            if ((toUp && maybeToY<rc.origin.y)
//                || (!toUp && maybeToY>rc.origin.y)) {
//                rc.origin.y = maybeToY;
//                _viewTopMenu.frame = rc;
//            }
//        }
//        else {
            if (abs(currOffsetY-lastOffsetY)>10) {
                BOOL needFullscreen = NO;
                if (currOffsetY>30 && toUp) {
                    needFullscreen = YES;
                }
                [self showFullscreen:needFullscreen];
            }
//        }
        
        lastOffsetY = currOffsetY;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    _isDragging = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(scrollView == _svIndex) {
        int pageNum = (scrollView.contentOffset.x==0)?0:1;
        [_viewDots setPage:pageNum];
    }
}

#pragma mark - webview delegate
- (void)contextualMenuAction:(NSNotification*)notification {
    int index = [[WebviewsManager arrWebViews] indexOfObject:_webViewCurrent];
    if([[[WebviewsManager arrURLCaches] objectAtIndex:index] isEqualToString:@""]) {
        return;
    }
    
    CGPoint pt;
    NSDictionary *coord = [notification object];
    pt.x = [[coord objectForKey:@"x"] floatValue];
    pt.y = [[coord objectForKey:@"y"] floatValue];
    
    pt = [_webViewCurrent convertPoint:pt fromView:nil];
    
    CGSize viewSize = [_webViewCurrent frame].size;
    CGSize windowSize = [_webViewCurrent windowSize];
    
    CGFloat f = windowSize.width / viewSize.width;
    
    pt.x = pt.x * f;
    pt.y = pt.y * f;
    
    [self openContextualMenuAt:pt];
}

- (void)openContextualMenuAt:(CGPoint)pt {
    // Load the JavaScript code from the Resources and inject it into the web page
    NSString *path = [[NSBundle mainBundle] pathForResource:@"tools" ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];

    [_webViewCurrent stringByEvaluatingJavaScriptFromString: jsCode];
    
    // get the Tags at the touch location
    NSString *tags = [_webViewCurrent stringByEvaluatingJavaScriptFromString:
                      [NSString stringWithFormat:@"MyAppGetHTMLElementsAtPoint(%i,%i);",(NSInteger)pt.x,(NSInteger)pt.y]];

    // create the UIActionSheet and populate it with buttons related to the tags
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:GetTextFromKey(@"QingXuanZe")
                                                       delegate:self cancelButtonTitle:nil
                                         destructiveButtonTitle:nil otherButtonTitles:nil];

    // If a link was touched, add link-related buttons
    _stateHaveUrl = ([tags rangeOfString:@",A,"].location != NSNotFound);
    if (_stateHaveUrl) {
        [sheet addButtonWithTitle:NSLocalizedString(@"ZaiDangQianYeMianDaKaiLianJie", nil)];
        [sheet addButtonWithTitle:NSLocalizedString(@"ZaiXinBiaoQianDaKaiLianJie", nil)];
        
        NSArray *arr = [tags componentsSeparatedByString:@","];
        int index = [arr indexOfObject:@"A"];
        _currUrl = [arr objectAtIndex:index+1];
    }
    // If an image was touched, add image-related buttons
    _stateHaveImg = ([tags rangeOfString:@",IMG,"].location != NSNotFound);
    if (_stateHaveImg) {
        [sheet addButtonWithTitle:NSLocalizedString(@"BaoCunTuPianDaoBenDi", nil)];
        
        NSArray *arr = [tags componentsSeparatedByString:@","];
        int index = [arr indexOfObject:@"IMG"];
        _selectedImageURL = [arr objectAtIndex:index+1];
    }
    
    // Add buttons which should be always available
    [sheet addButtonWithTitle:NSLocalizedString(@"BaoCunDangQianYeMianDaoShuQian", nil)];
    [sheet addButtonWithTitle:NSLocalizedString(@"YongSafariDaKaiLianJie", nil)];
    
    [sheet showInView:[[UIApplication sharedApplication].windows objectAtIndex:0]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self setBtnRefreshstate];
    
    WebViewEx_ipad *webviewEx = (WebViewEx_ipad *)webView;
    [WebviewsManager changeCacheWithUrl:webviewEx.link webview:webviewEx];
    
    int index = [[WebviewsManager arrWebViews] indexOfObject:webView];
    CtrlTag_ipad *tag = [_viewTopMenu.viewTagsTab.arrTags objectAtIndex:index];
    if(!webviewEx.link.length) {
        tag.labTitle.text = GetTextFromKey(@"JiaZaiZhong");
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self setBtnRefreshstate];
    
    WebViewEx_ipad *webviewEx = (WebViewEx_ipad *)webView;
    // 禁止弹出默认系统菜单
    [webviewEx stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';"];
    // 页内搜索
    static NSString *jsPlugin = nil;
    if (!jsPlugin) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"js_plugins" ofType:@"js"];
        NSError *error = nil;
        jsPlugin = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    }
    NSString *js = [NSString stringWithFormat:@"var highlightPlugin = document.getElementById('js_plugins'); \
                    if (highlightPlugin == undefined) { \
                        document.body.innerHTML += '<div id=\"js_plugins\"> \
                                                        <style type=\"text/css\"> \
                                                            .utaHighlight { background-color:yellow; } \
                                                            .selectSpan { background-color:orange; } \
                                                        </style> \
                                                    </div>'; \
                        %@ \
                    }", jsPlugin];
    [webviewEx stringByEvaluatingJavaScriptFromString:js];
    // 无图模式
    if ([AppManager noImgMode]) {
        js = [NSString stringWithFormat:@"imgVisibility(%d)", 0];
        [webviewEx stringByEvaluatingJavaScriptFromString:js];
    }
    // 字体大小
    if (webviewEx.textSizeAdjust != 1) {
        NSString *js = [NSString stringWithFormat:@"jQuery('body').css('webkitTextSizeAdjust', '%f%%');", webviewEx.textSizeAdjust*100];
        [webviewEx stringByEvaluatingJavaScriptFromString:js];
    }
    
    // ----------------------
    int index = [[WebviewsManager arrWebViews] indexOfObject:webviewEx];
    [WebviewsManager changeCacheWithUrl:webviewEx.link webview:webviewEx];
    
    CtrlTag_ipad *tag = [_viewTopMenu.viewTagsTab.arrTags objectAtIndex:index];
    NSString *link = webviewEx.link;
    NSString *title = webviewEx.title;
    if (title.length) {
        tag.labTitle.text = title;
    }
    else if(link.length) {
        tag.labTitle.text = link;
    }
    else {
        tag.labTitle.text = GetTextFromKey(@"KongBaiYe");
    }
    
    if (webviewEx == _webViewCurrent) {
        webviewEx.shouldReload = NO;
        [self setSubviewsState];
    }
    else {
        if(link.length > 15) {
            NSString *host = [[NSURL URLWithString:link] host];
            [tag.imgIcon setImageWithUrl:[@"http://www.google.com/s2/favicons?domain=" stringByAppendingString:host]];
            tag.iconHaveSet = YES;
        }
    }

    CGRect rc = _viewMain.bounds;
    rc.origin.y = _viewTopMenu.bounds.size.height;
    rc.size.height -= rc.origin.y;
    _webViewCurrent.frame = rc;
    
    // 保存历史记录
    if (title.length) {
        ModelFavorite *model = [ADOFavorite queryWithDataType:WKSyncDataTypeHistory link:link uid:[WKSync shareWKSync].modelUser.uid withGuest:NO];
        if (model) {
            [ADOFavorite updateTime:[[NSDate date] timeIntervalSince1970] title:title withFid:model.fid times:model.times+1];
        }
        else if (title.length) {
            model = [ModelFavorite modelFavorite];
            model.time = [[NSDate date] timeIntervalSince1970];
            model.title = title;
            model.link = link;
            model.dataType = WKSyncDataTypeHistory;
            [ADOFavorite addModel:model];
        }
    }
    
    // UIWebView 内存处理 之一
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

#pragma mark - actionsheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(actionSheet.tag == kTagShareSheet) {
        ShareType type = buttonIndex==0?ShareTypeSinaWeibo:ShareTypeTencentWeibo;
        [[ShareSDKPackage shareShareSDKPackage] shareWithType:type andTitle:@"我绑定了中华浏览器！" andContent:@"我绑定了中华浏览器！" andUrl:nil andDescription:@"我绑定了中华浏览器！" andImage:nil];
    }
    else {
        if(_stateHaveUrl) {
            if(buttonIndex == 0) {
                [self openUrlAtCurrentTag];
            }
            else if (buttonIndex == 1) {
                [self openUrlAtNewTag];
            }
            if (buttonIndex <= 1) {
                return;
            }
            
            if (!_stateHaveImg) {
                buttonIndex++;
            }
            if (buttonIndex == 2) {
                [self saveImg];
            }
            else if (buttonIndex == 3) {
                [self saveCurrntUrlToFav];
            }
            else if (buttonIndex == 4) {
                [self openUrlWithSafari];
            }
        }
        else {
            if (!_stateHaveImg) {
                buttonIndex++;
            }

            if(buttonIndex == 0) {
                [self saveImg];
            }
            else if (buttonIndex == 1) {
                [self saveCurrntUrlToFav];
            }
            else if (buttonIndex == 2) {
                [self openUrlWithSafari];
            }
        }
    }
}

- (void)openUrlAtCurrentTag {
    _webViewCurrent.shouldReload = YES;
    
    _svIndex.alpha = 0;
    [self setSubviewsState];
}

- (void)openUrlAtNewTag {
    if([WebviewsManager arrWebViews].count >= kMaxTagNum) {
        [ViewIndicator showWarningWithStatus:GetTextFromKey(@"BiaoQianYiMan") duration:1.0];
        return;
    }
    
    _svIndex.alpha = 0;
    [_viewTopMenu.viewTagsTab addTag];
}

- (void)openUrlWithSafari {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_currUrl]];
}

- (void)saveImg {
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_selectedImageURL]]];
    if(image) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        [ViewIndicator showSuccessWithStatus:GetTextFromKey(@"YiChengGongBaoCunDaoXiangCe")  duration:1.0];
    }
}

- (void)saveCurrntUrlToFav {
    [ViewIndicator showSuccessWithStatus:GetTextFromKey(@"YiChengGongBaoCunDaoShouCang")  duration:1.0];
}

#pragma mark - touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self hideViewMask];
}

#pragma mark - ViewSliderDelegate_ipad
- (void)valueChange:(float)value {
    [AppManager changeBrightness:value];
    
    _brightnessWindow.alpha = (1.0-value)*kBrightnessMin;
}

#pragma mark - txtUrl
- (void)topMenuViewUrlWider:(BOOL)need {
    BOOL atHome = _svIndex.alpha==1;
    
    CGFloat addW = 195;
    UIView *viewUrl = _viewTopMenu.viewUrl;
    UIView *txtUrl = _viewTopMenu.txtUrl;
    UIImageView *ivLineV = _viewTopMenu.ivLineV;
    UIView *btnQRCode = _viewTopMenu.btnQRCode;
    UIView *btnRefresh = _viewTopMenu.btnRefresh;
    __block CGRect rc = viewUrl.frame;
    rc.size.width += need?addW:-addW;
    [UIView animateWithDuration:0.25 animations:^{
        viewUrl.frame = rc;

        CGFloat szW = btnQRCode.bounds.size.width;
        CGFloat tx = (need?szW:(atHome?0:-szW));
        btnQRCode.transform = CGAffineTransformMakeTranslation(tx, 0);
        ivLineV.alpha = btnQRCode.alpha = !need;
        btnRefresh.alpha = !atHome && !need;

        rc = txtUrl.frame;
        rc.size.width = btnQRCode.frame.origin.x-rc.origin.x-1;
        txtUrl.frame = rc;
        
        _viewTopMenu.viewTopSearch.alpha = !need;
        if (need) {
            [viewUrl.superview bringSubviewToFront:viewUrl];
        }
    } completion:^(BOOL finished) {
        if (!need) {
            [viewUrl.superview sendSubviewToBack:viewUrl];
        }
    }];
}

- (void)onTouchSearch {
    UITextField *txtWord = _viewTopMenu.txtUrl;
    if (txtWord.text.length > 0) {
        NSString *keyword = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                  (CFStringRef)txtWord.text,
                                                                                                  NULL,
                                                                                                  NULL,//(CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                                                                                  kCFStringEncodingUTF8));
        NSString *urlStr = keyword;
        if (![urlStr hasPrefix:@"http://"] && ![urlStr hasPrefix:@"https://"]) {
            urlStr = [@"http://" stringByAppendingString:urlStr];
        }
        _currUrl = urlStr;
        [self openUrlAtCurrentTag];
        [txtWord resignFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate
- (void)whenFindInPageWordChanged:(UITextField *)txtWord {
    if (txtWord.text.length) {
        [_webViewCurrent stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"jQuery('body').removeHighlight().utaHighlight('%@');", txtWord.text]];
    }
    else {
        [_webViewCurrent stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"jQuery('body').removeHighlight();"]];
    }
    
    _viewFindInPage.findIndex = 0;
    NSInteger count = [[_webViewCurrent stringByEvaluatingJavaScriptFromString:@"jQuery('.utaHighlight').length;"] integerValue];
    _viewFindInPage.findCount = count;
    if (count > 0) {
        [self focusToFindIndex:0];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _viewTopMenu.txtUrl) {
        [self topMenuViewUrlWider:YES];
    }
        
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if (textField == _viewTopMenu.txtUrl) {
        [self topMenuViewUrlWider:NO];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _viewTopMenu.txtUrl) {
        [self onTouchSearch];
    }
    else if (textField == _viewFindInPage.txtWord) {
        [textField resignFirstResponder];
        
        return NO;
    }
    
    return YES;
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            _DEBUG_LOG(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved:
            _DEBUG_LOG(@"Mail saved...");
            break;
        case MFMailComposeResultSent:
            _DEBUG_LOG(@"Mail sent...");
            break;
        case MFMailComposeResultFailed:
            _DEBUG_LOG(@"Mail send errored: %@...", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    [controller dismissModalViewControllerAnimated:YES];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    switch (result) {
        case MessageComposeResultCancelled:
            _DEBUG_LOG(@"Msg send canceled...");
            break;
        case MessageComposeResultSent:
            _DEBUG_LOG(@"Msg saved...");
            break;
        case MessageComposeResultFailed:
            _DEBUG_LOG(@"Msg send errored: ..");
            break;
        default:
            break;
    }
    
    [controller dismissModalViewControllerAnimated:YES];
}

#pragma mark - ZBarReaderViewDelegate
- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image {
    const zbar_symbol_t *symbol = zbar_symbol_set_first_symbol(symbols.zbarSymbolSet);
    NSString *symbolStr = [NSString stringWithUTF8String:zbar_symbol_get_data(symbol)];
//    if (zbar_symbol_get_type(symbol) == ZBAR_QRCODE) {  // 是否QR二维码
//    }
    
    if ([symbolStr hasPrefix:@"itms://"]
        || [symbolStr hasPrefix:@"itms-apps://"]
        || [symbolStr hasPrefix:@"http://itunes"]
        || [symbolStr hasPrefix:@"https://itunes"]) {
        _currUrl = symbolStr;
        [self openUrlWithSafari];
    }
    else if ([symbolStr hasPrefix:@"http://"]
             | [symbolStr hasPrefix:@"https://"]) {
        _currUrl = symbolStr;
        [self openUrlAtCurrentTag];
    }
    else {
        [_viewTopMenu.viewTopSearch searchWithKeyword:symbolStr];
    }
    
    if ((_viewTopMenu.btnQRCode.selected)) {
        [self onTouchQRCode:_viewTopMenu.btnQRCode];
    }
    
    if (!_audioPlayer) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"2d-code" ofType:@"wav"];
        NSError  *error;
        _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:path]error:&error];
        [_audioPlayer prepareToPlay];
    }
    [_audioPlayer play];
}

#pragma mark - ViewTopSearchDelegate_ipad
- (void)viewTopSearch:(ViewTopSearch_ipad *)view openUrl:(NSString *)url {
    _currUrl = url;
    [self openUrlAtCurrentTag];
}

#pragma mark - ViewHomeSearchDelegate_ipad
- (void)viewHomeSearch:(ViewHomeSearch_ipad *)view openUrl:(NSString *)url {
    _currUrl = url;
    [self openUrlAtCurrentTag];
}

#pragma mark - ViewCommonSitesDelegate;
- (void)viewCommonSites:(ViewCommonSites *)viewCommonSites reqLink:(NSString *)link action:(ReqLinkAction)action {
    _currUrl = link;
    [self openUrlAtCurrentTag];
}

#pragma mark - ViewHomeDelegate
- (void)viewHome:(ViewHome_ipad *)viewHome modelUrl:(ModelUrl_ipad *)modelUrl {
    _currUrl = modelUrl.link;
    [self openUrlAtCurrentTag];
}

- (void)viewHomeWillAdd:(ViewHome_ipad *)viewHome {
    if (!_vcAddSite) {
        _vcAddSite = [[ControllerAddSite alloc] initWithNibName:@"ControllerAddSite" bundle:nil];
        _vcAddSite.delegate = self;
    }
    [_vcAddSite showSubviews:YES];
}

#pragma mark - VcAddSiteDelegate
- (void)vcAddSite:(ControllerAddSite *)vcAddSite title:(NSString *)title url:(NSString *)url {
    ModelUrl_ipad *model = [ModelUrl_ipad model];
    model.title = title;
    model.link = url;
    model.time = [[NSDate date] timeIntervalSince1970];
    model.dataType = WKSyncDataTypeHome;

    if ([ADOFavorite addModel:model]) {
        [_viewHome addCustomItem:model];
    }
    [vcAddSite showSubviews:NO];
}

#pragma mark - VcHistoryDelegate
- (void)vcHistory:(ControllerHistory *)vcHistory didSelectUrl:(NSString *)url {
    if (_webViewCurrent) {
        _currUrl = url;
        
        [self openUrlAtCurrentTag];
        
        if (_viewTopMenu.btnBookmarker.isSelected) {
            [self onTouchHis:_viewTopMenu.btnBookmarker];
        }
    }
}

- (void)vcHistory:(ControllerHistory *)vcHistory didDeleteFavUrl:(NSString *)url {
    if ([_webViewCurrent.link isEqualToString:url])
        _viewTopMenu.btnAddFav.selected = NO;
}

#pragma mark - private methods
- (void)installBrightnessWindow {
    _brightnessWindow = [[UIWindow alloc] initWithFrame:self.view.window.frame];
    _brightnessWindow.hidden = NO;
    _brightnessWindow.alpha = (isDayMode?0:kBrightnessMin);
    _brightnessWindow.userInteractionEnabled = NO;
    _brightnessWindow.backgroundColor = [UIColor blackColor];
    _brightnessWindow.windowLevel = UIWindowLevelStatusBar+1;
}

- (void)sliderBrightnessValueChange {
    CGFloat brightness = _viewMenu.sliderBrightness.value;
    [AppManager changeBrightness:brightness];
    _brightnessWindow.alpha = (1.0-brightness)*kBrightnessMin;
}

- (void)createCustomCache {
    CustomURLCache *urlCache = [[CustomURLCache alloc] initWithMemoryCapacity:20*1024*1024
                                                                 diskCapacity:200*1024*1024
                                                                     diskPath:nil
                                                                    cacheTime:0];
    [CustomURLCache setSharedURLCache:urlCache];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    CustomURLCache *urlCache = (CustomURLCache *)[NSURLCache sharedURLCache];
    [urlCache removeAllCachedResponses];
    [self createCustomCache];
    
    // 重建所有webview
    [WebviewsManager remakeWebviewsExcludeCurrent:_webViewCurrent];
}

@end
