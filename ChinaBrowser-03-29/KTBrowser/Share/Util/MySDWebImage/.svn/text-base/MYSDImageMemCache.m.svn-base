//
//  MYSDImageMemCache.m
//  MengChongZhi
//
//  Created by arBao on 8/2/13.
//  Copyright (c) 2013 arBao. All rights reserved.
//

#import "MYSDImageMemCache.h"
//static NSInteger cacheMaxCacheAge = 60*60*24*7;// a week
static MYSDImageMemCache *_memCache;

@implementation MYSDImageMemCache

- (void)dealloc {
    _arrMemCache = nil;
    _arrPathCache = nil;
}

+ (MYSDImageMemCache *)shareImageMemCache {
    if(_memCache == nil) {
        _memCache = [[MYSDImageMemCache alloc] init];
    }
    
    return _memCache;
}

- (void)cleanAllMemCache {
    [_arrMemCache removeAllObjects];
    [_arrPathCache removeAllObjects];
}

- (id)init {
    if(self = [super init]) {
        _arrMemCache = [[NSMutableArray alloc] init];
        _arrPathCache = [[NSMutableArray alloc] init];
        
        
    }
    
    return self;
}

- (UIImage *)getWebCacheWithPath:(NSString *)path; {
    
    UIImage *image = nil;
    
    NSString *pathMD5 = [path MD5Hash];
    
    if([_arrPathCache containsObject:pathMD5]) {
        int index = [_arrPathCache indexOfObject:pathMD5];
        image = [_arrMemCache objectAtIndex:index];
    }
    else {
        NSFileManager *fm = [NSFileManager defaultManager];
        if([fm fileExistsAtPath:path]) {
//            NSData *data=[NSData dataWithContentsOfFile:path];
            UIImage *imageCache=[UIImage imageWithContentsOfFile:path];
            image = imageCache;
            if(image)
            [self storeWebCacheWithPath:path andImage:imageCache];
        }
        else {
            
        }
    }
    
    return image;
}

- (void)storeWebCacheWithPath:(NSString *)path andImage:(UIImage *)image {
    NSString *pathMD5 = [path MD5Hash];
    if(![_arrPathCache containsObject:pathMD5]) {
        [_arrPathCache addObject:pathMD5];
        [_arrMemCache addObject:image];
    }
}

@end
