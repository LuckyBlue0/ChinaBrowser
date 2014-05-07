//
//  ModelFavorite.m
//  WKBrowser
//
//  Created by David on 13-10-24.
//  Copyright (c) 2013年 VeryApps. All rights reserved.
//

#import "ModelFavorite.h"

@implementation ModelFavorite

- (void)dealloc
{
    SAFE_RELEASE(_title);
    SAFE_RELEASE(_link);
}

+ (ModelFavorite *)modelFavorite
{
    return [[ModelFavorite alloc] init];
}

@end
