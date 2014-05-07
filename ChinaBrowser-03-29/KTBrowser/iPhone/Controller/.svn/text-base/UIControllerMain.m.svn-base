//
//  UIControllerMain.m
//  KTBrowser
//
//  Created by David on 14-2-13.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIControllerMain.h"

#import "UIImage+BlurredFrame.h"
#import "UIImage+ImageEffects.h"

#import "UIViewInputToolBar.h"

#import "UIControllerMenu.h"
#import <QuartzCore/QuartzCore.h>
#import "UIControllerPainting.h"

#import <ShareSDK/ShareSDK.h>

#import "ViewIndicator.h"
#import "UIViewSetBrightness.h"
#import "UIViewSetFont.h"

#import "UIWebViewAdditions.h"
#import "UnpreventableUILongPressGestureRecognizer.h"

#import "ADOFavorite.h"
#import "BlockUI.h"
#import "UIView+Genie.h"
#import "SIAlertView.h"

#import <AGCommon/NSString+Common.h>
#import "UIControllerSetSkin.h"

#import "VAGuideView.h"
#import "WKSync.h"

#import "UIControllerSync.h"
#import "UIControllerLogin.h"
#import "UINavControllerUser.h"

#import "ACPButton.h"


@interface UIControllerMain ()

- (void)didLoginNotification:(NSNotification *)notification;
- (void)didLogoutNotification:(NSNotification *)notification;
- (void)didSyncHomeNotification:(NSNotification *)notification;

/**
 *  调整视图
 */
- (void)resizeAfterTopBarResizedWithInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

/**
 *  计算主要视图区域大小
 *  除_viewTopBar 和 _viewToolBar 之外的可视区域 大小
 *
 *  @return CGRect
 */
- (CGRect)mainFrame;

/**
 *  网页 长按 手势
 *
 *  @param longPressGesture
 */
- (void)longPressGesture:(UILongPressGestureRecognizer *)longPressGesture;

/**
 *  网页 平移 手势
 *
 *  @param panGesture
 */
- (void)panGesture:(UIPanGestureRecognizer *)panGesture;

/**
 *  获取ShareSDK 分享的内容
 *
 *  @return id<ISSContent>
 */
- (id<ISSContent>)shareContent;

/**
 *  请求一个网页链接
 *
 *  @param link   链接地址
 *  @param action 请求链接的打开方式
 */
- (void)reqLink:(NSString *)link action:(ReqLinkAction)action;

/**
 *  创建一个网页窗口
 *
 *  @param link 链接
 *
 *  @return UIWebView
 */
- (UIWebPage *)newWebPageWithLink:(NSString *)link;

/**
 *  根据网页逻辑修改控件状态
 */
- (void)updateState;

/**
 *  带前进后退效果的 显示首页
 */
- (void)backToHome;

/**
 *  带前进后退的效果，显示当前网页
 */
- (void)forwardToWebView;

/**
 *  添加历史记录
 *
 *  @param title 网页标题
 *  @param link  链接
 */
- (void)recordHistoryWithTitle:(NSString *)title link:(NSString *)link;

- (UIImage *)snapeShotOfViewHome;
- (UIImage *)snapeShotOfWebViewAtIndex:(NSInteger)index;

@end

@implementation UIControllerMain
{
    UIImage *_imageHomeSnapeShot;
}

- (void)didLoginNotification:(NSNotification *)notification
{
    BOOL isExist = [ADOFavorite isExistsWithDataType:WKSyncDataTypeFavorite link:_currWebPage.link uid:[WKSync shareWKSync].modelUser.uid withGuest:NO];
    if (!_currWebPage.showHome) {
        _viewTopBar.btnBookmark.selected = isExist;
    }
    [[WKSync shareWKSync] syncAll];
}

- (void)didLogoutNotification:(NSNotification *)notification
{
    BOOL isExist = [ADOFavorite isExistsWithDataType:WKSyncDataTypeFavorite link:_currWebPage.link uid:[WKSync shareWKSync].modelUser.uid withGuest:NO];
    if (!_currWebPage.showHome) {
        _viewTopBar.btnBookmark.selected = isExist;
    }
    
    if (kShouldShowLocalHome) {
         
    }
}

- (void)didSyncHomeNotification:(NSNotification *)notification
{
    if (kShouldShowLocalHome) {
        
    }
}

/**
 *  调整视图
 */
- (void)resizeAfterTopBarResizedWithInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    void (^resize)()=^{
        CGRect rc;
        
        // _viewToolBar
        rc = _viewToolBar.frame;
        rc.size.height = UIInterfaceOrientationIsLandscape(interfaceOrientation)?34:44;
        if (UIInputModalFindInPage==_viewTopBar.inpuModal) {
            // 如果是 页内查找模式，不显示工具栏
            rc.origin.y = self.view.bounds.size.height;
        }
        else {
            rc.origin.y = self.view.bounds.size.height-rc.size.height;
        }
        _viewToolBar.frame = rc;
        
        // _currMainView
        _currMainView.frame = [self mainFrame];
        
        // 其他控件
        if (_controllerInputUrl) {
            CGRect rc = _viewContain.frame;
            rc.origin.y = _viewTopBar.frame.origin.y+_viewTopBar.frame.size.height;
            rc.size.height = self.view.bounds.size.height-rc.origin.y;
            _controllerInputUrl.view.frame = rc;
        }
        if (_controllerInputSearch) {
            CGRect rc = _viewContain.frame;
            rc.origin.y = _viewTopBar.frame.origin.y+_viewTopBar.frame.size.height;
            rc.size.height = self.view.bounds.size.height-rc.origin.y;
            _controllerInputSearch.view.frame = rc;
        }
    };
    
    [UIView animateWithDuration:0.35 animations:^{
        resize();
    }];
}

/**
 *  计算主要视图区域大小
 *  除_viewTopBar 和 _viewToolBar 之外的可视区域 大小
 *
 *  @return CGRect
 */
- (CGRect)mainFrame
{
    CGRect rc = self.view.bounds;
    rc.origin.y = _viewTopBar.frame.origin.y+_viewTopBar.frame.size.height;
    rc.size.height = _viewToolBar.frame.origin.y-rc.origin.y;
    return rc;
}

/**
 *  网页 长按 手势
 *
 *  @param longPressGesture
 */
