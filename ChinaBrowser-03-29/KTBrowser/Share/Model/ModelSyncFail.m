//
//  ModelSyncFail.m
//  WKBrowser
//
//  Created by David on 13-10-22.
//  Copyright (c) 2013年 VeryApps. All rights reserved.
//

#import "ModelSyncFail.h"

@implementation ModelSyncFail

- (void)dealloc
{
    SAFE_RELEASE(_title);
    SAFE_RELEASE(_link);
    SAFE_RELEASE(_fids_server);
}

+ (ModelSyncFail *)modelSyncFail
{
    return [[ModelSyncFail alloc] init];
}

@end
