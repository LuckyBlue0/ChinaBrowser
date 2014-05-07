//
//  ADOFavorite.h
//  WKBrowser
//
//  Created by David on 13-10-24.
//  Copyright (c) 2013年 VeryApps. All rights reserved.
/*
 "fid INTEGER  PRIMARY KEY AUTOINCREMENT DEFAULT 1,"
 "fid_server INTEGER DEFAULT 0,"
 "uid INTEGER DEFAULT 0,"
 "title TEXT,"
 "link TEXT,"
 "time Double DEFAULT 0,"
 "data_type INTEGER DEFAULT 0)"
 */

#import <Foundation/Foundation.h>

#import <sqlite3.h>
#import "ModelFavorite.h"

@interface ADOFavorite : NSObject

+ (BOOL)isExistsWithDataType:(WKSyncDataType)dataType link:(NSString *)link uid:(NSInteger)uid withGuest:(BOOL)withGuest;;
+ (BOOL)isExistsWithDataType:(WKSyncDataType)dataType fid_server:(NSInteger)fid_server uid:(NSInteger)uid withGuest:(BOOL)withGuest;;
+ (NSInteger)addModel:(ModelFavorite *)model;

+ (BOOL)deleteWithFid:(NSInteger)fid;
+ (BOOL)deleteWithFids:(NSString *)fids;
+ (BOOL)deleteWithFidServer:(NSInteger)fidServer;

+ (BOOL)deleteWithDataType:(WKSyncDataType)dataType link:(NSString *)link uid:(NSInteger)uid;
+ (BOOL)deleteWithDataType:(WKSyncDataType)dataType uid:(NSInteger)uid;
+ (BOOL)deleteNoFidServerWithDataType:(WKSyncDataType)dataType uid:(NSInteger)uid;
+ (BOOL)deleteDataType:(WKSyncDataType)dataType uid:(NSInteger)uid notContainFidsServer:(NSString *)fidsServer;

+ (BOOL)updateTime:(NSTimeInterval)time withFid:(NSInteger)fid;
+ (BOOL)updateTime:(NSTimeInterval)time withFid:(NSInteger)fid times:(NSInteger)times;

+ (BOOL)updateTime:(NSTimeInterval)time title:(NSString *)title withFid:(NSInteger)fid;
+ (BOOL)updateTime:(NSTimeInterval)time title:(NSString *)title withFid:(NSInteger)fid times:(NSInteger)times;

+ (BOOL)updateFidServer:(NSInteger)fid_server withUid:(NSInteger)uid dataType:(WKSyncDataType)dataType link:(NSString *)link;
+ (BOOL)updateFidServer:(NSInteger)fid_server withUid:(NSInteger)uid dataType:(WKSyncDataType)dataType link:(NSString *)link times:(NSInteger)times;

+ (BOOL)updateModel:(ModelFavorite *)model withFidServer:(NSInteger)fid_server uid:(NSInteger)uid;

+ (NSArray *)queryWityUid:(NSInteger)uid dataType:(WKSyncDataType)dataType withGuest:(BOOL)withGuest;
+ (NSArray *)queryWityUid:(NSInteger)uid dataType:(WKSyncDataType)dataType page:(NSInteger)page pagesize:(NSInteger)pagesize withGuest:(BOOL)withGuest;

+ (NSArray *)queryMostVisitedCount:(NSInteger)mostVisitedCount WityUid:(NSInteger)uid dataType:(WKSyncDataType)dataType withGuest:(BOOL)withGuest;

+ (ModelFavorite *)queryWithDataType:(WKSyncDataType)dataType link:(NSString *)link uid:(NSInteger)uid withGuest:(BOOL)withGuest;

@end
