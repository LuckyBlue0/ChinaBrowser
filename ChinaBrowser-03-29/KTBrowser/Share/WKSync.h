//
//  WKSync.h
//  WKBrowser
//
//  Created by David on 13-10-19.
//  Copyright (c) 2013年 VeryApps. All rights reserved.
/*
 1、同步添加操作
 2、同步删除操作
 3、同步批量删除操作
 4、同步清除历史
 5、
 */

#import <Foundation/Foundation.h>

#import "ModelUserSettings.h"
#import "ModelUser.h"

@class ASIFormDataRequest;
@class ASINetworkQueue;

typedef void (^WKSyncBlocSyncFailComplited) (void);
typedef void (^WKSyncBlock) (void);

@interface WKSync : NSObject
{
    ASINetworkQueue *_asiQueueCurr;
    
    ASINetworkQueue *_asiQueueHome;
    ASINetworkQueue *_asiQueueFavorite;
    ASINetworkQueue *_asiQueueHistory;
    
    WKSyncBlocSyncFailComplited _blockSyncFailComplitedHome;
    WKSyncBlocSyncFailComplited _blockSyncFailComplitedFavorite;
    WKSyncBlocSyncFailComplited _blockSyncFailComplitedHistory;
    
    WKSyncBlock _blockSyncHome;
    WKSyncBlock _blockSyncFavorite;
    WKSyncBlock _blockSyncHistory;
}

@property (nonatomic, strong) ModelUser *modelUser;
@property (nonatomic, strong) ModelUserSettings *modelUserSettings;


+ (WKSync *)shareWKSync;

// 添加数据
- (void)syncAddWithDataType:(WKSyncDataType)type title:(NSString *)title link:(NSString *)link;
// 删除数据
- (void)syncDelWithDataType:(WKSyncDataType)type fid_server:(NSInteger)fid_server;
// 批量删除数据
- (void)syncDelWithDataType:(WKSyncDataType)type fids_server:(NSString *)fids_server;
// 清除历史记录
- (void)syncDelAllHistory;
// 更新
- (void)syncUpdateTime:(NSTimeInterval)time fid_server:(NSInteger)fid_server;

/*
 ------ 同步某类数据
 1、提交上次失败的操作
 2、下载最新的数据，更新到本地
 */
- (void)syncWithDataType:(WKSyncDataType)dataType;
- (void)syncWithDataType:(WKSyncDataType)dataType block:(WKSyncBlock)block;
- (void)stopSyncWithDataType:(WKSyncDataType)dataType;

- (void)syncAll;
- (void)stopSyncAll;

// ------ 1、提交上次失败的操作
- (void)syncUploadSyncFailWithDataType:(WKSyncDataType)dataType block:(WKSyncBlocSyncFailComplited)block;
// ------ 2、下载最新的数据，更新到本地
- (void)syncQueryWithDataType:(WKSyncDataType)dataType page:(NSUInteger)page;


@end
