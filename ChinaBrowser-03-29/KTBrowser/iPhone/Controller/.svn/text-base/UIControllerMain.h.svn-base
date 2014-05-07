//
//  UIControllerMain.h
//  KTBrowser
//
//  Created by David on 14-2-13.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewToolBar.h"
#import "UIViewToolBarDelegate.h"
#import "UIScrollViewCenter.h"
#import "UIScrollViewIconSite.h"
#import "UIViewTopBar.h"
#import "UIControllerMenu.h"
#import "UIControllerInputUrl.h"
#import "UIControllerInputSearch.h"
#import "UIControllerPopoverSearchOption.h"
#import "UIViewSNSOption.h"
#import "UIViewHome.h"
#import "SMPageControl.h"
#import "UIControllerAddWebsite.h"
#import "UIControllerBookmarkHistory.h"
#import "UIControllerQRCode.h"
#import "UIControllerSetSkin.h"

#import "UIViewSetFontDelegate.h"
#import "UIControllerWindows.h"
#import "UIWebPage.h"

@interface UIControllerMain : UIViewController
<UIViewTopBarDelegate,
UIViewToolBarDelegate,
UIControllerMenuDelegate,
UIControllerInputSearchDelegate,
UIControllerInputUrlDelegate,
UIControllerPopoverSearchOptionDelegate,
UIViewSNSOptionDelegate,
UIScrollViewCenterDelegate,
UIScrollViewIconSiteDelegate,
UIControllerAddWebsiteDelegate,
UIWebViewDelegate,
UIControllerBookmarkHistoryDelegate,
UIControllerQRCodeDelegate,
UIControllerSetSkinDelegate,
UIViewSetFontDelegate,
UIWebPageDelegate,
UIScrollViewWindowDatasource,
UIControllerWindowsDelegate> {
    
    IBOutlet UIImageView *_imageViewBg;
    IBOutlet UIView *_viewContain;
    
    // 顶部
    IBOutlet UIViewTopBar *_viewTopBar;
    
    // 中间
    IBOutlet UIViewHome *_viewHome;
    IBOutlet UIScrollViewIconSite *_scrollViewIconSite;
    IBOutlet SMPageControl *_pageControl;
    
    // 底部
    IBOutlet UIViewToolBar *_viewToolBar;
    
    //-----------------
    UIControllerPopoverSearchOption *_controllerPopoverSearchOption;
    UIControllerMenu *_controllerMenu;
    
    UIControllerInputSearch *_controllerInputSearch;
    UIControllerInputUrl *_controllerInputUrl;
    
    // --------------- 网页相关
    NSMutableArray *_arrWebPage;
    UIWebPage *_currWebPage;
    
    // 当前显示的主体 部分，可能是_currWebView或_viewHome
    UIView *_currMainView;
}

@end
