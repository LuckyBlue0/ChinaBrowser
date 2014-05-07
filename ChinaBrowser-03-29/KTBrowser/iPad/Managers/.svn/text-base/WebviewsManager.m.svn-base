//
//  WebviewsManager.m
//

#import "WebviewsManager.h"

#import "WebViewEx_ipad.h"

#import "UIWebView+Clean.h"

#define kInsetTop (isIOS(7)?105:85)
#define kOriginY (isIOS(7)?105:85)

@interface WebviewsManager ()

@property (nonatomic, strong) NSMutableArray *arrWebViews;
@property (nonatomic, strong) NSMutableArray *arrURLCaches;
@property (nonatomic, weak) id<UIWebViewDelegate> objDelegate;

@end

@implementation WebviewsManager

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_arrWebViews removeAllObjects];
    [_arrURLCaches removeAllObjects];
}

- (id)init {
    if (self = [super init]) {
        _arrWebViews = [[NSMutableArray alloc] init];
        _arrURLCaches = [[NSMutableArray alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(whenNoImgModeChanged:) name:kNotifNoImgModeChanged object:nil];
    }
    
    return self;
}

+ (WebviewsManager *)instance {
    static WebviewsManager *instance;
    if(!instance) {
        instance = [[WebviewsManager alloc] init];
    }
    
    return instance;
}

+ (NSMutableArray *)arrWebViews {
    return [self instance].arrWebViews;
}

+ (NSMutableArray *)arrURLCaches {
    return [self instance].arrURLCaches;
}

+ (void)setObjDelegate:(id<UIWebViewDelegate>)objDelegate {
    [self instance].objDelegate = objDelegate;
}

/*
 * 无图模式
 */
- (void)whenNoImgModeChanged:(NSNotification *)notif {
    WebViewEx_ipad *currWebView = (WebViewEx_ipad *)notif.object;
    
    for (WebViewEx_ipad *webView in _arrWebViews) {
        webView.shouldReload = (webView != currWebView);
    }
}

- (WebViewEx_ipad *)makeWebview {
    CGRect rc = CGRectZero;
    rc.size = CGSizeMake(isPortrait?768:1024, isPortrait?1024:768);
//    rc.size.height += kInsetTop;
    rc.origin.y = kOriginY;
    WebViewEx_ipad *webView = [[WebViewEx_ipad alloc] initWithFrame:rc];
    webView.scalesPageToFit = YES;
    webView.backgroundColor = [UIColor clearColor];
    webView.dataDetectorTypes = UIDataDetectorTypeNone;
//    webView.scrollView.contentInset = UIEdgeInsetsMake(kInsetTop, 0, 0, 0);
    if(_objDelegate)
        webView.delegate = _objDelegate;
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    return webView;
}

- (void)addOneWebview {
    [_arrWebViews addObject:[self makeWebview]];
}

+ (void)addWebview {
    [[self instance] addOneWebview];
}

- (void)deleteOneWebviewByIndex:(NSUInteger)index {
    WebViewEx_ipad *webview = [_arrWebViews objectAtIndex:index];
    
    [_arrURLCaches removeObjectAtIndex:index];
    [_arrWebViews removeObjectAtIndex:index];
    
    [webview cleanForDealloc];
    webview = nil;
}

+ (void)deleteWebviewByIndex:(NSUInteger)index {
    [[self instance] deleteOneWebviewByIndex:index];
}

- (void)deleteOneWebview:(WebViewEx_ipad *)webview {
    int index = [_arrWebViews indexOfObject:webview];
    
    [self deleteOneWebviewByIndex:index];
}

+ (void)deleteWebview:(WebViewEx_ipad *)webview {
    [[self instance] deleteOneWebview:webview];
}

- (void)whenMemoryWarning:(WebViewEx_ipad *)webviewCurrent {
    for (int idx=0; idx<_arrWebViews.count; idx++) {
        WebViewEx_ipad *webViewRaw = [_arrWebViews objectAtIndex:idx];
        if (webViewRaw != webviewCurrent) {
            WebViewEx_ipad *webViewNew = [self makeWebview];
            webViewNew.shouldReload = ![[_arrURLCaches objectAtIndex:idx] isEqualToString:@""];
            [_arrWebViews replaceObjectAtIndex:idx withObject:webViewNew];

            [webViewRaw cleanForDealloc];
            webViewRaw = nil;
        }
    }
}

+ (void)remakeWebviewsExcludeCurrent:(WebViewEx_ipad *)webviewCurrent {
    [[self instance] whenMemoryWarning:webviewCurrent];
}

- (void)changeCache:(NSString *)url webview:(WebViewEx_ipad *)webview {
    url = url?url:@"";
    int index = [_arrWebViews indexOfObject:webview];
    if(index != NSNotFound) {
        if (index < _arrURLCaches.count) {
            [_arrURLCaches replaceObjectAtIndex:index withObject:url];
        }
        else {
            [_arrURLCaches addObject:url];
        }
    }
}

+ (void)changeCacheWithUrl:(NSString *)url webview:(WebViewEx_ipad *)webview {
    [[self instance] changeCache:url webview:webview];
}

@end
