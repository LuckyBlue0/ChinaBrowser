//
//  UIControllerMenu.m
//  KTBrowser
//
//  Created by David on 14-2-20.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIControllerMenu.h"

#import <QuartzCore/QuartzCore.h>
#import "UIViewMenuItem.h"

#import "UIControllerPainting.h"

@interface UIControllerMenu ()

- (IBAction)onTouchCommonly;
- (IBAction)onTouchSettings;
- (IBAction)onTouchTools;

- (void)onTouchMenuItem:(UIViewMenuItem *)viewMenuItem;

- (void)updateUIMode;


@end

@implementation UIControllerMenu

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _imageViewMask.frame = [_imageViewMask convertRect:_imageViewMask.bounds toView:_imageViewLine];
    [_imageViewLine addSubview:_imageViewMask];
    _imageViewLine.clipsToBounds = YES;
    
    _viewMenu.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width*3, _scrollView.bounds.size.height);
    
    [_btnCommonly setTitle:NSLocalizedString(@"commonly", nil) forState:UIControlStateNormal];
    [_btnSettings setTitle:NSLocalizedString(@"settings", nil) forState:UIControlStateNormal];
    [_btnTools setTitle:NSLocalizedString(@"tools", nil) forState:UIControlStateNormal];
    
    [self onTouchCommonly];
    
    NSArray *arrArrMenuItem = @[
                             @[
                                 @{
                                     @"type":@(MenuItemAddToBookmark),
                                     @"title":@"add_bookmark",
                                     @"icon":@"0"
                                     },
                                 @{
                                     @"type":@(MenuItemBookmarkHistory),
                                     @"title":@"bookmark_history",
                                     @"icon":@"1"
                                     },
                                 @{
                                     @"type":@(MenuItemRefresh),
                                     @"title":@"refresh",
                                     @"icon":@"2"
                                     },
                                 @{
                                     @"type":@(MenuItemNewPage),
                                     @"title":@"new_page",
                                     @"icon":@"6"
                                     },
                                 @{
                                     @"type":@(MenuItemDayNightModal),
                                     @"title":@"ui_mode_night",
                                     @"icon":@"3"
                                     },
                                 @{
                                     @"type":@(MenuItemSetBrightness),
                                     @"title":@"set_brightness",
                                     @"icon":@"4"
                                     }/*,
                                 @{
                                     @"type":@(MenuItemAddToBookmark),
                                     @"title":@"refresh",
                                     @"icon":@"0"
                                     },
                                 @{
                                     @"type":@(MenuItemAddToBookmark),
                                     @"title":@"refresh",
                                     @"icon":@"0"
                                     }*/
                                 ],
                             @[
                                 @{
                                     @"type":@(MenuItemNoImage),
                                     @"title":@"no_image",
                                     @"icon":@"9"
                                     },
                                 @{
                                     @"type":@(MenuItemNoSaveHistory),
                                     @"title":@"no_history",
                                     @"icon":@"11"
                                     },
                                 @{
                                     @"type":@(MenuItemFontSize),
                                     @"title":@"fontsize",
                                     @"icon":@"10"
                                     },
                                 @{
                                     @"type":@(MenuItemRotate),
                                     @"title":@"lock_rotate",
                                     @"icon":@"12"
                                     },
                                 @{
                                     @"type":@(MenuItemFullscreen),
                                     @"title":@"fullscreen",
                                     @"icon":@"22"
                                     },
                                 @{
                                     @"type":@(MenuItemSkin),
                                     @"title":@"skin",
                                     @"icon":@"15"
                                     },
                                 @{
                                     @"type":@(MenuItemFeedback),
                                     @"title":@"feedback",
                                     @"icon":@"13"
                                     },
                                 @{
                                     @"type":@(MenuItemCheckVersion),
                                     @"title":@"check_update",
                                     @"icon":@"14"
                                     }
                                 ],
                             @[
                                 @{
                                     @"type":@(MenuItemScreenshot),
                                     @"title":@"screenshot",
                                     @"icon":@"16"
                                     },
                                 @{
                                     @"type":@(MenuItemShare),
                                     @"title":@"share",
                                     @"icon":@"17"
                                     },
                                 @{
                                     @"type":@(MenuItemFindInPage),
                                     @"title":@"find_in_page",
                                     @"icon":@"19"
                                     },
                                 @{
                                     @"type":@(MenuItemQRCode),
                                     @"title":@"qrcode",
                                     @"icon":@"20"
                                     }/*,
                                 @{
                                     @"type":@(MenuItemAddToBookmark),
                                     @"title":@"refresh",
                                     @"icon":@"20"
                                     },
                                 @{
                                     @"type":@(MenuItemAddToBookmark),
                                     @"title":@"refresh",
                                     @"icon":@"0"
                                     },
                                 @{
                                     @"type":@(MenuItemAddToBookmark),
                                     @"title":@"refresh",
                                     @"icon":@"0"
                                     },
                                 @{
                                     @"type":@(MenuItemAddToBookmark),
                                     @"title":@"refresh",
                                     @"icon":@"0"
                                     }*/
                                 ]
                             ];
    
    for (NSInteger i=0; i<3; i++) {
        UIView *viewPage = _scrollView.subviews[i];
//        viewPage.frame = CGRectOffset(viewPage.bounds, viewPage.bounds.size.width*i, 0);
        NSArray *arrMenuItem = arrArrMenuItem[i];
        
        NSInteger itemCount = arrMenuItem.count;
        
        for (NSInteger j=0; j<itemCount; j++) {
            UIViewMenuItem *viewMenuItem = [UIViewMenuItem viewMenuItemFromXib];
            CGRect rc = viewMenuItem.frame;
            NSInteger col = GetColWithIndexCol(j, 4);
            NSInteger row = GetRowWithIndexCol(j, 4);
            rc.origin.x = 5+(rc.size.width+10)*col;
            rc.origin.y = 8+(rc.size.height+4)*row;
            viewMenuItem.frame = rc;
            
            NSDictionary *dicMenuItem = arrArrMenuItem[i][j];
            
            MenuItem menuItem = [dicMenuItem[@"type"] integerValue];
            
            viewMenuItem.tag = menuItem;
            [viewMenuItem addTarget:self action:@selector(onTouchMenuItem:) forControlEvents:UIControlEventTouchUpInside];
            
            NSString *key = dicMenuItem[@"title"];
            viewMenuItem.labelTitle.text = NSLocalizedString(key, key);
            viewMenuItem.imageViewIcon.image = [UIImage imageWithFilename:
                                                [NSString stringWithFormat:@"Menu.bundle/menu_%@_0.png",
                                                 dicMenuItem[@"icon"]]];
            viewMenuItem.imageViewIcon.highlightedImage = [UIImage imageWithFilename:
                                                           [NSString stringWithFormat:@"Menu.bundle/menu_%@_1.png",
                                                            dicMenuItem[@"icon"]]];
            [viewPage addSubview:viewMenuItem];
            
            /**
             UIViewMenuItem *_viewMenuBookmarkAction;    // *
             UIViewMenuItem *_viewMenuRefresh;           // *
             UIViewMenuItem *_viewMenuDayNightModal;     // *
             UIViewMenuItem *_viewMenuNoImage;           // *
             UIViewMenuItem *_viewMenuNoSaveHistory;     // *
             UIViewMenuItem *_viewMenuRotate;            // *
             UIViewMenuItem *_viewMenuFullscreen;        // *
             */
            switch (menuItem) {
                case MenuItemAddToBookmark:
                    _viewMenuBookmarkAction = viewMenuItem;
                    break;
                case MenuItemRefresh:
                    _viewMenuRefresh = viewMenuItem;
                    break;
                case MenuItemDayNightModal:
                    _viewMenuDayNightModal = viewMenuItem;
                    break;
                case MenuItemNoImage:
                    _viewMenuNoImage = viewMenuItem;
                    break;
                case MenuItemNoSaveHistory:
                    _viewMenuNoSaveHistory = viewMenuItem;
                    break;
                case MenuItemRotate:
                    _viewMenuRotate = viewMenuItem;
                    break;
                case MenuItemFullscreen:
                    _viewMenuFullscreen = viewMenuItem;
                    break;
                case MenuItemFindInPage:
                    _viewMenuFindInPage = viewMenuItem;
                    break;
                case MenuItemFontSize:
                    _viewMenuSetFont = viewMenuItem;
                    break;
                default:
                    break;
            }
        }
    }
    
    _viewMenuNoImage.selected = [AppConfig config].noImage;
    _viewMenuNoSaveHistory.selected = [AppConfig config].noHistory;
    _viewMenuRotate.selected = [AppConfig config].rotateLock;
    _viewMenuDayNightModal.selected = ([AppConfig config].uiMode==UIModeDay);
    _viewMenuDayNightModal.labelTitle.text = NSLocalizedString(([AppConfig config].uiMode==UIModeNight)?@"ui_mode_day":@"ui_mode_night", 0);
    _viewMenuRotate.labelTitle.text = NSLocalizedString([AppConfig config].rotateLock?@"unlock_rotate":@"lock_rotate", 0);
    NSString *key = @"fullscreen";
    if ([AppConfig config].fullScreen || [AppConfig config].fullScreenLandscope) {
        key = @"exit_fullscreen";
    }
    _viewMenuFullscreen.labelTitle.text = NSLocalizedString(key, nil);
    _viewMenuFullscreen.selected = [AppConfig config].fullScreen||[AppConfig config].fullScreenLandscope;
    
    [self updateUIMode];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)onTouchCommonly
{
    [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width*0, 0) animated:YES];
}

