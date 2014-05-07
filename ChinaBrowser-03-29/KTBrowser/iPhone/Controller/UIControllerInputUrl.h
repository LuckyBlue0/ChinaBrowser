//
//  UIControllerInputUrl.h
//  KTBrowser
//
//  Created by David on 14-2-20.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIControllerInputUrlDelegate;

@interface UIControllerInputUrl : UIViewController

@property (nonatomic, assign) id<UIControllerInputUrlDelegate> delegate;

- (void)showInController:(UIViewController *)controller completion:(void(^)(void))completion;
- (void)dismissWithCompletion:(void(^)(void))completion;

@end

@protocol UIControllerInputUrlDelegate <NSObject>

- (void)controllerInputUrlWillDismiss:(UIControllerInputUrl *)controller;

@end
