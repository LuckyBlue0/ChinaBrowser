//
//  UIControllerPopoverSearchOption.h
//  KTBrowser
//
//  Created by David on 14-2-26.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIControllerPopoverSearchOptionDelegate;

@interface UIControllerPopoverSearchOption : UIViewController
{
    IBOutlet UIImageView *_imageViewPop;
    IBOutlet UIView *_viewPopover;
    IBOutlet UIView *_viewContent;
}

@property (nonatomic, weak) IBOutlet id<UIControllerPopoverSearchOptionDelegate> delegate;

- (void)showInController:(UIViewController *)controller
                 options:(NSArray *)optioins
                position:(CGPoint)position
              completion:(void(^)(void))completion;
- (void)dismissWithCompletion:(void(^)(void))completion;

@end

@protocol UIControllerPopoverSearchOptionDelegate <NSObject>

- (void)controllerPopoverSearchOption:(UIControllerPopoverSearchOption *)controllerPopoverSearchOption didSelectIndex:(NSInteger)index;

@end
