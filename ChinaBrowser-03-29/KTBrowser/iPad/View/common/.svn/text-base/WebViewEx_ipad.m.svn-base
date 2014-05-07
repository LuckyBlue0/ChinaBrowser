//
//  WebViewEx_ipad.m
//

#import "WebViewEx_ipad.h"

@implementation WebViewEx_ipad

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.textSizeAdjust = 1;
    }
    
    return self;
}

- (NSString *)title {
    return [self stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (NSString *)link {
    return self.request.URL.absoluteString;
}

- (CGSize)windowSize {
    CGSize size;
    size.width = [[self stringByEvaluatingJavaScriptFromString:@"window.innerWidth"] integerValue];
    size.height = [[self stringByEvaluatingJavaScriptFromString:@"window.innerHeight"] integerValue];
    
    return size;
}

- (CGPoint)scrollOffset {
    CGPoint pt;
    pt.x = [[self stringByEvaluatingJavaScriptFromString:@"window.pageXOffset"] integerValue];
    pt.y = [[self stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] integerValue];
    
    return pt;
}

@end
