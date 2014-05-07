//
//  ADOSkin.h
//  ChinaBrowser
//
//  Created by David on 14-3-17.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sqlite3.h>

#import "ModelSkin.h"

@interface ADOSkin : NSObject

+ (BOOL)isExistWithImagePath:(NSString *)imagePath type:(SkinType)type;

+ (NSInteger)addModel:(ModelSkin *)model;

+ (BOOL)deleteWithSid:(NSInteger)sid;
+ (BOOL)deleteAll;

+ (NSArray *)queryAll;
+ (NSArray *)queryWithType:(SkinType)type;

@end
