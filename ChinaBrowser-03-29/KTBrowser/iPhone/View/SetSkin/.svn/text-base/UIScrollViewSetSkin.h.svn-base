//
//  UIScrollViewSetSkin.h
//  ChinaBrowser
//
//  Created by David on 14-3-17.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewSetSkinItem.h"

#import "ModelSkin.h"

@protocol UIScrollViewSetSkinDelegate;

@interface UIScrollViewSetSkin : UIScrollView
{
    NSMutableArray *_arrViewItem;
    
    CGFloat _colCount;
    CGFloat _rowCount;
    
    UIViewSetSkinItem *_viewSetSkinItemAdd;
    
    NSMutableArray *_arrSkin;
    NSInteger _sysItemCount;
}

@property (nonatomic, weak) IBOutlet id<UIScrollViewSetSkinDelegate> delegateSetSkin;

@property (nonatomic, assign) CGFloat itemW, itemH;
@property (nonatomic, assign) CGFloat minPaddingLR, paddingTB;
@property (nonatomic, assign) CGFloat spaceX, spaceY;
@property (nonatomic, assign) BOOL edit;

- (void)addItemWithModel:(ModelSkin *)model;

- (void)removeItemAtIndex:(NSInteger)index;
- (void)removeItem:(UIViewSetSkinItem *)viewSetSkinItem;
- (void)removeAll;

- (void)setArrSkin:(NSArray *)arrSkin;
- (void)appendArrSkin:(NSArray *)arrSkin;

@end

@protocol UIScrollViewSetSkinDelegate <NSObject>

- (void)scrollViewSetSkin:(UIScrollViewSetSkin *)scrollViewSetSkin selectSkinImagePath:(NSString *)skinImagePath;
- (void)scrollViewSetSkinWillAddSkin:(UIScrollViewSetSkin *)scrollViewSetSkin;

@end
