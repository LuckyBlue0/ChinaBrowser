//
//  UIControllerMenu.h
//  KTBrowser
//
//  Created by David on 14-2-20.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewMenuItem.h"

@class CALayer;
@protocol UIControllerMenuDelegate;

@interface UIControllerMenu : UIViewController <UIScrollViewDelegate>
{
    IBOutlet UIView *_viewMenu;
    IBOutlet UIImageView *_imageViewBgL;
    IBOutlet UIImageView *_imageViewBgM;
    IBOutlet UIImageView *_imageViewBgR;
    
    IBOutlet UIScrollView *_scrollView;
    IBOutlet UIButton *_btnCommonly;
    IBOutlet UIButton *_btnSettings;
    IBOutlet UIButton *_btnTools;
    
    IBOutlet UIImageView *_imageViewLine;
    IBOutlet UIImageView *_imageViewMask;
    
    // * 表示有状态区分的
    UIViewMenuItem *_viewMenuBookmarkAction;    // *
    UIViewMenuItem *_viewMenuRefresh;           // *
    UIViewMenuItem *_viewMenuDayNightModal;     // *
    UIViewMenuItem *_viewMenuNoImage;           // *
    UIViewMenuItem *_viewMenuNoSaveHistory;     // *
    UIViewMenuItem *_viewMenuRotate;            // *
    UIViewMenuItem *_viewMenuFullscreen;        // *
    UIViewMenuItem *_viewMenuFindInPage;        // *
    UIViewMenuItem *_viewMenuSetFont;           // *
}

@property (nonatomic, weak) IBOutlet id<UIControllerMenuDelegate> delegate;

- (void)showInController:(UIViewController *)controller completion:(void(^)(void))completion position:(CGPoint)position;
- (void)dismissWithCompletion:(void(^)(void))completion;

- (void)setBookmarkActionState:(UIControlState)state;

- (void)enableMenuItem:(BOOL)enable;

@end

@protocol UIControllerMenuDelegate <NSObject>

- (void)controllerMenu:(UIControllerMenu *)controllerMenu seletedMenuItem:(UIViewMenuItem *)menuItem;
- (void)controllerMenuDidDismiss:(UIControllerMenu *)controllerMenu;

@end
