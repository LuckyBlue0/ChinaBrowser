//
//  AppConfig.h
//  KTBrowser
//
//  Created by David on 14-2-15.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, UIMode) {
    UIModeDay,
    UIModeNight
};

@class UINavController;
@class CALayer;

/**
 *  App 配置类（昼夜模式、亮度、是否有图、是否记录历史记录、是否允许旋转、搜索引擎）
 */
@interface AppConfig : NSObject
{
}

@property (nonatomic, strong) UIImage *bgImage;

// 视图 昼/夜 模式
@property (nonatomic, assign) UIMode uiMode;

@property (nonatomic, strong) NSString *skinImagePath;

@property (nonatomic, strong, readonly) NSString *skinBundleName;

// 旋转控制相关
@property (nonatomic, strong) UIViewController *rootController;  // 控制按钮所在的控制器
@property (nonatomic, assign) BOOL shouldShowRotateLock;
@property (nonatomic, assign) UIInterfaceOrientation interfaceOrientation;
@property (nonatomic, assign) UIInterfaceOrientation deviceOrientation;
@property (nonatomic, assign, readonly) UIInterfaceOrientationMask interfaceOrientationMask;

@property (nonatomic, assign) BOOL rotateLock;

// 亮度调节 相关
@property (nonatomic, strong) CALayer *layerMask;
@property (nonatomic, assign) CGFloat brightnessDay;
@property (nonatomic, assign) CGFloat brightnessNight;

// 有图无图
@property (nonatomic, assign) BOOL noImage;

// 是否记录历史记录
@property (nonatomic, assign) BOOL noHistory;

// 是搜记住密码
@property (nonatomic, assign) BOOL rememberPwd;


/**
 *  {@"cateIndex":@(), @"item":[{@"itemIndex":@()},{@"itemIndex":@()}]}
 */
@property (nonatomic, strong) NSMutableDictionary *dicSearchConfig;

// 网页字体大小
@property (nonatomic, assign) CGFloat fontsize;

// 是否全屏
@property (nonatomic, assign) BOOL fullScreen;

// 横屏状态是否全屏
@property (nonatomic, assign) BOOL fullScreenLandscope;



+ (AppConfig *)config;

+ (UIImage *)bgImageWithFile:(NSString *)file;

- (void)setup;

@end


// -------------------------browser config keys in user defaults -------------
extern NSString *const KTBrowserSkinImagePath;
extern NSString *const KTBrowserUIMode;
extern NSString *const KTBrowserBrightnessDay;
extern NSString *const KTBrowserBrightnessNight;
extern NSString *const KTBrowserNoImage;
extern NSString *const KTBrowserNoHistory;
extern NSString *const KTBrowserRotateLock;
extern NSString *const KTBrowserSearchConfig;

extern NSString *const KTBrowserWebFontsize;
extern NSString *const KTBrowserRememberPwd;

// -------------------------browser notification -------------
extern NSString *const KTNotificationSetFontsize;
extern NSString *const KTNotificationUserInfoFontsize;

extern NSString *const KTNotificationUpdateUIMode;

extern NSString *const kNotificationDidSyncHome;
extern NSString *const kNotificationUpdateSyncTime;
extern NSString *const kNotificationUpdateFidServer;

extern NSString *const kNotificationDidLogin;
extern NSString *const kNotificationDidLogout;

extern NSString *const kCurrUserId;
extern NSString *const kCurrLoginShareType;

