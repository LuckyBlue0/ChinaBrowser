//
//  WKSync.m
//  WKBrowser
//
//  Created by David on 13-10-19.
//  Copyright (c) 2013年 VeryApps. All rights reserved.
/*
 启动app
 1、提交失败的操作
 2、同步最新的数据下来
 */

#import "WKSync.h"

#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"

#import "ModelSyncFail.h"
#import "ADOSyncFail.h"
#import "ADOUserSettings.h"

#import "CJSONDeserializer.h"

#import "ADOFavorite.h"

#import "ViewIndicator.h"

typedef NS_ENUM(NSInteger, WKSyncType) {
    WKSyncTypeUpload,
    WKSyncTypeQuery
};

static WKSync *wkSync;


@interface WKSync ()

// 首次同步到网络失败，需要记录下来，下次同步
- (void)asiDidCurrFailRequest:(ASIHTTPRequest *)req;
- (void)asiDidCurrFinishRequest:(ASIHTTPRequest *)req;

// 提交上次同步失败的操作，成功后从失败列表数据库中删除
- (void)asiDidSyncFinishRequest:(ASIHTTPRequest *)req;
- (void)asiDidSyncFinishQueue:(ASINetworkQueue *)queue;

- (NSString *)dataTypeToString:(WKSyncDataType)dataType;
- (WKSyncDataType)dataTypeFromString:(NSString *)string;

@end

@implementation WKSync
{
    NSMutableArray *_arrFidServerHome;
    NSMutableArray *_arrFidServerFav;
    NSMutableArray *_arrFidServerHistory;
}

- (void)dealloc
{
    SAFE_RELEASE(_modelUserSettings);
    SAFE_RELEASE(_modelUser);
    
    [_asiQueueCurr reset];
    SAFE_RELEASE(_asiQueueCurr);
}

- (id)init
{
    self = [super init];
    if (self) {
        _asiQueueCurr = [[ASINetworkQueue alloc] init];
        [_asiQueueCurr reset];
        
        _asiQueueCurr.delegate = self;
        [_asiQueueCurr setShouldCancelAllRequestsOnFailure:NO];
        [_asiQueueCurr setRequestDidFailSelector:@selector(asiDidCurrFailRequest:)];
        [_asiQueueCurr setRequestDidFinishSelector:@selector(asiDidCurrFinishRequest:)];
        [_asiQueueCurr go];
    }
    return self;
}

+ (WKSync *)shareWKSync
{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wkSync = [[WKSync alloc] init];
    });
    return wkSync;
}

// 添加数据：home/favorite/history
- (void)syncAddWithDataType:(WKSyncDataType)type title:(NSString *)title link:(NSString *)link
{
    if (!_modelUser) return;
    
    if (type==WKSyncDataTypeFavorite && !_modelUserSettings.shouldSyncFavorite) {
        ModelSyncFail *model = [ModelSyncFail modelSyncFail];
        model.uid = _modelUser.uid;
        model.title = title;
        model.link = link;
        model.actionType = WKSyncActionTypeAdd;
        model.dataType = type;
        model.time = [[NSDate date] timeIntervalSince1970];
        [ADOSyncFail addModel:model];
        return;
    }
    if (type==WKSyncDataTypeHistory && !_modelUserSettings.shouldSyncHistory) {
        ModelSyncFail *model = [ModelSyncFail modelSyncFail];
        model.uid = _modelUser.uid;
        model.title = title;
        model.link = link;
        model.actionType = WKSyncActionTypeAdd;
        model.dataType = type;
        model.time = [[NSDate date] timeIntervalSince1970];
        [ADOSyncFail addModel:model];
        return;
    }
    if (type==WKSyncDataTypeHome && !_modelUserSettings.shouldSyncHome) {
        if (kShouldShowLocalHome) {
            ModelSyncFail *model = [ModelSyncFail modelSyncFail];
            model.uid = _modelUser.uid;
            model.title = title;
            model.link = link;
            model.actionType = WKSyncActionTypeAdd;
            model.dataType = type;
            model.time = [[NSDate date] timeIntervalSince1970];
            [ADOSyncFail addModel:model];
        }
        return;
    }
    
    ASIFormDataRequest *req = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:API_Favorite]];
    req.timeOutSeconds = 10;
    
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     API_AppName, @"app",
                                     @"add", @"ac",
                                     [NSNumber numberWithLongLong:_modelUserSettings.uid], @"uid",
                                     _modelUser.hash, @"hash",
                                     title, @"title",
                                     [link urlEncode], @"link",
                                     [self dataTypeToString:type], @"type",
                                     [NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]], @"time",
                                     nil];
    [dicParam enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [req setPostValue:obj forKey:key];
    }];
    [dicParam setObject:[NSNumber numberWithInteger:WKSyncActionTypeAdd] forKey:@"action_type"];
    req.userInfo = dicParam;
    [_asiQueueCurr addOperation:req];
}

