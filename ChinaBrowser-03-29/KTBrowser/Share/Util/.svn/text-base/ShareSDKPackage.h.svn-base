//
//  ShareSDKPackage.h
//

#import <Foundation/Foundation.h>

#import <ShareSDK/ShareSDK.h>

@interface ShareSDKPackage : NSObject

@property (nonatomic,weak) UIViewController *rootViewController;

+ (ShareSDKPackage *)shareShareSDKPackage;

- (void)registerSDK_KEYS;

- (void)showTheShareSheetWithTitle:(NSString *)title andContent:(NSString *)content andUrl:(NSString *)url andDescription:(NSString *)description andImage:(NSString *)imagePath;

- (void)shareWithType:(int)type andTitle:(NSString *)title andContent:(NSString *)content andUrl:(NSString *)url andDescription:(NSString *)description andImage:(NSString *)imagePath;

- (void)showTheShareSheetWithTitle:(NSString *)title andContent:(NSString *)content andUrl:(NSString *)url andDescription:(NSString *)description andImage:(NSString *)imagePath andSender:(UIView *)sender;

@end

