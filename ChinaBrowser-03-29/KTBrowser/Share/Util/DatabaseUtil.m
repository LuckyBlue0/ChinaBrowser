//
//  DatabaseUtil.m
//  FengShang
//
//  Created by David on 12-7-24.
//  Copyright (c) 2012年 com.veryapps. All rights reserved.
//

#import "DatabaseUtil.h"
#import <sqlite3.h>

@implementation DatabaseUtil

+ (void)createDatabase {
//    if ([[NSFileManager defaultManager] fileExistsAtPath:GetDBPath() isDirectory:nil]) return;
    
    char * error = nil;
    sqlite3 *db = nil;
    /*
    char *sqlFav = "create table if not exists tab_fav ("
    "f_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT DEFAULT 1,"
    "f_title text,"
    "f_link text);";
    
    char *sqlHistory = "create table if not exists tab_history ("
    "h_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT DEFAULT 1,"
    "h_title text,"
    "h_link text,"
    "h_lasttime double);";
    
    char *sqlHomesite = "create table if not exists tab_homesite ("
    "h_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT DEFAULT 1,"
    "h_title text,"
    "h_icon text,"
    "h_link text);";
    
    char *sql_white_list = "create table if not exists tab_whitelist ("
    "w_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT DEFAULT 1,"
    "w_title text,"
    "w_link text);";
    */
    /*
     us_uid
     us_updateTimeInterval
     us_shouldSyncHome
     us_shouldSyncFavorite
     us_shouldSyncHistory
     */
    char *sql_user_setting = "create table if not exists tab_usersettings ("
    "us_usid INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT DEFAULT 1,"
    "us_uid integer,"
    "us_updateTimeInterval double,"
    "us_shouldSyncHome integer,"
    "us_shouldSyncFavorite integer,"
    "us_shouldSyncHistory integer);";
    
    char *sql_favorite = "CREATE TABLE tab_favorite ("
    "fid INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT DEFAULT 1,"
    "fid_server INTEGER DEFAULT 0,"
    "uid INTEGER DEFAULT 0,"
    "title TEXT,"
    "link TEXT,"
    "time Double DEFAULT 0,"
    "data_type INTEGER DEFAULT 0,"
    "times INTEGER DEFAULT 1)";
    
    char *sql_sync_fail = "CREATE TABLE tab_sync_fail ("
    "sfid INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT DEFAULT 1,"
    "fid_server INTEGER DEFAULT 0,"
    "uid INTEGER DEFAULT 0,"
    "title TEXT,"
    "link TEXT,"
    "time Double DEFAULT 0,"
    "data_type INTEGER DEFAULT 0,"
    "action_type INTEGER DEFAULT 0,"
    "fids_server TEXT)";
    
    char *sql_skin = "CREATE TABLE tab_skin ("
    "sid INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT DEFAULT 1,"
    "stype INTEGER DEFAULT 0,"
    "name TEXT,"
    "thumb_path TEXT,"
    "image_path TEXT)";
     
    
    char * arrSql[] = {/*sql_white_list, */sql_user_setting, sql_favorite, sql_sync_fail, sql_skin};
    int nSql = sizeof(arrSql)/sizeof(char*);
    
    if (SQLITE_OK == sqlite3_open([GetDBPathWithName(DB_NAME) UTF8String], &db)) {
        for (int i=0; i<nSql; i++) {
            if (SQLITE_OK != sqlite3_exec(db, arrSql[i], NULL, NULL, &error)) break;
        }
    }
    
    if (error) sqlite3_free(error);
    if (db) sqlite3_close(db);
}

@end
