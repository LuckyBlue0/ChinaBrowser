//
//  WindowRoot_ipad.m
//
//  Created by arBao on 8/16/13.
//  Copyright (c) 2013 arBao. All rights reserved.
//

#import "WindowRoot_ipad.h"

@implementation WindowRoot_ipad

- (void)tapAndHoldAction:(NSTimer*)timer {
    _contextualMenuTimer = nil;
    NSDictionary *coord = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithFloat:_tapLocation.x], @"x",
                           [NSNumber numberWithFloat:_tapLocation.y], @"y", nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"TapAndHoldNotification" object:coord];
}

- (void)sendEvent:(UIEvent *)event {
    NSSet *touches = [event touchesForWindow:self];
    
    [super sendEvent:event];    // Call super to make sure the event is processed as usual
    
    if ([touches count] == 1) { // We're only interested in one-finger events
        UITouch *touch = [touches anyObject];
        NSInteger touch_phase = touch.phase;
        switch (touch_phase) {
            case UITouchPhaseBegan:  // A finger touched the screen
                _tapLocation = [touch locationInView:self];
                [_contextualMenuTimer invalidate];
                _contextualMenuTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                        target:self selector:@selector(tapAndHoldAction:)
                                                                      userInfo:nil repeats:NO];
                break;
                
            case UITouchPhaseEnded:
            case UITouchPhaseMoved:
            case UITouchPhaseCancelled:
                [_contextualMenuTimer invalidate];
                _contextualMenuTimer = nil;
                break;
        }
    }
    else {                    // Multiple fingers are touching the screen
        [_contextualMenuTimer invalidate];
        _contextualMenuTimer = nil;
    }
}

@end
