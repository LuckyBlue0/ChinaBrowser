//
//  ModelUserSettings.h
//  WKBrowser
//
//  Created by David on 13-10-22.
//  Copyright (c) 2013年 VeryApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelUserSettings : NSObject

@property (nonatomic, assign) NSInteger usid;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) NSTimeInterval updateTimeInterval;

@property (nonatomic, assign) BOOL shouldSyncHome;
@property (nonatomic, assign) BOOL shouldSyncFavorite;
@property (nonatomic, assign) BOOL shouldSyncHistory;

+ (ModelUserSettings *)modelUserSettings;

@end
