//
//  UIViewCateSiteContent.h
//  KTBrowser
//
//  Created by David on 14-2-17.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewSkin.h"

@class UIViewCateSiteItem;
@protocol UIViewCateSiteContentDelegate;

/**
 *  首页中部视图：网址分类-》顶部
 */
@interface UIViewCateSiteContent : UIControl
{
    NSArray *_arrSite;
}

@property (nonatomic, weak) id<UIViewCateSiteContentDelegate> delegate;

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

@protocol UIViewCateSiteContentDelegate <NSObject>

- (void)viewCateSiteContent:(UIViewCateSiteContent *)viewCateSiteContent didSelectItem:(UIViewCateSiteItem *)viewCateSiteItem;

@end
