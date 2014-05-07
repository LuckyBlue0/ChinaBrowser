//
//  ADOSyncFail.h
//  WKBrowser
//
//  Created by David on 13-10-22.
//  Copyright (c) 2013年 VeryApps. All rights reserved.
/*
 "sfid INTEGER  PRIMARY KEY AUTOINCREMENT DEFAULT 1,"
 "fid_server INTEGER DEFAULT 0,"
 "uid INTEGER DEFAULT 0,"
 "title TEXT,"
 "link TEXT,"
 "time Double DEFAULT 0,"
 "data_type INTEGER DEFAULT 0,"
 "action_type INTEGER DEFAULT 0)" 
 */

#import <Foundation/Foundation.h>

#import <sqlite3.h>
#import "ModelSyncFail.h"

@interface ADOSyncFail : NSObject

+ (BOOL)addModel:(ModelSyncFail *)model;

+ (BOOL)deleteWithSfid:(NSInteger)sfid;

+ (NSArray *)queryWithUid:(NSInteger)uid;
+ (NSArray *)queryWithUid:(NSInteger)uid dataType:(WKSyncDataType)dataType;

@end