// 删除
- (void)syncDelWithDataType:(WKSyncDataType)type fid_server:(NSInteger)fid_server
{
    if (!_modelUser || fid_server<=0) return;
    
    if (type==WKSyncDataTypeFavorite && !_modelUserSettings.shouldSyncFavorite) {
        ModelSyncFail *model = [ModelSyncFail modelSyncFail];
        model.uid = _modelUser.uid;
        model.fid_server = fid_server;
        model.actionType = WKSyncActionTypeDelete;
        model.dataType = type;
        model.time = [[NSDate date] timeIntervalSince1970];
        [ADOSyncFail addModel:model];
        return;
    }
    if (type==WKSyncDataTypeHistory && !_modelUserSettings.shouldSyncHistory) {
        ModelSyncFail *model = [ModelSyncFail modelSyncFail];
        model.uid = _modelUser.uid;
        model.fid_server = fid_server;
        model.actionType = WKSyncActionTypeDelete;
        model.dataType = type;
        model.time = [[NSDate date] timeIntervalSince1970];
        [ADOSyncFail addModel:model];
        return;
    }
    if (type==WKSyncDataTypeHome && !_modelUserSettings.shouldSyncHome) {
        if (kShouldShowLocalHome) {
            ModelSyncFail *model = [ModelSyncFail modelSyncFail];
            model.uid = _modelUser.uid;
            model.fid_server = fid_server;
            model.actionType = WKSyncActionTypeDelete;
            model.dataType = type;
            model.time = [[NSDate date] timeIntervalSince1970];
            [ADOSyncFail addModel:model];
        }
        return;
    }
    
    ASIFormDataRequest *req = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:API_Favorite]];
    req.timeOutSeconds = 10;
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     API_AppName, @"app",
                                     @"delete", @"ac",
                                     [NSNumber numberWithLongLong:_modelUserSettings.uid], @"uid",
                                     _modelUser.hash, @"hash",
                                     
                                     [NSNumber numberWithInteger:fid_server], @"id",
                                     nil];
    [dicParam enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [req setPostValue:obj forKey:key];
    }];
    
    [dicParam setObject:[NSNumber numberWithInteger:WKSyncActionTypeDelete] forKey:@"action_type"];
    req.userInfo = dicParam;
    
    [_asiQueueCurr addOperation:req];
}

