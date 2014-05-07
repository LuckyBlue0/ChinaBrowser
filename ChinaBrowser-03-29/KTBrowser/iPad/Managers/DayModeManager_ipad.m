//
//  DayModeManager_ipad.m
//

#import "DayModeManager_ipad.h"

@interface DayModeManager_ipad ()

@property (nonatomic, assign) DayMode dayMode;

@end

@implementation DayModeManager_ipad

- (id)init {
    if(self = [super init]) {
        if(![[NSUserDefaults standardUserDefaults] objectForKey:kDayModeSave]) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:DayModeIsDay] forKey:kDayModeSave];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        _dayMode = [[[NSUserDefaults standardUserDefaults] objectForKey:kDayModeSave] intValue];
    }
    
    return self;
}

+ (DayMode)dayMode {
    return [self instance].dayMode;
}

- (void)changeDayMode {
    _dayMode = (_dayMode==DayModeIsDay)?DayModeIsNight:DayModeIsDay;

    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:_dayMode] forKey:kDayModeSave];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifDayModeChanged object:nil];
}

+ (void)switchDayMode {
    [[self instance] changeDayMode];
}

+ (DayModeManager_ipad *)instance {
    static DayModeManager_ipad *instance;
    if(instance == nil) {
        instance = [[DayModeManager_ipad alloc] init];
    }
    
    return instance;
}

@end
