//
//  UIViewPanel.h
//  KTBrowser
//
//  Created by David on 14-3-3.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewSkin.h"

@interface UIViewPanel : UIViewSkin
{
    UIView *_viewContent;
    UILabel *_labelTitle;
}

@property (nonatomic, strong) IBOutlet UILabel *labelTitle;
@property (nonatomic, strong) IBOutlet UIView *viewContent;

- (void)showInView:(UIView *)view completion:(void(^)(void))completion;
- (void)dismissWithCompletion:(void(^)(void))completion;

@end
