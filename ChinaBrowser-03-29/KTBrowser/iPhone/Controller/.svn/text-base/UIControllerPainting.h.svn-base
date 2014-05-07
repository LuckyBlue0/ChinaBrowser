//
//  UIControllerPainting.h
//  KTBrowser
//
//  Created by David on 14-2-21.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewBrushSet.h"
#import "UIViewEraserSet.h"
#import "UIViewOffScreenDraw.h"
#import "UIViewSNSOption.h"

@interface UIControllerPainting : UIViewController <UIViewBrushSetDelegate, UIViewEraserSetDelegate, UIViewSNSOptionDelegate>
{
    IBOutlet UIViewOffScreenDraw *_viewPainting;
    IBOutlet UIView *_viewBottom;
    
    IBOutlet UIButton *_btnBack;
    IBOutlet UIButton *_btnBrush;
    IBOutlet UIButton *_btnEraser;
    IBOutlet UIButton *_btnRedo;
    IBOutlet UIButton *_btnMore;
    
    CGPoint _pointPrev;
}

@property (nonatomic, strong) UIImage *image;

@end
