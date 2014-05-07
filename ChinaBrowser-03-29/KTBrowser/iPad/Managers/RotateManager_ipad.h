//
//  RotateManager_ipad.h
//

#import <Foundation/Foundation.h>

@interface RotateManager_ipad : NSObject

typedef enum {
    ScreenOrientationLandscape,
    ScreenOrientationPortrait,
} ScreenOrientation;

+ (ScreenOrientation)screenOrientation;
+ (void)toScreenOrientation:(ScreenOrientation)screenOrientation;
+ (void)changeScreenOrientation;

@end