- (void)longPressGesture:(UILongPressGestureRecognizer *)longPressGesture
{
    // 正在执行 页内查找 操作 不允许
    if (_viewTopBar.inpuModal==UIInputModalFindInPage) {
        return;
    }
    
    if (UIGestureRecognizerStateBegan==longPressGesture.state) {
        UIWebView *webView = (UIWebView *)longPressGesture.view;
        CGPoint point = [longPressGesture locationInView:webView];
        
        // convert point from view to HTML coordinate system
        CGSize viewSize = [webView frame].size;
        CGSize windowSize = [webView windowSize];
        
        CGFloat f = windowSize.width / viewSize.width;
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.) {
            point.x = point.x * f;
            point.y = point.y * f;
        } else {
            // On iOS 4 and previous, document.elementFromPoint is not taking
            // offset into account, we have to handle it
            CGPoint offset = [webView scrollOffset];
            point.x = point.x * f + offset.x;
            point.y = point.y * f + offset.y;
        }
        
        // Load the JavaScript code from the Resources and inject it into the web page
        NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"js.bundle/JSTools.js"];
        NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [webView stringByEvaluatingJavaScriptFromString: jsCode];
        
        // get the Tags at the touch location
        NSString *tags = [webView stringByEvaluatingJavaScriptFromString:
                          [NSString stringWithFormat:@"MyAppGetHTMLElementsAtPoint(%i,%i);",(NSInteger)point.x,(NSInteger)point.y]];
        
        NSString *tagsHREF = [webView stringByEvaluatingJavaScriptFromString:
                              [NSString stringWithFormat:@"MyAppGetLinkHREFAtPoint(%i,%i);",(NSInteger)point.x,(NSInteger)point.y]];
        
        NSString *tagsSRC = [webView stringByEvaluatingJavaScriptFromString:
                             [NSString stringWithFormat:@"MyAppGetLinkSRCAtPoint(%i,%i);",(NSInteger)point.x,(NSInteger)point.y]];
        
        NSArray *arrA = [tagsHREF componentsSeparatedByString:@","];
        NSArray *arrIMG = [tagsSRC componentsSeparatedByString:@","];
        
        NSString *href = nil;
        NSString *src = nil;
        if ([tags rangeOfString:@",A,"].location != NSNotFound) {
            href = arrA[1];
            NSURL *url = [NSURL URLWithString:href];
            if ([url.scheme isEqualToString:@"newtab"]) {
                href = [url.resourceSpecifier urlDecode]?:url.resourceSpecifier;
            }
        }
        if ([tags rangeOfString:@",IMG,"].location != NSNotFound) {
            src = arrIMG[1];
        }
        
        if (href || src) {
            UIActionSheet *sheet = nil;
            if (src) {
                sheet = [[UIActionSheet alloc] initWithTitle:href
                                                    delegate:nil
                                           cancelButtonTitle:NSLocalizedString(@"cancel", @"取消")
                                      destructiveButtonTitle:@"打开"
                                           otherButtonTitles:@"新窗口打开", @"在后台打开", @"查看图片", @"下载图片", nil];
            }
            else {
                sheet = [[UIActionSheet alloc] initWithTitle:href
                                            delegate:nil
                                   cancelButtonTitle:NSLocalizedString(@"cancel", @"取消")
                              destructiveButtonTitle:@"打开"
                                   otherButtonTitles:@"新窗口打开", @"在后台打开", nil];
            }
            [sheet showInView:[AppConfig config].rootController.view withCompletionHandler:^(NSInteger buttonIndex) {
                _DEBUG_LOG(@"%d----:%@", buttonIndex, href);
                if (sheet.cancelButtonIndex==buttonIndex) {
                    return;
                }
                switch (buttonIndex) {
                    case 0:
                    {
                        // 打开
                        [self reqLink:href action:ReqLinkActionOpenInSelf];
                    }
                        break;
                    case 1:
                    {
                        // 新窗口打开
                        [self reqLink:href action:ReqLinkActionOpenInNewWindow];
                    }
                        break;
                    case 2:
                    {
                        // 后台打开
                        /*
                        NSString *title = arrA[0];
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
                        label.textColor = [UIColor darkGrayColor];
                        label.backgroundColor = [UIColor redColor];
                        label.font = [UIFont systemFontOfSize:10];
                        if (title && [title isKindOfClass:[NSString class]]) {
                            label.text = title;
                        }
                        else {
                            label.text = href;
                        }
                        [label sizeToFit];
                        label.center = point;
                        [self.view addSubview:label];
                        
                        CGPoint pointDes = [_viewToolBar convertPoint:_viewToolBar.btnWindows.center toView:self.view];
                        [UIView animateWithDuration:0.35 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            label.center = pointDes;
                        } completion:^(BOOL finished) {
                            [label removeFromSuperview];
                        }];
                        */
                        [self reqLink:href action:ReqLinkActionOpenInBackground];
                    }
                        break;
                    case 3:
                    {
                        // 查看图片
                        _DEBUG_LOG(@"下载图片：%s:%@", __FUNCTION__, src);
                        [self reqLink:src action:ReqLinkActionOpenInNewWindow];
                    }
                        break;
                    case 4:
                    {
                        // 下载图片
                        _DEBUG_LOG(@"查看图片：%s:%@", __FUNCTION__, src);
                    }
                        break;
                        
                    default:
                        break;
                }
            }];
        }
    }
}

/**
 *  网页 平移 手势
 *
 *  @param panGesture
 */
- (void)panGesture:(UIPanGestureRecognizer *)panGesture
{
    _DEBUG_LOG(@"---%s====%@", __FUNCTION__, NSStringFromCGPoint([panGesture translationInView:self.view]));
}

/**
 *  获取ShareSDK 分享的内容
 *
 *  @return id<ISSContent>
 */
- (id<ISSContent>)shareContent
{
    id<ISSContent> content = nil;
    if (_currWebPage.superview) {
        id<ISSCAttachment> attachment = [ShareSDK pngImageWithImage:[UIImage imageFromView:_currWebPage]];
        content = [ShareSDK content:[_currWebPage.title stringByAppendingFormat:@" %@", _currWebPage.link]
                     defaultContent:nil
                              image:attachment
                              title:_currWebPage.title
                                url:_currWebPage.link
                        description:nil
                          mediaType:SSPublishContentMediaTypeImage];
    }
    else {
        id<ISSCAttachment> attachment = [ShareSDK pngImageWithImage:[UIImage imageFromView:self.view]];
        NSString *bundleVersioin = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
        NSString *bundleName = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleNameKey];
        content = [ShareSDK content:[bundleName stringByAppendingFormat:@" %@", bundleVersioin]
                     defaultContent:nil
                              image:attachment
                              title:bundleName
                                url:@"http://www.koto.com"
                        description:nil
                          mediaType:SSPublishContentMediaTypeImage];
    }
    return content;
}

/**
 *  请求一个连接地址
 *
 *  @param link   NSString *    链接地址
 *  @param action ReqLinkAction 请求链接操作类型
 */
- (void)reqLink:(NSString *)link action:(ReqLinkAction)action
{
    switch (action) {
        case ReqLinkActionOpenInSelf:
        {
            [_viewHome removeFromSuperview];
            _currMainView = _currWebPage;
            _currMainView.frame = [self mainFrame];
            [_currWebPage loadURL:[NSURL URLWithString:link]];
            [_viewContain insertSubview:_currMainView aboveSubview:_imageViewBg];
            _currWebPage.showHome = NO;
            
            [self updateState];
        }
            break;
        case ReqLinkActionOpenInNewWindow:
        {
            UIWebPage *webPage = [self newWebPageWithLink:link];
            
            CGAffineTransform tfScale = CGAffineTransformMakeScale(0.8, 0.8);
            CGAffineTransform tfTransRight = CGAffineTransformMakeTranslation(webPage.bounds.size.width, 0);
            CGAffineTransform tfTransLeft = CGAffineTransformMakeTranslation(-webPage.bounds.size.width, 0);
            
            // 创建当前视图的快照影子
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:webPage.frame];
            imageView.image = [UIImage imageFromView:_currMainView];
            [_viewContain addSubview:imageView];
            [_arrWebPage addObject:webPage];
            [_viewToolBar setWindowsNumber:_arrWebPage.count animated:YES];
            
            // 移除当前视图
            [_currMainView removeFromSuperview];
            
            _currWebPage = webPage;
            _currMainView = _currWebPage;
            
            // 显示新网页 视图
            [_viewContain insertSubview:_currMainView aboveSubview:_imageViewBg];
            
            _currMainView.transform = CGAffineTransformConcat(tfScale, tfTransRight);
            [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                _currMainView.transform = CGAffineTransformIdentity;
                imageView.transform = CGAffineTransformConcat(tfScale, tfTransLeft);
            }
                             completion:^(BOOL finished) {
                imageView.transform = CGAffineTransformIdentity;
                [imageView removeFromSuperview];
            }];
            
            [self updateState];
        }
            break;
        case ReqLinkActionOpenInBackground:
        {
            UIWebPage *webPage = [self newWebPageWithLink:link];
            [_arrWebPage addObject:webPage];
            [_viewToolBar setWindowsNumber:_arrWebPage.count];
            
            [UIView animateWithDuration:0.2 delay:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _viewToolBar.btnWindows.transform = CGAffineTransformMakeScale(1.1, 1.1);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    _viewToolBar.btnWindows.transform = CGAffineTransformMakeScale(1, 1);
                }];
            }];
        }
            break;
        case ReqLinkActionNewBlankWindow:
        {
            if (link && link.length>0) {
                [self reqLink:link action:ReqLinkActionOpenInNewWindow];
            }
            else {
                UIWebPage *webPage = [self newWebPageWithLink:link];
                
                CGAffineTransform tfScale = CGAffineTransformMakeScale(0.8, 0.8);
                CGAffineTransform tfTransRight = CGAffineTransformMakeTranslation(webPage.bounds.size.width, 0);
                CGAffineTransform tfTransLeft = CGAffineTransformMakeTranslation(-webPage.bounds.size.width, 0);
             
                // 创建当前视图的快照影子
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:webPage.frame];
                imageView.image = [UIImage imageFromView:_currMainView];
                [_viewContain addSubview:imageView];
                [_arrWebPage addObject:webPage];
                [_viewToolBar setWindowsNumber:_arrWebPage.count animated:YES];
                
                _viewHome.frame = [self mainFrame];
                if (!_currWebPage.showHome) {
                    [_currWebPage removeFromSuperview];
                }
                
                _currWebPage = webPage;
                // 当前显示网页
                _currMainView = _viewHome;
                [_viewContain insertSubview:_currMainView aboveSubview:_imageViewBg];
                
                _currMainView.transform = CGAffineTransformConcat(tfScale, tfTransRight);
                [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     _currMainView.transform = CGAffineTransformIdentity;
                                     imageView.transform = CGAffineTransformConcat(tfScale, tfTransLeft);
                                 }
                                 completion:^(BOOL finished) {
                                     imageView.transform = CGAffineTransformIdentity;
                                     [imageView removeFromSuperview];
                                 }];
                [self updateState];
            }
        }
            break;
            
        default:
            break;
    }
}

