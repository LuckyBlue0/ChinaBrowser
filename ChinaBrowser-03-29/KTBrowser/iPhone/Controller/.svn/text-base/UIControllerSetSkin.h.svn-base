//
//  UIControllerSetSkin.h
//  ChinaBrowser
//
//  Created by David on 14-3-14.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewBar.h"
#import "UIScrollViewSetSkin.h"

@protocol UIControllerSetSkinDelegate;

@interface UIControllerSetSkin : UIViewController <UIScrollViewSetSkinDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    IBOutlet UIImageView *_imageViewBg;
    IBOutlet UIViewBar *_viewBarTop;
    IBOutlet UIViewBar *_viewBarBottom;
    
    IBOutlet UIScrollViewSetSkin *_scrollView;
    
    IBOutlet UILabel *_labelTitle;
    IBOutlet UIButton *_btnCancel;
    
    NSString *_skinImagePath;
}

@property (nonatomic, weak) IBOutlet id<UIControllerSetSkinDelegate> delegate;

@end

@protocol UIControllerSetSkinDelegate <NSObject>

- (void)controllerSetSkin:(UIControllerSetSkin *)controllerSetSkin willRotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration;
- (void)controllerSetSkinDidChanageSkin:(UIControllerSetSkin *)controllerSetSkin;

@end
