//
//  common.h
//

#import <Foundation/Foundation.h>

// Debug Logging
#if 1 // Set to 1 to enable debug logging
    #ifndef _DEBUG_LOG
        #define _DEBUG_LOG(x, ...) NSLog(x, ## __VA_ARGS__);
    #endif
#else
    #ifndef _DEBUG_LOG
        #define _DEBUG_LOG(x, ...)
    #endif
#endif

// safely release
#ifndef SAFE_RELEASE
    #if __has_feature(objc_arc)
        #define SAFE_RELEASE(_x_) {}
    #else
        #define SAFE_RELEASE(_x_) if(_x_){[_x_ release];_x_=nil;}
    #endif
#endif

#ifndef IsiPhone5
    #define IsiPhone5 CGSizeEqualToSize([[UIScreen mainScreen] bounds].size, CGSizeMake(320, 568))
#endif

#ifndef IsiOS7
    #define IsiOS7 [[UIApplication sharedApplication] respondsToSelector:NSSelectorFromString(@"ignoreSnapshotOnNextApplicationLaunch")]
#endif

// index col row
#define GetColWithIndexRow(_index, _row) (_index/_row)
#define GetRowWithIndexRow(_index, _row) ((_index+_row)%_row)

#define GetColWithIndexCol(_index, _col) ((_index+_col)%_col)
#define GetRowWithIndexCol(_index, _col) (_index/_col)

//  APNS host
#define APNS_HOST @"www.veryapps.com/plugin/apns"

#define kShouldShowLocalHome 1

// database path 
#ifndef DB_NAME
    #define DB_NAME @"KTBrowser.db"
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
    #define CustomTextAlignmentCenter NSTextAlignmentCenter
    #define CustomTextAlignmentLeft   NSTextAlignmentLeft
    #define CustomTextAlignmentRight  NSTextAlignmentRight

    #define CustomLineBreakModeWordWrap         NSLineBreakByWordWrapping
    #define CustomLineBreakModeCharacterWrap    NSLineBreakByCharWrapping
    #define CustomLineBreakModeClip             NSLineBreakByClipping
    #define CustomLineBreakModeHeadTruncation   NSLineBreakByTruncatingHead
    #define CustomLineBreakModeTailTruncation   NSLineBreakByTruncatingTail
    #define CustomLineBreakModeMiddleTruncation NSLineBreakByTruncatingMiddle
#else
    #define CustomTextAlignmentCenter UITextAlignmentCenter
    #define CustomTextAlignmentLeft   UITextAlignmentLeft
    #define CustomTextAlignmentRight  UITextAlignmentRight

    #define CustomLineBreakModeWordWrap         UILineBreakModeWordWrap
    #define CustomLineBreakModeCharacterWrap    UILineBreakModeCharacterWrap
    #define CustomLineBreakModeClip             UILineBreakModeClip
    #define CustomLineBreakModeHeadTruncation   UILineBreakModeHeadTruncation
    #define CustomLineBreakModeTailTruncation   UILineBreakModeTailTruncation
    #define CustomLineBreakModeMiddleTruncation UILineBreakModeMiddleTruncation
#endif

// =======================================
// =======================================
//////////////////// iPad ////////////////
// =======================================
// device
#ifndef iPhone5
    #define iPhone5 ([[UIScreen mainScreen] bounds].size.height == 568)
#endif

NSUInteger DeviceSystemMajorVersion();
#ifndef isIOS
    #define isIOS(versionNumber) (DeviceSystemMajorVersion() >= versionNumber)
#endif

#ifndef isPadIdiom
    #define isPadIdiom (UIUserInterfaceIdiomPad==UI_USER_INTERFACE_IDIOM())
#endif

#ifndef isPortrait
    #define isPortrait UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)
#endif

CGFloat InterfaceDegrees();
#define degreesToRadians(x) (M_PI*(x)/180.0)

// --------- bundle file -------
#define kBundlePathWithName(name) [[NSBundle mainBundle] pathForResource:name ofType:@"bundle"]
// home_ipad.bundle
#define BundleImageForHome(imgName, imgType) [UIImage imageWithContentsOfFile:[[NSBundle bundleWithPath:kBundlePathWithName(@"home_ipad")] pathForResource:imgName ofType:imgType]]
#define BundlePngImageForHome(imgName) BundleImageForHome(imgName, @"png")
// search_ipad.bundle file
#define BundleImageForSearch(imgName) [UIImage imageWithContentsOfFile:[[NSBundle bundleWithPath:kBundlePathWithName(@"search_ipad")] pathForResource:imgName ofType:@"png"]]

// -------------- arBao define --------------

// screenSize
#define SCREEN_SIZE_IPAD CGSizeMake(([RotateManager_ipad screenOrientation] == ScreenOrientationPortrait ? 768: 1024),([RotateManager_ipad screenOrientation] == ScreenOrientationPortrait ? (isIOS(7) ? 1024: 1004): (isIOS(7) ?768: 748)))

#define SCREEN_SIZE_IPHONE CGSizeMake(320,(isIOS(7) ? (iPhone5 ? 568:548):(iPhone5 ? 480:460)))
#define isDayMode ([DayModeManager_ipad dayMode] == DayModeIsDay)

#define ImageFromSkinByName(_X_) ([SkinManager_ipad getSkinImageByName:_X_])

#define GetTextFromKey(_X_) ([LangManager_ipad getTextFromKey:_X_])
