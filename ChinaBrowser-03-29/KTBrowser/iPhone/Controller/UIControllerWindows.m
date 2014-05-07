//
//  UIControllerWindows.m
//  KTBrowser
//
//  Created by David on 14-3-7.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIControllerWindows.h"

#import "UIScrollViewWindowItem.h"

#import "UIColor+Expanded.h"
#import "UIImage+Bundle.h"

@interface UIControllerWindows ()

- (void)resizeWithInterfaceOrientation:(UIInterfaceOrientation)interfaceOriention;

- (IBAction)onTouchAdd;
- (IBAction)onTouchBack;

@end

@implementation UIControllerWindows

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
    
    _arrWindowItem = [NSMutableArray array];
    
    _viewBarBottom.borderWidth = 1;
    _viewBarBottom.border = UIBorderTop;
    _viewBarBottom.borderColor = [UIColor colorWithWhite:0.3 alpha:1];
    _viewBarBottom.backgroundColor = [UIColor colorWithString:@"#3D3D3D"];
    
    self.view.backgroundColor = [UIColor colorWithString:@"#333333"];
    _scrollViewWindow.backgroundColor = [UIColor clearColor];
    _scrollViewWindow.paddingTB = 20;
    _scrollViewWindow.paddingLR = 20;
    _scrollViewWindow.itemW = 180;
    _scrollViewWindow.itemH = 130;
    _scrollViewWindow.showsHorizontalScrollIndicator = NO;
    _scrollViewWindow.showsVerticalScrollIndicator = NO;
    
    [_btnAdd setImage:[UIImage imageWithFilename:@"wnd.bundle/wnd_0.png"] forState:UIControlStateNormal];
    [_btnAdd setImage:[UIImage imageWithFilename:@"wnd.bundle/wnd_1.png"] forState:UIControlStateDisabled];
    
    [_btnBack setImage:[UIImage imageWithFilename:@"tab.bundle/tab_0_1.png"] forState:UIControlStateNormal];
    
    [self resizeWithInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Applications should use supportedInterfaceOrientations and/or shouldAutorotate..
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation NS_DEPRECATED_IOS(2_0, 6_0)
{
    if ([AppConfig config].rotateLock) {
        return NO;
    }
    else {
        return YES;
    }
}

// New Autorotation support.
- (BOOL)shouldAutorotate NS_AVAILABLE_IOS(6_0)
{
    if ([AppConfig config].rotateLock) {
        return NO;
    }
    else {
        return YES;
    }
}

- (NSUInteger)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0)
{
    if ([AppConfig config].rotateLock) {
        return [AppConfig config].interfaceOrientationMask;
    }
    else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self resizeWithInterfaceOrientation:toInterfaceOrientation];
}

#pragma mark - public methods

- (void)showInController:(UIViewController *)controller currIndex:(NSInteger)currIndex completion:(void (^)(void))completion
{
    [controller addChildViewController:self];
    self.view.frame = controller.view.bounds;
    [controller.view addSubview:self.view];
    _scrollViewWindow.selectIndex = currIndex;
    
    self.view.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 1;
    } completion:^(BOOL finished) {
        if (completion) completion();
    }];
}

- (void)reloadWithDatasource:(id<UIScrollViewWindowDatasource>)datasource
{
    _scrollViewWindow.datasource = datasource;
    NSInteger count = [datasource numbersOfItemScrollViewWindow:_scrollViewWindow];
    for (NSInteger i=0; i<count; i++) {
        UIScrollViewWindowItem *scrollViewWindowItem = [UIScrollViewWindowItem scrollViewWindowItemFromXib];
        scrollViewWindowItem.selected = _scrollViewWindow.selectIndex==i;
        scrollViewWindowItem.labelTitle.textAlignment = UITextAlignmentLeft;
        [_scrollViewWindow addScrollViewWindowItem:scrollViewWindowItem];
    }
    
    [_scrollViewWindow reload];
}

- (void)dismissWithCompletion:(void(^)(void))completion
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 0;
        self.view.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        if (completion) completion();
        
        [self removeFromParentViewController];
    }];
}

#pragma mark - private
- (void)resizeWithInterfaceOrientation:(UIInterfaceOrientation)interfaceOriention
{
    BOOL fs = [AppConfig config].fullScreen;
    if (UIInterfaceOrientationIsLandscape(interfaceOriention)) {
        // 横屏
        CGRect rc = self.view.bounds;
        rc.size.height = 34;
        rc.origin.y = self.view.bounds.size.height-rc.size.height;
        _viewBarBottom.frame = rc;
        
        rc = self.view.bounds;
        if (IsiOS7 && !fs) {
            rc.origin.y += 20;
        }
        rc.size.height = _viewBarBottom.frame.origin.y-rc.origin.y;
        _scrollViewWindow.frame = rc;
    }
    else {
        // 竖屏
        CGRect rc = self.view.bounds;
        rc.origin.x = 0;
        rc.size.height = 44;
        rc.origin.y = self.view.bounds.size.height-rc.size.height;
        _viewBarBottom.frame = rc;
        
        rc = self.view.bounds;
        if (IsiOS7 && !fs) {
            rc.origin.y += 20;
        }
        rc.size.height = _viewBarBottom.frame.origin.y-rc.origin.y;
        _scrollViewWindow.frame = rc;
    }
}

- (IBAction)onTouchAdd
{
    [_delegate controllerWindowsNewWindow:self];
    
    UIScrollViewWindowItem *scrollViewWindowItem = [UIScrollViewWindowItem scrollViewWindowItemFromXib];
    scrollViewWindowItem.selected = NO;
    scrollViewWindowItem.labelTitle.textAlignment = UITextAlignmentLeft;
    [_scrollViewWindow addScrollViewWindowItem:scrollViewWindowItem];
    
    _scrollViewWindow.selectIndex = [_scrollViewWindow.datasource numbersOfItemScrollViewWindow:_scrollViewWindow]-1;
    
    [_scrollViewWindow reload];
}

- (IBAction)onTouchBack
{
    [self dismissWithCompletion:nil];
}

#pragma mark - UIScrollViewDelegate

/**
 *  选择窗口
 *
 *  @param scrollViewWindow UIScrollViewWindow
 *  @param index             索引
 */
- (void)scrollViewWindow:(UIScrollViewWindow *)scrollViewWindow didSelectFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    [_delegate controllerWindows:self didSelectFromIndex:fromIndex toIndex:toIndex];
}

/**
 *  已经删除窗口
 *
 *  @param scrollViewWindow UIScrollViewWindow
 *  @param index             索引
 */
- (void)scrollViewWindow:(UIScrollViewWindow *)scrollViewWindow didRemoveAtIndex:(NSInteger)index toIndex:(NSInteger)toIndex
{
    [_delegate controllerWindows:self didRemoveAtIndex:index toIndex:toIndex];
}

/**
 *  新建网页窗口
 *
 *  @param scrollViewWindow UIScrollViewWindow
 */
- (void)scrollViewWindowWillAddNewWindow:(UIScrollViewWindow *)scrollViewWindow
{
    [self onTouchAdd];
}

@end
