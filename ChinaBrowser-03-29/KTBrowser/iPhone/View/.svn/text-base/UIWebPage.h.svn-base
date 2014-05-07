//
//  UIWebPage.h
//  ChinaBrowser
//
//  Created by David on 14-3-24.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIWebPageDelegate;

@interface UIWebPage : UIView <UIWebViewDelegate>
{
    UIImageView *_imageViewSnapeshot;
}

@property (nonatomic, weak) id<UIWebPageDelegate> delegate;

@property (nonatomic, strong) IBOutlet UIWebView *webView;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *link;

@property (nonatomic, assign, readonly) BOOL isCache;
@property (nonatomic, assign) BOOL showHome;

@property (nonatomic, assign) CGFloat fontSize;

+ (UIWebPage *)webPageFromXib;

/**
 *  网页快照（需要子类实现***）
 */
- (void)snapeWebView;

/**
 *  停止加载网页（需要子类实现***）
 */
- (void)stop;

/**
 *  刷新网页，重新加载网页（需要子类实现***）
 */
- (void)reload;

/**
 *  后退（需要子类实现***）
 */
- (void)goBack;

/**
 *  前进（需要子类实现***）
 */
- (void)goForward;

/**
 *  加载网页
 *
 *  @param url url
 */
- (void)loadURL:(NSURL *)url;

@end

@protocol UIWebPageDelegate <NSObject>

@optional
- (BOOL)webPage:(UIWebPage *)webPag webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)webPage:(UIWebPage *)webPag webViewDidStartLoad:(UIWebView *)webView;
- (void)webPage:(UIWebPage *)webPag webViewDidFinishLoad:(UIWebView *)webView;
- (void)webPage:(UIWebPage *)webPag webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;

@end