/**
 *  创建一个(空白的)网页窗口
 *
 *  @param link 链接，可以为空
 *
 *  @return UIWebView
 */
- (UIWebPage *)newWebPageWithLink:(NSString *)link
{
    /**
     *  创建网页窗口
     */
    UIWebPage *webPage = [UIWebPage webPageFromXib];
    webPage.delegate = self;
    webPage.frame = [self mainFrame];
    
    UnpreventableUILongPressGestureRecognizer *longPressGesture = [[UnpreventableUILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    longPressGesture.allowableMovement = 20;
    longPressGesture.minimumPressDuration = 1.0f;
    [webPage.webView addGestureRecognizer:longPressGesture];
    
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
//    pan.minimumNumberOfTouches = 2;
//    pan.maximumNumberOfTouches = 2;
//    [webPage addGestureRecognizer:pan];
    
    if (link) {
        webPage.showHome = NO;
        [webPage loadURL:[NSURL URLWithString:link]];
    }
    else {
        webPage.showHome = YES;
    }
    
    return webPage;
}

/**
 *  根据网页逻辑修改控件状态
 */
- (void)updateState
{
    if (_currWebPage.showHome) {
        // 显示主页
        _viewTopBar.textFieldURL.text = nil;
        _viewToolBar.btnHome.enabled = NO;
        _viewTopBar.btnBookmark.enabled = NO;
        
        // 前进后退
        _viewToolBar.btnGoBack.enabled = NO;
        
        if ([_currWebPage.link length]>0) {
            _viewToolBar.btnGoForward.enabled = YES;
        }
    }
    else {
        // 显示网页
        _viewTopBar.textFieldURL.text = _currWebPage.link;
        _viewToolBar.btnHome.enabled = YES;
        _viewTopBar.btnBookmark.enabled = YES;
        _viewTopBar.btnBookmark.selected = [ADOFavorite isExistsWithDataType:WKSyncDataTypeFavorite link:_currWebPage.link uid:[WKSync shareWKSync].modelUser.uid withGuest:NO];
        
        // 前进后退
        _viewToolBar.btnGoBack.enabled = YES;
        _viewToolBar.btnGoForward.enabled = _currWebPage.webView.canGoForward;
    }
}

/**
 *  带前进后退效果的 显示首页
 */
- (void)backToHome
{
    if (_viewHome.superview && !_currWebPage.superview) return;
    
    _viewHome.alpha = 1;
    _viewHome.hidden = NO;
    _viewHome.frame = [self mainFrame];
    
    CGAffineTransform tfScale = CGAffineTransformMakeScale(1, 1);
    CGAffineTransform tfTransRight = CGAffineTransformMakeTranslation(_currWebPage.bounds.size.width, 0);
    CGAffineTransform tfTransLeft = CGAffineTransformMakeTranslation(-_currWebPage.bounds.size.width, 0);
    
    // 创建当前视图的快照影子
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:_currWebPage.frame];
    imageView.image = [UIImage imageFromView:_currMainView];
    [_viewContain addSubview:imageView];
    // 移除当前视图
    [_currWebPage removeFromSuperview];
    
    // 设置主视图
    _currMainView = _viewHome;
    _currMainView.transform = CGAffineTransformConcat(tfScale, tfTransLeft);
    _currWebPage.showHome = YES;
    
    // 显示新网页 视图
    [_viewContain insertSubview:_currMainView aboveSubview:_imageViewBg];
    
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _currMainView.transform = CGAffineTransformIdentity;
                         imageView.transform = CGAffineTransformConcat(tfScale, tfTransRight);
                     }
                     completion:^(BOOL finished) {
                         imageView.transform = CGAffineTransformIdentity;
                         [imageView removeFromSuperview];
                     }];
    
    [self updateState];
}

/**
 *  带前进后退的效果，显示当前网页
 */
- (void)forwardToWebView
{
    if (!_viewHome.superview && _currWebPage.superview) return;
    
    _currWebPage.alpha = 1;
    _currWebPage.hidden = NO;
    _currWebPage.frame = [self mainFrame];
    
    CGAffineTransform tfScale = CGAffineTransformMakeScale(1, 1);
    CGAffineTransform tfTransRight = CGAffineTransformMakeTranslation(_viewHome.bounds.size.width, 0);
    CGAffineTransform tfTransLeft = CGAffineTransformMakeTranslation(-_viewHome.bounds.size.width, 0);
    
    // 创建当前视图的快照影子
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:_viewHome.frame];
    imageView.image = [UIImage imageFromView:_currMainView];
    [_viewContain addSubview:imageView];
    // 移除当前视图
    [_viewHome removeFromSuperview];
    
    // 设置主视图
    _currMainView = _currWebPage;
    _currWebPage.showHome = NO;
    
    // 显示新网页 视图
    [_viewContain insertSubview:_currMainView aboveSubview:_imageViewBg];
    
    _currMainView.transform = CGAffineTransformConcat(tfScale, tfTransRight);
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _currMainView.transform = CGAffineTransformIdentity;
                         imageView.transform = CGAffineTransformConcat(tfScale, tfTransLeft);
                     }
                     completion:^(BOOL finished) {
                         imageView.transform = CGAffineTransformIdentity;
                         [imageView removeFromSuperview];
                     }];
    
    [self updateState];
}

// ----------------------------------------------------------------------
/**
 *  添加历史记录
 *
 *  @param title 网页标题
 *  @param link  链接
 */
- (void)recordHistoryWithTitle:(NSString *)title link:(NSString *)link
{
    ModelFavorite *model = [ADOFavorite queryWithDataType:WKSyncDataTypeHistory
                                                     link:link
                                                      uid:[WKSync shareWKSync].modelUser.uid
                                                withGuest:NO];
    if (model) {
        NSTimeInterval ti = [[NSDate date] timeIntervalSince1970];
        [ADOFavorite updateTime:ti title:title withFid:model.fid times:model.times+1];
        
        // TODO:同步操作
        [[WKSync shareWKSync] syncUpdateTime:ti fid_server:model.fid_server];
    }
    else if (title.length>0 && link.length>0) {
        model = [ModelFavorite modelFavorite];
        model.time = [[NSDate date] timeIntervalSince1970];
        model.title = title;
        model.link = link;
        model.dataType = WKSyncDataTypeHistory;
        model.uid = [WKSync shareWKSync].modelUser.uid;
        [ADOFavorite addModel:model];
        
        // TODO:同步操作
        [[WKSync shareWKSync] syncAddWithDataType:WKSyncDataTypeHistory title:model.title link:model.link];
    }
}

- (UIImage *)snapeShotOfViewHome
{
    if (!_imageHomeSnapeShot) {
        _imageHomeSnapeShot = [UIImage imageFromView:_viewHome];
    }
    return _imageHomeSnapeShot;
}

- (UIImage *)snapeShotOfWebViewAtIndex:(NSInteger)index
{
    UIWebPage *webPage = _arrWebPage[index];
    if (webPage.showHome) {
        return [self snapeShotOfViewHome];
    }
    else {
        return [UIImage imageFromView:webPage];
    }
}

