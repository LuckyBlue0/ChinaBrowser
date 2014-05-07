//
//  UIWebPage.m
//  ChinaBrowser
//
//  Created by David on 14-3-24.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIWebPage.h"

#import "UIImage+Bundle.h"

@interface UIWebPage ()

- (void)setup;

@end

@implementation UIWebPage

@synthesize title = _title;
@synthesize link = _link;

- (void)setTitle:(NSString *)title
{
    _title = title;
}

- (NSString *)title
{
    if (_showHome) {
        return NSLocalizedString(@"homePage", nil);
    }
    else if (!_isCache && _link) {
        _title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        return _title;
    }
    else {
        return NSLocalizedString(@"JiaZaiZhong", nil);
    }
}

- (void)setFontSize:(CGFloat)fontSize
{
     
}

- (void)setLink:(NSString *)link
{
    _link = link;
    if (_link) {
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_link]]];
    }
}

- (NSString *)link
{
    return _link;
}

- (void)setup
{
    _webView = [[UIWebView alloc] initWithFrame:self.bounds];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.scrollView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.6];
    _webView.opaque = YES;
    _webView.scrollView.alwaysBounceVertical = NO;
    _webView.scrollView.alwaysBounceHorizontal = NO;
    for (UIView *subView in _webView.scrollView.subviews) {
        if([subView isKindOfClass:[UIImageView class]]) {
            [subView removeFromSuperview];
        }
    }
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
    
    _fontSize = kWebFontSizeDefault;
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
}

+ (UIWebPage *)webPageFromXib;
{
    return [[NSBundle mainBundle] loadNibNamed:@"UIWebPage" owner:nil options:nil][0];
}

/**
 *  网页快照（需要子类实现***）
 */
- (void)snapeWebView
{
    if (_isCache||!_link) return;
    
    _isCache = YES;
    _imageViewSnapeshot = [[UIImageView alloc] initWithFrame:_webView.frame];
    _imageViewSnapeshot.clipsToBounds = YES;
    _imageViewSnapeshot.backgroundColor = [UIColor whiteColor];
    _imageViewSnapeshot.image = [UIImage imageFromView:_webView];
    [_webView loadHTMLString:@"" baseURL:nil];
    _webView.alpha = 0;
    
    [_webView removeFromSuperview];
    [self addSubview:_imageViewSnapeshot];
}

/**
 *  停止加载网页（需要子类实现***）
 */
- (void)stop
{
    [_webView stopLoading];
}

/**
 *  刷新网页，重新加载网页（需要子类实现***）
 */
- (void)reload
{
    if (_link) {
        if (_isCache) {
            _isCache = NO;
            [self insertSubview:_webView belowSubview:_imageViewSnapeshot];
            [UIView animateWithDuration:1 animations:^{
                _imageViewSnapeshot.alpha = 0;
                _webView.alpha = 1;
            } completion:^(BOOL finished) {
                [_imageViewSnapeshot removeFromSuperview];
                _imageViewSnapeshot = nil;
            }];
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_link]]];
        }
        else {
            [_webView reload];
        }
    }
}

/**
 *  后退（需要子类实现***）
 */
- (void)goBack
{
    [_webView goBack];
}

/**
 *  前进（需要子类实现***）
 */
- (void)goForward
{
    [_webView goForward];
}

/**
 *  加载网页
 *
 *  @param url url
 */
- (void)loadURL:(NSURL *)url
{
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    /*
    if ([request.URL.scheme isEqualToString:@"newtab"]) {
        NSString *link = [request.URL.resourceSpecifier urlDecode]?:request.URL.resourceSpecifier;
        if (link.length>0) {
            // TODO:新建标签
            
        }
        return NO;
    }
    */
    
    BOOL ret = YES;
    if ([_delegate respondsToSelector:@selector(webPage:webView:shouldStartLoadWithRequest:navigationType:)]) {
        ret = [_delegate webPage:self webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    return YES&ret;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if ([_delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [_delegate webPage:self webViewDidStartLoad:webView];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    /*
    // js 注入
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"handle" ofType:@"js"];
    NSString *js = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"MyIPhoneApp_Init();"];
    */
    
    if (!_isCache) {
        _link = [_webView stringByEvaluatingJavaScriptFromString:@"window.location.href"];
        _title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    
    
    if ([_delegate respondsToSelector:@selector(webPage:webViewDidFinishLoad:)]) {
        [_delegate webPage:self webViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([_delegate respondsToSelector:@selector(webPage:webView:didFailLoadWithError:)]) {
        [_delegate webPage:self webView:webView didFailLoadWithError:error];
    }
}

@end
