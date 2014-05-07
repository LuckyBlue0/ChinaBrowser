//
//  ViewCommonSites.h
//

#import <UIKit/UIKit.h>

#import "ViewSiteContent.h"

@protocol ViewCommonSitesDelegate;

/**
 *  首页中部可滚动的视图
 */
@interface ViewCommonSites : UIScrollView <UITableViewDataSource, UITableViewDelegate, ViewSiteContentDelegate> {
    ViewSiteContent *_viewHeaderSites;
    ViewSiteContent *_viewExpandCell;
    UITableView *_tbSites;
    
    NSArray *_arrHeaderSite;
    NSArray *_arrCateSite;
    NSInteger _currSectionIndex;
    
    NSMutableArray *_arrViewHeader;
    NSMutableArray *_arrMostVisitedHistory;
}

@property (nonatomic, weak) id<ViewCommonSitesDelegate> objDelegate;

@end

@protocol ViewCommonSitesDelegate <NSObject>

- (void)viewCommonSites:(ViewCommonSites *)viewCommonSites reqLink:(NSString *)link action:(ReqLinkAction)action;

@end
