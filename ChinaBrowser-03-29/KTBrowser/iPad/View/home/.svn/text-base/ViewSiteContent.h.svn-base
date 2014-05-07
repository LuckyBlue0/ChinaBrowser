//
//  ViewSiteContent.h
//  KTBrowser
//
//  Created by Glex on 14-3-12.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ControlSuper_ipad.h"

#import "UIViewSkin.h"

@class ViewSiteItem;
@protocol ViewSiteContentDelegate;

/**
 *  首页中部视图：网址分类-》顶部
 */
@interface ViewSiteContent : ControlSuper_ipad {
    NSArray *_arrSite;
}

@property (nonatomic, weak) id<ViewSiteContentDelegate> objDelegate;

@property (nonatomic, assign) NSUInteger numberOfCol;
@property (nonatomic, assign, readonly) CGFloat itemWidth;
@property (nonatomic, assign, readonly) CGFloat itemHeight;

@property (nonatomic, assign, readonly) NSUInteger numberOfRow;

@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) BOOL dashLine;

@property (nonatomic, strong) UIColor *highlightColor;

- (void)setArrSite:(NSArray *)arrSite;

@end

@protocol ViewSiteContentDelegate <NSObject>

- (void)viewSiteContent:(ViewSiteContent *)viewSiteContent didSelectItem:(ViewSiteItem *)viewSiteItem;

@end