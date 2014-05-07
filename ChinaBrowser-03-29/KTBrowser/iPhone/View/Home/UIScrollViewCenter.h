//
//  UIScrollViewCenter.h
//  KTBrowser
//
//  Created by David on 14-2-17.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewCateSiteContent.h"
#import "UIScrollViewIconSite.h"

@protocol UIScrollViewCenterDelegate;

/**
 *  首页中部可滚动的视图
 */
@interface UIScrollViewCenter : UIScrollView <UITableViewDataSource, UITableViewDelegate, UIViewCateSiteContentDelegate>
{
    UIViewCateSiteContent *_viewCateSiteContent;
    UIViewCateSiteContent *_viewCateSiteContentCell;
    IBOutlet UITableView *_tableViewCateSite;
    IBOutlet UIScrollViewIconSite *_scrollViewIconSite;
    
    NSArray *_arrHeaderSite;
    NSArray *_arrCateSite;
    NSArray *_arrIconSite;
    NSInteger _currSectionIndex;
    
    NSMutableArray *_arrViewHeader;
    NSMutableArray *_arrMostVisitedHistory;
}

@property (nonatomic, weak) IBOutlet id<UIScrollViewCenterDelegate> delegateCenter;

@end

@protocol UIScrollViewCenterDelegate <NSObject>

- (void)scrollViewCenter:(UIScrollViewCenter *)scrollViewCenter reqLink:(NSString *)link action:(ReqLinkAction)action;

@end
