//
//  UIScrollViewIconSite.h
//  KTBrowser
//
//  Created by David on 14-2-19.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewSkin.h"

#import "UIViewIconWebItem.h"

#import "ModelFavorite.h"

@protocol UIScrollViewIconSiteDelegate;

/**
 *  首页中部可滚动视图：图标网址部分
 */
@interface UIScrollViewIconSite : UIScrollView
{
    NSMutableArray *_arrViewItem;
    
    CGFloat _colCount;
    CGFloat _rowCount;
    
    UIViewIconWebItem *_viewIconWebItemAdd;
    
    NSMutableArray *_arrSite;
    NSInteger _sysItemCount;
}

@property (nonatomic, weak) IBOutlet id<UIScrollViewIconSiteDelegate> delegateIconSite;

@property (nonatomic, assign) CGFloat itemW, itemH;
@property (nonatomic, assign) CGFloat minPaddingLR, paddingTB;
@property (nonatomic, assign) CGFloat spaceX, spaceY;
@property (nonatomic, assign) BOOL edit;

- (void)addIconWebWithIcon:(UIImage *)image title:(NSString *)title;
- (void)addIconWeb:(UIViewIconWebItem *)viewIconWebItem;
- (void)addIconWebWithModel:(ModelFavorite *)model;

- (void)removeItemAtIndex:(NSInteger)index;
- (void)removeItem:(UIViewIconWebItem *)viewIconWebItem;
- (void)removeAll;

- (void)setArrSite:(NSArray *)arrSite;
- (void)appendArrSite:(NSArray *)arrSite;

@end

@protocol UIScrollViewIconSiteDelegate <NSObject>

- (void)scrollViewIconSite:(UIScrollViewIconSite *)scrollViewIconSite iconSiteEvent:(IconSiteEvent)iconSiteEvent;
- (void)scrollViewIconSite:(UIScrollViewIconSite *)scrollViewIconSite reqLink:(NSString *)link action:(ReqLinkAction)action;

@end
