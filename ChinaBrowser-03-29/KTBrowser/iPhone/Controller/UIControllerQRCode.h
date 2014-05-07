//
//  UIControllerQRCode.h
//  KTBrowser
//
//  Created by David on 14-3-13.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZBarSDK.h"

@protocol UIControllerQRCodeDelegate;

@interface UIControllerQRCode : UIViewController <ZBarReaderViewDelegate>
{
    IBOutlet UIButton *_btnTorchMode;
    IBOutlet UIImageView *_imageViewLine;
    IBOutlet UIImageView *_imageViewMask;
    IBOutlet UIButton *_btnCancel;
    IBOutlet UILabel *_labelTitle;
    
    ZBarReaderView *_viewReader;
    
}

@property (nonatomic, weak) IBOutlet id<UIControllerQRCodeDelegate> delegate;

@end

@protocol UIControllerQRCodeDelegate <NSObject>

/**
 *  扫描结果
 *
 *  @param controllerQRCode     UIControllerQRCode
 *  @param result               NSString *
 */
- (void)controllerQRCode:(UIControllerQRCode *)controllerQRCode result:(NSString *)result;

/**
 *  已经消失
 *
 *  @param controllerQRCode UIControllerQRCode
 */
- (void)controllerQRCodeDidDismiss:(UIControllerQRCode *)controllerQRCode;

- (void)controllerQRCode:(UIControllerQRCode *)controllerQRCode willRotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration;

@end
