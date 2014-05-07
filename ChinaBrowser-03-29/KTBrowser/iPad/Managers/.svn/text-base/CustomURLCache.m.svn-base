//
//  CustomURLCache.m
//  LocalCache
//
//  Created by tan on 13-2-12.
//  Copyright (c) 2013年 adways. All rights reserved.
//

#import "CustomURLCache.h"

@interface CustomURLCache (private)

- (NSString *)cacheFolder;
- (NSString *)cacheFilePath:(NSString *)file;
- (NSString *)cacheRequestFileName:(NSString *)requestUrl;
- (NSString *)cacheRequestOtherInfoFileName:(NSString *)requestUrl;
- (NSCachedURLResponse *)dataFromRequest:(NSURLRequest *)request;
- (void)deleteCacheFolder;

@end

static NSData *_blankImgData = nil;
static NSCachedURLResponse *_blankImgResponse = nil;

@implementation CustomURLCache

@synthesize cacheTime = _cacheTime;
@synthesize diskPath = _diskPath;
@synthesize responseDictionary = _responseDictionary;

/**
 * 无图模式的空白图片
 */
- (NSData *)blankImgData {
    if (!_blankImgData) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"img_blank" ofType:@"png"];
        _blankImgData = [NSData dataWithContentsOfFile:path];
    }
    
    return _blankImgData;
}

- (NSCachedURLResponse *)blankImgResponse {
    if (!_blankImgResponse) {
        if ([self blankImgData].length > 0) {
            _blankImgResponse = [[NSCachedURLResponse alloc] initWithResponse:[[NSURLResponse alloc] init] data:_blankImgData];
        }
    }
    
    return _blankImgResponse;
}

- (id)initWithMemoryCapacity:(NSUInteger)memoryCapacity diskCapacity:(NSUInteger)diskCapacity diskPath:(NSString *)path cacheTime:(NSInteger)cacheTime {
    if (self = [super initWithMemoryCapacity:memoryCapacity diskCapacity:diskCapacity diskPath:path]) {
        self.cacheTime = cacheTime;
        if (path)
            self.diskPath = path;
        else
            self.diskPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        
        self.responseDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    
    return self;
}

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request {
    if ([request.HTTPMethod compare:@"GET"] != NSOrderedSame) {
        return [super cachedResponseForRequest:request];
    }
    
    // 启用无图模式
    if ([AppManager noImgMode]) {
        NSString *extension = [request.URL.path pathExtension];
        NSArray *arrImgTypes = [NSArray arrayWithObjects:@"jpg", @"gif", @"png", @"bmp", nil];
        if ([arrImgTypes containsObject:extension]) {
            return [self blankImgResponse];
        }
    }
    
    return [self dataFromRequest:request];
}

- (void)removeAllCachedResponses {
    [super removeAllCachedResponses];
    
    [self setDiskCapacity:0];
    [self setMemoryCapacity:0];
    
    [self deleteCacheFolder];
}

- (void)removeCachedResponseForRequest:(NSURLRequest *)request {
    [super removeCachedResponseForRequest:request];
    
    NSString *url = request.URL.absoluteString;
    NSString *fileName = [self cacheRequestFileName:url];
    NSString *otherInfoFileName = [self cacheRequestOtherInfoFileName:url];
    NSString *filePath = [self cacheFilePath:fileName];
    NSString *otherInfoPath = [self cacheFilePath:otherInfoFileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filePath error:nil];
    [fileManager removeItemAtPath:otherInfoPath error:nil];
}

#pragma mark - custom url cache
- (NSString *)cacheFolder {
    return @"urlCache";
}

- (void)deleteCacheFolder {
    NSString *path = [NSString stringWithFormat:@"%@/%@", self.diskPath, [self cacheFolder]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:path error:nil];
}

- (NSString *)cacheFilePath:(NSString *)file {
    NSString *path = [NSString stringWithFormat:@"%@/%@", self.diskPath, [self cacheFolder]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if ([fileManager fileExistsAtPath:path isDirectory:&isDir] && isDir) {
    }
    else {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [NSString stringWithFormat:@"%@/%@", path, file];
}

- (NSString *)cacheRequestFileName:(NSString *)requestUrl {
    return [requestUrl md5];
}

- (NSString *)cacheRequestOtherInfoFileName:(NSString *)requestUrl {
    return [[NSString stringWithFormat:@"%@-otherInfo", requestUrl] md5];
}

- (NSCachedURLResponse *)dataFromRequest:(NSURLRequest *)request {
    NSString *url = request.URL.absoluteString;
    NSString *fileName = [self cacheRequestFileName:url];
    NSString *otherInfoFileName = [self cacheRequestOtherInfoFileName:url];
    NSString *filePath = [self cacheFilePath:fileName];
    NSString *otherInfoPath = [self cacheFilePath:otherInfoFileName];
    NSDate *date = [NSDate date];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSDictionary *otherInfo = [NSDictionary dictionaryWithContentsOfFile:otherInfoPath];
        BOOL expire = false;

        if (self.cacheTime > 0) {
            NSInteger createTime = [[otherInfo objectForKey:@"time"] intValue];
            if (createTime + self.cacheTime < [date timeIntervalSince1970]) {
                expire = true;
            }
        }
        
        if (expire == false) {
            NSLog(@"data from cache ...");
            
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            NSURLResponse *response = [[NSURLResponse alloc] initWithURL:request.URL
                                                                MIMEType:[otherInfo objectForKey:@"MIMEType"]
                                                   expectedContentLength:data.length
                                                        textEncodingName:[otherInfo objectForKey:@"textEncodingName"]];
            if (data.length > 0) {
                return [[NSCachedURLResponse alloc] initWithResponse:response data:data];
            }
        }
        else {
            NSLog(@"cache expire ... ");
            
            [fileManager removeItemAtPath:filePath error:nil];
            [fileManager removeItemAtPath:otherInfoPath error:nil];
        }
    }

    __block NSCachedURLResponse *cachedResponse = nil;
    // sendSynchronousRequest请求也要经过NSURLCache
    id boolExsite = [self.responseDictionary objectForKey:url];
    if (boolExsite == nil) {
        [self.responseDictionary setValue:[NSNumber numberWithBool:TRUE] forKey:url];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:[[NSOperationQueue alloc] init]
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
             [self.responseDictionary removeObjectForKey:url];
             
            if (error) {
                cachedResponse = nil;
                NSLog(@"---error : %@", error);
            }
            else if (data.length > 0) {
                NSLog(@"---save cache: %@", request.URL.absoluteString);

                // 启用无图模式
                if ([AppManager noImgMode]) {
                    NSArray *arrMIMETypes = [NSArray arrayWithObjects:@"image/jpeg", @"image/pjpeg", @"image/gif", @"image/png", @"image/bmp", @"image/x-windows-bmp", nil];
                    if ([arrMIMETypes containsObject:response.MIMEType]) {
                        data = [self blankImgData];
                    }
                }
                
                // save to cache
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f", [date timeIntervalSince1970]], @"time",
                                                                                   response.MIMEType, @"MIMEType",
                                                                                   response.textEncodingName, @"textEncodingName", nil];
                [dict writeToFile:otherInfoPath atomically:YES];
                [data writeToFile:filePath atomically:YES];

                cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data];
           }
         }];
        });
        
        return cachedResponse;
    }
    
    return nil;
}

@end
