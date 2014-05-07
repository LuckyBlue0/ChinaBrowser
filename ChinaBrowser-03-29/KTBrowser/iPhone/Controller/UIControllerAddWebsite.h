//
//  UIControllerAddWebsite.h
//  KTBrowser
//
//  Created by David on 14-3-10.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewBar.h"

@protocol UIControllerAddWebsiteDelegate;

@interface UIControllerAddWebsite : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    IBOutlet UIImageView *_imageViewBg;
    
    IBOutlet UIViewBar *_viewBarTop;
    IBOutlet UIViewBar *_viewBarBottom;
    
    IBOutlet UITextField *_textFieldTitle;
    IBOutlet UITextField *_textFieldUrl;
    
    IBOutlet UIButton *_btnBookmark;
    IBOutlet UIButton *_btnHistory;
    IBOutlet UIImageView *_imageViewMask;
    
    IBOutlet UITableView *_tableView;
    
    NSMutableArray *_arrBookmark;
    NSMutableArray *_arrArrHistory;
    
    UrlType _urlType;
    NSMutableArray *_arrViewHeader;
    NSInteger _currSectionIndex;
}

@property (nonatomic, weak) IBOutlet id<UIControllerAddWebsiteDelegate> delegate;

@end

@protocol UIControllerAddWebsiteDelegate <NSObject>

- (void)controllerAddWebsite:(UIControllerAddWebsite *)controllerAddWebsite title:(NSString *)title link:(NSString *)link;
- (void)controllerAddWebsite:(UIControllerAddWebsite *)controllerAddWebsite willRotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration;

@end
