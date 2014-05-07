//
//  AppConfig.m
//  KTBrowser
//
//  Created by David on 14-2-15.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "AppConfig.h"

#import "BlockUI.h"

#import "UINavController.h"

#import <QuartzCore/QuartzCore.h>

#import "UIImage+BlurredFrame.h"
#import "UIImage+ImageEffects.h"


static AppConfig *_config;

@interface AppConfig ()

- (void)didRotateNofication;

- (void)showLock;
- (void)dismissLock;

@end

@implementation AppConfig
{
    UIButton *_btnLock;
}

@synthesize bgImage = _bgImage;
@synthesize brightnessDay = _brightnessDay;
@synthesize brightnessNight = _brightnessNight;
@synthesize rotateLock = _rotateLock;
@synthesize fullScreen = _fullScreen;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (AppConfig *)config
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _config = [[AppConfig alloc] init];
    });
    return _config;
}

+ (UIImage *)bgImageWithFile:(NSString *)file
{
    UIImage *image = [UIImage imageWithContentsOfFile:file];
    image = [image applyBlurWithRadius:15
                             tintColor:[[UIColor whiteColor] colorWithAlphaComponent:0.08]
                 saturationDeltaFactor:1.5
                             maskImage:nil];
    return image;
}

- (void)setup
{
    _interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRotateNofication)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    _shouldShowRotateLock = YES;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    // skinImagePath
    if ([ud objectForKey:KTBrowserSkinImagePath]) {
        _skinImagePath = [ud objectForKey:KTBrowserSkinImagePath];
    }
    else {
        NSString *imagePath = GetDocumentDirAppend(@"skin/image");
        _skinImagePath = [imagePath stringByAppendingPathComponent:@"0.png"];
        [ud setObject:_skinImagePath forKey:KTBrowserSkinImagePath];
        [ud synchronize];
    }
    
    // UIMode
    if ([ud objectForKey:KTBrowserUIMode]) {
        _uiMode = [ud integerForKey:KTBrowserUIMode];
    }
    else {
        _uiMode = UIModeDay;
        [ud setInteger:_uiMode forKey:KTBrowserUIMode];
        [ud synchronize];
    }
    
    // brightnessDay
    if ([ud objectForKey:KTBrowserBrightnessDay]) {
        _brightnessDay = [ud floatForKey:KTBrowserBrightnessDay];
    }
    else {
        _brightnessDay = 1;
        [ud setFloat:_brightnessDay forKey:KTBrowserBrightnessDay];
        [ud synchronize];
    }
    
    // brightnessnight
    if ([ud objectForKey:KTBrowserBrightnessNight]) {
        _brightnessNight = [ud floatForKey:KTBrowserBrightnessNight];
    }
    else {
        _brightnessNight = 0.5;
        [ud setFloat:_brightnessNight forKey:KTBrowserBrightnessNight];
        [ud synchronize];
    }
    
    // no image
    if ([ud objectForKey:KTBrowserNoImage]) {
        _noImage = [ud boolForKey:KTBrowserNoImage];
    }
    else {
        _noImage = NO;
        [ud setBool:_noImage forKey:KTBrowserNoImage];
        [ud synchronize];
    }
    
    // no history
    if ([ud objectForKey:KTBrowserNoHistory]) {
        _noHistory = [ud boolForKey:KTBrowserNoHistory];
    }
    else {
        _noHistory = NO;
        [ud setBool:_noHistory forKey:KTBrowserNoHistory];
        [ud synchronize];
    }
    
    // rotate lock
    if ([ud objectForKey:KTBrowserRotateLock]) {
        _rotateLock = [ud boolForKey:KTBrowserRotateLock];
    }
    else {
        _rotateLock = NO;
        [ud setBool:_rotateLock forKey:KTBrowserRotateLock];
        [ud synchronize];
    }
    
    // font size
    if ([ud objectForKey:KTBrowserWebFontsize]) {
        _fontsize = [ud floatForKey:KTBrowserWebFontsize];
    }
    else {
        _fontsize = 19;
        [ud setFloat:_fontsize forKey:KTBrowserWebFontsize];
        [ud synchronize];
    }
    
    // _rememberPwd
    if ([ud objectForKey:KTBrowserRememberPwd]) {
        _rememberPwd = [ud boolForKey:KTBrowserRememberPwd];
    }
    else {
        _rememberPwd = NO;
        [ud setBool:_rememberPwd forKey:KTBrowserRememberPwd];
        [ud synchronize];
    }
    
    switch (_uiMode) {
        case UIModeDay:
        {
            [UIView animateWithDuration:0.01 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                _layerMask.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1-_brightnessDay].CGColor;
            } completion:nil];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        }
            break;
        case UIModeNight:
        {
            [UIView animateWithDuration:0.01 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                _layerMask.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1-_brightnessNight*0.6].CGColor;
            } completion:nil];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - private
