//
//  UIViewSNSOption.h
//  KTBrowser
//
//  Created by David on 14-3-3.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <ShareSDK/ShareSDKTypeDef.h>

@protocol UIViewSNSOptionDelegate;

@interface UIViewSNSOption : UIView
{
    NSMutableArray *_arrItem;
    
    IBOutlet UIView *_viewContent;
    IBOutlet UIButton *_btnCancel;
    
//    NSArray *_arrOption;
}

@property (nonatomic, weak) id<UIViewSNSOptionDelegate> delegate;

@property (nonatomic, assign) CGFloat itemW, itemH;
@property (nonatomic, assign) CGFloat minPaddingLR, paddingTB;
@property (nonatomic, assign) CGFloat spaceX, spaceY;

+ (UIViewSNSOption *)viewSNSOptionFromXib;

- (void)showInView:(UIView *)view arrShareType:(NSArray *)arrShareType completion:(void(^)())completion;
- (void)dismissWithCompletion:(void(^)(void))completion;

@end

@protocol UIViewSNSOptionDelegate <NSObject>

- (void)viewSNSOption:(UIViewSNSOption *)viewSNSOption didSelectShareTeyp:(ShareType)shareType;

@end
