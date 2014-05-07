//
//  MYSDWebImageManager.m
//  MySDWebImage
//
//  Created by arBao on 7/30/13.
//  Copyright (c) 2013 arBao. All rights reserved.
//

#import "MYSDWebImageManager.h"

#import "MYSDWebImageCommon.h"
#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"
#import "UIImage+circleImage.h"

static MYSDWebImageManager *_manager;

@implementation MYSDWebImageManager

#pragma mark init
- (id)init {
    if(self = [super init]) {
        _arrDownloaders = [[NSMutableArray alloc] init];
        _arrUrls = [[NSMutableArray alloc] init];
        _arrCacheDelegate = [[NSMutableArray alloc] init];
        _arrInfo = [[NSMutableArray alloc] init];
        _arrDownloadIdentifers = [[NSMutableArray alloc] init];
    }
    
    return self;
}

+ (MYSDWebImageManager *)shareMYSDWebImageManager
{
    if(_manager == nil) {
        _manager = [[MYSDWebImageManager alloc] init];
    }
    return _manager;
}


#pragma mark methods

- (NSString *)getImagePathWithUrl:(NSString *)url
{
    NSString *path = DiskPath;
    return path;
}

- (UIImage *)getImageWithUrl:(NSString *)url
{
    return nil;
}

- (void)setImageWithUrl:(NSString *)url Delegate:(id<MYSDWebImageManagerDelegate>)onedelegate withInfo:(NSDictionary *)dicInfo
{
//    NSLog(@"dicInfo %p",dicInfo);
    NSString *path = DiskPath;
    TypeOfDownloadPic type = [[dicInfo objectForKey:@"type"] intValue];
    
    if(type == typeOfCircle) {
        path = [NSString stringWithFormat:@"%@_circle",path];
    }
    
    MYSDImageMemCache *memCache = [MYSDImageMemCache shareImageMemCache];
    UIImage *imageCache = [memCache getWebCacheWithPath:path];
    if(imageCache) {
        [onedelegate mywebImageManager:self didFinishWithImage:imageCache withAnimation:NO];
        return;
    }
    else
    {
        if([_arrDownloadIdentifers containsObject:[NSString stringWithFormat:@"%p%@",onedelegate,url]]) {
            
        }
        else {
//            NSLog(@"no imageCache and no containsObject");
            ImageDownloader *downloader = [[ImageDownloader alloc] init];
            downloader.delegate = self;
            [downloader downloaderWithURL:url delegate:self];
            [_arrCacheDelegate addObject:onedelegate];
            [_arrUrls addObject:url?url:@""];
            [_arrDownloaders addObject:downloader];
            [_arrInfo addObject:dicInfo];
            [_arrDownloadIdentifers addObject:[NSString stringWithFormat:@"%p%@",onedelegate,url?url:@""]];
        }
    }
}

#pragma mark download complete

- (void)downloadFailed:(ImageDownloader *)downloader
{
    int index = [_arrDownloaders indexOfObject:downloader];
    if(downloader.retryTimes != 0) {
        NSString *url = [_arrUrls objectAtIndex:index];
        [downloader downloaderWithURL:url delegate:self];
        downloader.retryTimes --;
    }
    else
    {
        [_arrCacheDelegate removeObjectAtIndex:index];
        [_arrDownloaders removeObjectAtIndex:index];
        [_arrUrls removeObjectAtIndex:index];
        [_arrInfo removeObjectAtIndex:index];
        [_arrDownloadIdentifers removeObjectAtIndex:index];
    }
    
}

- (void)downloadFinish:(ImageDownloader *)downloader
{
    int index = [_arrDownloaders indexOfObject:downloader];
    
    id <MYSDWebImageManagerDelegate> delegate = [_arrCacheDelegate objectAtIndex:index];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *url = [_arrUrls objectAtIndex:index];
    NSString *path = DiskPath;
    if([fm fileExistsAtPath:path]) {
//        NSData *data=[NSData dataWithContentsOfFile:path];
                
//        UIImage *image=[UIImage imageWithContentsOfFile:path];
        UIImage *image = [UIImage imageWithData:downloader.mdata];
        
        NSDictionary *dic = [_arrInfo objectAtIndex:index];
        TypeOfDownloadPic type = [[dic objectForKey:@"type"] intValue];
        if(type == typeOfNormal) {
            
        }
        else if (type == typeOfSizeAndCorners) {

            int width = [[dic objectForKey:@"width"] intValue];
            int height = [[dic objectForKey:@"height"] intValue];
            int corners = [[dic objectForKey:@"corners"] intValue];
            
            image = [image resizedImage:CGSizeMake(width, height) interpolationQuality:1];
            image = [image roundedCornerImage:corners borderSize:0];
            
            NSData *data = UIImagePNGRepresentation(image);
            [data writeToFile:path atomically:NO];
        }
        else if (type == typeOfCircle) {
            image = [UIImage circleImage:image];
            NSData *data = UIImagePNGRepresentation(image);
            path = [NSString stringWithFormat:@"%@_circle",path];
            [data writeToFile:path atomically:NO];
        }
        
        MYSDImageMemCache *memCache = [MYSDImageMemCache shareImageMemCache];
//        NSLog(@"%p",image);
        if(image)
            [memCache storeWebCacheWithPath:path andImage:image];
        
        NSMutableArray *arrTmp = [NSMutableArray array];
        for(int i=0; i<_arrCacheDelegate.count; i++) {
            id<MYSDWebImageManagerDelegate> delegateTmp = [_arrCacheDelegate objectAtIndex:i];
            if(delegateTmp == delegate)
                [arrTmp addObject:[NSNumber numberWithInt:i]];
        }
        
        if([[arrTmp lastObject] intValue] == index) {
            
            if([delegate respondsToSelector:@selector(mywebImageManager:didFinishWithImage:withAnimation:)]) {
                [delegate mywebImageManager:self didFinishWithImage:image withAnimation:YES];
                
            }
        }
        
        
        
        
    }
    else
    {
        NSLog(@"图片没有保存成功");
    }
   
    [_arrCacheDelegate removeObjectAtIndex:index];
    [_arrDownloaders removeObjectAtIndex:index];
    [_arrUrls removeObjectAtIndex:index];
    [_arrInfo removeObjectAtIndex:index];
    [_arrDownloadIdentifers removeObjectAtIndex:index];
}

- (void)cancelForDelegate:(id<MYSDWebImageManagerDelegate>)delegate
{
    NSUInteger idx;
    while ((idx = [_arrCacheDelegate indexOfObjectIdenticalTo:delegate])!=NSNotFound) {
//        NSLog(@"cancel");
        [_arrCacheDelegate removeObjectAtIndex:idx];
        
        ImageDownloader *downLoader = [_arrDownloaders objectAtIndex:idx];
        [downLoader cancel];
        
        [_arrDownloaders removeObjectAtIndex:idx];
        [_arrUrls removeObjectAtIndex:idx];
        [_arrInfo removeObjectAtIndex:idx];
        [_arrDownloadIdentifers removeObjectAtIndex:idx];
    }
    
    
    
}


@end



















