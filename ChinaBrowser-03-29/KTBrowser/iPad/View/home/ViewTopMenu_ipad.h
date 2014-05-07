//
//  ViewTopMenu_ipad.h
//  BrowserApp
//
//  Created by arBao on 14-1-28.
//  Copyright (c) 2014年 arBao. All rights reserved.
//

#import "ViewSuper_ipad.h"

@class ViewTopSearch_ipad;
@class ViewTagsBar_ipad;

@interface ViewTopMenu_ipad : ViewSuper_ipad

@property (nonatomic, strong) ViewTopSearch_ipad *viewTopSearch;

@property (nonatomic, assign) BOOL clickedAddTag;

///////////////// By arBao ///////////////////////////
@property (strong, nonatomic) IBOutlet UIView *viewTools;
@property (strong, nonatomic) IBOutlet UIButton *btnPageBack;
@property (strong, nonatomic) IBOutlet ViewTagsBar_ipad *viewTagsTab;
@property (strong, nonatomic) IBOutlet UIButton *btnAddTag;

@property (strong, nonatomic) IBOutlet UIButton *btnPageFront;
@property (strong, nonatomic) IBOutlet UIButton *btnAddFav;
@property (strong, nonatomic) IBOutlet UIButton *btnHome;
@property (strong, nonatomic) IBOutlet UIView *viewUrl;
@property (strong, nonatomic) IBOutlet UITextFieldEx *txtUrl;
@property (strong, nonatomic) IBOutlet UIImageView *ivLineV;
@property (strong, nonatomic) IBOutlet UIButton *btnQRCode;
@property (strong, nonatomic) IBOutlet UIButton *btnRefresh;
@property (strong, nonatomic) IBOutlet UIButton *btnBookmarker;
@property (strong, nonatomic) IBOutlet UIButton *btnMenu;
@property (strong, nonatomic) IBOutlet UIButton *btnUser;

- (void)hideKeyboard;
- (void)setBtnsEnable:(BOOL)enable;

@end
