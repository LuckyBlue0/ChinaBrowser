//
//  main.m
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "AppDelegate_ipad.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        Class appClass = isPadIdiom?[AppDelegate_ipad class]:[AppDelegate class];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([appClass class]));
    }
}
