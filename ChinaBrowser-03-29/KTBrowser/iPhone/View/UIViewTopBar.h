//
//  UIViewTopBar.h
//  KTBrowser
//
//  Created by David on 14-2-17.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewSkin.h"

#import "UIViewTopBarDelegate.h"
#import "UIViewSearchLeft.h"

@interface UIViewTopBar : UIViewSkin <UITextFieldDelegate>
{
    IBOutlet UIImageView *_imageViewSearchCateMask;
    
    IBOutlet UIImageView *_imageViewBgBottom;
    IBOutlet UIView *_viewContain;
    IBOutlet UIImageView *_imageViewBgContain;
    IBOutlet UIButton *_btnPersonal;
    IBOutlet UIButton *_btnErWeiMa;
    IBOutlet UIButton *_btnCancel;
    IBOutlet UIViewSearchLeft *_viewSearchLeft;
    
    IBOutlet UIView *_viewFindInPage;
    IBOutlet UIButton *_btnFindCancel;
    IBOutlet UIView *_viewFindContain;
    IBOutlet UIImageView *_imageViewFindBg;
    IBOutlet UITextField *_textFieldFind;
    IBOutlet UIView *_viewFindNum;
    
    UIInputModal _inputModal;
    UIColor *_colorSearchBg;
    
    NSArray *_arrSearchOption;
    
    /**
     *  {@"cateIndex":@(), @"item":[{@"itemIndex":@()},{@"itemIndex":@()}]}
     */
    NSMutableDictionary *_dicSearchConfig;
    
    NSArray *_arrSearchCateBtn;
}

@property (nonatomic, weak) IBOutlet id<UIViewTopBarDelegate> delegate;

@property (nonatomic, strong) IBOutlet UITextField *textFieldURL;
@property (nonatomic, strong) IBOutlet UITextField *textFieldSearch;
@property (nonatomic, strong) IBOutlet UIView *viewTop;
@property (nonatomic, strong) IBOutlet UIView *viewBottom;
@property (nonatomic, strong) IBOutlet UIButton *btnBookmark;
@property (nonatomic, strong) IBOutlet UIButton *btnFindPrev;
@property (nonatomic, strong) IBOutlet UILabel *labelNum;
@property (nonatomic, strong) IBOutlet UIButton *btnFindNext;

@property (nonatomic, assign) NSInteger findIndex;
@property (nonatomic, assign) NSInteger findCount;
@property (nonatomic, assign, readonly) UIInputModal inpuModal;

/**
 *  设置书签按钮状态
 *
 *  @param state UIControlState
 */
- (void)setBookmarkState:(UIControlState)state;

- (void)toggleInputModal:(UIInputModal)inputModal animated:(BOOL)animated;

- (NSString *)getSearchLinkWithKeyword:(NSString *)keyword;

@property (nonatomic, assign) BOOL fullscreen;

- (void)setFullscreen:(BOOL)fullscreen animated:(BOOL)animated;

- (void)setCurrCateSearchIndex:(NSInteger)index;

@end