// ----------------------------------------------------------------------
#pragma mark -
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _arrWebPage = [NSMutableArray array];
    
    [UIViewInputToolBar attachToInputView:_viewTopBar.textFieldURL];
    
    _imageViewBg.image = [AppConfig config].bgImage;
    _viewContain.backgroundColor = [UIColor clearColor];
    _viewToolBar.btnGoBack.enabled = _viewToolBar.btnGoForward.enabled = NO;
    
    _pageControl.numberOfPages = 2;
    _pageControl.currentPage = 0;
    
    _currWebPage = [self newWebPageWithLink:nil];
    [_arrWebPage addObject:_currWebPage];
    [_viewToolBar setWindowsNumber:_arrWebPage.count];
    _currMainView = _viewHome;
    _currMainView.frame = [self mainFrame];
    
    [self updateState];
    
    
    // guide
    if ([VAGuideView shouldShowGuide]) {
        NSString *preStr = IsiPhone5?@"iPhone5":@"iPhone";
        NSMutableArray *arrImage = [NSMutableArray array];
        for (int i=0; i<4; i++) {
            UIImage *image = [UIImage imageWithFilename:[NSString stringWithFormat:@"%@-guide-%d-v.png", preStr, i]];
            [arrImage addObject:image];
        }
        VAGuideView *_guideView = [VAGuideView guideViewWithFrame:self.view.bounds arrImages:arrImage space:30];
        _guideView.imageContentMode = UIViewContentModeBottom;
        ACPButton *btnStart = [ACPButton buttonWithType:UIButtonTypeCustom];
        [btnStart setTitle:NSLocalizedString(@"start_app", 0) forState:UIControlStateNormal];
        btnStart.showsTouchWhenHighlighted = YES;
        btnStart.titleLabel.font = [UIFont systemFontOfSize:14];
        [btnStart setFlatStyleType:ACPButtonOK];
        [btnStart setBorderStyle:nil andInnerColor:nil];
        [btnStart setCornerRadius:3];
        
        CGRect rc;
        rc.size = CGSizeMake(120, 36);
        rc.origin.y = self.view.bounds.size.height-rc.size.height-60;
        rc.origin.x = floorf((self.view.bounds.size.width-rc.size.width)/2);
        btnStart.frame = rc;
        btnStart.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
        [_guideView addButtonAtLastPage:btnStart];
        
        if (_guideView && arrImage.count>0) {
            [AppConfig config].shouldShowRotateLock = NO;
            [AppConfig config].rotateLock = YES;
            [self.view addSubview:_guideView];
            double delayInSeconds = 0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [_guideView startAnimationWithDuration:3
                                 animationComplecation:nil
                                            didDismiss:^{
                                                [AppConfig config].shouldShowRotateLock = YES;
                                                [AppConfig config].rotateLock = NO;
                                            }];
            });
        }
        
        if ([WKSync shareWKSync].modelUser) {
            // 已登录的用户，先同步用户数据；数据同步完成后会自动通知更新UI
            [[WKSync shareWKSync] syncAll];
        }
        else if (kShouldShowLocalHome) {
            // 未登录，并且需要显示首页，则直接更新UI
        }
    }
    else {
        if ([WKSync shareWKSync].modelUser) {
            // 已登录的用户，先同步用户数据；数据同步完成后会自动通知更新UI
            [[WKSync shareWKSync] syncAll];
        }
        else if (kShouldShowLocalHome) {
            // 未登录，并且需要显示首页，则直接更新UI
        }
    }
}

// Applications should use supportedInterfaceOrientations and/or shouldAutorotate..
#pragma mark - autorotate -
// ------------------------------------------------------- rotate -----------------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation NS_DEPRECATED_IOS(2_0, 6_0)
{
    if ([AppConfig config].rotateLock) {
        return NO;
    }
    else {
        return YES;
    }
}

// New Autorotation support.
- (BOOL)shouldAutorotate NS_AVAILABLE_IOS(6_0)
{
    if ([AppConfig config].rotateLock) {
        return NO;
    }
    else {
        return YES;
    }
}

- (NSUInteger)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0)
{
    if ([AppConfig config].rotateLock) {
        return [AppConfig config].interfaceOrientationMask;
    }
    else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (_controllerPopoverSearchOption) {
        [_controllerPopoverSearchOption dismissWithCompletion:nil];
        _controllerPopoverSearchOption = nil;
    }
    if (_controllerMenu) {
        [_controllerMenu dismissWithCompletion:nil];
        _controllerMenu = nil;
    }
    
    _imageHomeSnapeShot = nil;
    
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        // 竖屏
        [AppConfig config].fullScreenLandscope = NO;
    }
    else {
        // 横屏
        [AppConfig config].fullScreenLandscope = YES;
    }
    
    // _viewTopBar
    BOOL fs = [AppConfig config].fullScreen;
    [[UIApplication sharedApplication] setStatusBarHidden:fs withAnimation:UIStatusBarAnimationSlide];
    _viewTopBar.fullscreen = fs;
    
    // TODO：调整视图
    [self resizeAfterTopBarResizedWithInterfaceOrientation:toInterfaceOrientation];
}

// ------------------------------------------------------- rotate -----------------------------------------------------------------

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIViewTopBarDelegate

/**
 *  即将切换输入状态（UIViewTopBar.frame 大小调整 前）
 *
 *  @param viewTopBar UIViewTopBar
 *  @param inputModal UIInputModal
 */
- (void)viewTopBar:(UIViewTopBar *)viewTopBar willToggleInpuModal:(UIInputModal)inputModal
{
    // 切换 顶栏 输入模式 时，将
    if (_scrollViewIconSite.edit) {
        _scrollViewIconSite.edit = NO;
        [_viewToolBar showEditDone:NO];
    }
    
    if (UIInputModalNone==inputModal) {
        [_controllerInputSearch dismissWithCompletion:^{
        }];
        _controllerInputSearch = nil;
        
        [_controllerInputUrl dismissWithCompletion:^{
        }];
        _controllerInputUrl = nil;
        
        if (_currMainView==_currWebPage) {
            _viewTopBar.textFieldURL.text = _currWebPage.link;
        }
    }
    else if (UIInputModalFindInPage!=inputModal) {
        // 即将切换到 输入 或 搜索
        // 删除
        [_currMainView removeFromSuperview];
        _currMainView.alpha = 0;
    }
}

/**
 *  已切换输入状态（UIViewTopBar.frame 大小已经调整过）
 *
 *  @param viewTopBar UIViewTopBar
 *  @param inputModal UIInputModal
 */
- (void)viewTopBar:(UIViewTopBar *)viewTopBar didToggleInpuModal:(UIInputModal)inputModal
{
    if (UIInputModalNone==inputModal) {
        _currMainView.frame = [self mainFrame];
        [_viewContain insertSubview:_currMainView aboveSubview:_imageViewBg];
        
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
            _currMainView.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }
    else if (UIInputModalURL==inputModal) {
        if (!_controllerInputUrl) {
            _controllerInputUrl = [self.storyboard instantiateViewControllerWithIdentifier:@"UIControllerInputUrl"];
            _controllerInputUrl.delegate = self;
            CGRect rc = _viewContain.frame;
            rc.origin.y = _viewTopBar.frame.origin.y+_viewTopBar.frame.size.height;
            rc.size.height = _viewContain.bounds.size.height-rc.origin.y;
            _controllerInputUrl.view.frame = rc;
            [_controllerInputUrl showInController:self completion:nil];
        }
    }
    else if (UIInputModalSearch==inputModal) {
        if (!_controllerInputSearch) {
            _controllerInputSearch = [self.storyboard instantiateViewControllerWithIdentifier:@"UIControllerInputSearch"];
            _controllerInputSearch.delegate = self;
            CGRect rc = _viewContain.frame;
            rc.origin.y = _viewTopBar.frame.origin.y+_viewTopBar.frame.size.height;
            rc.size.height = _viewContain.bounds.size.height-rc.origin.y;
            _controllerInputSearch.view.frame = rc;
            [_controllerInputSearch showInController:self completion:nil];
        }
    }
}

- (void)viewTopBarWillToggleToFindInPage:(UIViewTopBar *)viewTopBar
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rc = _viewToolBar.frame;
        rc.origin.y = self.view.bounds.size.height;
        _viewToolBar.frame = rc;
        
        _currMainView.frame = [self mainFrame];
    }];
}

