//
//  UIViewTopBar.m
//  KTBrowser
//
//  Created by David on 14-2-17.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewTopBar.h"

#import <AGCommon/UIImage+Common.h>
#import "NSString+URL.h"
#import <AGCommon/NSString+Common.h>
#import "UITextInputUtil.h"
#import "ViewIndicator.h"

@interface UIViewTopBar ()

- (void)onTouchItem:(UIButton *)btnItem;

- (void)resizeUIWithAnimated:(BOOL)animated completion:(void(^)())completion;

- (void)initSearchOption;

- (IBAction)onTouchEWM;
- (IBAction)onTouchBookmark;
- (IBAction)onTouchSearchIcon;
- (IBAction)onTouchPersonal;
- (IBAction)onTouchCancel;
- (IBAction)onTouchCancelFind;

- (IBAction)onTouchFindPrev;
- (IBAction)onTouchFindNext;

- (void)resizeFindView;

@end

@implementation UIViewTopBar

- (void)setFindCount:(NSInteger)findCount
{
    _findCount = findCount;
    if (_findCount==0) {
        _labelNum.text = @"0";
    }
    else {
        _labelNum.text = [NSString stringWithFormat:@"%d/%d", _findIndex+1, _findCount];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [self resizeFindView];
    }];
}

- (void)setFindIndex:(NSInteger)findIndex
{
    if (findIndex<0 || findIndex>=_findCount) {
        return;
    }
    _findIndex = findIndex;
    if (_findCount==0) {
        _labelNum.text = @"0";
    }
    else {
        _labelNum.text = [NSString stringWithFormat:@"%d/%d", _findIndex+1, _findCount];
    }
    
    if (_findIndex==0) {
        _btnFindPrev.enabled = NO;
    }
    else {
        _btnFindPrev.enabled = YES;
    }
    if (_findIndex>=_findCount-1) {
        _btnFindNext.enabled = NO;
    }
    else {
        _btnFindNext.enabled = YES;
    }
    
    if (_findCount==1) {
        _btnFindPrev.enabled = _btnFindNext.enabled = NO;
    }
}

