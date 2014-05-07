//
//  ADOSkin.m
//  ChinaBrowser
//
//  Created by David on 14-3-17.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ADOSkin.h"

@implementation ADOSkin

static int QueryCallback (void *result, int colCount, char **data, char **colName)
{
    NSMutableArray *arrResult = (__bridge NSMutableArray *)result;
    ModelSkin *model = [ModelSkin modelSkin];
    model.sid = atoi(data[0]);
    model.skinType = atoi(data[1]);
    char *
    value = data[2];
    if (value) model.name = [NSString stringWithCString:value encoding:NSUTF8StringEncoding];
    value = data[3];
    if (value) model.thumbPath = [NSString stringWithCString:value encoding:NSUTF8StringEncoding];
    value = data[4];
    if (value) model.imagePath = [NSString stringWithCString:value encoding:NSUTF8StringEncoding];
    
    [arrResult addObject:model];
    return 0;
}

+ (BOOL)isExistWithImagePath:(NSString *)imagePath type:(SkinType)type
{
    const char *filename = [GetDBPathWithName(DB_NAME) UTF8String];
    sqlite3 *db = nil ;
    const char *sql = [[NSString stringWithFormat:@"select * from tab_skin where stype=%d and image_path = \"%@\"", type, imagePath] UTF8String];
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

+ (NSInteger)addModel:(ModelSkin *)model
{
    if ([ADOSkin isExistWithImagePath:model.imagePath type:model.skinType]) {
        return 0;
    }
    NSInteger lastInsertId = 0;
    const char *filename = [GetDBPathWithName(DB_NAME) UTF8String];
    sqlite3 *db;
    const char *sql = [[NSString stringWithFormat:@"insert into tab_skin "
                        "(stype, name, thumb_path, image_path) values "
                        "(%d,'%@', '%@', '%@');",
                        model.skinType, model.name, model.thumbPath, model.imagePath] UTF8String];
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

+ (BOOL)deleteWithSid:(NSInteger)sid
{
    BOOL flage = NO;
    const char *filename = [GetDBPathWithName(DB_NAME) UTF8String];
    sqlite3 *db;
    const char *sql = [[NSString stringWithFormat:@"delete from tab_skin where sid = %d",
                        sid] UTF8String];
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

+ (BOOL)deleteAll
{
    BOOL flage = NO;
    const char *filename = [GetDBPathWithName(DB_NAME) UTF8String];
    sqlite3 *db;
    const char *sql = [[NSString stringWithFormat:@"delete from tab_skin"] UTF8String];
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

+ (NSArray *)queryAll
{
    const char *filename = [GetDBPathWithName(DB_NAME) UTF8String];
    sqlite3 *db = nil ;
    const char *sql = [[NSString stringWithFormat:@"select * from tab_skin"] UTF8String];
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

+ (NSArray *)queryWithType:(SkinType)type
{
    const char *filename = [GetDBPathWithName(DB_NAME) UTF8String];
    sqlite3 *db = nil ;
    const char *sql = [[NSString stringWithFormat:@"select * from tab_skin where stype = %d", type] UTF8String];
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
