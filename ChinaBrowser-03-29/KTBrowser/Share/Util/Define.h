//
//  Define.h
//  JiShi
//
//  Created by David on 13-12-3.
//  Copyright (c) 2013年 David. All rights reserved.
//

#ifndef JiShi_Define_h
#define JiShi_Define_h

/**
 *  同步数据类型
 */
typedef NS_ENUM(NSInteger, WKSyncDataType) {
    /**
     *  未知
     */
    WKSyncDataTypeUnknow,
    /**
     *  首页数据
     */
    WKSyncDataTypeHome,
    /**
     *  收藏夹
     */
    WKSyncDataTypeFavorite,
    /**
     *  历史记录
     */
    WKSyncDataTypeHistory
};

/**
 *  同步操作
 */
typedef NS_ENUM(NSInteger, WKSyncActionType) {
    /**
     *  未知
     */
    WKSyncActionTypeUnknow,
    /**
     *  添加
     */
    WKSyncActionTypeAdd,
    /**
     *  更新
     */
    WKSyncActionTypeUpdate,
    /**
     *  删除
     */
    WKSyncActionTypeDelete,
    /**
     *  批量删除
     */
    WKSyncActionTypeDeleteBatch,
    /**
     *  删除全部
     *  只清除 历史记录
     */
    WKSyncActionTypeDeleteAll,
};

/**
 *  菜单类型
 */
typedef NS_ENUM(NSInteger, MenuItem) {
    /**
     *  添加书签
     */
    MenuItemAddToBookmark = 0,
    /**
     *  书签和历史记录
     */
    MenuItemBookmarkHistory,
    /**
     *  刷新
     */
    MenuItemRefresh,
    /**
     *  日间/黑夜模式
     */
    MenuItemDayNightModal,
    /**
     *  亮度调节
     */
    MenuItemSetBrightness,
    /**
     *  下载和文件
     */
    MenuItemDownload,
    /**
     *  新建标签
     */
    MenuItemNewPage,
    /**
     *  退出
     */
    MenuItemExit,
    /**
     *  系统设置
     */
    MenuItemSystemSettings,
    /**
     *  无图模式
     */
    MenuItemNoImage,
    /**
     *  字体大小
     */
    MenuItemFontSize,
    /**
     *  无痕浏览
     */
    MenuItemNoSaveHistory,
    /**
     *  旋转
     */
    MenuItemRotate,
    /**
     *  全屏
     */
    MenuItemFullscreen,
    /**
     *  反馈
     */
    MenuItemFeedback,
    /**
     *  版本检查
     */
    MenuItemCheckVersion,
    /**
     *  皮肤设置
     */
    MenuItemSkin,
    /**
     *  截图涂鸦
     */
    MenuItemScreenshot,
    /**
     *  分享
     */
    MenuItemShare,
    /**
     *  自由复制
     */
    MenuItemFreeCopy,
    /**
     *  业内查找
     */
    MenuItemFindInPage,
    /**
     *  二维码
     */
    MenuItemQRCode,
    /**
     *  单手操作
     */
    MenuItemOneHand
};

/**
 *  请求链接操作
 */
typedef NS_ENUM(NSInteger, ReqLinkAction) {
    /**
     *  当前窗口打开
     */
    ReqLinkActionOpenInSelf,
    /**
     *  后台打开
     */
    ReqLinkActionOpenInBackground,
    /**
     *  新窗口打开
     */
    ReqLinkActionOpenInNewWindow,
    /**
     *  新建空白页
     */
    ReqLinkActionNewBlankWindow
};

/**
 *  首页图标网址
 */
typedef NS_ENUM (NSInteger, IconSiteEvent){
    /**
     *  添加事件
     */
    IconSiteEventAdd,
    /**
     *  开始编辑
     */
    IconSiteEventBeginEdit,
    /**
     *  解释编辑
     */
    IconSiteEventEndEdit
};

/**
 *  UIView boder
 */
typedef NS_ENUM(NSInteger, UIBorder) {
    /**
     * 上
     */
    UIBorderTop         = 1 << 0,
    /**
     * 下
     */
    UIBorderBottom      = 1 << 1,
    /**
     *  左
     */
    UIBorderLeft        = 1 << 2,
    /**
     *  右
     */
    UIBorderRight       = 1 << 3,
    /**
     *  上下
     */
    UIBorderTopBottom   = UIBorderTop|UIBorderBottom,
    /**
     *  所有
     */
    UIBorderAll         = UIBorderTop|UIBorderBottom|UIBorderLeft|UIBorderRight
};

/**
 *  顶部的距离
 */
#define TopEdge 20.0f
/**
 *  浏览器模块 地址栏显示正常标题和链接/在输入框显示标题
 *  1: 只显示标题
 *  0: 显示我标题和链接
 */
#define BrowserShowTitleOnly 0

#define kThemeColor RGBCOLOR(233, 39, 6)

#define kSearchOptionIndex @"kSearchOptionIndex"

#define kWebFontSizeDefault 18

/**
 *  地址栏优先显示标题，没有标题，则显示链接；
 */
#define TKShowTitle 1

#endif
