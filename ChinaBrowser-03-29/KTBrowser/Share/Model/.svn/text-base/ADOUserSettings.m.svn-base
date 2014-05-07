//
//  ADOUserSettings.m
//  WKBrowser
//
//  Created by David on 13-10-22.
//  Copyright (c) 2013年 VeryApps. All rights reserved.
//

#import "ADOUserSettings.h"

@implementation ADOUserSettings

static int QueryCallback (void *result, int colCount, char **data, char **colName)
{
    NSMutableArray *arrResult = (NSMutableArray *)result;
    ModelUserSettings *model = [ModelUserSettings modelUserSettings];
    model.usid = atoi(data[0]);
    model.uid = atoll(data[1]);
    model.updateTimeInterval = atof(data[2]);
    model.shouldSyncHome = atoi(data[3]);
    model.shouldSyncFavorite = atoi(data[4]);
    model.shouldSyncHistory = atoi(data[5]);
    
    [arrResult addObject:model];
    return 0;
}

+ (BOOL)isExsitsWithUid:(int64_t)uid
{
    const char *filename = [GetDBPathWithName(DB_NAME_1) UTF8String];
    sqlite3 *db = nil ;
    const char *sql = [[NSString stringWithFormat:@"select * from tab_usersettings where us_uid = %lld", uid] UTF8String];
    sqlite3_callback callback = QueryCallback;
    NSMutableArray *arrResult = [NSMutableArray array];
    char *msg = nil;
    do {
        if (SQLITE_OK!=sqlite3_open(filename, &db))
            break;
        if (SQLITE_OK!=sqlite3_exec(db, sql, callback, (void*)arrResult, &msg))
            break;
    } while (NO);
    
    if (msg) sqlite3_free(msg);
    if (db) sqlite3_close(db);
    
    return arrResult.count>0;
}

+ (BOOL)addWithModel:(ModelUserSettings *)model
{
    BOOL flage = NO;
    const char *filename = [GetDBPathWithName(DB_NAME_1) UTF8String];
    sqlite3 *db;
    const char *sql = [[NSString stringWithFormat:@"insert into tab_usersettings "
                        "(us_uid, us_updateTimeInterval, us_shouldSyncHome, us_shouldSyncFavorite, us_shouldSyncHistory) values "
                        "(%lld, %lf, %d, %d, %d);", model.uid, model.updateTimeInterval, model.shouldSyncHome, model.shouldSyncFavorite, model.shouldSyncHistory]
                       UTF8String];
    char *msg=nil;
    do {
        if (SQLITE_OK!=sqlite3_open(filename, &db))
            break;
        if (SQLITE_OK!=sqlite3_exec(db, sql, nil, nil, &msg)) {
            break;
        }
        flage = YES;
    } while (NO);
    
    if (msg) sqlite3_free(msg);
    if (db) sqlite3_close(db);
    
    return flage;
}

+ (BOOL)updateModel:(ModelUserSettings *)model withUid:(int64_t)uid
{
    BOOL flage = NO;
    const char *filename = [GetDBPathWithName(DB_NAME_1) UTF8String];
    sqlite3 *db;
    const char *sql = [[NSString stringWithFormat:@"update tab_usersettings "
                        "set us_updateTimeInterval = %lf, us_shouldSyncHome = %d, "
                        "us_shouldSyncFavorite = %d, us_shouldSyncHistory = %d where us_uid = %lld;",
                        model.updateTimeInterval,
                        model.shouldSyncHome,
                        model.shouldSyncFavorite,
                        model.shouldSyncHistory,
                        model.uid]
                       UTF8String];
    char *msg=nil;
    do {
        if (SQLITE_OK!=sqlite3_open(filename, &db))
            break;
        if (SQLITE_OK!=sqlite3_exec(db, sql, nil, nil, &msg)) {
            break;
        }
        flage = YES;
    } while (NO);
    
    if (msg) sqlite3_free(msg);
    if (db) sqlite3_close(db);
    
    return flage;
}

+ (BOOL)deleteWithUid:(int64_t)uid
{
    BOOL flage = NO;
    const char *filename = [GetDBPathWithName(DB_NAME_1) UTF8String];
    sqlite3 *db;
    const char *sql = [[NSString stringWithFormat:@"delete from tab_usersettings where us_uid=%lld", uid]
                       UTF8String];
    char *msg=nil;
    do {
        if (SQLITE_OK!=sqlite3_open(filename, &db))
            break;
        if (SQLITE_OK!=sqlite3_exec(db, sql, nil, nil, &msg)) {
            break;
        }
        flage = YES;
    } while (NO);
    
    if (msg) sqlite3_free(msg);
    if (db) sqlite3_close(db);
    
    return flage;
}

+ (ModelUserSettings *)queryWithUid:(int64_t)uid
{
    const char *filename = [GetDBPathWithName(DB_NAME_1) UTF8String];
    sqlite3 *db = nil ;
    const char *sql = [[NSString stringWithFormat:@"select * from tab_usersettings where us_uid=%lld", uid] UTF8String];
    sqlite3_callback callback = QueryCallback;
    NSMutableArray *arrResult = [NSMutableArray array];
    char *msg = nil;
    do {
        if (SQLITE_OK!=sqlite3_open(filename, &db))
            break;
        if (SQLITE_OK!=sqlite3_exec(db, sql, callback, (void*)arrResult, &msg))
            break;
    } while (NO);
    
    if (msg) sqlite3_free(msg);
    if (db) sqlite3_close(db);
    
    return arrResult.count>0?[arrResult objectAtIndex:0]:nil;
}

@end
