//
//  ModelUser.m
//  WKBrowser
//
//  Created by David on 13-10-18.
//  Copyright (c) 2013年 VeryApps. All rights reserved.
//

#import "ModelUser.h"

@implementation ModelUser

- (void)dealloc
{
    SAFE_RELEASE(_username);
    SAFE_RELEASE(_avatar);
    SAFE_RELEASE(_email);
    SAFE_RELEASE(_hash);
    SAFE_RELEASE(_pwd);
    
    SAFE_RELEASE(_nickname);
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:_uid forKey:@"_uid"];
    [aCoder encodeObject:_username forKey:@"_username"];
    [aCoder encodeObject:_avatar forKey:@"_avatar"];
    [aCoder encodeObject:_hash forKey:@"_hash"];
    [aCoder encodeObject:_email forKey:@"_email"];
    [aCoder encodeObject:_pwd forKey:@"_pwd"];
    
    [aCoder encodeObject:_nickname forKey:@"_nickname"];
    [aCoder encodeInteger:_autoCreate forKey:@"_autoCreate"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        self.uid = [aDecoder decodeIntegerForKey:@"_uid"];
        self.username = [aDecoder decodeObjectForKey:@"_username"];
        self.avatar = [aDecoder decodeObjectForKey:@"_avatar"];
        self.hash = [aDecoder decodeObjectForKey:@"_hash"];
        self.email = [aDecoder decodeObjectForKey:@"_email"];
        self.pwd = [aDecoder decodeObjectForKey:@"_pwd"];
        
        self.nickname = [aDecoder decodeObjectForKey:@"_nickname"];
        self.autoCreate = [aDecoder decodeIntegerForKey:@"_autoCreate"];
    }
    return self;
}

#pragma mark - 
+ (ModelUser *)modelUser
{
    ModelUser *model = [[ModelUser alloc] init];
    return model;
}

+ (ModelUser *)modelUserWithDictionary:(NSDictionary *)dictionary
{
    return [[ModelUser alloc] initWithDictionary:dictionary];
}

+ (ModelUser *)modelUserWithData:(NSData *)data
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (NSData *)modelUserToData
{
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    if (self) {
        id val = [dictionary objectForKey:@"id"];
        if (val) self.uid = [val integerValue];
        
        val = [dictionary objectForKey:@"hash"];
        if ([val isKindOfClass:[NSString class]]) self.hash = val;
        
        val = [dictionary objectForKey:@"username"];
        if ([val isKindOfClass:[NSString class]]) self.username = val;
        
        val = [dictionary objectForKey:@"avatar"];
        if ([val isKindOfClass:[NSString class]]) self.avatar = val;
        
        val = [dictionary objectForKey:@"email"];
        if ([val isKindOfClass:[NSString class]]) self.email = val;
        
        val = [dictionary objectForKey:@"nickname"];
        if ([val isKindOfClass:[NSString class]]) self.nickname = val;
        
        val = [dictionary objectForKey:@"auto_create"];
        if (val) self.autoCreate = [val integerValue];
    }
    return self;
}

@end
