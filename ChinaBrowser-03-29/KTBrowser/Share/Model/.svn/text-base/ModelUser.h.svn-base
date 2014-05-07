//
//  ModelUser.h
//  WKBrowser
//
//  Created by David on 13-10-18.
//  Copyright (c) 2013年 VeryApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelUser : NSObject <NSCoding>

@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, strong) NSString *hash;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *avatar;

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *pwd;

@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, assign) NSInteger autoCreate;

+ (ModelUser *)modelUser;
+ (ModelUser *)modelUserWithDictionary:(NSDictionary *)dictionary;

+ (ModelUser *)modelUserWithData:(NSData *)data;
- (NSData *)modelUserToData;
- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
