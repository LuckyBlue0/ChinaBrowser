//
//  ViewIndicator.h
//
//  Created by Glex on 13-5-30.
//  Copyright (c) 2013年 VeryApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

typedef enum {
    IndicatorTypeDefault,
    IndicatorTypeSuccess,
    IndicatorTypeWarning,
    IndicatorTypeLoading,
    IndicatorTypeProgress,
    IndicatorTypeError
} IndicatorType;

@interface ViewIndicator : UIView <ASIProgressDelegate>

/**
 * IndicatorTypeDefault Style
 */
+ (void)showWithStatus:(NSString *)status;

/**
 * 调用此函数, 则需手动关闭视图, 只对下列枚举值有效:
 * IndicatorTypeDefault,
 * IndicatorTypeSuccess,
 * IndicatorTypeWarning,
 * IndicatorTypeError
 */
+ (void)showWithStatus:(NSString *)status indicatorType:(IndicatorType)indicatorType;

+ (void)showProgressWithStatus:(NSString *)status request:(ASIHTTPRequest *)request;

+ (void)showLoadingWithStatus:(NSString *)status request:(ASIHTTPRequest *)request;

+ (void)showSuccessWithStatus:(NSString *)status duration:(NSTimeInterval)duration;

+ (void)showErrorWithStatus:(NSString *)status duration:(NSTimeInterval)duration;

+ (void)showWarningWithStatus:(NSString *)status duration:(NSTimeInterval)duration;

+ (void)dismiss;

@end