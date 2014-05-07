//
//  UIViewSNSItem.h
//  KTBrowser
//
//  Created by David on 14-3-3.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewSNSItem : UIControl

@property (nonatomic, strong) IBOutlet UIImageView *imageViewIcon;
@property (nonatomic, strong) IBOutlet UILabel *labelTitle;

+ (UIViewSNSItem *)viewSNSItemFromItem;

@end
