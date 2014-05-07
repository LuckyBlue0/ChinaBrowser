//
//  UIScrollViewWindow.h
//  ChinaBrowser
//
//  Created by David on 14-3-20.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIScrollViewWindowItem.h"

typedef NS_ENUM(NSInteger, WindowItemDeleteDirection) {
    WindowItemDeleteDirectionLeft,
    WindowItemDeleteDirectionRight,
    WindowItemDeleteDirectionTop,
    WindowItemDeleteDirectionBottom
};

@protocol  UIScrollViewWindowDelegate;
@protocol  UIScrollViewWindowDatasource;

@interface UIScrollViewWindow : UIScrollView <UIScrollViewDelegate>
{
    NSMutableArray *_arrScrollViewWindowItem;
    
    BOOL _canChanageAlpha;
}

@property (nonatomic, assign) CGFloat itemW, itemH;
@property (nonatomic, assign) CGFloat paddingLR, paddingTB;
@property (nonatomic, assign) CGFloat spaceX, spaceY;

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, weak) IBOutlet id<UIScrollViewWindowDelegate> delegateWindow;
@property (nonatomic, weak) IBOutlet id<UIScrollViewWindowDatasource> datasource;

/**
 *  激发删除的 比例 范围 [0, 1]
 */
@property (nonatomic, assign) CGFloat canRemovePercent;

- (void)reload;

- (void)addScrollViewWindowItem:(UIScrollViewWindowItem *)scrollViewWindowItem;

- (void)removeItemAtIndex:(NSInteger)index;
- (void)removeItemAtIndex:(NSInteger)index deleteDirection:(WindowItemDeleteDirection)deleteDirection;

- (void)scrollToItemIndex:(NSInteger)index withAnimated:(BOOL)animated completion:(void(^)(void))completion;

@end

@protocol  UIScrollViewWindowDelegate <NSObject>

/**
 *  选择窗口
 *
 *  @param scrollViewWindow UIScrollViewWindow
 *  @param index             索引
 */
- (void)scrollViewWindow:(UIScrollViewWindow *)scrollViewWindow didSelectFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

/**
 *  已经删除窗口
 *
 *  @param scrollViewWindow UIScrollViewWindow
 *  @param index             索引
 */
- (void)scrollViewWindow:(UIScrollViewWindow *)scrollViewWindow didRemoveAtIndex:(NSInteger)index toIndex:(NSInteger)toIndex;

/**
 *  新建网页窗口
 *
 *  @param scrollViewWindow UIScrollViewWindow
 */
- (void)scrollViewWindowWillAddNewWindow:(UIScrollViewWindow *)scrollViewWindow;

@end

@protocol  UIScrollViewWindowDatasource <NSObject>
/**
 *  窗口数量
 *
 *  @param scrollViewWindow UIScrollViewWindow
 *
 *  @return NSInteger
 */
- (NSInteger)numbersOfItemScrollViewWindow:(UIScrollViewWindow *)scrollViewWindow;

/**
 *  获取窗口 标题
 *
 *  @param scrollViewWindow    UIScrollViewWindow
 *  @param index                NSInteger 索引
 *  @return                     标题
 */
- (NSString *)scrollViewWindow:(UIScrollViewWindow *)scrollViewWindow titleAtIndex:(NSInteger)index;

/**
 *  获取窗口缩略图
 *
 *  @param scrollViewWindow    UIScrollViewWindow
 *  @param index                NSInteger 索引
 *  @return                     缩略图
 */
- (UIImage *)scrollViewWindow:(UIScrollViewWindow *)scrollViewWindow imageAtIndex:(NSInteger)index;

@end
