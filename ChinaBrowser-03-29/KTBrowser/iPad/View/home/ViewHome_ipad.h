//
//  ViewHome_ipad.h
//
//  Created by arBao on 8/23/13.
//  Copyright (c) 2013 arBao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ViewSuper_ipad.h"
#import "ViewHomeItem_ipad.h"

@class ModelUrl_ipad;
@class ViewHomeSearch_ipad;

@protocol ViewHomeDelegate;

@interface ViewHome_ipad : ViewSuper_ipad

@property (nonatomic, assign) BOOL editing;
@property (nonatomic, strong) ViewHomeSearch_ipad *viewHomeSearch;
@property (nonatomic, assign) id<ViewHomeDelegate> objDelegate;

///////////// By arBao ///////////////
//@property (nonatomic, assign) TypeOfSearchBar typeOfSearchBar;
@property (strong, nonatomic) IBOutlet UIScrollView *svSites;

- (void)hideKeyboard;
- (void)addCustomItem:(ModelUrl_ipad *)model;

@end

@protocol ViewHomeDelegate <NSObject>

@required
- (void)viewHome:(ViewHome_ipad *)viewHome modelUrl:(ModelUrl_ipad *)modelUrl;
- (void)viewHomeWillAdd:(ViewHome_ipad *)viewHome;

@end
