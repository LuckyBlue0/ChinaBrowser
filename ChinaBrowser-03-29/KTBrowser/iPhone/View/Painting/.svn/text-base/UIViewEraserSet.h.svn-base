//
//  UIViewEraserSet.h
//  KTBrowser
//
//  Created by David on 14-2-26.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewPanel.h"

@protocol UIViewEraserSetDelegate;

@interface UIViewEraserSet : UIViewPanel
{
    IBOutlet UIView *_viewWrap;
    IBOutlet UISlider *_slider;
}

@property (nonatomic, weak) id<UIViewEraserSetDelegate> delegate;

+ (UIViewEraserSet *)viewEraserSetFromXib;
- (void)setEraserWidth:(CGFloat)width;

@end

@protocol UIViewEraserSetDelegate <NSObject>

- (void)viewEraserSetWidth:(CGFloat)eraserWidth;

@end