// 批量删除
- (void)syncDelWithDataType:(WKSyncDataType)type fids_server:(NSString *)fids_server
{
    if (!_modelUser) return;
    
    if (type==WKSyncDataTypeFavorite && !_modelUserSettings.shouldSyncFavorite) {
        ModelSyncFail *model = [ModelSyncFail modelSyncFail];
        model.uid = _modelUser.uid;
        model.fids_server = fids_server;
        model.actionType = WKSyncActionTypeDeleteBatch;
        model.dataType = type;
        model.time = [[NSDate date] timeIntervalSince1970];
        [ADOSyncFail addModel:model];
        return;
    }
    if (type==WKSyncDataTypeHistory && !_modelUserSettings.shouldSyncHistory) {
        ModelSyncFail *model = [ModelSyncFail modelSyncFail];
        model.uid = _modelUser.uid;
        model.fids_server = fids_server;
        model.actionType = WKSyncActionTypeDeleteBatch;
        model.dataType = type;
        model.time = [[NSDate date] timeIntervalSince1970];
        [ADOSyncFail addModel:model];
        return;
    }
    if (type==WKSyncDataTypeHome && !_modelUserSettings.shouldSyncHome) {
        if (kShouldShowLocalHome) {
            ModelSyncFail *model = [ModelSyncFail modelSyncFail];
            model.uid = _modelUser.uid;
            model.fids_server = fids_server;
            model.actionType = WKSyncActionTypeDeleteBatch;
            model.dataType = type;
            model.time = [[NSDate date] timeIntervalSince1970];
            [ADOSyncFail addModel:model];
        }
        return;
    }
    
    ASIFormDataRequest *req = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:API_Favorite]];
    req.timeOutSeconds = 10;
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     API_AppName, @"app",
                                     @"batch_delete", @"ac",
                                     [NSNumber numberWithLongLong:_modelUserSettings.uid], @"uid",
                                     _modelUser.hash, @"hash",
                                     
                                     fids_server, @"ids",
                                     [self dataTypeToString:type], @"type",
                                     nil];
    [dicParam enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [req setPostValue:obj forKey:key];
    }];
    
    [dicParam setObject:[NSNumber numberWithInteger:WKSyncActionTypeDeleteBatch] forKey:@"action_type"];
    req.userInfo = dicParam;
    
    [_asiQueueCurr addOperation:req];
}

// 清除历史记录
- (void)syncDelAllHistory
{
    if (!_modelUser) return;
    
    if (!_modelUserSettings.shouldSyncHistory) {
        ModelSyncFail *model = [ModelSyncFail modelSyncFail];
        model.uid = _modelUser.uid;
        model.actionType = WKSyncActionTypeDeleteAll;
        model.time = [[NSDate date] timeIntervalSince1970];
        [ADOSyncFail addModel:model];
        return;
    }
    
    ASIFormDataRequest *req = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:API_Favorite]];
    req.timeOutSeconds = 10;
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     API_AppName, @"app",
                                     @"delete_all", @"ac",
                                     [NSNumber numberWithLongLong:_modelUserSettings.uid], @"uid",
                                     _modelUser.hash, @"hash",
                                     
                                     nil];
    [dicParam enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [req setPostValue:obj forKey:key];
    }];
    
    [dicParam setObject:[NSNumber numberWithInteger:WKSyncActionTypeDeleteAll] forKey:@"action_type"];
    req.userInfo = dicParam;
    
    [_asiQueueCurr addOperation:req];
}

// 更新历史记录的 访问时间
- (void)syncUpdateTime:(NSTimeInterval)time fid_server:(NSInteger)fid_server
{
    if (!_modelUser) return;
    
    if (!_modelUserSettings.shouldSyncHistory) {
        ModelSyncFail *model = [ModelSyncFail modelSyncFail];
        model.uid = _modelUser.uid;
        model.time = time;
        model.fid_server = fid_server;
        model.dataType = WKSyncDataTypeHistory;
        model.actionType = WKSyncActionTypeUpdate;
        [ADOSyncFail addModel:model];
        return;
    }
    
    ASIFormDataRequest *req = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:API_Favorite]];
    req.timeOutSeconds = 10;
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     API_AppName, @"app",
                                     @"modify", @"ac",
                                     [NSNumber numberWithLongLong:_modelUserSettings.uid], @"uid",
                                     _modelUser.hash, @"hash",
                                     
                                     [NSNumber numberWithInteger:(NSInteger)time], @"time",
                                     [NSNumber numberWithInteger:fid_server], @"id",
                                     [self dataTypeToString:WKSyncDataTypeHistory], @"type",
                                     nil];
    [dicParam enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [req setPostValue:obj forKey:key];
    }];
    
    [dicParam setObject:[NSNumber numberWithInteger:WKSyncActionTypeUpdate] forKey:@"action_type"];
    req.userInfo = dicParam;
    
    [_asiQueueCurr addOperation:req];
}