- (void)viewTopBarWillToggleToNotFindInPage:(UIViewTopBar *)viewTopBar
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rc = _viewToolBar.frame;
        rc.origin.y = self.view.bounds.size.height-rc.size.height;
        _viewToolBar.frame = rc;
        
        _currMainView.frame = [self mainFrame];
    }];
}

/**
 *  点击书签按钮
 *
 *  @param viewTopBar UIViewTopBar
 */
- (void)viewTopBarTouchBookmark:(UIViewTopBar *)viewTopBar
{
    NSString *link = _currWebPage.link;
    ModelFavorite *model = [ADOFavorite queryWithDataType:WKSyncDataTypeFavorite link:link uid:[WKSync shareWKSync].modelUser.uid withGuest:NO];
    if (model) {
        if ([ADOFavorite deleteWithFid:model.fid]) {
            _viewTopBar.btnBookmark.selected = NO;
            
            // TODO: 同步操作
            [[WKSync shareWKSync] syncDelWithDataType:WKSyncDataTypeFavorite fid_server:model.fid_server];
            
            [ViewIndicator showSuccessWithStatus:NSLocalizedString(@"ShanChuShouCangChengGong", nil) duration:1];
        }
    }
    else {
        model = [ModelFavorite modelFavorite];
        model.title = _currWebPage.title;
        model.link = link;
        model.uid = [WKSync shareWKSync].modelUser.uid;
        model.dataType = WKSyncDataTypeFavorite;
        model.time = [[NSDate date] timeIntervalSince1970];
        if ([ADOFavorite addModel:model]) {
            __block UIImageView *imageView = [[UIImageView alloc] initWithFrame:_currWebPage.frame];
            imageView.image = [UIImage imageFromView:_currWebPage];
            imageView.layer.borderWidth = 0.8;
            imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
            [self.view addSubview:imageView];
            
            // TODO: 同步操作
            [[WKSync shareWKSync] syncAddWithDataType:WKSyncDataTypeFavorite title:model.title link:model.link];
            
            CGRect rc = [_viewTopBar.btnBookmark convertRect:_viewTopBar.btnBookmark.bounds toView:self.view];
            [imageView genieInTransitionWithDuration:0.8 destinationRect:CGRectInset(rc, (rc.size.width-4)/2, (rc.size.height-4)/2) destinationEdge:BCRectEdgeBottom completion:^{
                [imageView removeFromSuperview];
                _viewTopBar.btnBookmark.selected = YES;
                
                [ViewIndicator showSuccessWithStatus:NSLocalizedString(@"YiChengGongBaoCunDaoShouCang", nil) duration:1];
            }];
            _currWebPage.alpha = 0;
            [UIView animateWithDuration:1 delay:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
                _currWebPage.alpha = 1;
            } completion:^(BOOL finished) {
                _viewTopBar.btnBookmark.selected = YES;
            }];
        }
    }
}

/**
 *  点击二维码
 *
 *  @param viewTopBar UIViewTopBar
 */
- (void)viewTopBarTouchQRCode:(UIViewTopBar *)viewTopBar
{
    [_viewTopBar.textFieldURL resignFirstResponder];
    UIControllerQRCode *controllerQRCode = [self.storyboard instantiateViewControllerWithIdentifier:@"UIControllerQRCode"];
    controllerQRCode.delegate = self;
    [self presentModalViewController:controllerQRCode animated:YES];
}

/**
 *  点击搜索引擎的Icon，来显示搜索引擎的选项
 *
 *  @param viewTopBar UIViewTopBar
 *  @param options    搜索引擎的选项
 *  @param position   弹出菜单的位置
 */
- (void)viewTopBarShowSearchOption:(UIViewTopBar *)viewTopBar options:(NSArray *)options position:(CGPoint)position
{
    [viewTopBar.textFieldSearch resignFirstResponder];
    _controllerPopoverSearchOption = [self.storyboard instantiateViewControllerWithIdentifier:@"UIControllerPopoverSearchOption"];
    _controllerPopoverSearchOption.delegate = self;
    [_controllerPopoverSearchOption showInController:self options:options position:position completion:nil];
}

- (void)viewTopBar:(UIViewTopBar *)viewTopBar reqLink:(NSString *)link
{
    [self reqLink:link action:ReqLinkActionOpenInSelf];
}

/**
 *  页内查找标签
 *
 *  @param viewTopBar UIViewTopBar
 *  @param keyword    关键字
 */
- (void)viewTopBar:(UIViewTopBar *)viewTopBar findKeywrodInPage:(NSString *)keyword
{
    // 注入 JS 查找
    NSString *resPath = [[NSBundle mainBundle] resourcePath];
    static NSString *jsQuery = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        jsQuery = [NSString stringWithContentsOfFile:[resPath stringByAppendingPathComponent:@"js_plugins.js"] encoding:NSUTF8StringEncoding error:nil];
        
    });
    NSString *js = [NSString stringWithFormat:@"var highlightPlugin = document.getElementById('js_plugins'); \
                    if (highlightPlugin == undefined) { \
                    document.body.innerHTML += '<div id=\"js_plugins\"> \
                    <style type=\"text/css\"> \
                    .utaHighlight { background-color:yellow; } \
                    .selectSpan { background-color:yellow; color:red;} \
                    </style> \
                    </div>'; \
                    %@ \
                    }", jsQuery];
    
    [_currWebPage.webView stringByEvaluatingJavaScriptFromString:js];
    
    [_currWebPage.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"jQuery('body').removeHighlight().utaHighlight('%@');", keyword]];

    NSString *count = [_currWebPage.webView stringByEvaluatingJavaScriptFromString:@"jQuery('.utaHighlight').length"];
    _viewTopBar.findCount = [count integerValue];
    _viewTopBar.findIndex = 0;
    
    if (_viewTopBar.findCount>0) {
        [self viewTopBar:_viewTopBar focusToFindIndex:_viewTopBar.findIndex];
    }
}

/**
 *  聚焦到当前查找的点
 *
 *  @param viewTopBar UIViewTopBar
 *  @param findIndex  focusToFindIndex
 */
- (void)viewTopBar:(UIViewTopBar *)viewTopBar focusToFindIndex:(NSInteger)findIndex
{
//    NSString *js = [NSString stringWithFormat:@"function getTop() {var e = $($('.utaHighlight')[%d]); return e.offset().top;} getTop();", findIndex];
    NSString *js = [NSString stringWithFormat:@"scrollToFindIdx(%d);", findIndex];
    CGFloat offset = [[_currWebPage.webView stringByEvaluatingJavaScriptFromString:js] floatValue];
    
    CGFloat contentHeight = _currWebPage.webView.scrollView.contentSize.height;
    offset = MIN(offset, contentHeight-_currWebPage.webView.scrollView.bounds.size.height);
    [_currWebPage.webView.scrollView setContentOffset:CGPointMake(0, offset) animated:YES];
}

/**
 *  取消页内查找
 *
 *  @param viewTopBar UIViewTopBar
 */
- (void)viewTopBarCancelFindInPage:(UIViewTopBar *)viewTopBar
{
    [_currWebPage.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"jQuery('body').removeHighlight();"]];
}

/**
 *  点击用户头像
 *
 *  @param viewTopBar UIViewTopBar
 */
- (void)viewTopBarOnTouchPersonal:(UIViewTopBar *)viewTopBar
{
    if ([WKSync shareWKSync].modelUser) {
        UIControllerSync *controller = [[UIControllerSync alloc] initWithNibName:@"UIControllerSync" bundle:nil];
        controller.title = NSLocalizedString(@"sync", 0);
        
        UINavControllerUser *navController = [[UINavControllerUser alloc] initWithRootViewController:controller];
        navController.navigationBarHidden = YES;
        [self presentModalViewController:navController animated:YES];
    }
    else {
        UIControllerLogin *controller = [[UIControllerLogin alloc] initWithNibName:@"UIControllerLogin" bundle:nil];
        controller.title = NSLocalizedString(@"login", 0);
        
        UINavControllerUser *navController = [[UINavControllerUser alloc] initWithRootViewController:controller];
        navController.navigationBarHidden = YES;
        [self presentModalViewController:navController animated:YES];
    }
}

