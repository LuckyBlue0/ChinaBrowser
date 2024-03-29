//
//  UIViewBrushSet.h
//  KTBrowser
//
//  Created by David on 14-2-26.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewPanel.h"

@protocol UIViewBrushSetDelegate;

@interface UIViewBrushSet : UIViewPanel
{
    IBOutlet UIView *_viewWrap;
    IBOutlet UIView *_viewBrush;
    
    IBOutlet UISlider *_slider;
    
    NSArray *_arrColor;
}

@property (nonatomic, weak) id<UIViewBrushSetDelegate> delegate;

+ (UIViewBrushSet *)viewBrushSetFromXib;

- (void)setColor:(UIColor *)color width:(CGFloat)width;

@end

@protocol UIViewBrushSetDelegate <NSObject>

- (void)viewBrushSetLineColor:(UIColor *)lineColor;
- (void)viewBrushSetLineWidth:(CGFloat)lineWidth;

@end
