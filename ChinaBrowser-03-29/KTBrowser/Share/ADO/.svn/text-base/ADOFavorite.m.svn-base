//
//  ADOFavorite.m
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

#import "ADOFavorite.h"

@implementation ADOFavorite

static int QueryCallback (void *result, int colCount, char **data, char **colName)
{
    NSMutableArray *arrResult = (__bridge NSMutableArray *)result;
    ModelFavorite *model = [ModelFavorite modelFavorite];
    model.fid = atoi(data[0]);
    model.fid_server = atoi(data[1]);
    model.uid = atoi(data[2]);
    char *
    value = data[3];
    if (value) model.title = [NSString stringWithCString:value encoding:NSUTF8StringEncoding];
    value = data[4];
    if (value) model.link = [NSString stringWithCString:value encoding:NSUTF8StringEncoding];
    model.time = atof(data[5]);
    model.dataType = atoi(data[6]);
    model.times = atoi(data[7]);
    
    [arrResult addObject:model];
    return 0;
}

+ (BOOL)isExistsWithDataType:(WKSyncDataType)dataType link:(NSString *)link uid:(NSInteger)uid withGuest:(BOOL)withGuest;
{
    const char *filename = [GetDBPathWithName(DB_NAME) UTF8String];
    sqlite3 *db = nil ;
    const char *sql = [[NSString stringWithFormat:@"select * from tab_favorite where data_type=%d and link = \"%@\" and (%@uid=%d)",
                        dataType, link, withGuest?@"uid=0 or ":@"", uid] UTF8String];
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
    
    return arrResult.count>0;
}

+ (BOOL)isExistsWithDataType:(WKSyncDataType)dataType fid_server:(NSInteger)fid_server uid:(NSInteger)uid withGuest:(BOOL)withGuest;
{
    const char *filename = [GetDBPathWithName(DB_NAME) UTF8String];
    sqlite3 *db = nil ;
    const char *sql = [[NSString stringWithFormat:@"select * from tab_favorite where data_type=%d and fid_server = %d and (%@uid=%d)",
                        dataType, fid_server, withGuest?@"uid=0 or ":@"", uid] UTF8String];
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
    
    return arrResult.count>0;
}

+ (NSInteger)addModel:(ModelFavorite *)model
{
    if (model.title.length==0 || model.link.length==0) {
        return 0;
    }
    
    NSInteger lastInsertId = 0;
    const char *filename = [GetDBPathWithName(DB_NAME) UTF8String];
    sqlite3 *db;
    const char *sql = [[NSString stringWithFormat:@"insert into tab_favorite "
                        "(fid_server, uid, title, link, time, data_type, times) values "
                        "(%d, %d, '%@', '%@', %lf, %d, %d);",
                        model.fid_server, model.uid, model.title, model.link, model.time, model.dataType, 1]
                       UTF8String];
    char *msg=nil;
    do {
        if (SQLITE_OK!=sqlite3_open(filename, &db))
            break;
        if (SQLITE_OK!=sqlite3_exec(db, sql, nil, nil, &msg)) {
            break;
        }
    } while (NO);
    
    lastInsertId = (NSInteger)sqlite3_last_insert_rowid(db);
    
    if (msg) sqlite3_free(msg);
    if (db) sqlite3_close(db);
    
    return lastInsertId;
}