- (void)didRotateNofication
{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    UIDeviceOrientation interfaceOrientation = (UIDeviceOrientation)[AppConfig config].interfaceOrientation;
    
    if (UIDeviceOrientationUnknown != deviceOrientation
        && UIDeviceOrientationFaceUp != deviceOrientation
        && UIDeviceOrientationFaceDown != deviceOrientation
        && UIDeviceOrientationPortraitUpsideDown != deviceOrientation) {
        
        if (deviceOrientation!=interfaceOrientation) {
            _deviceOrientation = (UIInterfaceOrientation)deviceOrientation;
            if (!_rotateLock) {
                _interfaceOrientation = (UIInterfaceOrientation)deviceOrientation;
            }
            
            if (_shouldShowRotateLock) {
                [self showLock];
            }
        }
    }
}

- (UIInterfaceOrientationMask)interfaceOrientationMask
{
    return 1 << _interfaceOrientation;
}

- (void)showLock
{
    
    void(^trans)()=^{
        return;
        CGRect rc = _rootController.view.bounds;
        CGRect rcDes;
        [[UIApplication sharedApplication] setStatusBarOrientation:_deviceOrientation animated:YES];
        CGFloat degrees;
        switch (_deviceOrientation) {
            case UIInterfaceOrientationPortraitUpsideDown:
                degrees = 180.0;
                rcDes.size.width = MIN(rc.size.width, rc.size.height);
                rcDes.size.height = MAX(rc.size.width, rc.size.height);
                break;
            case UIInterfaceOrientationLandscapeLeft:
            {
                degrees = -90.0;
                rcDes.size.width = MAX(rc.size.width, rc.size.height);
                rcDes.size.height = MIN(rc.size.width, rc.size.height);
            }
                break;
            case UIInterfaceOrientationLandscapeRight:
                degrees = 90.0;
                rcDes.size.width = MAX(rc.size.width, rc.size.height);
                rcDes.size.height = MIN(rc.size.width, rc.size.height);
                break;
            default: // as UIInterfaceOrientationPortrait
            {
                degrees = 0.0;
                rcDes.size.width = MIN(rc.size.width, rc.size.height);
                rcDes.size.height = MAX(rc.size.width, rc.size.height);
            }
                break;
        }
        
        if (!IsiOS7 && ![[UIApplication sharedApplication] isStatusBarHidden]) {
//            rc.size.height-=20;
        }
        _interfaceOrientation = _deviceOrientation;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            _rootController.view.transform = CGAffineTransformMakeRotation((degrees*M_PI/180.0));
            _rootController.view.bounds = rcDes;
        } completion:^(BOOL finished) {
            
        }];
        
    };
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGRect rc = CGRectMake(0, 0, 66, 66);
        rc.origin.x = (_rootController.view.bounds.size.width-rc.size.width)/2;
        rc.origin.y = _rootController.view.bounds.size.height-rc.size.height-50;
        _btnLock = [[UIButton alloc] initWithFrame:rc];
        _btnLock.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
        _btnLock.clipsToBounds = YES;
        _btnLock.layer.cornerRadius = 4;
        _btnLock.alpha = 0;
        [_rootController.view addSubview:_btnLock];
        
        [_btnLock handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            self.rotateLock = !_rotateLock;
            if (_rotateLock) {
                [_btnLock setImage:[UIImage imageWithFilename:@"Common.bundle/screen_unlock.png"] forState:UIControlStateNormal];
            }
            else {
                [_btnLock setImage:[UIImage imageWithFilename:@"Common.bundle/screen_lock.png"] forState:UIControlStateNormal];
                
                trans();
            }
            
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissLock) object:nil];
            [self performSelector:@selector(dismissLock) withObject:nil afterDelay:2];
        }];
    });
    
    if (_rotateLock) {
        [_btnLock setImage:[UIImage imageWithFilename:@"Common.bundle/screen_unlock.png"] forState:UIControlStateNormal];
    }
    else {
        [_btnLock setImage:[UIImage imageWithFilename:@"Common.bundle/screen_lock.png"] forState:UIControlStateNormal];
        trans();
    }
    
    _btnLock.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        _btnLock.alpha = 1;
    } completion:^(BOOL finished) {
    }];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissLock) object:nil];
    [self performSelector:@selector(dismissLock) withObject:nil afterDelay:2];
}

