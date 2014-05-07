//
//  ViewHomeSearch.h
//
//  Created by Glex on 14-3-07.
//  Copyright (c) 2014年 arBao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ViewSuper_ipad.h"

@class ModelUrl_ipad;
@class ControllerSuper_ipad;
@protocol ViewHomeSearchDelegate_ipad;

@interface ViewHomeSearch_ipad : ViewSuper_ipad <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) ControllerSuper_ipad<ViewHomeSearchDelegate_ipad> *objDelegate;

- (void)fixSubviews;
- (void)hideKeyboard;

@end

@protocol ViewHomeSearchDelegate_ipad <NSObject>

@required
- (void)viewHomeSearch:(ViewHomeSearch_ipad *)view openUrl:(NSString *)url;

@end
