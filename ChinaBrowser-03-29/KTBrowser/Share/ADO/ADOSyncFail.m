//
//  ADOSyncFail.m
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

#import "ADOSyncFail.h"

@implementation ADOSyncFail

static int QueryCallback (void *result, int colCount, char **data, char **colName)
{
    NSMutableArray *arrResult = (__bridge NSMutableArray *)result;
    ModelSyncFail *model = [ModelSyncFail modelSyncFail];
    model.sfid = atoi(data[0]);
    model.fid_server = atoi(data[1]);
    model.uid = atoi(data[2]);
    char *
    value = data[3];
    if (value) model.title = [NSString stringWithCString:value encoding:NSUTF8StringEncoding];
    value = data[4];
    if (value) model.link = [NSString stringWithCString:value encoding:NSUTF8StringEncoding];
    model.time = atof(data[5]);
    model.dataType = atoi(data[6]);
    model.actionType = atoi(data[7]);
    value = data[8];
    if (value) model.fids_server = [NSString stringWithCString:value encoding:NSUTF8StringEncoding];
    
    [arrResult addObject:model];
    return 0;
}


+ (BOOL)addModel:(ModelSyncFail *)model
{
    BOOL flage = NO;
    const char *filename = [GetDBPathWithName(DB_NAME) UTF8String];
    sqlite3 *db;
    const char *sql = [[NSString stringWithFormat:@"insert into tab_sync_fail "
                        "(fid_server, uid, title, link, time, data_type, action_type, fids_server) values "
                        "(%d, %d, '%@', '%@', %lf, %d, %d, %@);", model.fid_server, model.uid, model.title, model.link, model.time, model.dataType, model.actionType, model.fids_server]
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

+ (BOOL)deleteWithSfid:(NSInteger)sfid
{
    BOOL flage = NO;
    const char *filename = [GetDBPathWithName(DB_NAME) UTF8String];
    sqlite3 *db;
    const char *sql = [[NSString stringWithFormat:@"delete from tab_sync_fail where sfid = %d", sfid]
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

+ (NSArray *)queryWithUid:(NSInteger)uid
{
    const char *filename = [GetDBPathWithName(DB_NAME) UTF8String];
    sqlite3 *db = nil ;
    const char *sql = [[NSString stringWithFormat:@"select * from tab_sync_fail where uid = %d", uid] UTF8String];
    sqlite3_callback callback = QueryCallback;
    NSMutableArray *arrResult = [NSMutableArray array];
    char *msg = nil;
    do {
        if (SQLITE_OK!=sqlite3_open(filename, &db))
            break;
        if (SQLITE_OK!=sqlite3_exec(db, sql, callback, (__bridge void*)arrResult, &msg))
            break;
    } while (NO);
    
    if (msg) sqlite3_free(msg);
    if (db) sqlite3_close(db);
    
    return arrResult;
}

+ (NSArray *)queryWithUid:(NSInteger)uid dataType:(WKSyncDataType)dataType
{
    const char *filename = [GetDBPathWithName(DB_NAME) UTF8String];
    sqlite3 *db = nil ;
    const char *sql = [[NSString stringWithFormat:@"select * from tab_sync_fail where uid = %d and data_type=%d", uid, dataType] UTF8String];
    sqlite3_callback callback = QueryCallback;
    NSMutableArray *arrResult = [NSMutableArray array];
    char *msg = nil;
    do {
        if (SQLITE_OK!=sqlite3_open(filename, &db))
            break;
        if (SQLITE_OK!=sqlite3_exec(db, sql, callback, (__bridge void*)arrResult, &msg))
            break;
    } while (NO);
    
    if (msg) sqlite3_free(msg);
    if (db) sqlite3_close(db);
    
    return arrResult;
}

@end
