//
//  UIColorEx.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define RGB_COLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBA_COLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

#define HSV_COLOR(h,s,v) [UIColor colorWithHue:(h) saturation:(s) value:(v) alpha:1]
#define HSVA_COLOR(h,s,v,a) [UIColor colorWithHue:(h) saturation:(s) value:(v) alpha:(a)]

@interface UIColor (UIColorEx)

+ (UIColor*)randomColorWithAlpha:(CGFloat)alpha;
+ (UIColor*)randomColor;

+ (UIColor *)colorWithHex:(NSString *)hexStr alpha:(CGFloat)alphaValue;
+ (UIColor *)colorWithHex:(NSString *)hexStr;

@end
