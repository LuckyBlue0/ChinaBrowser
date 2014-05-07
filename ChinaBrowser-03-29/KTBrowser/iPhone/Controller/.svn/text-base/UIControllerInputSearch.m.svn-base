//
//  UIControllerInputSearch.m
//  KTBrowser
//
//  Created by David on 14-2-20.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIControllerInputSearch.h"

@interface UIControllerInputSearch ()

@end

@implementation UIControllerInputSearch

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismissWithCompletion:nil];
}

- (void)showInController:(UIViewController *)controller completion:(void(^)(void))completion
{
    [controller addChildViewController:self];
    [controller.view addSubview:self.view];
    
    self.view.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 1;
        self.view.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
    } completion:^(BOOL finished) {
        if (completion) completion();
    }];
}

- (void)dismissWithCompletion:(void(^)(void))completion
{
    if ([_delegate respondsToSelector:@selector(controllerInputSearchWillDismiss:)]) {
        [_delegate controllerInputSearchWillDismiss:self];
    }
    [UIView animateWithDuration:0.1 animations:^{
        self.view.alpha = 0;
        self.view.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        if (completion) completion();
        [self removeFromParentViewController];
    }];
}

@end
