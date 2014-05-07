//
//  UIViewInputToolBar.h
//  KTBrowser
//
//  Created by David on 14-2-15.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewSkin.h"

@interface UIViewInputToolBar : UIViewSkin <UIInputViewAudioFeedback>

@property (nonatomic, weak) UIResponder<UITextInput> *inputView;

+ (void)attachToInputView:(UIResponder<UITextInput> *)inputView;
+ (void)clearAttach;

@end
