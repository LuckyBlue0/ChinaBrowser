//
//  UINavigationController+EX.h
//  TopspeedBrowser
//
//  Created by Glex on 13-8-02.
//  Copyright (c) 2013年 VeryApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (EX)

- (void)pushViewController:(UIViewController *)viewController animationWithCATransitionSubtype:(NSString *)subtype;
- (void)popViewControllerAnimatedWithCATransitionSubtype:(NSString *)subtype;
- (void)popToRootViewControllerAnimatedWithCATransitionSubtype:(NSString *)subtype;

@end
