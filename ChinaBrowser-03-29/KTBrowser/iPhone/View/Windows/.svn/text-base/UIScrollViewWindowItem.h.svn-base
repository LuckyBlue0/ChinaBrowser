//
//  UIScrollViewWindowItem.h
//  ChinaBrowser
//
//  Created by David on 14-3-20.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UILayoutDirection) {
    UILayoutDirectionHorizontal,
    UILayoutDirectionVertical
};

@interface UIScrollViewWindowItem : UIScrollView
{
    IBOutlet UIImageView *_imageViewMask;
}

@property (nonatomic, strong) IBOutlet UIControl *viewWindItem;
@property (nonatomic, strong) IBOutlet UILabel *labelTitle;
@property (nonatomic, strong) IBOutlet UIButton *btnDel;
@property (nonatomic, strong) IBOutlet UIImageView *imageViewThumb;
@property (nonatomic, strong) IBOutlet UIView *viewThumb;

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, assign) UILayoutDirection layoutDirection;

+ (UIScrollViewWindowItem *)scrollViewWindowItemFromXib;

@end