#pragma mark - UIViewToolBarDelegate
- (void)viewToolBar:(UIViewToolBar *)viewToolBar toolBarEvent:(ToolBarEvent)toolBarEvent point:(CGPoint)point
{
    if (_viewTopBar.inpuModal==UIInputModalFindInPage) {
        return;
    }
    
    [_viewTopBar.textFieldURL resignFirstResponder];
    [_viewTopBar.textFieldSearch resignFirstResponder];
    
    switch (toolBarEvent) {
        case ToolBarEventStop:
        {}
            break;
        case ToolBarEventGoBack:
        {
            if (_currWebPage.superview) {
                if (_currWebPage.webView.canGoBack) {
                    [_currWebPage goBack];
                }
                else {
                    // 带前进后退的显示效果
                    [self backToHome];
                }
                [self updateState];
            }
        }
            break;
        case ToolBarEventGoForward:
        {
            // goforward
            if (_viewHome.superview) {
                _DEBUG_LOG(@"%s::%@", __FUNCTION__, _currWebPage.link);
                // 带前进后退的显示效果
                [self forwardToWebView];
            }
            else {
                [_currWebPage goForward];
            }
        }
            break;
        case ToolBarEventWindows:
        {
            UIControllerWindows *controllerWindows = [self.storyboard instantiateViewControllerWithIdentifier:@"UIControllerWindows"];
            controllerWindows.delegate = self;
            [controllerWindows showInController:self currIndex:[_arrWebPage indexOfObject:_currWebPage] completion:nil];
            [controllerWindows reloadWithDatasource:self];
        }
            break;
        case ToolBarEventMenu:
        {
            if (!_controllerMenu) {
                _controllerMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"UIControllerMenu"];
                _controllerMenu.delegate = self;
            }
            [_controllerMenu showInController:self completion:nil position:point];
            
            if (!_currWebPage.showHome) {
                // 不显示首页，表示显示 网页
                BOOL isExist = [ADOFavorite isExistsWithDataType:WKSyncDataTypeFavorite
                                                            link:_currWebPage.link
                                                             uid:[WKSync shareWKSync].modelUser.uid withGuest:NO];
                [_controllerMenu setBookmarkActionState:isExist?UIControlStateSelected:UIControlStateNormal];
            }
            else {
                [_controllerMenu setBookmarkActionState:UIControlStateDisabled];
                
            }
            [_controllerMenu enableMenuItem:!_currWebPage.showHome];
        }
            break;
        case ToolBarEventHome:
        {
            [self backToHome];
        }
            break;
        case ToolBarEventEditDone:
        {
            _scrollViewIconSite.edit = NO;
            [_viewToolBar showEditDone:NO];
//            [AppConfig config].shouldShowRotateLock = YES;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UIControllerMenuDelegate
- (void)controllerMenu:(UIControllerMenu *)controllerMenu seletedMenuItem:(UIViewMenuItem *)menuItem
{
    _controllerMenu = nil;
    switch ((MenuItem)menuItem.tag) {
        case MenuItemAddToBookmark:{
            ModelFavorite *model = [ADOFavorite queryWithDataType:WKSyncDataTypeFavorite
                                                             link:_currWebPage.link
                                                              uid:[WKSync shareWKSync].modelUser.uid
                                                        withGuest:NO];
            if (model) {
                if ([ADOFavorite deleteWithFid:model.fid])
                {
                    // TODO: 同步操作
                    [[WKSync shareWKSync] syncDelWithDataType:WKSyncDataTypeFavorite
                                                   fid_server:model.fid_server];
                    
                    [ViewIndicator showSuccessWithStatus:NSLocalizedString(@"ShanChuShouCangChengGong", nil) duration:1];
                    
                    _viewTopBar.btnBookmark.selected = NO;
                }
            }
            else {
                model = [ModelFavorite modelFavorite];
                model.title = _currWebPage.title;
                model.link = _currWebPage.link;
                model.dataType = WKSyncDataTypeFavorite;
                model.uid = [WKSync shareWKSync].modelUser.uid;
                model.time = [[NSDate date] timeIntervalSince1970];
                if ([ADOFavorite addModel:model])
                {
                    // TODO: 同步操作
                    [[WKSync shareWKSync] syncAddWithDataType:WKSyncDataTypeFavorite title:model.title link:model.link];
                    
                    [ViewIndicator showSuccessWithStatus:NSLocalizedString(@"YiChengGongBaoCunDaoShouCang", nil) duration:1];
                    
                    _viewTopBar.btnBookmark.selected = YES;
                }
            }
        }break;
        case MenuItemBookmarkHistory:{
            UIControllerBookmarkHistory *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"UIControllerBookmarkHistory"];
            controller.delegate = self;
            [self presentModalViewController:controller animated:YES];
        }break;
        case MenuItemRefresh:{
            [_currWebPage reload];
        }break;
        case MenuItemDayNightModal:{
            _imageViewBg.image = [AppConfig config].bgImage;
            [KTAnimationKit animationEaseIn:_imageViewBg];
        }break;
        case MenuItemSetBrightness:{
            UIViewSetBrightness *viewSetBrightness = [UIViewSetBrightness viewSetBrightnessFromXib];
            if (UIModeDay==[AppConfig config].uiMode) {
                [viewSetBrightness setBrightness:[AppConfig config].brightnessDay];
            }
            else {
                [viewSetBrightness setBrightness:[AppConfig config].brightnessNight];
            }
            [viewSetBrightness showInView:self.view completion:nil];
        }break;
        case MenuItemDownload:{
            
        }break;
        case MenuItemNewPage:{
            [self reqLink:nil action:ReqLinkActionNewBlankWindow];
        }break;
        case MenuItemExit:{
            
        }break;
            
        case MenuItemSystemSettings:{
            
        }break;
        case MenuItemNoImage:{
            // 注入JS
            NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"js.bundle/handle.js"];
            NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
            
            for (UIWebPage *webPage in _arrWebPage) {
                [webPage.webView stringByEvaluatingJavaScriptFromString:jsCode];
                
                // 设置有/无图
                if ([AppConfig config].noImage) {
                    [webPage.webView stringByEvaluatingJavaScriptFromString:@"JSHandleHideImage();"];
                }
                else {
                    [webPage.webView stringByEvaluatingJavaScriptFromString:@"JSHandleShowImage();"];
                }
            }
            
        }break;
        case MenuItemFontSize:{
            UIViewSetFont *viewSetFont = [UIViewSetFont viewSetFontFromXib];
            viewSetFont.delegate = self;
//            [viewSetFont setFontsize:[AppConfig config].fontsize];
            [viewSetFont setFontsize:_currWebPage.fontSize];
            [viewSetFont showInView:self.view completion:nil];
        }break;
        case MenuItemNoSaveHistory:{
            
        }break;
        case MenuItemRotate:{
            
        }break;
        case MenuItemFullscreen:{
            // TODO：调整视图
            BOOL fs = [AppConfig config].fullScreen || [AppConfig config].fullScreenLandscope;
            [[UIApplication sharedApplication] setStatusBarHidden:fs withAnimation:UIStatusBarAnimationSlide];
            [UIView animateWithDuration:0.35 animations:^{
                // ios 7 以下兼容
                [self.navigationController.view layoutSubviews];
                _viewTopBar.fullscreen = fs;
                
                CGRect rc = _currMainView.frame;
                rc.origin.y = _viewTopBar.frame.origin.y+_viewTopBar.frame.size.height;
                rc.size.width = self.view.bounds.size.width;
                rc.size.height = _viewToolBar.frame.origin.y-rc.origin.y;
                _currMainView.frame = rc;
            }];
            
            _controllerMenu = nil;
        }break;
        case MenuItemFeedback:{
            
        }break;
        case MenuItemCheckVersion:{
            
        }break;
        case MenuItemSkin:{
            UIControllerSetSkin *controllerSetSkin = [self.storyboard instantiateViewControllerWithIdentifier:@"UIControllerSetSkin"];
            controllerSetSkin.delegate = self;
            [self presentModalViewController:controllerSetSkin animated:YES];
        }break;
            
        case MenuItemScreenshot:{
            UIImage *image = [UIImage imageFromView:self.view];
            UIControllerPainting *controllerPainting = [self.storyboard instantiateViewControllerWithIdentifier:@"UIControllerPainting"];
            [controllerPainting setImage:image];
            [self presentModalViewController:controllerPainting animated:YES];
        }break;
        case MenuItemShare:{
            UIViewSNSOption *viewSNS = [UIViewSNSOption viewSNSOptionFromXib];
            viewSNS.delegate = self;
            NSArray *arrShareType = [ShareSDK getShareListWithType:
                                     ShareTypeSinaWeibo,
                                     ShareTypeTencentWeibo,
                                     ShareTypeQQ,
                                     ShareTypeQQSpace,
                                     ShareTypeWeixiSession,
                                     ShareTypeWeixiTimeline,
                                     ShareTypeSMS,
                                     ShareTypeMail, nil];
            [viewSNS showInView:self.view arrShareType:arrShareType completion:nil];
        }break;
        case MenuItemFreeCopy:{
            
        }break;
        case MenuItemFindInPage:{
            [_viewTopBar toggleInputModal:UIInputModalFindInPage animated:YES];
        }break;
        case MenuItemQRCode:{
            [_viewTopBar.textFieldURL resignFirstResponder];
            UIControllerQRCode *controllerQRCode = [self.storyboard instantiateViewControllerWithIdentifier:@"UIControllerQRCode"];
            controllerQRCode.delegate = self;
            [self presentModalViewController:controllerQRCode animated:YES];
        }break;
        case MenuItemOneHand:{
            
        }break;
        default:
            break;
    }
}

