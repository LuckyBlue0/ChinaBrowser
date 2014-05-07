//
//  ViewTopSearch.h
//
//  Created by Glex on 14-3-07.
//  Copyright (c) 2014年 arBao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ViewSuper_ipad.h"

@class ModelUrl_ipad;
@class ControllerSuper_ipad;
@protocol ViewTopSearchDelegate_ipad;

@interface ViewTopSearch_ipad : ViewSuper_ipad <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) ControllerSuper_ipad<ViewTopSearchDelegate_ipad> *objDelegate;

- (void)hideKeyboard;
- (void)searchWithKeyword:(NSString *)keyword;

@end

@protocol ViewTopSearchDelegate_ipad <NSObject>

@required
- (void)viewTopSearch:(ViewTopSearch_ipad *)view openUrl:(NSString *)url;

@end
