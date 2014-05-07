//
//  MYSDWebImageManager.h
//  MySDWebImage
//
//  Created by arBao on 7/30/13.
//  Copyright (c) 2013 arBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageDownloader.h"
#import "MYSDImageMemCache.h"

@protocol MYSDWebImageManagerDelegate;

typedef enum
{
    typeOfNormal = 1098,
    typeOfSizeAndCorners,
    typeOfCircle,
}TypeOfDownloadPic;

@interface MYSDWebImageManager : NSObject<ImageDownloaderDelegate>
{
    NSMutableArray *_arrUrls;
    NSMutableArray *_arrDownloaders;
    NSMutableArray *_arrCacheDelegate;
    NSMutableArray *_arrInfo;
    NSMutableArray *_arrDownloadIdentifers;
    
    
}

- (NSString *)getImagePathWithUrl:(NSString *)url;

- (UIImage *)getImageWithUrl:(NSString *)url;

+ (MYSDWebImageManager *)shareMYSDWebImageManager;

-(void)setImageWithUrl:(NSString *)url Delegate:(id<MYSDWebImageManagerDelegate>)onedelegate withInfo:(NSDictionary *)dicInfo;
- (void)cancelForDelegate:(id<MYSDWebImageManagerDelegate>)delegate;

@end

@protocol MYSDWebImageManagerDelegate <NSObject>

@optional

- (void)mywebImageManager:(MYSDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image withAnimation:(BOOL)yesOrNo;
- (void)mywebImageManager:(MYSDWebImageManager *)imageManager didFailWithError:(NSError *)error;


@end