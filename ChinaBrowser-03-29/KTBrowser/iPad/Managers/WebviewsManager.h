//
//  WebviewsManager.h
//

#import <Foundation/Foundation.h>

@class WebViewEx_ipad;

@interface WebviewsManager : NSObject

+ (NSMutableArray *)arrWebViews;
+ (NSMutableArray *)arrURLCaches;
+ (void)setObjDelegate:(id<UIWebViewDelegate>)objDelegate;

+ (void)addWebview;
+ (void)deleteWebviewByIndex:(NSUInteger)index;
+ (void)deleteWebview:(WebViewEx_ipad *)webview;
+ (void)remakeWebviewsExcludeCurrent:(WebViewEx_ipad *)webviewCurrent;
+ (void)changeCacheWithUrl:(NSString *)url webview:(WebViewEx_ipad *)webview;

@end
