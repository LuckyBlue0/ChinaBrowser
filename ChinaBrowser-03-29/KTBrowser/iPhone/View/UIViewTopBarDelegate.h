//
//  UIViewTopBarDelegate.h
//  KTBrowser
//
//  Created by David on 14-2-18.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UIInputModal) {
    UIInputModalNone,
    UIInputModalURL,
    UIInputModalSearch,
    UIInputModalFindInPage
};

@class UIViewTopBar;

@protocol UIViewTopBarDelegate <NSObject>

/**
 *  响应请求连接
 *
 *  @param viewTopBar UIViewTopBar
 *  @param link       link
 */
- (void)viewTopBar:(UIViewTopBar *)viewTopBar reqLink:(NSString *)link;

/**
 *  页内查找标签
 *
 *  @param viewTopBar UIViewTopBar
 *  @param keyword    关键字
 */
- (void)viewTopBar:(UIViewTopBar *)viewTopBar findKeywrodInPage:(NSString *)keyword;

/**
 *  聚焦到当前查找的点
 *
 *  @param viewTopBar UIViewTopBar
 *  @param findIndex  focusToFindIndex
 */
- (void)viewTopBar:(UIViewTopBar *)viewTopBar focusToFindIndex:(NSInteger)findIndex;

/**
 *  取消页内查找
 *
 *  @param viewTopBar UIViewTopBar
 */
- (void)viewTopBarCancelFindInPage:(UIViewTopBar *)viewTopBar;

/**
 *  点击用户头像
 *
 *  @param viewTopBar UIViewTopBar
 */
- (void)viewTopBarOnTouchPersonal:(UIViewTopBar *)viewTopBar;

/**
 *  点击书签按钮
 *
 *  @param viewTopBar UIViewTopBar
 */
- (void)viewTopBarTouchBookmark:(UIViewTopBar *)viewTopBar;

/**
 *  点击二维码
 *
 *  @param viewTopBar UIViewTopBar
 */
- (void)viewTopBarTouchQRCode:(UIViewTopBar *)viewTopBar;

/**
 *  点击搜索引擎的Icon，来显示搜索引擎的选项
 *
 *  @param viewTopBar UIViewTopBar
 *  @param options    搜索引擎的选项
 *  @param position   弹出菜单的位置
 */
- (void)viewTopBarShowSearchOption:(UIViewTopBar *)viewTopBar options:(NSArray *)options position:(CGPoint)position;

/**
 *  切换输入状态
 *
 *  @param viewTopBar UIViewTopBar
 *  @param inputModal UIInputModal
 */
- (void)viewTopBar:(UIViewTopBar *)viewTopBar willToggleInpuModal:(UIInputModal)inputModal;

/**
 *  切换输入状态
 *
 *  @param viewTopBar UIViewTopBar
 *  @param inputModal UIInputModal
 */
- (void)viewTopBar:(UIViewTopBar *)viewTopBar didToggleInpuModal:(UIInputModal)inputModal;

- (void)viewTopBarWillToggleToFindInPage:(UIViewTopBar *)viewTopBar;
- (void)viewTopBarWillToggleToNotFindInPage:(UIViewTopBar *)viewTopBar;

@end
