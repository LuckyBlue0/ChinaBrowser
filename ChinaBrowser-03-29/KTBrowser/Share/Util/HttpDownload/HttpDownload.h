//
//  HttpDownload.h
//  HttpDownload
//
//  Created by arBao on 4/24/13.
//  Copyright (c) 2013 arBao. All rights reserved.
//

@protocol HttpDownloadDelegate ;

#import <Foundation/Foundation.h>

#import "ASIFormDataRequest.h"
#import "CJSONSerializer.h"

#import "NSString+Hashing.h"

#import "VARequest.h"

@interface HttpDownload : NSObject <ASIHTTPRequestDelegate, ASIProgressDelegate> {
    NSMutableData *_mData;
}

@property (nonatomic,weak)id<HttpDownloadDelegate>delegate;
@property (nonatomic,strong)NSMutableData *mData;
@property (nonatomic,assign)BOOL isFinished;
@property (nonatomic,assign)NSInteger TagOfType;
@property (nonatomic,strong) ASIFormDataRequest *myPostRequest;
@property (nonatomic,assign) int indexRow;

- (void)postPicWithAsiFromUrl:(NSString *)url withArray:(NSArray *)array andFileKey:(NSString *)key;

- (void)postWithAsiFromUrl:(NSString *)url withArray:(NSArray *)array;

- (void)postWithAsiNoTimeStrampFromUrl:(NSString *)url withArray:(NSArray *)array;

-(void)downloadWithAsiFromUrl:(NSString *)url withLoadingWords:(NSString *)words;

-(void)downloadWithAsiFromUrl:(NSString *)url;

- (void)postPicWithTimeStramp:(NSString *)url withArray:(NSArray *)array andFileKey:(NSString *)key withPicArray:(NSArray *)picArray;


-(void)requestFailed:(ASIHTTPRequest *)request;

@end

@protocol HttpDownloadDelegate <NSObject>

@required
-(void)downloadCompelete:(HttpDownload *)httpDownload;

@optional
-(void)downloadFailed:(HttpDownload *)httpDownload;

@end