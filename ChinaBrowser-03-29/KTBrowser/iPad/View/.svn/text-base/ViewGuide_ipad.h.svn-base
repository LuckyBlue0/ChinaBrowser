//
//  ViewGuide_ipad.h
//  BrowserApp
//
//  Created by Glex on 14-3-05.
//  Copyright (c) 2014年 arBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewGuideDelegate_ipad;

@interface ViewGuide_ipad : UIView <UIScrollViewDelegate>

@property(nonatomic, assign) id<ViewGuideDelegate_ipad> delegate;

@end

@protocol ViewGuideDelegate_ipad <NSObject>

@required
- (void)viewGuideDismiss:(ViewGuide_ipad *)viewGuide;

@end
