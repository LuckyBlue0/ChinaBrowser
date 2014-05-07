//
//  ModelSyncFail.h
//  WKBrowser
//
//  Created by David on 13-10-22.
//  Copyright (c) 2013年 VeryApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelSyncFail : NSObject

@property (nonatomic, assign) NSInteger sfid;
@property (nonatomic, assign) NSInteger fid_server;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, assign) NSTimeInterval time;
@property (nonatomic, assign) WKSyncDataType dataType;
@property (nonatomic, assign) WKSyncActionType actionType;
@property (nonatomic, strong) NSString *fids_server;

+ (ModelSyncFail *)modelSyncFail;

@end
