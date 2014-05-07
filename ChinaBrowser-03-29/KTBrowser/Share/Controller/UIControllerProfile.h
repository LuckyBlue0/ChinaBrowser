//
//  UIControllerProfile.h
//  WKBrowser
//
//  Created by David on 13-11-5.
//  Copyright (c) 2013年 VeryApps. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ACPButton.h"
#import "UIViewNavBar.h"
#import "UIViewUserCell.h"

@class ASIFormDataRequest;
@protocol UIControllerProfileDelegate;

@interface UIControllerProfile : UIViewController
<UITextFieldDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UIActionSheetDelegate>
{
    __weak IBOutlet UIImageView *_imageViewBg;
    
    __weak IBOutlet UIViewNavBar *_viewNav;
    __weak IBOutlet UIScrollView *_scrollView;
    
    __weak IBOutlet UIButton *_btnImageAvatar;
    
    __weak IBOutlet UILabel *_labelSectionHeader0;
    __weak IBOutlet UILabel *_labelSectionFooter0;
    
    __weak IBOutlet UIViewUserCell *_viewCell00;
    __weak IBOutlet UIViewUserCell *_viewCell01;
    
    __weak IBOutlet UILabel *_labelUsername;
    __weak IBOutlet UILabel *_labelNickname;
    
    __weak IBOutlet UITextField *_textFiledUsername;
    __weak IBOutlet UITextField *_textFiledNickname;
    
    __weak IBOutlet UILabel *_labelSectionHeader1;
    __weak IBOutlet UILabel *_labelSectionFooter1;
    
    __weak IBOutlet UIViewUserCell *_viewCell10;
    __weak IBOutlet UIViewUserCell *_viewCell11;
    __weak IBOutlet UIViewUserCell *_viewCell12;
    
    __weak IBOutlet UILabel *_labelOldPwd;
    __weak IBOutlet UILabel *_labelNewPwd;
    __weak IBOutlet UILabel *_labelNewPwd2;
    
    __weak IBOutlet UITextField *_textFiledPwdOld;
    __weak IBOutlet UITextField *_textFiledPwdNew;
    __weak IBOutlet UITextField *_textFiledPwdNew2;
    
    __weak IBOutlet ACPButton *_btnSubmit;
    
    
    __weak ASIFormDataRequest *_reqModify;
}

@property (nonatomic, assign) id<UIControllerProfileDelegate> delegate;

@end


@protocol UIControllerProfileDelegate <NSObject>

- (void)controllerProfileDidModify:(UIControllerProfile *)controller;

@end