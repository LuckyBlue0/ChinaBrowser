//
//  UIControllerInputSearch.h
//  KTBrowser
//
//  Created by David on 14-2-20.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIControllerInputSearchDelegate;

@interface UIControllerInputSearch : UIViewController

@property (nonatomic, assign) id<UIControllerInputSearchDelegate> delegate;

- (void)showInController:(UIViewController *)controller completion:(void(^)(void))completion;
- (void)dismissWithCompletion:(void(^)(void))completion;

@end

@protocol UIControllerInputSearchDelegate <NSObject>

- (void)controllerInputSearchWillDismiss:(UIControllerInputSearch *)controller;

@end