/*
 ------ 同步某类数据
 1、提交上次失败的操作
 2、下载最新的数据，更新到本地
 */
- (void)syncWithDataType:(WKSyncDataType)dataType
{
    [self syncUploadSyncFailWithDataType:dataType block:^{
        switch (dataType) {
            case WKSyncDataTypeHome:
            {
                _arrFidServerHome = [NSMutableArray array];
            }break;
            case WKSyncDataTypeFavorite:
            {
                _arrFidServerFav = [NSMutableArray array];
            }break;
            case WKSyncDataTypeHistory:
            {
                _arrFidServerHistory = [NSMutableArray array];
            }break;
            default:break;
        }
        
        [self syncQueryWithDataType:dataType page:0];
    }];
}

- (void)syncWithDataType:(WKSyncDataType)dataType block:(WKSyncBlock)block
{
    switch (dataType) {
        case WKSyncDataTypeHome:
        {
            _blockSyncHome = block;
        }break;
        case WKSyncDataTypeFavorite:
        {
            _blockSyncFavorite = block;
        }break;
        case WKSyncDataTypeHistory:
        {
            _blockSyncHistory = block;
        }break;
        default:break;
    }
    
    [self syncWithDataType:dataType];
}

- (void)stopSyncWithDataType:(WKSyncDataType)dataType
{
    switch (dataType) {
        case WKSyncDataTypeHome:
            [_asiQueueHome reset];
            SAFE_RELEASE(_asiQueueHome);
            break;
        case WKSyncDataTypeFavorite:
            [_asiQueueFavorite reset];
            SAFE_RELEASE(_asiQueueFavorite);
            break;
        case WKSyncDataTypeHistory:
            [_asiQueueHistory reset];
            SAFE_RELEASE(_asiQueueHistory);
            break;
            
        default:
            break;
    }
}

- (void)syncAll
{
    [self syncWithDataType:WKSyncDataTypeHome];
    [self syncWithDataType:WKSyncDataTypeFavorite];
    [self syncWithDataType:WKSyncDataTypeHistory];
}

- (void)stopSyncAll
{
    [self stopSyncWithDataType:WKSyncDataTypeHome];
    [self stopSyncWithDataType:WKSyncDataTypeFavorite];
    [self stopSyncWithDataType:WKSyncDataTypeHistory];
}

