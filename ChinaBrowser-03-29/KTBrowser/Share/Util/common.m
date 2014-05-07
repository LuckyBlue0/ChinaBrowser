//
//  common.m
//

#import "common.h"

NSUInteger DeviceSystemMajorVersion() {
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    
    return _deviceSystemMajorVersion;
}

CGFloat InterfaceDegrees() {
    CGFloat degrees;
    
    switch ([UIApplication sharedApplication].statusBarOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            degrees = 180.0;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            degrees = -90.0;
            break;
        case UIInterfaceOrientationLandscapeRight:
            degrees = 90.0;
            break;
        default: // UIInterfaceOrientationPortrait
            degrees = 0.0;
            break;
    }
    
    return degrees;
}