- (IBAction)onTouchSettings
{
    [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width*1, 0) animated:YES];
}

- (IBAction)onTouchTools
{
    [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width*2, 0) animated:YES];
}

- (void)onTouchMenuItem:(UIViewMenuItem *)viewMenuItem
{
    BOOL perform = NO;
    switch (viewMenuItem.tag) {
        case MenuItemNoImage:{
            [AppConfig config].noImage = ![AppConfig config].noImage;
            _viewMenuNoImage.selected = [AppConfig config].noImage;
        }break;
        case MenuItemNoSaveHistory:{
            [AppConfig config].noHistory = ![AppConfig config].noHistory;
            _viewMenuNoSaveHistory.selected = [AppConfig config].noHistory;
        }break;
        case MenuItemDayNightModal:{
            if (UIModeDay == [AppConfig config].uiMode) {
                [AppConfig config].uiMode = UIModeNight;
            } else {
                [AppConfig config].uiMode = UIModeDay;
            }
            _viewMenuDayNightModal.selected = ([AppConfig config].uiMode==UIModeDay);
            _viewMenuDayNightModal.labelTitle.text = NSLocalizedString(([AppConfig config].uiMode==UIModeNight)?@"ui_mode_day":@"ui_mode_night", 0);
            perform = YES;
        }break;
        case MenuItemFullscreen:{
            NSString *key = @"exit_fullscreen";
            if ([AppConfig config].fullScreen) {
                key = @"fullscreen";
                [AppConfig config].fullScreen = NO;
            }
            else {
                [AppConfig config].fullScreen = YES;
                key = @"exit_fullscreen";
            }
            _viewMenuFullscreen.labelTitle.text = NSLocalizedString(key, nil);
            _viewMenuFullscreen.selected = [AppConfig config].fullScreen||[AppConfig config].fullScreenLandscope;
            perform = YES;
        }break;
        case MenuItemRotate:{
            [AppConfig config].rotateLock = ![AppConfig config].rotateLock;
            _viewMenuRotate.selected = [AppConfig config].rotateLock;
            _viewMenuRotate.labelTitle.text = NSLocalizedString([AppConfig config].rotateLock?@"unlock_rotate":@"lock_rotate", 0);
        }break;
        default: {
            perform = YES;
        }break;
    }
    
    [self dismissWithCompletion:^{
        if ([_delegate respondsToSelector:@selector(controllerMenu:seletedMenuItem:)]) {
            [_delegate controllerMenu:self seletedMenuItem:viewMenuItem];
        }
    }];
}

