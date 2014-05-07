//
//  UIControllerBookmarkHistory.h
//  KTBrowser
//
//  Created by David on 14-3-10.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewBar.h"

@protocol UIControllerBookmarkHistoryDelegate;

@interface UIControllerBookmarkHistory : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UIImageView *_imageViewBg;
    
    IBOutlet UIViewBar *_viewBarTop;
    IBOutlet UIViewBar *_viewBarBottom;
    
    IBOutlet UIButton *_btnEdit;
    IBOutlet UIButton *_btnDone;
    IBOutlet UIButton *_btnSync;
    IBOutlet UIButton *_btnClear;
    IBOutlet UIButton *_btnBack;
    
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

@property (nonatomic, weak) IBOutlet id<UIControllerBookmarkHistoryDelegate> delegate;

@end

@protocol UIControllerBookmarkHistoryDelegate <NSObject>

- (void)controllerBookmarkHistory:(UIControllerBookmarkHistory *)controllerBookmarkHistory willRotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration;
- (void)controllerBookmarkHistory:(UIControllerBookmarkHistory *)controllerBookmarkHistory reqLink:(NSString *)link;
- (void)controllerBookmarkHistoryDidDeleteBookmark:(UIControllerBookmarkHistory *)controllerBookmarkHistory;
- (void)controllerBookmarkHistoryDidClearBookmark:(UIControllerBookmarkHistory *)controllerBookmarkHistory;

@end