// ------ 1、提交上次失败的操作
- (void)syncUploadSyncFailWithDataType:(WKSyncDataType)dataType block:(WKSyncBlocSyncFailComplited)block
{
    if (!_modelUser) return;
    
    NSArray *arrSyncFail = [ADOSyncFail queryWithUid:_modelUserSettings.uid dataType:dataType];
    
    ASINetworkQueue *asiQueue = nil;
    
    switch (dataType) {
        case WKSyncDataTypeHome:
            asiQueue = _asiQueueHome;
            _blockSyncFailComplitedHome = block;
            break;
        case WKSyncDataTypeFavorite:
            asiQueue = _asiQueueFavorite;
            _blockSyncFailComplitedFavorite = block;
            break;
        case WKSyncDataTypeHistory:
            asiQueue = _asiQueueHistory;
            _blockSyncFailComplitedHistory = block;
            break;
            
        default:
            break;
    }
    
    [asiQueue reset];
    SAFE_RELEASE(asiQueue);
    
    asiQueue = [[ASINetworkQueue alloc] init];
    [asiQueue reset];
    asiQueue.delegate = self;
    [asiQueue setShouldCancelAllRequestsOnFailure:NO];
    [asiQueue setRequestDidFinishSelector:@selector(asiDidSyncFinishRequest:)];
    [asiQueue setQueueDidFinishSelector:@selector(asiDidSyncFinishQueue:)];
    asiQueue.userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:dataType] forKey:@"data_type"];
    
    switch (dataType) {
        case WKSyncDataTypeHome:
            _asiQueueHome = asiQueue;
            break;
        case WKSyncDataTypeFavorite:
            _asiQueueFavorite = asiQueue;
            break;
        case WKSyncDataTypeHistory:
            _asiQueueHistory = asiQueue;
            break;
            
        default:
            break;
    }
    
    for (ModelSyncFail *modelSyncFail in arrSyncFail) {
        
        if (modelSyncFail.dataType==WKSyncDataTypeHome && !_modelUserSettings.shouldSyncHome) continue;
        if (modelSyncFail.dataType==WKSyncDataTypeFavorite && !_modelUserSettings.shouldSyncFavorite) continue;
        if (modelSyncFail.dataType==WKSyncDataTypeHistory && !_modelUserSettings.shouldSyncHistory) continue;
        
        ASIFormDataRequest *req = nil;
        NSMutableDictionary *dicParam = nil;
        switch (modelSyncFail.actionType) {
            case WKSyncActionTypeAdd:
            {
                req = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:API_Favorite]];
                
                dicParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            API_AppName, @"app",
                            @"add", @"ac",
                            [NSNumber numberWithLongLong:_modelUserSettings.uid], @"uid",
                            _modelUser.hash, @"hash",
                            modelSyncFail.title, @"title",
                            [modelSyncFail.link urlEncode], @"link",
                            [self dataTypeToString:modelSyncFail.dataType], @"type",
                            [NSNumber numberWithInteger:modelSyncFail.time], @"time",
                            nil];
                
                [dicParam enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    [req setPostValue:obj forKey:key];
                }];
                
                [dicParam setObject:[NSNumber numberWithInteger:modelSyncFail.actionType] forKey:@"action_type"];
            }
                break;
            case WKSyncActionTypeDelete:
            {
                req = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:API_Favorite]];
                
                dicParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            API_AppName, @"app",
                            @"delete", @"ac",
                            [NSNumber numberWithLongLong:_modelUserSettings.uid], @"uid",
                            _modelUser.hash, @"hash",
                            [NSNumber numberWithInteger:modelSyncFail.fid_server], @"id",
                            nil];
                
                [dicParam enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    [req setPostValue:obj forKey:key];
                }];
                
                [dicParam setObject:[NSNumber numberWithInteger:modelSyncFail.actionType] forKey:@"action_type"];
            }
                break;
            case WKSyncActionTypeDeleteBatch:
            {
                req = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:API_Favorite]];
                
                dicParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            API_AppName, @"app",
                            @"batch_delete", @"ac",
                            [NSNumber numberWithLongLong:_modelUserSettings.uid], @"uid",
                            _modelUser.hash, @"hash",
                            
                            modelSyncFail.fids_server, @"ids",
                            [self dataTypeToString:modelSyncFail.dataType], @"type",
                            nil];
                
                [dicParam enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    [req setPostValue:obj forKey:key];
                }];
                
                [dicParam setObject:[NSNumber numberWithInteger:modelSyncFail.actionType] forKey:@"action_type"];
            }
                break;
            case WKSyncActionTypeDeleteAll:
            {
                req = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:API_Favorite]];
                dicParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            API_AppName, @"app",
                            @"delete_all", @"ac",
                            [NSNumber numberWithLongLong:_modelUserSettings.uid], @"uid",
                            _modelUser.hash, @"hash",
                            
                            nil];
                
                [dicParam enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    [req setPostValue:obj forKey:key];
                }];
                
                [dicParam setObject:[NSNumber numberWithInteger:modelSyncFail.actionType] forKey:@"action_type"];
                
                req.userInfo = dicParam;
            }
                break;
            case WKSyncActionTypeUpdate:
            {
                req = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:API_Favorite]];
                dicParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            API_AppName, @"app",
                            @"modify", @"ac",
                            [NSNumber numberWithLongLong:_modelUserSettings.uid], @"uid",
                            _modelUser.hash, @"hash",
                            
                            [NSNumber numberWithInteger:(NSInteger)modelSyncFail.time], @"time",
                            [NSNumber numberWithInteger:modelSyncFail.fid_server], @"id",
                            [self dataTypeToString:WKSyncDataTypeHistory], @"type",
                            nil];
                
                [dicParam enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    [req setPostValue:obj forKey:key];
                }];
                
                [dicParam setObject:[NSNumber numberWithInteger:modelSyncFail.actionType] forKey:@"action_type"];
            }
                break;
            default:
                break;
        }
        
        if (req) {
            [dicParam setObject:[NSNumber numberWithInteger:modelSyncFail.sfid] forKey:@"sfid"];
            [dicParam setObject:[NSNumber numberWithInteger:WKSyncTypeUpload] forKey:@"sync_type"];
            
            req.timeOutSeconds = 10;
            req.userInfo = dicParam;
            
            [asiQueue addOperation:req];
        }
    }
    
    [asiQueue go];
    
    if (arrSyncFail.count==0) {
        asiQueue.queueDidFinishSelector = nil;
        
        block();
    }
    
}

