//
//  SkinManager_ipad.m
//

#import "SkinManager_ipad.h"

@implementation SkinManager_ipad

+ (SkinManager_ipad *)instance {
    static SkinManager_ipad *instance;
    
    if(instance == nil) {
        instance = [[SkinManager_ipad alloc] init];
    }
    
    return instance;
}

/**
 * 获取当前皮肤对应的图片
 */
+ (UIImage *)getSkinImageByName:(NSString *)imgName {
    NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:isDayMode?@"Skins/imgsDay":@"Skins/imgsNight"];
    
    NSString *imgPath = [bundlePath stringByAppendingPathComponent:imgName];
    
    return [UIImage imageWithContentsOfFile:imgPath];
}

/**
 * 皮肤管理区域的模糊图片
 */
+ (UIImage *)skinBlurImage {
    return [[AppManager vcRoot] getSkinBlurImage];
}

@end
