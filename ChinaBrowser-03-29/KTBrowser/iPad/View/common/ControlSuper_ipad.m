//
//  ControlSuper_ipad.m
//  BrowserApp
//
//  Created by Glex on 14-3-11.
//  Copyright (c) 2014年 arBao. All rights reserved.
//

#import "ControlSuper_ipad.h"

@implementation ControlSuper_ipad

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self observeNotif];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self observeNotif];
    }
    
    return self;
}

- (void)observeNotif {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(whenDeviceDidRotate) name:kNotifDidRotate object:nil];// 旋转通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(whenLangChanged) name:kNotifLangChanged object:nil];// 多语言通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(whenDayModeChanged) name:kNotifDayModeChanged object:nil];// 日间模式切换
}

#pragma mark - 供子类重写的方法
// 旋转
- (void)whenDeviceDidRotate {
}

// 多语言
- (void)whenLangChanged {
}

// 黑夜/日间 模式
- (void)whenDayModeChanged {
}

@end
