//
//  LangManager_ipad.m
//

#import "LangManager_ipad.h"

#import "NSString+Hashing.h"

#define kHaveBeenChangeLanguageByUser @"kHaveBeenChangeLanguageByUser"
#define kLanguageFormUserChoosen      @"kLanguageFormUserChoosen"

@implementation LangManager_ipad

+ (LangManager_ipad *)instance {
    static LangManager_ipad* instance;
    if(instance == nil) {
        instance = [[LangManager_ipad alloc] init];
    }
    
    return instance;
}

- (NSString *)textFromKey:(NSString *)key {
    // 用户自定义语言
    if([[NSUserDefaults standardUserDefaults] objectForKey:kHaveBeenChangeLanguageByUser]) {
        NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:kLanguageFormUserChoosen];
        switch ([num integerValue]) {
            case LangageTypeEnglish: {
                return NSLocalizedStringFromTable(key, @"en.lproj/", nil);
            }
                break;
            case LangageTypeChineseSimple: {
                return NSLocalizedStringFromTable(key, @"zh-Hans.lproj/", nil);
            }
                break;
            case LangageTypeChineseTraditional: {
                return NSLocalizedStringFromTable(key, @"zh-Hant.lproj/", nil);
            }
                break;
            case LangageTypeJapanese: {
                return NSLocalizedStringFromTable(key, @"ja.lproj/", nil);
            }
                break;
            case LangageTypeKorean: {
                return NSLocalizedStringFromTable(key, @"ko.lproj/", nil);
            }
                break;
                
            default:
                break;
        }
    }
    
    // 系统语言
    return NSLocalizedString(key, nil);
}

+ (NSString *)getTextFromKey:(NSString *)key {
    return [[self instance] textFromKey:key];
}

- (void)toLanguage:(LangageType)langageType {
    _currentLanguageType = langageType;
    if([[NSUserDefaults standardUserDefaults] objectForKey:kHaveBeenChangeLanguageByUser] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kHaveBeenChangeLanguageByUser];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:langageType] forKey:kLanguageFormUserChoosen];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifLangChanged object:nil];
}

+ (void)changeLanguageTo:(LangageType)langageType {
    return [[self instance] toLanguage:langageType];
}

@end
