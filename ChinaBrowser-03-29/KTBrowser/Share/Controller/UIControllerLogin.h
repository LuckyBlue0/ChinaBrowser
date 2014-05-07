//
//  UIControllerLogin.h
//  WKBrowser
//
//  Created by David on 13-10-16.
//  Copyright (c) 2013年 VeryApps. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewNavBar.h"
#import "UIViewSNSItem.h"
#import "UIViewUserCell.h"

#import "ACPButton.h"

@class ASIFormDataRequest;

@interface UIControllerLogin : UIViewController <UITextFieldDelegate>
{
    
    __weak IBOutlet UIImageView *_imageViewBg;
    __weak IBOutlet UIViewNavBar *_viewNav;
    
    __weak IBOutlet UIScrollView *_scrollView;
    
    __weak IBOutlet UIViewUserCell *_viewCell00;
    __weak IBOutlet UIViewUserCell *_viewCell01;
    
    __weak IBOutlet UIViewUserCell *_viewCell10;
    
    __weak IBOutlet UILabel *_labelUsername;
    __weak IBOutlet UILabel *_labelPwd;
    
    __weak IBOutlet UITextField *_textFiledUsername;
    __weak IBOutlet UITextField *_textFiledPwd;
    
    __weak IBOutlet UIButton *_btnRemember;
    __weak IBOutlet UIButton *_btnFindPwd;
    __weak IBOutlet ACPButton *_btnLogin;
    __weak IBOutlet ACPButton *_btnRegister;
    
    __weak IBOutlet UILabel *_labelOtherLogin;
    __weak IBOutlet UIImageView *_imageViewLineLeft;
    __weak IBOutlet UIImageView *_imageViewLineRight;
    
    __weak IBOutlet UIViewSNSItem *_viewSNSItemSina;
    __weak IBOutlet UIViewSNSItem *_viewSNSItemTQQ;
    __weak IBOutlet UIViewSNSItem *_viewSNSItemQQ;
    
    __weak ASIFormDataRequest *_reqLogin;
}

@end
