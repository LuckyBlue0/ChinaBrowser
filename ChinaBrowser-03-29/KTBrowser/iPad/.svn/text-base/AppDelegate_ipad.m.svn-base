//
//  AppDelegate.m
//  BrowserApp
//
//  Created by arBao on 14-1-27.
//  Copyright (c) 2014年 arBao. All rights reserved.
//

#import "AppDelegate_ipad.h"

#import "ShareSDKPackage.h"

#import "ControllerNav_ipad.h"

#import "DatabaseUtil.h"

@implementation AppDelegate_ipad

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [DatabaseUtil createDatabase];
    
    _window = [[WindowRoot_ipad alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.backgroundColor = isDayMode?kMainBgColorDay:kMainBgColorNight;

    ControllerNav_ipad *nav = [[ControllerNav_ipad alloc] initWithRootViewController:[AppManager vcRoot]];
    _window.rootViewController = nav;
    [_window makeKeyAndVisible];
    
    [ShareSDKPackage shareShareSDKPackage].rootViewController = nav;
    [[ShareSDKPackage shareShareSDKPackage] registerSDK_KEYS];
    
    return YES;
}

@end
