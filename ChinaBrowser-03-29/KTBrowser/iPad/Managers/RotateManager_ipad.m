//
//  RotateManager_ipad.m
//

#import "RotateManager_ipad.h"

@interface RotateManager_ipad ()

@property (nonatomic, assign) ScreenOrientation screenOrientation;

@end

@implementation RotateManager_ipad

+ (RotateManager_ipad *)instance {
    static RotateManager_ipad* instance;
    if(instance == nil) {
        instance = [[RotateManager_ipad alloc] init];
    }
    
    return instance;
}

- (void)switchScreenOrientation {
    _screenOrientation = (_screenOrientation==ScreenOrientationLandscape) ? ScreenOrientationPortrait:ScreenOrientationLandscape;
}

+ (void)changeScreenOrientation {
    [[self instance] switchScreenOrientation];
}

+ (ScreenOrientation)screenOrientation {
    return [self instance].screenOrientation;
}

+ (void)toScreenOrientation:(ScreenOrientation)screenOrientation {
    [[self instance] setScreenOrientation:screenOrientation];
}

@end
