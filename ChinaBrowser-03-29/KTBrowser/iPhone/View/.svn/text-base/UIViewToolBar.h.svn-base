//
//  UIViewToolBar.h
//  KTBrowser
//
//  Created by David on 14-2-14.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewSkin.h"

#import "UIViewToolBarDelegate.h"

@interface UIViewToolBar : UIViewSkin
{
    IBOutlet UIButton *_btnEditDone;
    
    IBOutlet UILabel *_labelNumb;
}

@property (nonatomic, weak) IBOutlet id<UIViewToolBarDelegate> delegate;

@property (nonatomic, strong) IBOutlet UIButton *btnStop;
@property (nonatomic, strong) IBOutlet UIButton *btnGoBack;
@property (nonatomic, strong) IBOutlet UIButton *btnGoForward;
@property (nonatomic, strong) IBOutlet UIButton *btnMenu;
@property (nonatomic, strong) IBOutlet UIButton *btnWindows;
@property (nonatomic, strong) IBOutlet UIButton *btnHome;

@property (nonatomic, assign) NSInteger windowsNumber;

- (void)setWindowsNumber:(NSInteger)windowsNumber animated:(BOOL)animated;

/**
 *  现实编辑完成按钮
 *
 *  @param show 是否现实 完成按钮
 */
- (void)showEditDone:(BOOL)show;

@end
