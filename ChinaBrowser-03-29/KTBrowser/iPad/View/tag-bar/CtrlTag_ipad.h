//
//  UIControlTag.h
//  browser9374
//
//  Created by arBao on 8/23/13.
//  Copyright (c) 2013 arBao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ControlSuper_ipad.h"

@interface CtrlTag_ipad : ControlSuper_ipad

@property (nonatomic, assign) BOOL iconHaveSet;
@property (nonatomic, strong) UIButton *btnClose;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UIImageView *imgIcon;

- (void)setSelectState:(BOOL)select;

@end
