//
//  UIControllerSync.h
//  WKBrowser
//
//  Created by David on 13-10-16.
//  Copyright (c) 2013年 VeryApps. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ModelUser.h"
#import "ModelUserSettings.h"
#import "ADOUserSettings.h"

#import "UIControllerProfile.h"

#import "UIViewNavBar.h"
#import "UIViewUserCell.h"

#import "ACPButton.h"

@interface UIControllerSync : UIViewController <UIActionSheetDelegate, UIControllerProfileDelegate>
{
    __weak IBOutlet UIImageView *_imageViewBg;
    __weak IBOutlet UIViewNavBar *_viewNav;
    __weak IBOutlet UIScrollView *_scrollView;
    
    __weak IBOutlet UIViewUserCell *_viewCell00;
    __weak IBOutlet UIImageView *_imageViewAvatar;
    __weak IBOutlet UILabel *_labelUsername;
    
    __weak IBOutlet UIViewUserCell *_viewCell10;
    __weak IBOutlet UILabel *_labelSyncTimeKey;
    __weak IBOutlet UILabel *_labelSyncTimeValue;
    __weak IBOutlet UIViewUserCell *_viewCell20;
    __weak IBOutlet UILabel *_labelHomeKey;
    __weak IBOutlet UISwitch *_switchHome;
    __weak IBOutlet UIViewUserCell *_viewCell21;
    __weak IBOutlet UILabel *_labelFavKey;
    __weak IBOutlet UISwitch *_switchFav;
    __weak IBOutlet UIViewUserCell *_viewCell22;
    __weak IBOutlet UILabel *_labelHistoryKey;
    __weak IBOutlet UISwitch *_switchHistory;
    
    __weak IBOutlet UIViewUserCell *_viewCell30;
    __weak IBOutlet ACPButton *_btnPersonal;
    __weak IBOutlet ACPButton *_btnSync;
    __weak IBOutlet ACPButton *_btnLogout;
}

@end