- (void)dismissLock
{
    [UIView animateWithDuration:0.2 animations:^{
        _btnLock.alpha = 0;
    } completion:^(BOOL finished) {
        _btnLock.hidden = YES;
    }];
}

- (NSString *)skinBundleName
{
    if (UIModeDay==_uiMode) {
        return @"Default.bundle";
    }
    else {
        return @"Night.bundle";
    }
}

- (UIImage *)bgImage
{
    if (!_bgImage) {
        _bgImage = [AppConfig bgImageWithFile:_skinImagePath];
    }
    return _bgImage;
}

- (void)setSkinImagePath:(NSString *)skinImagePath
{
    if (!_skinImagePath || ![_skinImagePath isEqual:skinImagePath]) {
        _skinImagePath = skinImagePath;
        _bgImage = [AppConfig bgImageWithFile:_skinImagePath];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:skinImagePath forKey:KTBrowserSkinImagePath];
        [ud synchronize];
    }
}

- (void)setUiMode:(UIMode)uiMode
{
    _uiMode = uiMode;
    NSString *imageName = nil;
    switch (_uiMode) {
        case UIModeDay:
        {
            [UIView animateWithDuration:0.01 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                _layerMask.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1-_brightnessDay].CGColor;
            } completion:nil];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            
            imageName = @"0.png";
        }
            break;
        case UIModeNight:
        {
            [UIView animateWithDuration:0.01 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                _layerMask.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1-_brightnessNight*0.6].CGColor;
            } completion:nil];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            
            imageName = @"1.png";
        }
            break;
            
        default:
            break;
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSString *imagePath = GetDocumentDirAppend(@"skin/image");
    _skinImagePath = [imagePath stringByAppendingPathComponent:imageName];
    _bgImage = [AppConfig bgImageWithFile:_skinImagePath];
    [ud setObject:_skinImagePath forKey:KTBrowserSkinImagePath];
    [ud setInteger:_uiMode forKey:KTBrowserUIMode];
    [ud synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KTNotificationUpdateUIMode object:nil];
}

- (void)setBrightnessDay:(CGFloat)brightnessDay
{
    _brightnessDay = brightnessDay;
    
    [[NSUserDefaults standardUserDefaults] setFloat:_brightnessDay forKey:KTBrowserBrightnessDay];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (UIModeDay==_uiMode) {
        [UIView animateWithDuration:0.01 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            _layerMask.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1-_brightnessDay].CGColor;
        } completion:nil];
    }
}

- (void)setBrightnessNight:(CGFloat)brightnessNight
{
    _brightnessNight = brightnessNight;
    
    [[NSUserDefaults standardUserDefaults] setFloat:_brightnessNight forKey:KTBrowserBrightnessNight];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (UIModeNight==_uiMode) {
        [UIView animateWithDuration:0.01 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            _layerMask.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1-_brightnessNight*0.6].CGColor;
        } completion:nil];
    }
}