- (UIInputModal)inpuModal
{
    return _inputModal;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
 */

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // add event
    for (UIButton *item in _viewTop.subviews) {
        if ([item isKindOfClass:[UIButton class]]) {
            [item addTarget:self action:@selector(onTouchItem:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0];
    [_btnCancel setTitle:NSLocalizedString(@"cancel", @"Cancel") forState:UIControlStateNormal];
    [_btnFindCancel setTitle:NSLocalizedString(@"cancel", @"Cancel") forState:UIControlStateNormal];
    
    _textFieldFind.placeholder = _textFieldSearch.placeholder = NSLocalizedString(@"search", nil);
    _textFieldURL.placeholder = NSLocalizedString(@"input_url_or_qrcode", nil);
    
    [self updateUIMode];
    [self toggleInputModal:UIInputModalNone animated:NO];
    
    [self initSearchOption];
}

- (void)updateUIMode
{
    [super updateUIMode];
    
    
    NSInteger key = [AppConfig config].uiMode==UIModeDay?0:1;
    _imageViewBgContain.image = [[UIImage imageWithFilename:[NSString stringWithFormat:@"top.bundle/%d_search_txt_bg.png", key]]
                                 stretchableImageWithLeftCapWidth:10
                                 topCapHeight:10];
    _imageViewFindBg.image = _imageViewBgContain.image;
    
    [_btnPersonal setBackgroundImage:_imageViewBgContain.image forState:UIControlStateNormal];
    [_btnCancel setBackgroundImage:_imageViewBgContain.image forState:UIControlStateNormal];
    [_btnFindCancel setBackgroundImage:_imageViewBgContain.image forState:UIControlStateNormal];
    
    _imageViewBgBottom.image = [[UIImage imageWithFilename:[NSString stringWithFormat:@"top.bundle/%d_search_bg.png", key]]
                                stretchableImageWithLeftCapWidth:10
                                topCapHeight:44];
    _imageViewSearchCateMask.image = [UIImage imageWithFilename:[NSString stringWithFormat:@"top.bundle/%d_search.png", key]];
    
    [_btnErWeiMa setImage:[UIImage imageWithFilename:[NSString stringWithFormat:@"top.bundle/%d_btn_erwei.png", key]]
                 forState:UIControlStateNormal];
    
    [_btnPersonal setImage:[UIImage imageWithFilename:[NSString stringWithFormat:@"top.bundle/%d_btn_user.png", key]]
              forState:UIControlStateNormal];
    
    [_btnBookmark setImage:[UIImage imageWithFilename:[NSString stringWithFormat:@"top.bundle/%d_btn_collect.png", key]]
                  forState:UIControlStateNormal];
    [_btnBookmark setImage:[UIImage imageWithFilename:@"top.bundle/btn_collect_1.png"] forState:UIControlStateSelected];
    
    _textFieldSearch.leftView = _viewSearchLeft;
    _textFieldSearch.leftViewMode = UITextFieldViewModeAlways;
    
    if (_inputModal==UIInputModalSearch) {
        NSInteger key = [AppConfig config].uiMode==UIModeDay?0:1;
        _imageViewBgContain.image = [[UIImage imageWithFilename:[NSString stringWithFormat:@"top.bundle/%d_search_txt_bg.png", key]]
                                     stretchableImageWithLeftCapWidth:10
                                     topCapHeight:10];
        [_btnPersonal setBackgroundImage:_imageViewBgContain.image forState:UIControlStateNormal];
        [_btnCancel setBackgroundImage:_imageViewBgContain.image forState:UIControlStateNormal];
    }
    else {
        NSInteger key = [AppConfig config].uiMode==UIModeDay?0:1;
        _imageViewBgContain.image = [[UIImage imageWithFilename:[NSString stringWithFormat:@"top.bundle/%d_bg.png", key]]
                                     stretchableImageWithLeftCapWidth:10
                                     topCapHeight:10];
        [_btnPersonal setBackgroundImage:_imageViewBgContain.image forState:UIControlStateNormal];
        [_btnCancel setBackgroundImage:_imageViewBgContain.image forState:UIControlStateNormal];
    }
    
    if ([AppConfig config].uiMode==UIModeDay) {
        _textFieldSearch.textColor =
        _textFieldURL.textColor = [UIColor colorWithWhite:0.2 alpha:1];
        _textFieldFind.textColor = _labelNum.textColor = _textFieldURL.textColor;
        
        [_btnCancel setTitleColor:_textFieldSearch.textColor forState:UIControlStateNormal];
        
        [_btnFindPrev setBackgroundImage:[UIImage imageWithFilename:@"tab.bundle/tab_0_0.png"] forState:UIControlStateNormal];
        [_btnFindNext setBackgroundImage:[UIImage imageWithFilename:@"tab.bundle/tab_1_0.png"] forState:UIControlStateNormal];
        
        [_textFieldURL setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
        [_textFieldSearch setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
        [_textFieldFind setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    }
    else {
        _textFieldURL.textColor = [UIColor colorWithWhite:0.9 alpha:1];
        
        if (_inputModal==UIInputModalSearch) {
            _textFieldSearch.textColor = [UIColor blackColor];
        }
        else {
            _textFieldSearch.textColor = _textFieldURL.textColor;
        }
        
        _textFieldFind.textColor = _labelNum.textColor = _textFieldURL.textColor;
        [_btnCancel setTitleColor:_textFieldSearch.textColor forState:UIControlStateNormal];
        
        [_btnFindPrev setBackgroundImage:[UIImage imageWithFilename:@"tab.bundle/tab_0_1.png"] forState:UIControlStateNormal];
        [_btnFindNext setBackgroundImage:[UIImage imageWithFilename:@"tab.bundle/tab_1_1.png"] forState:UIControlStateNormal];
        
        [_textFieldURL setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        [_textFieldSearch setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        [_textFieldFind setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    }
    
    for (UIButton *item in _viewTop.subviews) {
        if ([item isKindOfClass:[UIButton class]]) {
            if ([AppConfig config].uiMode==UIModeDay) {
                [item setTitleColor:[UIColor colorWithWhite:0.5 alpha:1] forState:UIControlStateDisabled];
                [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            else {
                [item setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
                [item setTitleColor:[UIColor colorWithWhite:0.5 alpha:1] forState:UIControlStateNormal];
            }
        }
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    void (^anim)() = ^{
        CGRect rc;
        switch (_inputModal) {
            case UIInputModalNone:
            {
                rc = _btnErWeiMa.frame;
                rc.origin.x = -rc.size.width-10;
                _btnErWeiMa.frame = rc;
                
                rc = _btnCancel.frame;
                rc.origin.x = self.bounds.size.width+10;
                _btnCancel.frame = rc;
                
                rc = _btnPersonal.frame;
                rc.origin.x = self.bounds.size.width-rc.size.width-5;
                _btnPersonal.frame = rc;
                
                rc = _viewContain.frame;
                rc.origin.x = 5;
                rc.size.width = _btnPersonal.frame.origin.x-rc.origin.x-5;
                _viewContain.frame = rc;
                
                rc = _btnBookmark.frame;
                rc.origin.x = 0;
                _btnBookmark.frame = rc;
                
                rc = _textFieldSearch.frame;
                rc.size.width = 75;
                rc.origin.x = _viewContain.bounds.size.width-rc.size.width-3;
                _textFieldSearch.frame = rc;
                
                rc = _textFieldURL.frame;
                rc.origin.x = _btnBookmark.frame.origin.x+_btnBookmark.bounds.size.width;
                rc.size.width = _textFieldSearch.frame.origin.x-rc.origin.x;
                _textFieldURL.frame = rc;
            }
                break;
            case UIInputModalURL:
            {
                rc = _btnErWeiMa.frame;
                rc.origin.x = 5;
                _btnErWeiMa.frame = rc;
                
                rc = _btnCancel.frame;
                rc.origin.x = self.bounds.size.width-rc.size.width-5;
                _btnCancel.frame = rc;
                
                rc = _btnPersonal.frame;
                rc.origin.x = self.bounds.size.width+10;
                _btnPersonal.frame = rc;
                
                rc = _viewContain.frame;
                rc.origin.x = _btnErWeiMa.frame.origin.x+_btnErWeiMa.bounds.size.width;
                rc.size.width = _btnCancel.frame.origin.x-rc.origin.x-5;
                _viewContain.frame = rc;
                
                rc = _btnBookmark.frame;
                rc.origin.x = -rc.size.width-10;
                _btnBookmark.frame = rc;
                
                rc = _textFieldSearch.frame;
                rc.origin.x = _viewContain.bounds.size.width+10;
                _textFieldSearch.frame = rc;
                
                rc = _textFieldURL.frame;
                rc.origin.x = 5;
                rc.size.width = _viewContain.bounds.size.width-3-rc.origin.x;
                _textFieldURL.frame = rc;
            }
                break;
            case UIInputModalSearch:
            {
                rc = _btnErWeiMa.frame;
                rc.origin.x = -rc.size.width-10;
                _btnErWeiMa.frame = rc;
                
                rc = _btnCancel.frame;
                rc.origin.x = self.bounds.size.width-rc.size.width-5;
                _btnCancel.frame = rc;
                
                rc = _btnPersonal.frame;
                rc.origin.x = self.bounds.size.width+10;
                _btnPersonal.frame = rc;
                
                rc = _viewContain.frame;
                rc.origin.x = 5;
                rc.size.width = _btnCancel.frame.origin.x-rc.origin.x-5;
                _viewContain.frame = rc;
                
                rc = _btnBookmark.frame;
                rc.origin.x = -rc.size.width-10;
                _btnBookmark.frame = rc;
                
                rc = _textFieldURL.frame;
                rc.size.width = 50;
                rc.origin.x = -rc.size.width-10;
                _textFieldURL.frame = rc;
                
                rc = _textFieldSearch.frame;
                rc.origin.x = 5;
                rc.size.width = _viewContain.bounds.size.width-3-rc.origin.x;
                _textFieldSearch.frame = rc;
            }
                break;
                
            case UIInputModalFindInPage:
            {
            }
                break;
                
            default:
                break;
        }
    };
    
    anim();
}

#pragma mark - public
- (void)setFullscreen:(BOOL)fullscreen
{
    [self setFullscreen:fullscreen animated:NO];
}

- (void)setFullscreen:(BOOL)fullscreen animated:(BOOL)animated
{
    _fullscreen = fullscreen;
    [self resizeUIWithAnimated:animated completion:nil];
}

- (void)setCurrCateSearchIndex:(NSInteger)index
{
    NSInteger cateIndex = [_dicSearchConfig[@"cateIndex"] integerValue];
    NSMutableDictionary *dicSearchItem = _dicSearchConfig[@"item"][cateIndex];
    [dicSearchItem setObject:@(index) forKey:@"itemIndex"];
    NSDictionary *dicSearch = _arrSearchOption[cateIndex][@"item"][index];
    [_viewSearchLeft.btnIcon setImage:[UIImage imageWithFilename:[NSString stringWithFormat:@"Search.bundle/%@.png", dicSearch[@"icon"]]]
                             forState:UIControlStateNormal];
    
    [AppConfig config].dicSearchConfig = _dicSearchConfig;
}

/**
 *  设置书签按钮状态
 *
 *  @param state UIControlState
 */
- (void)setBookmarkState:(UIControlState)state
{
    if (UIControlStateNormal==state) {
        _btnBookmark.selected = NO;
        _btnBookmark.enabled = YES;
        _btnBookmark.highlighted = NO;
    }
    else if (UIControlStateDisabled==state) {
        _btnBookmark.enabled = NO;
    }
    else if (UIControlStateSelected==state) {
        _btnBookmark.selected = YES;
    }
}

#pragma mark - private
- (void)onTouchItem:(UIButton *)btnItem
{
    [UIView animateWithDuration:0.3 animations:^{
        for (UIButton *item in _viewTop.subviews) {
            if ([item isKindOfClass:[UIButton class]]) {
                item.enabled = item!=btnItem;
            }
        }
        
        CGPoint center =  _imageViewSearchCateMask.center;
        center.x = btnItem.center.x;
        _imageViewSearchCateMask.center = center;
        
    } completion:nil];
    
    NSInteger cateIndex = btnItem.tag;
    NSArray *arrSearchItemIndex = _dicSearchConfig[@"item"];
    NSInteger searchItemIndex = [arrSearchItemIndex[cateIndex][@"itemIndex"] integerValue];
    NSDictionary *dicSearch = _arrSearchOption[cateIndex][@"item"][searchItemIndex];
    [_viewSearchLeft.btnIcon setImage:[UIImage imageWithFilename:[NSString stringWithFormat:@"Search.bundle/%@.png", dicSearch[@"icon"]]]
                             forState:UIControlStateNormal];
    
    [_dicSearchConfig setObject:@(cateIndex) forKey:@"cateIndex"];
    [AppConfig config].dicSearchConfig = _dicSearchConfig;
}

- (void)toggleInputModal:(UIInputModal)inputModal animated:(BOOL)animated
{
    if (UIInputModalFindInPage!=inputModal) {
        // 退出查找 模式
        _findCount = 0;
        _findIndex = 0;
        _labelNum.text = nil;
        [self resizeFindView];
    }
    
    UIInputModal inputModalOld = _inputModal;
    
    _inputModal = inputModal;
    
    [_delegate viewTopBar:self willToggleInpuModal:inputModal];
    
    [self resizeUIWithAnimated:animated completion:^{
        if ([_delegate respondsToSelector:@selector(viewTopBar:didToggleInpuModal:)]) {
            [_delegate viewTopBar:self didToggleInpuModal:_inputModal];
        }
    }];
    
    if (inputModalOld!=UIInputModalFindInPage && inputModal==UIInputModalFindInPage) {
        // 进入 查找模式
        [_delegate viewTopBarWillToggleToFindInPage:self];
    }
    else if (inputModalOld==UIInputModalFindInPage && inputModal!=UIInputModalFindInPage) {
        // 退出 查找模式
        [_delegate viewTopBarWillToggleToNotFindInPage:self];
    }
    
    if (inputModal==UIInputModalFindInPage) {
        _textFieldFind.text = nil;
        [_textFieldFind becomeFirstResponder];
    }
}

- (void)resizeUIWithAnimated:(BOOL)animated completion:(void(^)())completion
{
    void (^anim)() = ^{
        CGRect rc;
        switch (_inputModal) {
            case UIInputModalNone:
            {
                NSInteger key = [AppConfig config].uiMode==UIModeDay?0:1;
                _imageViewBgContain.image = [[UIImage imageWithFilename:[NSString stringWithFormat:@"top.bundle/%d_bg.png", key]]
                                             stretchableImageWithLeftCapWidth:10
                                             topCapHeight:10];
                [_btnPersonal setBackgroundImage:_imageViewBgContain.image forState:UIControlStateNormal];
                [_btnCancel setBackgroundImage:_imageViewBgContain.image forState:UIControlStateNormal];
                
                [_viewSearchLeft showMagnifierIcon];
                
                _viewBottom.alpha = 1;
                _imageViewBgBottom.alpha = _viewTop.alpha = 0;
                _viewFindInPage.alpha = 0;
                _viewFindInPage.hidden = YES;
                // self.backgroundColor = [UIColor clearColor];
                
                if ([AppConfig config].uiMode==UIModeDay) {
                    _textFieldSearch.textColor =
                    _textFieldURL.textColor = [UIColor colorWithWhite:0.2 alpha:1];
                }
                else {
                    _textFieldSearch.textColor =
                    _textFieldURL.textColor = [UIColor colorWithWhite:0.9 alpha:1];
                }
                
                rc = self.bounds;
                rc.size.height = _viewBottom.bounds.size.height;
            }
                break;
            case UIInputModalURL:
            {
                NSInteger key = [AppConfig config].uiMode==UIModeDay?0:1;
                _imageViewBgContain.image = [[UIImage imageWithFilename:[NSString stringWithFormat:@"top.bundle/%d_bg.png", key]]
                                             stretchableImageWithLeftCapWidth:10
                                             topCapHeight:10];
                [_btnPersonal setBackgroundImage:_imageViewBgContain.image forState:UIControlStateNormal];
                [_btnCancel setBackgroundImage:_imageViewBgContain.image forState:UIControlStateNormal];
                
                [_viewSearchLeft showMagnifierIcon];
                
                _viewBottom.alpha = 1;
                _imageViewBgBottom.alpha = _viewTop.alpha = 0;
                _viewFindInPage.alpha = 0;
                _viewFindInPage.hidden = YES;
                // self.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.5];
                
                if ([AppConfig config].uiMode==UIModeDay) {
                    _textFieldSearch.textColor =
                    _textFieldURL.textColor = [UIColor colorWithWhite:0.2 alpha:1];
                }
                else {
                    _textFieldSearch.textColor =
                    _textFieldURL.textColor = [UIColor colorWithWhite:0.9 alpha:1];
                }
                
                [_btnCancel setTitleColor:_textFieldURL.textColor forState:UIControlStateNormal];
                
                rc = self.bounds;
                rc.size.height = _viewBottom.bounds.size.height;
            }
                break;
            case UIInputModalSearch:
            {
                NSInteger key = [AppConfig config].uiMode==UIModeDay?0:1;
                _imageViewBgContain.image = [[UIImage imageWithFilename:[NSString stringWithFormat:@"top.bundle/%d_search_txt_bg.png", key]]
                                             stretchableImageWithLeftCapWidth:10
                                             topCapHeight:10];
                [_btnPersonal setBackgroundImage:_imageViewBgContain.image forState:UIControlStateNormal];
                [_btnCancel setBackgroundImage:_imageViewBgContain.image forState:UIControlStateNormal];
                
                [_viewSearchLeft showOptionIcon];
                
                _viewBottom.alpha = 1;
                _imageViewBgBottom.alpha = 1;
                _viewTop.alpha = 1;
                _viewFindInPage.alpha = 0;
                _viewFindInPage.hidden = YES;
                // self.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.5];
                
                if ([AppConfig config].uiMode==UIModeDay) {
                    _textFieldSearch.textColor =
                    _textFieldURL.textColor = [UIColor colorWithWhite:0.2 alpha:1];
                    [_btnCancel setTitleColor:_textFieldSearch.textColor forState:UIControlStateNormal];
                }
                else {
                    _textFieldSearch.textColor = [UIColor colorWithWhite:0.2 alpha:1];
                    _textFieldURL.textColor = [UIColor colorWithWhite:0.9 alpha:1];
                    [_btnCancel setTitleColor:[UIColor colorWithWhite:0.2 alpha:1] forState:UIControlStateNormal];
                }
                
                rc = self.bounds;
                rc.size.height = _viewTop.bounds.size.height+_viewBottom.bounds.size.height;
            }
                break;
            case UIInputModalFindInPage:
            {
                _viewBottom.alpha = 0;
                _imageViewBgBottom.alpha = _viewTop.alpha = 0;
                _viewFindInPage.alpha = 1;
                _viewFindInPage.hidden = NO;
                
                NSInteger key = [AppConfig config].uiMode==UIModeDay?0:1;
                UIImage *bgImage = [[UIImage imageWithFilename:[NSString stringWithFormat:@"top.bundle/%d_bg.png", key]]
                                    stretchableImageWithLeftCapWidth:10
                                    topCapHeight:10];
                [_btnFindCancel setBackgroundImage:bgImage forState:UIControlStateNormal];
                _imageViewFindBg.image = bgImage;
                
                
                if ([AppConfig config].uiMode==UIModeDay) {
                    _textFieldFind.textColor = [UIColor colorWithWhite:0.2 alpha:1];
                }
                else {
                    _textFieldFind.textColor = [UIColor colorWithWhite:0.9 alpha:1];
                }
                
                [_btnFindCancel setTitleColor:_textFieldURL.textColor forState:UIControlStateNormal];
                
                rc = self.bounds;
                rc.size.height = _viewFindInPage.frame.size.height;
            }
                break;
                
            default:
                break;
        }
        
        rc.size.width = self.superview.bounds.size.width;
        rc.origin.x = 0;
        if (_fullscreen) {
            if (_inputModal==UIInputModalNone) {
                rc.origin.y=-rc.size.height;
            }
        }
        else {
            rc.origin.y = 0;
            if (IsiOS7) {
                // ios>=7
                rc.size.height += 20;
            }
        }
        self.frame = rc;
    };
    
    if (animated) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            anim();
        } completion:^(BOOL finished) {
            if (completion) completion();
        }];
    }
    else {
        anim();
        if (completion) completion();
    }
}

- (void)initSearchOption
{
    _arrSearchOption = [NSArray arrayWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Search.bundle/search_option.plist"]];
    
    _dicSearchConfig = [AppConfig config].dicSearchConfig;
    if (!_dicSearchConfig) {
        _dicSearchConfig = [NSMutableDictionary dictionaryWithObject:@(0) forKey:@"cateIndex"];
        [_dicSearchConfig setObject:[NSArray arrayWithObjects:
                                     [NSMutableDictionary dictionaryWithObject:@(0) forKey:@"itemIndex"],
                                     [NSMutableDictionary dictionaryWithObject:@(0) forKey:@"itemIndex"],
                                     [NSMutableDictionary dictionaryWithObject:@(0) forKey:@"itemIndex"],
                                     [NSMutableDictionary dictionaryWithObject:@(0) forKey:@"itemIndex"],
                                     [NSMutableDictionary dictionaryWithObject:@(0) forKey:@"itemIndex"],
                                     [NSMutableDictionary dictionaryWithObject:@(0) forKey:@"itemIndex"], nil]
                             forKey:@"item"];
    }
    
    NSInteger cateIndex = [_dicSearchConfig[@"cateIndex"] integerValue];
    NSMutableDictionary *dicSearchItem = _dicSearchConfig[@"item"][cateIndex];
    NSInteger itemIndex = [dicSearchItem[@"itemIndex"] integerValue];
    NSDictionary *dicSearch = _arrSearchOption[cateIndex][@"item"][itemIndex];
    [_viewSearchLeft.btnIcon setImage:[UIImage imageWithFilename:[NSString stringWithFormat:@"Search.bundle/%@.png", dicSearch[@"icon"]]]
                             forState:UIControlStateNormal];
    
//    _arrSearchCateBtn = [_viewTop.subviews subarrayWithRange:NSMakeRange(1, 5)];
    [self onTouchItem:[_viewTop.subviews subarrayWithRange:NSMakeRange(1, _viewTop.subviews.count-1)][cateIndex]];
    
}

- (IBAction)onTouchEWM
{
    [_delegate viewTopBarTouchQRCode:self];
}

- (IBAction)onTouchPersonal
{
    [_delegate viewTopBarOnTouchPersonal:self];
}

- (IBAction)onTouchCancel
{
    if (_textFieldSearch.isFirstResponder) {
        [_textFieldSearch resignFirstResponder];
    }
    if (_textFieldURL.isFirstResponder) {
        [_textFieldURL resignFirstResponder];
    }
    
    [self toggleInputModal:UIInputModalNone animated:YES];
}

- (IBAction)onTouchCancelFind
{
    [_delegate viewTopBarCancelFindInPage:self];
    if (_textFieldFind.isFirstResponder){
        [_textFieldFind resignFirstResponder];
    }
    _findCount = _findIndex = 0;
    _textFieldFind.text = nil;
    [self toggleInputModal:UIInputModalNone animated:YES];
}

- (IBAction)onTouchFindPrev
{
    self.findIndex--;
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [_delegate viewTopBar:self focusToFindIndex:_findIndex];
    });
}

- (IBAction)onTouchFindNext
{
    self.findIndex++;
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [_delegate viewTopBar:self focusToFindIndex:_findIndex];
    });
}

- (void)resizeFindView
{
    if (_findCount==0) {
        CGRect rc = _viewFindNum.frame;
        rc.origin.x = self.bounds.size.width+5;
        _viewFindNum.frame = rc;
        
        rc = _viewFindContain.frame;
        rc.size.width = self.bounds.size.width-rc.origin.x-5;
        _viewFindContain.frame = rc;
    }
    else {
        CGRect rc = _viewFindNum.frame;
        rc.origin.x = self.bounds.size.width-rc.size.width-5;
        _viewFindNum.frame = rc;
        
        rc = _viewFindContain.frame;
        rc.size.width = _viewFindNum.frame.origin.x-5-rc.origin.x;
        _viewFindContain.frame = rc;
    }
}

- (IBAction)onTouchBookmark
{
    if ([_delegate respondsToSelector:@selector(viewTopBarTouchBookmark:)]) {
        [_delegate viewTopBarTouchBookmark:self];
    }
}

- (IBAction)onTouchSearchIcon
{
    if ([_delegate respondsToSelector:@selector(viewTopBarShowSearchOption:options:position:)]) {
        CGPoint position = [_viewSearchLeft convertPoint:_viewSearchLeft.btnIcon.center toView:self];
        position.y += _viewBottom.bounds.size.height/2;
//        position.y = self.frame.origin.y+self.bounds.size.height;
        
        NSInteger cateIndex = [_dicSearchConfig[@"cateIndex"] integerValue];
        [_delegate viewTopBarShowSearchOption:self options:_arrSearchOption[cateIndex][@"item"] position:position];
    }
}

- (NSString *)getSearchLinkWithKeyword:(NSString *)keyword
{
    NSInteger cateIndex = [_dicSearchConfig[@"cateIndex"] integerValue];
    NSInteger itemIndex = [_dicSearchConfig[@"item"][cateIndex][@"itemIndex"] integerValue];
    
    NSDictionary *dicSearch = _arrSearchOption[cateIndex][@"item"][itemIndex];
    NSString *link = dicSearch[@"link"];
    
    // url编码
    keyword = [keyword urlEncodeNormal];
    if ([keyword isURLString]) {
        // 如果关键字是url链接地址，需要再做一次url深度编码
        keyword = [keyword urlEncode];
    }
    link = [link stringByAppendingString:keyword];
    return link;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (_textFieldURL==textField) {
        // url
        [self toggleInputModal:UIInputModalURL animated:YES];
        
        [UITextInputUtil selectTextForInput:textField atRange:NSMakeRange(0, textField.text.length)];
    }
    else if (_textFieldSearch==textField) {
        // search
        [self toggleInputModal:UIInputModalSearch animated:YES];
        
    }
    else if (_textFieldFind==textField) {
        // find
//        [self toggleInputModal:UIInputModalFindInPage animated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length==0) {
        [ViewIndicator showWarningWithStatus:NSLocalizedString(@"enter_content", nil) duration:1];
        return NO;
    }
    
    if (textField==_textFieldSearch) {
        NSString *link = [self getSearchLinkWithKeyword:textField.text];
        _textFieldURL.text = link;
        [_delegate viewTopBar:self reqLink:link];
        
        // none
        [self toggleInputModal:UIInputModalNone animated:YES];
    }
    else if (textField==_textFieldURL) {
        if ([textField.text isURLString]) {
            // 是连接地址
            NSString *link = [textField.text urlEncodeNormal];
            
            // 自动补全http协议
            if (!([link hasPrefix:@"http://"] || [link hasPrefix:@"https://"]))
                link = [NSString stringWithFormat:@"http://%@", link];
            
            _textFieldURL.text = link;
            [_delegate viewTopBar:self reqLink:link];
        }
        else {
            // 非请求，则 搜索,
            NSString *link = @"http://m.baidu.com/s?wd=";
            // url编码
            NSString *keyword = [textField.text urlEncodeNormal];
            if ([keyword isURLString]) {
                // 如果关键字是url链接地址，需要再做一次url深度编码
                keyword = [keyword urlEncode];
            }
            link = [link stringByAppendingString:keyword];
            _textFieldURL.text = link;
            [_delegate viewTopBar:self reqLink:link];
        }
        
        // none
        [self toggleInputModal:UIInputModalNone animated:YES];
    }
    else if (textField==_textFieldFind) {
        //
        [_delegate viewTopBar:self findKeywrodInPage:[textField.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
    }
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_textFieldURL==textField) {
        // url
    }
    else if (_textFieldSearch==textField) {
        // search
        textField.text = nil;
    }
    else if (_textFieldFind==textField) {
        //
    }
}

@end
