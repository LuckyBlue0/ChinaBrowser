//
//  ViewSkinItem.h
//  ChinaBrowser
//
//  Created by Glex on 14-3-27.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewSkinItem : UIControl

@property (nonatomic, strong) NSString *skinKey;
@property (nonatomic, strong) UIImage  *skinPic;
@property (nonatomic, strong) UIButton *btnClose;
@property (nonatomic, assign) BOOL shaking;

@end