- (void)updateUIMode
{
    _imageViewBgL.image = [[UIImage imageWithFilename:[NSString stringWithFormat:@"Menu.bundle/menu_bg_l.png"]]
                           stretchableImageWithLeftCapWidth:5 topCapHeight:10];
    _imageViewBgM.image = [[UIImage imageWithFilename:[NSString stringWithFormat:@"Menu.bundle/menu_bg_m.png"]]
                           stretchableImageWithLeftCapWidth:0 topCapHeight:10];
    _imageViewBgR.image = [[UIImage imageWithFilename:[NSString stringWithFormat:@"Menu.bundle/menu_bg_r.png"]]
                           stretchableImageWithLeftCapWidth:5 topCapHeight:10];
    
    _imageViewLine.image = [[UIImage imageWithFilename:[NSString stringWithFormat:@"Menu.bundle/menu_line.png"]]
                            stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    _imageViewMask.image = [[UIImage imageWithFilename:[NSString stringWithFormat:@"Menu.bundle/menu_line_mask.png"]]
                            stretchableImageWithLeftCapWidth:10 topCapHeight:0];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pt = [[touches anyObject] locationInView:_viewMenu];
    if (!CGRectContainsPoint(_viewMenu.bounds, pt)) {
        [self dismissWithCompletion:nil];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat rate = scrollView.contentOffset.x/(scrollView.contentSize.width-scrollView.bounds.size.width);
    CGFloat transX = rate*(_btnTools.center.x-_btnCommonly.center.x);
    _imageViewMask.transform = CGAffineTransformMakeTranslation(floorf(transX), 0);
}

#pragma mark - public
- (void)showInController:(UIViewController *)controller completion:(void(^)(void))completion position:(CGPoint)position
{
    self.view.frame = controller.view.bounds;
    [controller addChildViewController:self];
    [controller.view addSubview:self.view];
    
    _viewMenu.layer.anchorPoint = CGPointMake(0.5, 1);
    _viewMenu.layer.position = position;
    _viewMenu.transform = CGAffineTransformMakeScale(0, 0);
    _viewMenu.alpha = 0;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _viewMenu.alpha = 1;
        _viewMenu.transform = CGAffineTransformIdentity;
        self.view.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.3];
    } completion:^(BOOL finished) {
        if (completion) completion();
    }];
}

