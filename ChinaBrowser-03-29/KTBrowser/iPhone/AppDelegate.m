//
//  AppDelegate.m
//  KTBrowser
//
//  Created by David on 14-2-13.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "AppDelegate.h"

#import <QuartzCore/QuartzCore.h>

#import <ShareSDK/ShareSDK.h>

#import "WXApi.h"
#import "WeiboApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

#import "DatabaseUtil.h"

#import "BaiduMobStat.h"
#import "ADOSkin.h"

#import <AGCommon/UIImage+Common.h>

#import "WKSync.h"
#import "ModelUserSettings.h"
#import "ModelUser.h"
#import "ADOUserSettings.h"
#import "CHKeychain.h"

@interface AppDelegate ()

- (void)initShareSDK;
- (void)initBaiduMob;

@end

@implementation AppDelegate

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // 创建数据库
    [DatabaseUtil createDatabase];
    [self initShareSDK];
//    [self initBaiduMob];
    
    
    // 初始化皮肤
    NSString *skinDirPath = [GetDocumentDir() stringByAppendingPathComponent:@"skin"];
    BOOL isDir;
    if (![[NSFileManager defaultManager] fileExistsAtPath:skinDirPath isDirectory:&isDir]) {
        [ADOSkin deleteAll];
        
        NSString *thumbPath = GetDocumentDirAppend(@"skin/thumb");
        NSString *imagePath = GetDocumentDirAppend(@"skin/image");
        
        NSString *srcPath0 = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"0.png"];
        NSString *srcPath1 = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"1.png"];
        
        UIImage *image0 = [UIImage imageWithContentsOfFile:srcPath0];
        UIImage *image1 = [UIImage imageWithContentsOfFile:srcPath1];
        
        UIImage *thumb0 = [image0 scaleImageWithSize:CGSizeMake(300, 300)];
        UIImage *thumb1 = [image1 scaleImageWithSize:CGSizeMake(300, 300)];
        
        ModelSkin *model0 = [ModelSkin modelSkin];
        model0.skinType = SkinTypeSys;
        model0.name = @"日间";
        model0.thumbPath = [thumbPath stringByAppendingPathComponent:[srcPath0 lastPathComponent]];
        model0.imagePath = [imagePath stringByAppendingPathComponent:[srcPath0 lastPathComponent]];
        
        ModelSkin *model1 = [ModelSkin modelSkin];
        model1.skinType = SkinTypeSys;
        model1.name = @"黑夜";
        model1.thumbPath = [thumbPath stringByAppendingPathComponent:[srcPath1 lastPathComponent]];
        model1.imagePath = [imagePath stringByAppendingPathComponent:[srcPath1 lastPathComponent]];
        
        [ADOSkin addModel:model0];
        [ADOSkin addModel:model1];
        
        [UIImageJPEGRepresentation(image0, 0) writeToFile:model0.imagePath atomically:YES];
        [UIImageJPEGRepresentation(thumb0, 0) writeToFile:model0.thumbPath atomically:YES];
        
        [UIImageJPEGRepresentation(image1, 0) writeToFile:model1.imagePath atomically:YES];
        [UIImageJPEGRepresentation(thumb1, 0) writeToFile:model1.thumbPath atomically:YES];
    }
    
    CGRect rcMask = [UIScreen mainScreen].bounds;
    CALayer *layerMask = [CALayer layer];
    layerMask.frame = CGRectMake(0, 0, MAX(rcMask.size.width, rcMask.size.height), MAX(rcMask.size.width, rcMask.size.height));
    layerMask.zPosition = MAXFLOAT;
    layerMask.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7].CGColor;
    [self.window.layer addSublayer:layerMask];
    
    [AppConfig config].rootController = self.window.rootViewController;
    [AppConfig config].layerMask = layerMask;
    [[AppConfig config] setup];
    
    // 设置登录账号
    NSString *szUid = [CHKeychain load:kCurrUserId];
    if (szUid) {
        ModelUserSettings *modelUserSetttings = [ADOUserSettings queryWithUid:[szUid integerValue]];
        if (modelUserSetttings) {
            ModelUser *modelUser = [ModelUser modelUserWithData:[CHKeychain load:szUid]];
            [WKSync shareWKSync].modelUser = modelUser;
            [WKSync shareWKSync].modelUserSettings = modelUserSetttings;
        }
        else {
            [CHKeychain delete:szUid];
            [CHKeychain delete:kCurrUserId];
        }
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
       handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

#pragma mark - WXApiDelegate

-(void) onReq:(BaseReq*)req
{
    
}

-(void) onResp:(BaseResp*)resp
{
    
}

// --------
- (void)initShareSDK
{
    // ---- ShareSDK 相关
    [ShareSDK registerApp:SSK_AppId_ShareSDK useAppTrusteeship:NO];
    [ShareSDK ssoEnabled:YES];
    
    // 配置 新浪微博
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSinaWeiboWithAppKey:SSK_AppKey_SinaWeibo
                               appSecret:SSK_Secret_SinaWeibo
                             redirectUri:SSK_Redirect_SinaWeibo
                             weiboSDKCls:[WeiboSDK class]];
    
    // 配置 腾讯微博
    /**
     连接腾讯微博开放平台应用以使用相关功能，此应用需要引用TencentWeiboConnection.framework
     http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入libWeiboSDK.a，并引入WBApi.h，将WBApi类型传入接口
     **/
    [ShareSDK connectTencentWeiboWithAppKey:SSK_AppKey_TencentWeibo
                                  appSecret:SSK_Secret_TencentWeibo
                                redirectUri:SSK_Redirect_TencentWeibo
                                   wbApiCls:[WeiboApi class]];
    
    /**
     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
     http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
     **/
    [ShareSDK connectQZoneWithAppKey:SSK_AppKey_QZone
                           appSecret:SSK_Secret_QZone
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    
    /**
     *  QQ
     */
    [ShareSDK connectQQWithQZoneAppKey:SSK_AppKey_QZone
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    /**
     *  微信
     */
    [ShareSDK connectWeChatWithAppId:SSK_AppId_WeiXin wechatCls:[WXApi class]];
    
    /**
     *  信息
     */
    [ShareSDK connectSMS];
    
    /**
     *  邮件
     */
    [ShareSDK connectMail];
}

- (void)initBaiduMob
{
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    statTracker.enableExceptionLog = YES; // 是否允许截获并发送崩溃信息，请设置YES或者NO
    //    statTracker.channelId = @"Cydia";//设置您的app的发布渠道
    statTracker.logStrategy = BaiduMobStatLogStrategyAppLaunch;//根据开发者设定的时间间隔接口发送 也可以使用启动时发送策略
    statTracker.enableDebugOn = YES; //打开调试模式，发布时请去除此行代码或者设置为False即可。
    statTracker.logSendInterval = 1; //为1时表示发送日志的时间间隔为1小时,只有 statTracker.logStrategy = BaiduMobStatLogStrategyAppLaunch这时才生效。
    statTracker.logSendWifiOnly = NO; //是否仅在WIfi情况下发送日志数据
    statTracker.sessionResumeInterval = 5;//设置应用进入后台再回到前台为同一次session的间隔时间[0~600s],超过600s则设为600s，默认为30s
    
    //    NSString *adId = @"";
    //    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0f){
    //        adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    //    }
    //
    //    statTracker.adid = adId;
    
    [statTracker startWithAppId:BaiduMobAppKey];//设置您在mtj网站上添加的app的appkey
}

@end