// ------ 2、下载最新的数据，更新到本地
- (void)syncQueryWithDataType:(WKSyncDataType)dataType page:(NSUInteger)page
{
    ASINetworkQueue *asiQueue = nil;
    
    switch (dataType) {
        case WKSyncDataTypeHome:
            if (!_modelUserSettings.shouldSyncHome || !kShouldShowLocalHome) {
                // TODO:通知更新UI
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDidSyncHome object:nil];
                return;
            }
            asiQueue = _asiQueueHome;
            break;
        case WKSyncDataTypeFavorite:
            if (!_modelUserSettings.shouldSyncFavorite) return;
            asiQueue = _asiQueueFavorite;
            break;
        case WKSyncDataTypeHistory:
            if (!_modelUserSettings.shouldSyncHistory) return;
            asiQueue = _asiQueueHistory;
            break;
            
        default:
            break;
    }
    
    ASIFormDataRequest *req = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:API_Favorite]];
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     API_AppName, @"app",
                                     @"list", @"ac",
                                     @"1", @"nocache",
                                     [NSNumber numberWithInteger:_modelUserSettings.uid], @"uid",
                                     _modelUser.hash, @"hash",
                                     [NSNumber numberWithInteger:page], @"page",
                                     [self dataTypeToString:dataType], @"type",
                                     nil];
    [dicParam enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [req setPostValue:obj forKey:key];
    }];
    
    [dicParam setObject:[NSNumber numberWithInteger:WKSyncTypeQuery] forKey:@"sync_type"];
    req.userInfo = dicParam;
    
    [asiQueue addOperation:req];
}

#pragma mark - private methods
- (NSString *)dataTypeToString:(WKSyncDataType)dataType
{
    NSString *type = @"";
    switch (dataType) {
        case WKSyncDataTypeHome:
            type = @"home";
            break;
        case WKSyncDataTypeFavorite:
            type = @"favorite";
            break;
        case WKSyncDataTypeHistory:
            type = @"history";
            break;
            
        default:
            break;
    }
    return type;
}

- (WKSyncDataType)dataTypeFromString:(NSString *)string
{
    WKSyncDataType type = WKSyncDataTypeUnknow;
    if ([string isEqualToString:@"favorite"]) {
        type = WKSyncDataTypeFavorite;
    }
    else if ([string isEqualToString:@"home"]) {
        type = WKSyncDataTypeHome;
    }
    else if ([string isEqualToString:@"history"]) {
        type = WKSyncDataTypeHistory;
    }
    return type;
}

