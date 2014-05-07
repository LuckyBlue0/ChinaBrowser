//
//  UINavigationController+EX.m
//  TopspeedBrowser
//
//  Created by Glex on 13-8-02.
//  Copyright (c) 2013年 VeryApps. All rights reserved.
//

#import "UINavigationController+EX.h"

#import <QuartzCore/QuartzCore.h>

@implementation UINavigationController (EX)

- (void)pushViewController:(UIViewController *)viewController animationWithCATransitionSubtype:(NSString *)subtype {
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType: kCATransitionPush];
    [animation setSubtype: subtype];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [self pushViewController:viewController animated:NO];
    [self.view.layer addAnimation:animation forKey:nil];
}

- (void)popViewControllerAnimatedWithCATransitionSubtype:(NSString *)subtype {
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType: kCATransitionPush];
    [animation setSubtype: subtype];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [self popViewControllerAnimated:NO];
    [self.view.layer addAnimation:animation forKey:nil];
}

- (void)popToRootViewControllerAnimatedWithCATransitionSubtype:(NSString *)subtype {
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType: kCATransitionPush];
    [animation setSubtype: subtype];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [self popToRootViewControllerAnimated:NO];
    [self.view.layer addAnimation:animation forKey:nil];
}

@end
