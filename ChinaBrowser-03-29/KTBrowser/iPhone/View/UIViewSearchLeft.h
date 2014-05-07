//
//  UIViewSearchLeft.h
//  KTBrowser
//
//  Created by David on 14-2-18.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewSkin.h"

@interface UIViewSearchLeft : UIViewSkin
{
    IBOutlet UIImageView *_imageViewSearch;
    IBOutlet UIImageView *_imageViewArrow;
}

@property (nonatomic, strong) IBOutlet UIButton *btnIcon;

- (void)showMagnifierIcon;
- (void)showOptionIcon;

@end