#pragma mark ---------------------- asi
/*
 保存失败的请求
 
 首次同步到网络失败，需要记录下来，下次同步
 */
- (void)asiDidCurrFailRequest:(ASIHTTPRequest *)req
{
    ModelSyncFail *modelSyncFail = [ModelSyncFail modelSyncFail];
    modelSyncFail.fid_server = [[req.userInfo objectForKey:@"id"] integerValue];
    modelSyncFail.uid = [[req.userInfo objectForKey:@"uid"] integerValue];     // *
    modelSyncFail.title = [req.userInfo objectForKey:@"title"];
    modelSyncFail.link = [[req.userInfo objectForKey:@"link"] urlDecode];
    modelSyncFail.dataType = [self dataTypeFromString:[req.userInfo objectForKey:@"type"]];     // *
    modelSyncFail.actionType = [[req.userInfo objectForKey:@"action_type"] integerValue];       // *
    modelSyncFail.time = [[req.userInfo objectForKey:@"time"] doubleValue];
    modelSyncFail.fids_server = [req.userInfo objectForKey:@"ids"];
    
    [ADOSyncFail addModel:modelSyncFail];
}

// 修改 添加操作返回的 fid_server
- (void)asiDidCurrFinishRequest:(ASIHTTPRequest *)req
{
    WKSyncActionType actionType = [[req.userInfo objectForKey:@"action_type"] integerValue];
    WKSyncDataType dataType = [self dataTypeFromString:[req.userInfo objectForKey:@"type"]];
    NSDictionary *dicResult = [[CJSONDeserializer deserializer] deserialize:req.responseData error:nil];
    
    _DEBUG_LOG(@"%@:%@:%@:%@", NSStringFromSelector(_cmd), [dicResult objectForKey:@"msg"], dicResult, req.userInfo);
    
    if (actionType==WKSyncActionTypeAdd) {
        // 添加操作成功后 修改 本地数据的 fid_server
        NSDictionary *dicData = [dicResult objectForKey:@"data"];
        NSInteger fid_server = [[dicData objectForKey:@"id"] integerValue];
        [ADOFavorite updateFidServer:fid_server
                             withUid:_modelUser.uid
                            dataType:[self dataTypeFromString:[req.userInfo objectForKey:@"type"]]
                                link:[[req.userInfo objectForKey:@"link"] urlDecode]];
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [req.userInfo objectForKey:@"uid"], @"uid",
                                  [[req.userInfo objectForKey:@"link"] urlDecode], @"link",
                                  [NSNumber numberWithInteger:dataType], @"type",
                                  [NSNumber numberWithInteger:fid_server], @"fid_server",
                                  nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdateFidServer
                                                            object:nil
                                                          userInfo:userInfo];
        
        _modelUserSettings.updateTimeInterval = [[NSDate date] timeIntervalSince1970];
        [ADOUserSettings updateModel:_modelUserSettings withUid:_modelUser.uid];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdateSyncTime object:nil];
    }
}

// --------------------------
/*
 */
