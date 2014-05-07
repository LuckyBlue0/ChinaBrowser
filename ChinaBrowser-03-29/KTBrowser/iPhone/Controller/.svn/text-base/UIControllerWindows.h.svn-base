//
//  UIControllerWindows.h
//  KTBrowser
//
//  Created by David on 14-3-7.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewBar.h"
#import "UIScrollViewWindow.h"

@protocol UIControllerWindowsDelegate;

@interface UIControllerWindows : UIViewController <UIScrollViewWindowDelegate>
{
    IBOutlet UIScrollViewWindow *_scrollViewWindow;
    IBOutlet UIViewBar *_viewBarBottom;
    IBOutlet UIButton *_btnBack;
    IBOutlet UIButton *_btnAdd;
    
    NSMutableArray *_arrWindowItem;
}

@property (nonatomic, weak) id<UIControllerWindowsDelegate> delegate;

- (void)reloadWithDatasource:(id<UIScrollViewWindowDatasource>)datasource;

- (void)showInController:(UIViewController *)controller currIndex:(NSInteger)currIndex completion:(void (^)(void))completion;
- (void)dismissWithCompletion:(void (^)(void))completion;

@end

@protocol UIControllerWindowsDelegate <NSObject>

/**
 *  选择窗口
 *
 *  @param controllerWindows UIControllerWindows
 *  @param index             索引
 */
- (void)controllerWindows:(UIControllerWindows *)controllerWindows didSelectFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

/**
 *  已经删除窗口
 *
 *  @param controllerWindows UIControllerWindows
 *  @param index             索引
 */
- (void)controllerWindows:(UIControllerWindows *)controllerWindows didRemoveAtIndex:(NSInteger)index toIndex:(NSInteger)toIndex;

/**
 *  
 *
 *  @param controllerWindows <#controllerWindows description#>
 */
- (void)controllerWindowsNewWindow:(UIControllerWindows *)controllerWindows;

@end