- (void)controllerMenuDidDismiss:(UIControllerMenu *)controllerMenu
{
    _controllerMenu = nil;
}

#pragma mark - UIControllerInputSearchDelegate
- (void)controllerInputSearchWillDismiss:(UIControllerInputSearch *)controller
{
    [_viewTopBar.textFieldSearch resignFirstResponder];
    [_viewTopBar.textFieldURL resignFirstResponder];
    _controllerInputUrl = nil;
    _controllerInputSearch = nil;
    
    [_viewTopBar toggleInputModal:UIInputModalNone animated:YES];
}

#pragma mark - UIControllerInputUrlDelegate
- (void)controllerInputUrlWillDismiss:(UIControllerInputUrl *)controller
{
    [_viewTopBar.textFieldSearch resignFirstResponder];
    [_viewTopBar.textFieldURL resignFirstResponder];
    _controllerInputUrl = nil;
    _controllerInputSearch = nil;
    
    [_viewTopBar toggleInputModal:UIInputModalNone animated:YES];
}

#pragma mark - UIControllerPopoverSearchOptionDelegate
- (void)controllerPopoverSearchOption:(UIControllerPopoverSearchOption *)controllerPopoverSearchOption didSelectIndex:(NSInteger)index
{
    [_viewTopBar setCurrCateSearchIndex:index];
}

#pragma mark - UIViewSNSOptionDelegate
- (void)viewSNSOption:(UIViewSNSOption *)viewSNSOption didSelectShareTeyp:(ShareType)shareType
{
    [AppConfig config].layerMask.hidden = YES;
    if (ShareTypeMail==shareType||ShareTypeSMS==shareType) {
        [ShareSDK showShareViewWithType:shareType
                              container:nil
                                content:[self shareContent]
                          statusBarTips:NO
                            authOptions:nil
                           shareOptions:nil
                                 result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                     if (SSPublishContentStateSuccess==state) {
                                         [ViewIndicator showSuccessWithStatus:@"分享成功" duration:2];
                                         [AppConfig config].layerMask.hidden = NO;
                                     }
                                     else if (SSPublishContentStateFail==state) {
                                         [ViewIndicator showErrorWithStatus:[error errorDescription] duration:2];
                                         [AppConfig config].layerMask.hidden = NO;
                                     }
                                 }];
    }
    else {
        id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                             allowCallback:YES
                                                                    scopes:nil
                                                             powerByHidden:YES
                                                            followAccounts:nil
                                                             authViewStyle:SSAuthViewStyleModal
                                                              viewDelegate:nil
                                                   authManagerViewDelegate:nil];
        [ShareSDK shareContent:[self shareContent] type:shareType authOptions:authOptions shareOptions:nil statusBarTips:NO result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
            if (SSPublishContentStateSuccess==state) {
                [ViewIndicator showSuccessWithStatus:@"分享成功" duration:2];
                [AppConfig config].layerMask.hidden = NO;
            }
            else if (SSPublishContentStateFail==state) {
                [ViewIndicator showErrorWithStatus:[error errorDescription] duration:2];
                [AppConfig config].layerMask.hidden = NO;
            }
        }];
    }
}

#pragma mark - UIScrollViewCenterDelegate
- (void)scrollViewCenter:(UIScrollViewCenter *)scrollViewCenter reqLink:(NSString *)link action:(ReqLinkAction)action
{
    [self reqLink:link action:action];
}

#pragma mark - UIScrollViewIconSiteDelegate
- (void)scrollViewIconSite:(UIScrollViewIconSite *)scrollViewIconSite reqLink:(NSString *)link action:(ReqLinkAction)action
{
    NSURL *url = [NSURL URLWithString:link];
    if ([url.scheme isEqualToString:@"ChinaBrowserApp"]) {
        if ([url.resourceSpecifier isEqualToString:@"qrcode"]) {
            [_viewTopBar.textFieldURL resignFirstResponder];
            UIControllerQRCode *controllerQRCode = [self.storyboard instantiateViewControllerWithIdentifier:@"UIControllerQRCode"];
            controllerQRCode.delegate = self;
            [self presentModalViewController:controllerQRCode animated:YES];
        }
    }
    else {
        [self reqLink:link action:action];
    }
}

- (void)scrollViewIconSite:(UIScrollViewIconSite *)scrollViewIconSite iconSiteEvent:(IconSiteEvent)iconSiteEvent
{
    switch (iconSiteEvent) {
        case IconSiteEventAdd:
        {
            UIControllerAddWebsite *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"UIControllerAddWebsite"];
            controller.delegate = self;
            [self presentModalViewController:controller animated:YES];
        }
            break;
        case IconSiteEventBeginEdit:
        {
            [_viewToolBar showEditDone:YES];
//            [AppConfig config].shouldShowRotateLock = NO;
        }
            break;
        case IconSiteEventEndEdit:
        {
            [_viewToolBar showEditDone:NO];
//            [AppConfig config].shouldShowRotateLock = YES;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UIWebPageDelegate

- (BOOL)webPage:(UIWebPage *)webPag webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // 正在执行 页内查找 操作 不允许
    if (_viewTopBar.inpuModal==UIInputModalFindInPage) {
        return NO;
    }
    if ([request.URL.scheme isEqualToString:@"newtab"]) {
        NSString *link = [request.URL.resourceSpecifier urlDecode]?:request.URL.resourceSpecifier;
        if (link.length>0) {
            [self reqLink:link action:ReqLinkActionOpenInNewWindow];
        }
        return NO;
    }
    return YES;
}

- (void)webPage:(UIWebPage *)webPag webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webPage:(UIWebPage *)webPag webViewDidFinishLoad:(UIWebView *)webView
{
    // Disable the defaut actionSheet when doing a long press
    // 自定义长按选择
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    // 注入 JS（修改打开链接方式）
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"js.bundle/handle.js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [webView stringByEvaluatingJavaScriptFromString:jsCode];
    [webView stringByEvaluatingJavaScriptFromString:@"MyIPhoneApp_Init();"];
    
    
    // 设置有/无图
    if ([AppConfig config].noImage) {
        [webView stringByEvaluatingJavaScriptFromString:@"JSHandleHideImage();"];
    }
    else {
        [webView stringByEvaluatingJavaScriptFromString:@"JSHandleShowImage();"];
    }
    
    // 历史记录
    if (![AppConfig config].noHistory) {
        // 记录历史记录
        [self recordHistoryWithTitle:webView.title link:webView.link];
    }
    
    // 设置字体大小
    NSString *js = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%f%%'", webPag.fontSize/kWebFontSizeDefault*100];
    [webView stringByEvaluatingJavaScriptFromString:js];
    
    // 修改按钮状态
    [self updateState];
}

- (void)webPage:(UIWebPage *)webPag webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

#pragma mark - UIControllerAddWebsiteDelegate
- (void)controllerAddWebsite:(UIControllerAddWebsite *)controllerAddWebsite title:(NSString *)title link:(NSString *)link
{
    ModelFavorite *model = [ModelFavorite modelFavorite];
    model.title = title;
    model.link = link;
    model.time = [[NSDate date] timeIntervalSince1970];
    model.dataType = WKSyncDataTypeHome;
    model.uid = [WKSync shareWKSync].modelUser.uid;
    [_scrollViewIconSite addIconWebWithModel:model];
    [ADOFavorite addModel:model];
    
    [controllerAddWebsite dismissModalViewControllerAnimated:YES];
}

- (void)controllerAddWebsite:(UIControllerAddWebsite *)controllerAddWebsite willRotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    [self willRotateToInterfaceOrientation:interfaceOrientation duration:duration];
}

