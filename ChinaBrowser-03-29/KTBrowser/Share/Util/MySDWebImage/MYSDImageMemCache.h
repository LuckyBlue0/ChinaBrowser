//
//  MYSDImageMemCache.h
//  MengChongZhi
//
//  Created by arBao on 8/2/13.
//  Copyright (c) 2013 arBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYSDWebImageCommon.h"

@interface MYSDImageMemCache : NSObject
{
    NSMutableArray *_arrMemCache;
    NSMutableArray *_arrPathCache;
}

+ (MYSDImageMemCache *)shareImageMemCache;

- (UIImage *)getWebCacheWithPath:(NSString *)path;

- (void)storeWebCacheWithPath:(NSString *)path andImage:(UIImage *)image;

- (void)cleanAllMemCache;
@end

