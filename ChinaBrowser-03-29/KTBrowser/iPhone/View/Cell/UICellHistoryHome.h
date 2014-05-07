//
//  UICellHistoryHome.h
//  KTBrowser
//
//  Created by David on 14-3-7.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICellHistoryHome : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imageViewIcon;
@property (nonatomic, strong) IBOutlet UILabel *labelTitle;
@property (nonatomic, strong) IBOutlet UIImageView *imageViewArrow;
@property (nonatomic, strong) IBOutlet UILabel *labelLink;

+ (UICellHistoryHome *)cellHistoryFromXib;

@end
