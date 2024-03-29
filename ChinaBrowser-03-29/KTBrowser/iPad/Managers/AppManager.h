//
//  AppManager.h
//

#import <Foundation/Foundation.h>

#import "ControllerRoot_ipad.h"

@interface AppManager : NSObject

// topbar folder file
UIImage * getTopBarImageWithName(NSString *imgName);
// menu folder file
UIImage * getMenuImageWithName(NSString *imageName);

+ (ControllerRoot_ipad *)vcRoot;

+ (BOOL)stealthMode;
+ (void)changeStealthMode;

+ (BOOL)screenLocked;
+ (void)changeScreenLocked;

+ (BOOL)noImgMode;
+ (void)changeNoImgMode;

+ (CGFloat)fontAdjust;
+ (void)changeFontAdjust:(CGFloat)fontAdjust;

+ (CGFloat)brightness;
+ (void)changeBrightness:(CGFloat)brightness;

+ (NSArray *)homeSites;
+ (void)setHomeSitesWithArray:(NSArray *)array;

+ (NSArray *)topSearchItems;
+ (NSArray *)homeSearchItems;

+ (NSDictionary *)skinImages;
+ (NSString *)currentSkinKey;
+ (void)setCurrentSkinKey:(NSString *)key;
+ (UIImage *)currentSkin;
+ (void)setCurrentSkin:(UIImage *)skin;
+ (NSString *)addSkin:(UIImage *)skin;
+ (void)removeSkinForKey:(NSString *)key;

@end