#pragma mark - UIControllerBookmarkHistoryDelegate
- (void)controllerBookmarkHistory:(UIControllerBookmarkHistory *)controllerBookmarkHistory willRotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    [self willRotateToInterfaceOrientation:interfaceOrientation duration:duration];
}

- (void)controllerBookmarkHistory:(UIControllerBookmarkHistory *)controllerBookmarkHistory reqLink:(NSString *)link
{
    [self reqLink:link action:ReqLinkActionOpenInSelf];
}

- (void)controllerBookmarkHistoryDidDeleteBookmark:(UIControllerBookmarkHistory *)controllerBookmarkHistory
{
    BOOL isExist = [ADOFavorite isExistsWithDataType:WKSyncDataTypeFavorite link:_currWebPage.link uid:[WKSync shareWKSync].modelUser.uid withGuest:NO];
    if (!_currWebPage.showHome) {
        _viewTopBar.btnBookmark.selected = isExist;
    }
}

- (void)controllerBookmarkHistoryDidClearBookmark:(UIControllerBookmarkHistory *)controllerBookmarkHistory
{
    BOOL isExist = [ADOFavorite isExistsWithDataType:WKSyncDataTypeFavorite link:_currWebPage.link uid:[WKSync shareWKSync].modelUser.uid withGuest:NO];
    if (!_currWebPage.showHome) {
        _viewTopBar.btnBookmark.selected = isExist;
    }
    
}

#pragma mark - UIControllerQRCodeDelegate
- (void)controllerQRCode:(UIControllerQRCode *)controllerQRCode result:(NSString *)result
{
    if ([result isURLString]) {
        // 是连接地址
        NSString *link = [result urlEncodeNormal];
        
        // 自动补全http协议
        if (!([link hasPrefix:@"http://"] || [link hasPrefix:@"https://"]))
            link = [NSString stringWithFormat:@"http://%@", link];
        
        _viewTopBar.textFieldURL.text = link;
        [self reqLink:link action:ReqLinkActionOpenInSelf];
    }
    else {
        NSString *link = [_viewTopBar getSearchLinkWithKeyword:result];
        [self reqLink:link action:ReqLinkActionOpenInSelf];
    }
}

/**
 *  已经消失
 *
 *  @param controllerQRCode UIControllerQRCode
 */
- (void)controllerQRCodeDidDismiss:(UIControllerQRCode *)controllerQRCode
{
    [_viewTopBar toggleInputModal:UIInputModalNone animated:YES];
}

- (void)controllerQRCode:(UIControllerQRCode *)controllerQRCode willRotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    [self willRotateToInterfaceOrientation:interfaceOrientation duration:duration];
}

#pragma mark - UIControllerSetSkinDelegate
- (void)controllerSetSkin:(UIControllerSetSkin *)controllerSetSkin willRotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    [self willRotateToInterfaceOrientation:interfaceOrientation duration:duration];
}

- (void)controllerSetSkinDidChanageSkin:(UIControllerSetSkin *)controllerSetSkin
{
    _imageViewBg.image = [AppConfig config].bgImage;
    [KTAnimationKit animationEaseIn:_imageViewBg];
}

#pragma mark - UIViewSetFontDelegate
- (void)viewSetFont:(UIViewSetFont *)viewSetFont setFontSize:(CGFloat)fontSize
{
//    [AppConfig config].fontsize = fontSize;
    
//    for (UIWebPage *webPage in _arrWebPage) {
    _currWebPage.fontSize = fontSize;
        NSString *js = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%f%%'", fontSize/kWebFontSizeDefault*100];
        [_currWebPage.webView stringByEvaluatingJavaScriptFromString:js];
//    }
}

#pragma mark - UIControllerWindowsDelegate
- (void)controllerWindowsNewWindow:(UIControllerWindows *)controllerWindows
{
    [self reqLink:nil action:ReqLinkActionNewBlankWindow];
}

/**
 *  选择窗口
 *
 *  @param controllerWindows UIControllerWindows
 *  @param index             索引
 */
- (void)controllerWindows:(UIControllerWindows *)controllerWindows didSelectFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    if (!_currWebPage.showHome) {
        // 切换前显示的是 网页
        [_currWebPage removeFromSuperview];
        
        _currWebPage = _arrWebPage[toIndex];
        if (_currWebPage.showHome) {
            _currMainView = _viewHome;
        }
        else {
            _currMainView  = _currWebPage;
        }
        _currMainView.frame = [self mainFrame];
        [_viewContain insertSubview:_currMainView aboveSubview:_imageViewBg];
    }
    else {
        // 切换前显示的是 首页
        _currWebPage = _arrWebPage[toIndex];
        if (_currWebPage.showHome) {
            _currMainView = _viewHome;
        }
        else {
            [_viewHome removeFromSuperview];
            _currMainView  = _currWebPage;
            // 显示 主视图
            _currMainView.frame = [self mainFrame];
            [_viewContain insertSubview:_currMainView aboveSubview:_imageViewBg];
        }
    }
    
    [self updateState];
    [controllerWindows dismissWithCompletion:nil];
}

/**
 *  已经删除窗口
 *
 *  @param controllerWindows UIControllerWindows
 *  @param index             索引
 */
- (void)controllerWindows:(UIControllerWindows *)controllerWindows didRemoveAtIndex:(NSInteger)index toIndex:(NSInteger)toIndex
{
    [_currMainView removeFromSuperview];
    [_currWebPage removeFromSuperview];
    [_arrWebPage removeObjectAtIndex:index];
    
    [_viewToolBar setWindowsNumber:_arrWebPage.count animated:YES];
    
    if (_arrWebPage.count==0) {
        return;
    }
    
    _currWebPage = _arrWebPage[toIndex];
    if (_currWebPage.showHome) {
        _currMainView = _viewHome;
    }
    else {
        _currMainView = _currWebPage;
    }
    
    // 显示 主视图
    _currMainView.frame = [self mainFrame];
    [_viewContain insertSubview:_currMainView aboveSubview:_imageViewBg];
    
    [self updateState];
}

#pragma mark - UIScrollViewWindowDatasource

/**
 *  窗口数量
 *
 *  @param scrollViewWindow UIScrollViewWindow
 *
 *  @return NSInteger
 */
- (NSInteger)numbersOfItemScrollViewWindow:(UIScrollViewWindow *)scrollViewWindow
{
    return _arrWebPage.count;
}

/**
 *  获取窗口 标题
 *
 *  @param scrollViewWindow    UIScrollViewWindow
 *  @param index                NSInteger 索引
 *  @return                     标题
 */
- (NSString *)scrollViewWindow:(UIScrollViewWindow *)scrollViewWindow titleAtIndex:(NSInteger)index
{
    UIWebPage *webPage = _arrWebPage[index];
    return webPage.title;
}

/**
 *  获取窗口缩略图
 *
 *  @param scrollViewWindow    UIScrollViewWindow
 *  @param index                NSInteger 索引
 *  @return                     缩略图
 */
- (UIImage *)scrollViewWindow:(UIScrollViewWindow *)scrollViewWindow imageAtIndex:(NSInteger)index
{
    return [self snapeShotOfWebViewAtIndex:index];
}

@end
