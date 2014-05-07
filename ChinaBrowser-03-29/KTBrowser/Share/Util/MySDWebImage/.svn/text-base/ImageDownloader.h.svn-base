//
//  ImageDownloader.h
//  MySDWebImage
//
//  Created by arBao on 7/30/13.
//  Copyright (c) 2013 arBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@protocol ImageDownloaderDelegate;

@interface ImageDownloader : NSObject<ASIHTTPRequestDelegate>
{
    ASIHTTPRequest *_request;
    
    
}



@property (nonatomic,weak)id <ImageDownloaderDelegate>delegate;
@property (nonatomic,assign)int retryTimes;
@property  (nonatomic,strong) NSMutableData *mdata;

- (void)downloaderWithURL:(NSString *)url delegate:(id<ImageDownloaderDelegate>)delegate;

- (void)cancel;

@end

@protocol ImageDownloaderDelegate <NSObject>

- (void)downloadFinish:(ImageDownloader *)downloader;
- (void)downloadFailed:(ImageDownloader *)downloader;

@end