- (void)asiDidSyncFinishRequest:(ASIHTTPRequest *)req
{
    WKSyncType syncType = [[req.userInfo objectForKey:@"sync_type"] integerValue];
    if (WKSyncTypeUpload == syncType) {
        // 从同步操作记录中删除 同步成功的 操作
        NSInteger sfid = [[req.userInfo objectForKey:@"sfid"] integerValue];
        [ADOSyncFail deleteWithSfid:sfid];
        
        // 修改 添加操作返回的 fid_server
        [self asiDidCurrFinishRequest:req];
    }
    else if (WKSyncTypeQuery == syncType) {
        NSDictionary *dicResult = [[CJSONDeserializer deserializer] deserialize:req.responseData error:nil];
        NSArray *arrFavoriteDic = [dicResult objectForKey:@"data"];
        WKSyncDataType dataType = [self dataTypeFromString:[req.userInfo objectForKey:@"type"]];
        
        NSMutableArray *arrFidsServer = nil;
        WKSyncBlock block = nil;
        switch (dataType) {
            case WKSyncDataTypeHome:
            {
                arrFidsServer = _arrFidServerHome;
                block = _blockSyncHome;
            }break;
            case WKSyncDataTypeFavorite:
            {
                arrFidsServer = _arrFidServerFav;
                block = _blockSyncFavorite;
            }break;
            case WKSyncDataTypeHistory:
            {
                arrFidsServer = _arrFidServerHistory;
                block = _blockSyncHistory;
            }break;
            default:break;
        }
        
        if (arrFavoriteDic) {
            for (NSDictionary *dicFavorite in arrFavoriteDic) {
                ModelFavorite *modelFavorite = [ModelFavorite modelFavorite];
                modelFavorite.fid_server = [[dicFavorite objectForKey:@"id"] integerValue];
                modelFavorite.title = [dicFavorite objectForKey:@"title"];
                modelFavorite.link = [dicFavorite objectForKey:@"link"];
                modelFavorite.time = [[dicFavorite objectForKey:@"time"] doubleValue];
                modelFavorite.dataType = dataType;
                modelFavorite.uid = _modelUser.uid;
                
                [arrFidsServer addObject:[dicFavorite objectForKey:@"id"]];
                
                // fid_server, uid, data_type
                if ([ADOFavorite isExistsWithDataType:dataType fid_server:modelFavorite.fid_server uid:_modelUser.uid withGuest:NO]) {
                    // updaate
                    [ADOFavorite updateModel:modelFavorite withFidServer:modelFavorite.fid_server uid:_modelUser.uid];
                }
                else {
                    // add
                    [ADOFavorite addModel:modelFavorite];
                }
            }
        }
        
        NSString *next_page = [[dicResult objectForKey:@"next_page"] uppercaseString];
        if (next_page && [next_page isEqualToString:@"Y"]) {
            // 请求下一页数据
            [self syncQueryWithDataType:[self dataTypeFromString:[req.userInfo objectForKey:@"type"]]
                                   page:[[req.userInfo objectForKey:@"page"] integerValue]+1];
        }
        else {
            // 所有数据已下载完成，更新数据
            NSString *fidsServer = [arrFidsServer componentsJoinedByString:@","];
            [ADOFavorite deleteDataType:dataType uid:_modelUser.uid notContainFidsServer:fidsServer];
            
            if (block) block();
            
            if (WKSyncDataTypeHome == dataType) {
                // TODO:通知更新UI
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDidSyncHome object:nil];
            }
            
            _modelUserSettings.updateTimeInterval = [[NSDate date] timeIntervalSince1970];
            [ADOUserSettings updateModel:_modelUserSettings withUid:_modelUser.uid];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdateSyncTime object:nil];
        }
    }
}

/*
 同步失败请求后
 */
- (void)asiDidSyncFinishQueue:(ASINetworkQueue *)queue
{
    queue.queueDidFinishSelector = nil;
    _DEBUG_LOG(@"--------sync:%@", NSStringFromSelector(_cmd));
    switch ((WKSyncDataType)[[queue.userInfo objectForKey:@"data_type"] integerValue]) {
        case WKSyncDataTypeHome:
            if (_blockSyncFailComplitedHome)
                _blockSyncFailComplitedHome();
            break;
        case WKSyncDataTypeFavorite:
            if (_blockSyncFailComplitedFavorite)
                _blockSyncFailComplitedFavorite();
            break;
        case WKSyncDataTypeHistory:
            if (_blockSyncFailComplitedHistory)
                _blockSyncFailComplitedHistory();
            break;
            
        default:
            break;
    }
}

@end