- (void)dismissWithCompletion:(void(^)(void))completion
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _viewMenu.alpha = 0;
        _viewMenu.transform = CGAffineTransformMakeScale(0, 0);
        self.view.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [_delegate controllerMenuDidDismiss:self];
        
        [self.view removeFromSuperview];
        
        if (completion) completion();
        
        [self removeFromParentViewController];
    }];
}

- (void)setBookmarkActionState:(UIControlState)state
{
    switch (state) {
        case UIControlStateNormal:
            _viewMenuBookmarkAction.enabled = YES;
            _viewMenuBookmarkAction.selected = NO;
            _viewMenuBookmarkAction.labelTitle.text = NSLocalizedString(@"add_bookmark", 0);
            break;
        case UIControlStateDisabled:
            _viewMenuBookmarkAction.enabled = NO;
            _viewMenuBookmarkAction.selected = NO;
            _viewMenuBookmarkAction.labelTitle.text = NSLocalizedString(@"add_bookmark", 0);
            break;
        case UIControlStateSelected:
            _viewMenuBookmarkAction.enabled = YES;
            _viewMenuBookmarkAction.selected = YES;
            _viewMenuBookmarkAction.labelTitle.text = NSLocalizedString(@"remove_bookmark", 0);
            break;
            
        default:
            break;
    }
}

- (void)enableMenuItem:(BOOL)enable
{
    _viewMenuRefresh.enabled =
    _viewMenuSetFont.enabled =
    _viewMenuFindInPage.enabled = enable;
}

@end
