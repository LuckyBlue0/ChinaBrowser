//
//  UIViewSetFont.h
//  KTBrowser
//
//  Created by David on 14-3-4.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewPanel.h"

#import "UIViewSetFontDelegate.h"

@interface UIViewSetFont : UIViewPanel
{
    IBOutlet UISlider *_slider;
    
    IBOutlet UILabel *_labelContent;
    IBOutlet UILabel *_labelFontsize;
    
    CGFloat _fontsizeOld;
}

@property (nonatomic, weak) IBOutlet id<UIViewSetFontDelegate> delegate;

- (void)setFontsize:(CGFloat)fontsize;

+ (UIViewSetFont *)viewSetFontFromXib;

@end
