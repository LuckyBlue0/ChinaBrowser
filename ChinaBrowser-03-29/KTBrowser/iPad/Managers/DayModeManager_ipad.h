//
//  DayModeManager_ipad.h
//

#import <Foundation/Foundation.h>

@interface DayModeManager_ipad : NSObject

typedef enum {
    DayModeIsDay,
    DayModeIsNight,
} DayMode;

+ (DayMode)dayMode;
+ (void)switchDayMode;

@end
