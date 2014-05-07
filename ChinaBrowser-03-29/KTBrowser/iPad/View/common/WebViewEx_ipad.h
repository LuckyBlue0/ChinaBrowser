//
//  WebViewEx_ipad.h
//

#import <UIKit/UIKit.h>

@interface WebViewEx_ipad : UIWebView

- (CGSize)windowSize;
- (CGPoint)scrollOffset;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *link;

@property (nonatomic, assign) BOOL shouldReload;
@property (nonatomic, assign) CGFloat textSizeAdjust;

@end