+ (BOOL)deleteWithFid:(NSInteger)fid
{
    BOOL flage = NO;
    const char *filename = [GetDBPathWithName(DB_NAME) UTF8String];
    sqlite3 *db;
    const char *sql = [[NSString stringWithFormat:@"delete from tab_favorite where fid = %d",
                        fid] UTF8String];
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

+ (BOOL)deleteWithFids:(NSString *)fids
{
    BOOL flage = NO;
    const char *filename = [GetDBPathWithName(DB_NAME) UTF8String];
    sqlite3 *db;
    const char *sql = [[NSString stringWithFormat:@"delete from tab_favorite where fid in (%@)",
                        fids] UTF8String];
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

+ (BOOL)deleteWithFidServer:(NSInteger)fidServer
{
    BOOL flage = NO;
    const char *filename = [GetDBPathWithName(DB_NAME) UTF8String];
    sqlite3 *db;
    const char *sql = [[NSString stringWithFormat:@"delete from tab_favorite where fid_server = %d",
                        fidServer] UTF8String];
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

+ (BOOL)deleteWithDataType:(WKSyncDataType)dataType link:(NSString *)link uid:(NSInteger)uid
{
    BOOL flage = NO;
    const char *filename = [GetDBPathWithName(DB_NAME) UTF8String];
    sqlite3 *db;
    const char *sql = [[NSString stringWithFormat:@"delete from tab_favorite where data_type = %d and link=\"%@\" and uid=%d",
                        dataType, link, uid] UTF8String];
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

+ (BOOL)deleteWithDataType:(WKSyncDataType)dataType uid:(NSInteger)uid
{
    BOOL flage = NO;
    const char *filename = [GetDBPathWithName(DB_NAME) UTF8String];
    sqlite3 *db;
    const char *sql = [[NSString stringWithFormat:@"delete from tab_favorite where data_type = %d and uid=%d",
                        dataType, uid] UTF8String];
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

+ (BOOL)deleteNoFidServerWithDataType:(WKSyncDataType)dataType uid:(NSInteger)uid
{
    BOOL flage = NO;
    const char *filename = [GetDBPathWithName(DB_NAME) UTF8String];
    sqlite3 *db;
    const char *sql = [[NSString stringWithFormat:@"delete from tab_favorite where data_type = %d and uid=%d and fid_server=0",
                        dataType, uid] UTF8String];
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

+ (BOOL)deleteDataType:(WKSyncDataType)dataType uid:(NSInteger)uid notContainFidsServer:(NSString *)fidsServer
{
    BOOL flage = NO;
    const char *filename = [GetDBPathWithName(DB_NAME) UTF8String];
    sqlite3 *db;
    const char *sql = [[NSString stringWithFormat:@"delete from tab_favorite where data_type = %d and uid=%d and fid_server not in (%@)",
                        dataType, uid, fidsServer] UTF8String];
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

+ (BOOL)updateTime:(NSTimeInterval)time withFid:(NSInteger)fid
{
    BOOL flage = NO;
    const char *filename = [GetDBPathWithName(DB_NAME) UTF8String];
    sqlite3 *db;
    const char *sql = [[NSString stringWithFormat:@"update tab_favorite set time = %lf where fid = %d",
                        time, fid] UTF8String];
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

+ (BOOL)updateTime:(NSTimeInterval)time withFid:(NSInteger)fid times:(NSInteger)times
{
    BOOL flage = NO;
    const char *filename = [GetDBPathWithName(DB_NAME) UTF8String];
    sqlite3 *db;
    const char *sql = [[NSString stringWithFormat:@"update tab_favorite set time = %lf, times = %d where fid = %d",
                        time, times, fid] UTF8String];
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

+ (BOOL)updateTime:(NSTimeInterval)time title:(NSString *)title withFid:(NSInteger)fid
{
    BOOL flage = NO;
    const char *filename = [GetDBPathWithName(DB_NAME) UTF8String];
    sqlite3 *db;
    const char *sql = [[NSString stringWithFormat:@"update tab_favorite set time = %lf, title = '%@' where fid = %d",
                        time, title, fid] UTF8String];
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

+ (BOOL)updateTime:(NSTimeInterval)time title:(NSString *)title withFid:(NSInteger)fid times:(NSInteger)times
{
    BOOL flage = NO;
    const char *filename = [GetDBPathWithName(DB_NAME) UTF8String];
    sqlite3 *db;
    const char *sql = [[NSString stringWithFormat:@"update tab_favorite set time = %lf, title = '%@', times = %d where fid = %d",
                        time, title, times, fid] UTF8String];
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

+ (BOOL)updateFidServer:(NSInteger)fid_server withUid:(NSInteger)uid dataType:(WKSyncDataType)dataType link:(NSString *)link
{
    BOOL flage = NO;
    const char *filename = [GetDBPathWithName(DB_NAME) UTF8String];
    sqlite3 *db;
    const char *sql = [[NSString stringWithFormat:@"update tab_favorite set fid_server = %d where uid=%d and data_type=%d and link = \"%@\"",
                        fid_server, uid, dataType, link] UTF8String];
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

+ (BOOL)updateFidServer:(NSInteger)fid_server withUid:(NSInteger)uid dataType:(WKSyncDataType)dataType link:(NSString *)link times:(NSInteger)times
{
    BOOL flage = NO;
    const char *filename = [GetDBPathWithName(DB_NAME) UTF8String];
    sqlite3 *db;
    const char *sql = [[NSString stringWithFormat:@"update tab_favorite set fid_server = %d, times=%d where uid=%d and data_type=%d and link = \"%@\"",
                        fid_server, times, uid, dataType, link] UTF8String];
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

+ (BOOL)updateModel:(ModelFavorite *)model withFidServer:(NSInteger)fid_server uid:(NSInteger)uid
{
    BOOL flage = NO;
    const char *filename = [GetDBPathWithName(DB_NAME) UTF8String];
    sqlite3 *db;
    const char *sql = [[NSString stringWithFormat:@"update tab_favorite set title=\"%@\", link=\"%@\", time=%lf, times=%d where uid=%d and fid_server=%d",
                        model.title, model.link, model.time, model.times, uid, fid_server] UTF8String];
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

+ (NSArray *)queryWityUid:(NSInteger)uid dataType:(WKSyncDataType)dataType withGuest:(BOOL)withGuest;
{
    const char *filename = [GetDBPathWithName(DB_NAME) UTF8String];
    sqlite3 *db = nil ;
    const char *sql = [[NSString stringWithFormat:@"select * from tab_favorite where (%@uid=%d) and data_type = %d%@",
                        withGuest?@"uid=0 or ":@"",
                        uid, dataType, dataType!=WKSyncDataTypeHome?@" order by time desc":@""] UTF8String];
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

+ (NSArray *)queryWityUid:(NSInteger)uid dataType:(WKSyncDataType)dataType page:(NSInteger)page pagesize:(NSInteger)pagesize withGuest:(BOOL)withGuest;
{
    const char *filename = [GetDBPathWithName(DB_NAME) UTF8String];
    sqlite3 *db = nil ;
    const char *sql = [[NSString stringWithFormat:@"select * from tab_favorite where (%@uid=%d) and data_type = %d %@limit %d,%d",
                        withGuest?@"uid=0 or ":@"",
                        uid, dataType, dataType!=WKSyncDataTypeHome?@"order by time desc ":@"", page*pagesize, pagesize] UTF8String];
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

+ (NSArray *)queryMostVisitedCount:(NSInteger)mostVisitedCount WityUid:(NSInteger)uid dataType:(WKSyncDataType)dataType withGuest:(BOOL)withGuest
{
    const char *filename = [GetDBPathWithName(DB_NAME) UTF8String];
    sqlite3 *db = nil ;
    const char *sql = [[NSString stringWithFormat:@"select * from tab_favorite where (%@uid=%d) and data_type = %d %@limit 0, %d",
                        withGuest?@"uid=0 or ":@"",
                        uid, dataType, dataType!=WKSyncDataTypeHome?@"order by times desc ":@"", mostVisitedCount] UTF8String];
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

+ (ModelFavorite *)queryWithDataType:(WKSyncDataType)dataType link:(NSString *)link uid:(NSInteger)uid withGuest:(BOOL)withGuest;
{
    const char *filename = [GetDBPathWithName(DB_NAME) UTF8String];
    sqlite3 *db = nil ;
    NSString *sql = nil;
    if (withGuest) {
        sql = [NSString stringWithFormat:@"select * from tab_favorite where data_type=%d and link = \"%@\" and (uid=%d or uid=0)", dataType, link, uid];
    }
    else {
        sql = [NSString stringWithFormat:@"select * from tab_favorite where data_type=%d and link = \"%@\" and uid=%d", dataType, link, uid];
    }
    sqlite3_callback callback = QueryCallback;
    NSMutableArray *arrResult = [NSMutableArray array];
    char *msg = nil;
    do {
        if (SQLITE_OK!=sqlite3_open(filename, &db))
            break;
        if (SQLITE_OK!=sqlite3_exec(db, [sql UTF8String], callback, (__bridge void*)arrResult, &msg))
            break;
    } while (NO);
    
    if (msg) sqlite3_free(msg);
    if (db) sqlite3_close(db);
    
    return arrResult.count>0?[arrResult lastObject]:nil;
}

@end
