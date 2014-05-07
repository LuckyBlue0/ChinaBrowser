//
//  ADOUserSettings.h
//  WKBrowser
//
//  Created by David on 13-10-22.
//  Copyright (c) 2013年 VeryApps. All rights reserved.
/*
 us_uid
 us_updateTimeInterval
 us_shouldSyncHome
 us_shouldSyncFavorite
 us_shouldSyncHistory
 */

#import <Foundation/Foundation.h>

#import <sqlite3.h>
#import "ModelUserSettings.h"

@interface ADOUserSettings : NSObject

+ (BOOL)isExsitsWithUid:(NSInteger)uid;
+ (BOOL)addWithModel:(ModelUserSettings *)model;
+ (BOOL)updateModel:(ModelUserSettings *)model withUid:(NSInteger)uid;
+ (ModelUserSettings *)queryWithUid:(NSInteger)uid;
+ (BOOL)deleteWithUid:(NSInteger)uid;

@end
