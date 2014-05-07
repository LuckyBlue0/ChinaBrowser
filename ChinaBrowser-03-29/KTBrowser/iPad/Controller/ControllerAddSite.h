//
//  ControllerAddSite.h
//
//  Created by uta002 on 8/29/13.
//  Copyright (c) 2013 arBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VcAddSiteDelegate;

@interface ControllerAddSite : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) UIViewController<VcAddSiteDelegate> *delegate;

- (void)showSubviews:(BOOL)show;

@end

@protocol VcAddSiteDelegate <NSObject>

- (void)vcAddSite:(ControllerAddSite *)vcAddSite title:(NSString *)title url:(NSString *)url;

@end