- (void)setNoImage:(BOOL)noImage
{
    _noImage = noImage;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:_noImage forKey:KTBrowserNoImage];
    [ud synchronize];
}

- (void)setNoHistory:(BOOL)noHistory
{
    _noHistory = noHistory;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:_noHistory forKey:KTBrowserNoHistory];
    [ud synchronize];
}

- (void)setRememberPwd:(BOOL)rememberPwd
{
    _rememberPwd = rememberPwd;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:_rememberPwd forKey:KTBrowserRememberPwd];
    [ud synchronize];
}

- (void)setRotateLock:(BOOL)rotateLock
{
    _rotateLock = rotateLock;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:_rotateLock forKey:KTBrowserRotateLock];
    [ud synchronize];
}

- (BOOL)rotateLock
{
    return (_rotateLock||!_shouldShowRotateLock);
}

- (void)setDicSearchConfig:(NSMutableDictionary *)dicSearchConfig
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:dicSearchConfig forKey:KTBrowserSearchConfig];
    [ud synchronize];
}

- (NSMutableDictionary *)dicSearchConfig
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dicSearchConfig = [ud objectForKey:KTBrowserSearchConfig];
    return dicSearchConfig;
}

- (void)setFontsize:(CGFloat)fontsize
{
    _fontsize = fontsize;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setFloat:_fontsize forKey:KTBrowserWebFontsize];
    [ud synchronize];
    
    _DEBUG_LOG(@"%s", __FUNCTION__);
    
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:KTNotificationSetFontsize
                                                        object:nil
                                                      userInfo:[NSDictionary dictionaryWithObject:@(_fontsize)
                                                                                           forKey:KTNotificationUserInfoFontsize]];
}

- (void)setFullScreen:(BOOL)fullScreen
{
    _fullScreen = fullScreen;
    _fullScreenLandscope = fullScreen;
}

- (BOOL)fullScreen
{
    return _fullScreen || _fullScreenLandscope;
}

- (void)setFullScreenLandscope:(BOOL)fullScreenLandscope
{
    _fullScreenLandscope = fullScreenLandscope;
}

@end


// -------------------------browser config keys in user defaults -------------
NSString *const KTBrowserSkinImagePath      = @"KTBrowserSkinImagePath";
NSString *const KTBrowserUIMode             = @"KTBrowserUIMode";
NSString *const KTBrowserBrightnessDay      = @"KTBrowserBrightnessDay";
NSString *const KTBrowserBrightnessNight    = @"KTBrowserBrightnessNight";
NSString *const KTBrowserNoImage            = @"KTBrowserNoImage";
NSString *const KTBrowserNoHistory          = @"KTBrowserNoHistory";
NSString *const KTBrowserRotateLock         = @"KTBrowserRotateLock";
NSString *const KTBrowserSearchConfig       = @"KTBrowserSearchConfig";

NSString *const KTBrowserWebFontsize        = @"KTBrowserWebFontsize";
NSString *const KTBrowserRememberPwd        = @"KTBrowserRememberPwd";

NSString *const KTNotificationSetFontsize   = @"KTNotificationSetFontsize";
NSString *const KTNotificationUserInfoFontsize   = @"KTNotificationUserInfoFontsize";

NSString *const KTNotificationUpdateUIMode   = @"KTNotificationUpdateUIMode";

NSString *const kNotificationDidSyncHome    = @"kNotificationDidSyncHome";
NSString *const kNotificationUpdateSyncTime = @"kNotificationUpdateSyncTime";
NSString *const kNotificationUpdateFidServer= @"kNotificationUpdateFidServer";

NSString *const kNotificationDidLogin       = @"kNotificationDidLogin";
NSString *const kNotificationDidLogout      = @"kNotificationDidLogout";

NSString *const kCurrUserId                 = @"kCurrUserId";
NSString *const kCurrLoginShareType         = @"kCurrLoginShareType";

