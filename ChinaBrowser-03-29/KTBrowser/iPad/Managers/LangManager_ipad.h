//
//  LangManager_ipad.h
//

#import <Foundation/Foundation.h>

@interface LangManager_ipad : NSObject

@property(nonatomic, assign)LangageType currentLanguageType;

+ (NSString *)getTextFromKey:(NSString *)key;
+ (void)changeLanguageTo:(LangageType)langageType;

@end
