//
//  UINavigationControllerCustom.m
//

#import "ControllerNav_ipad.h"

@interface ControllerNav_ipad ()

@end

static BOOL _allowAutorotate = YES;

@implementation ControllerNav_ipad

+ (void)allowAutorotate:(BOOL)allow {
    _allowAutorotate = allow;
}

- (id)init {
    if(self = [super init]) {
        self.navigationBar.hidden = YES;
        self.navigationBarHidden = YES;
    }
    
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    if(self = [super initWithRootViewController:rootViewController]) {
        self.navigationBar.hidden = YES;
        self.navigationBarHidden = YES;
    }
    
    return self;
}

#pragma mark - autorotate
- (BOOL)shouldAutorotate {
    if (_allowAutorotate) {
        return (![AppManager screenLocked]);
    }
    
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

// iOS < 6.0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return [self shouldAutorotate];
}

@end
