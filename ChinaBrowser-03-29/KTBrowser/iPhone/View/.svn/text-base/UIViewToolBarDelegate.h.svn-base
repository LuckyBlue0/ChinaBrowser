//
//  UIViewToolBarDelegate.h
//  KTBrowser
//
//  Created by David on 14-2-15.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ToolBarEvent) {
    ToolBarEventUnknow,
    ToolBarEventRefresh,
    ToolBarEventStop,
    ToolBarEventGoBack,
    ToolBarEventGoForward,
    ToolBarEventMenu,
    ToolBarEventWindows,
    ToolBarEventHome,
    
    ToolBarEventEditDone
};

@class UIViewToolBar;

@protocol UIViewToolBarDelegate <NSObject>


@optional
/**
 *  UIViewToolBar 点击事件
 *
 *  @param viewToolBar  UIViewToolBar
 *  @param toolBarEvent ToolBarEvent 类型
 */
- (void)viewToolBar:(UIViewToolBar *)viewToolBar toolBarEvent:(ToolBarEvent)toolBarEvent point:(CGPoint)point;

@end
