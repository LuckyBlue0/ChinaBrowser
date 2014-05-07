//
//  ViewSkin.h
//  ChinaBrowser
//
//  Created by Glex on 14-3-27.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ViewSuper_ipad.h"

@interface ViewSkin : ViewSuper_ipad <UIAlertViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, assign) BOOL editing;

- (void)animateItems;
- (void)changeBlurImage;

@end
