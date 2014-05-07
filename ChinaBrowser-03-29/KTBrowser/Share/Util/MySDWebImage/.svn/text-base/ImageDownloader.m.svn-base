//
//  ImageDownloader.m
//  MySDWebImage
//
//  Created by arBao on 7/30/13.
//  Copyright (c) 2013 arBao. All rights reserved.
//



#import "ImageDownloader.h"
#import "NSString+Hashing.h"
#import "MYSDWebImageCommon.h"

@implementation ImageDownloader

- (void)dealloc
{
    [_request clearDelegatesAndCancel];
    _request = nil;
    
    _delegate = nil;
}

- (id)init {
    if(self = [super init]) {
        _retryTimes = MAX_Retry_Times;
    }
    
    return self;
}

- (void)cancel {
    [_request clearDelegatesAndCancel];
}

- (void)downloaderWithURL:(NSString *)url delegate:(id<ImageDownloaderDelegate>)delegate {
    _mdata = [[NSMutableData alloc] init];
    NSURL *URL = [NSURL URLWithString:url];
    _request = [ASIHTTPRequest requestWithURL:URL];
    _request.delegate = self;
    _request.timeOutSeconds = 15;
//    NSString *path = DiskPath;
//    _request.downloadDestinationPath=path;
    [_request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    if([_delegate respondsToSelector:@selector(downloadFinish:)]) {
        NSString *url = [request.url absoluteString];
        [_mdata appendData:request.responseData];
        [_mdata writeToFile:DiskPath atomically:YES];
        [_delegate downloadFinish:self];
    }
    else {
        
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    
    if([_delegate respondsToSelector:@selector(downloadFailed:)]) {
        [_delegate downloadFailed:self];
    }
}

@end
