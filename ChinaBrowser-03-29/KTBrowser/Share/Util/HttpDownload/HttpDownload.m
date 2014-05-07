//
//  HttpDownload.m
//  HttpDownload
//
//  Created by arBao on 4/24/13.
//  Copyright (c) 2013 arBao. All rights reserved.
//

#import "HttpDownload.h"

#import "ViewIndicator.h"

@implementation HttpDownload

- (void)dealloc {
    _delegate = nil;
    
    [_myPostRequest clearDelegatesAndCancel];
    _myPostRequest = nil;
}

- (void)downloadWithAsiFromUrl:(NSString *)url withLoadingWords:(NSString *)words {
    [self downloadWithAsiFromUrl:url];
    [ViewIndicator showLoadingWithStatus:words request:_myPostRequest];
}

-(void)downloadWithAsiFromUrl:(NSString *)url {
    _isFinished = NO;
    _mData = [[NSMutableData alloc] init];
    _myPostRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSString *path = [NSString stringWithFormat:@"%@/tmp/%@.json",NSHomeDirectory(),[url MD5Hash]];
    _myPostRequest.downloadDestinationPath = path;
    _myPostRequest.delegate = self;
    [_myPostRequest startAsynchronous];
}

- (void)postPicWithAsiFromUrl:(NSString *)url withArray:(NSArray *)array andFileKey:(NSString *)key {
    _isFinished=NO;
    _mData = [[NSMutableData alloc] init];
    _myPostRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSString *path=[NSString stringWithFormat:@"%@/tmp/%@.json",NSHomeDirectory(),[url MD5Hash]];
    _myPostRequest.downloadDestinationPath=path;
    
    _myPostRequest.delegate=self;
    [_myPostRequest setRequestMethod:@"POST"];
    
    for(int i = 0; i < array.count; i+=2) {
        id value = [array objectAtIndex:i];
        NSString *key = [array objectAtIndex:i + 1];
        [_myPostRequest setPostValue:value forKey:key];
    }
    
    NSString *filename = [@"temp" fileNameMD5WithExtension:@"png"];
    NSString *filepath = [GetCacheDir() stringByAppendingPathComponent:filename];
    [_myPostRequest setFile:filepath forKey:key];

    [_myPostRequest startAsynchronous];

}

- (void)postPicWithTimeStramp:(NSString *)url withArray:(NSArray *)array andFileKey:(NSString *)key withPicArray:(NSArray *)picArray {
    _isFinished=NO;
    _mData=[[NSMutableData alloc] init];
    _myPostRequest=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSString *path=[NSString stringWithFormat:@"%@/tmp/%@.json",NSHomeDirectory(),[url MD5Hash]];
    _myPostRequest.downloadDestinationPath=path;
    
    _myPostRequest.delegate=self;
    _myPostRequest.timeOutSeconds = 30;
    [_myPostRequest setRequestMethod:@"POST"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for(int i = 0; i < array.count; i+=2) {
        id value = [array objectAtIndex:i];
        NSString *key = [array objectAtIndex:i + 1];
        [_myPostRequest setPostValue:value forKey:key];
        [dic setValue:value forKey:key];
    }
    
    for(int i = 0;i < picArray.count ; i++) {
        [_myPostRequest addData:UIImageJPEGRepresentation((UIImage *)[picArray objectAtIndex:i], 1) forKey:[NSString stringWithFormat:@"%@[%d]",key,i]];
    }
    
    NSString *timestamp = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    [_myPostRequest setPostValue:timestamp forKey:@"timestamp"];
    [dic setValue:timestamp forKey:@"timestamp"];
    
    NSString *sign = [NSString signWithParams:dic];
    
    [_myPostRequest setPostValue:sign forKey:@"sign"];
    [_myPostRequest setUploadProgressDelegate:self];
    [_myPostRequest startAsynchronous];
}

- (void)setProgress:(float)newProgress {
    NSString *strProgress = [NSString stringWithFormat:@"上传进度: %d%%",(int)(newProgress * 100)];
    [ViewIndicator showProgressWithStatus:strProgress request:_myPostRequest];
}

- (void)postWithAsiNoTimeStrampFromUrl:(NSString *)url withArray:(NSArray *)array {
    _isFinished=NO;
    _mData=[[NSMutableData alloc] init];
    _myPostRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSString *path=[NSString stringWithFormat:@"%@/tmp/%@.json",NSHomeDirectory(),[url MD5Hash]];
    _myPostRequest.downloadDestinationPath=path;
    
    _myPostRequest.delegate=self;
    [_myPostRequest setRequestMethod:@"POST"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for(int i = 0; i < array.count; i+=2) {
        NSString *value = [array objectAtIndex:i];
        NSString *key = [array objectAtIndex:i + 1];
        [_myPostRequest setPostValue:value forKey:key];
        [dic setValue:value forKey:key];
    }
    
    NSString *sign = [NSString signWithParams:dic];
    
    [_myPostRequest setPostValue:sign forKey:@"sign"];
    
    [_myPostRequest startAsynchronous];
}

- (void)postWithAsiFromUrl:(NSString *)url withArray:(NSArray *)array {
    _isFinished=NO;
    _mData=[[NSMutableData alloc] init];
    _myPostRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSString *path=[NSString stringWithFormat:@"%@/tmp/%@.json",NSHomeDirectory(),[url MD5Hash]];
    _myPostRequest.downloadDestinationPath=path;
    
    _myPostRequest.delegate=self;
    [_myPostRequest setRequestMethod:@"POST"];
  
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for(int i = 0; i < array.count; i+=2) {
        NSString *value = [array objectAtIndex:i];
        NSString *key = [array objectAtIndex:i + 1];
        [_myPostRequest setPostValue:value forKey:key];
        [dic setValue:value forKey:key];
    }
    NSString *timestamp = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    [_myPostRequest setPostValue:timestamp forKey:@"timestamp"];
    [dic setValue:timestamp forKey:@"timestamp"];
 
    
    NSString *sign = [NSString signWithParams:dic];
    
    [_myPostRequest setPostValue:sign forKey:@"sign"];
    
    [_myPostRequest startAsynchronous];
}

-(void)requestFailed:(ASIHTTPRequest *)request {
    _DEBUG_LOG(@"failed  %@",request.error.localizedDescription);
    _isFinished = YES;
    
    if([self.delegate respondsToSelector:@selector(downloadFailed:)]) {
        NSFileManager *fm=[NSFileManager defaultManager];
        BOOL res=[fm fileExistsAtPath:request.downloadDestinationPath];
        if(res) {
            [_mData appendData:[NSData dataWithContentsOfFile:request.downloadDestinationPath]];
            _DEBUG_LOG(@"%@",request.downloadDestinationPath);
        }
        else {
            _DEBUG_LOG(@"缓存未初始化");
        }
        [self.delegate downloadFailed:self];
    }
    else {
        _DEBUG_LOG(@"下载失败!!but--->>   代理回掉失败方法失效！检查hd.delegate=self;写上了没有");
    }  
}

-(void)requestFinished:(ASIHTTPRequest *)request {
    _DEBUG_LOG(@"httpdownload finished");
    
    _isFinished=YES;
    
    [_mData appendData:[NSData dataWithContentsOfFile:request.downloadDestinationPath]];
    
    if([self.delegate respondsToSelector:@selector(downloadCompelete:)]) {
        [self.delegate downloadCompelete:self];
    }
    else {
        _DEBUG_LOG(@"下载完成!!but--->>  代理回掉失败方法失效！检查hd.delegate=self;写上了没有");
        
        _DEBUG_LOG(@"self delegate%@",self.delegate);
    }
}

@end














