//
//  UIViewInputToolBar.m
//  KTBrowser
//
//  Created by David on 14-2-15.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewInputToolBar.h"

static UIViewInputToolBar *viewInputToolBar;

@interface UIViewInputToolBar ()

- (void)onTouchKey:(UIButton *)item;

@end

@implementation UIViewInputToolBar
{
    IBOutlet UIButton *_btnLeft;
    IBOutlet UIButton *_btnRight;
    IBOutlet UIButton *_btnWWW;
    IBOutlet UIButton *_btnXie;
    IBOutlet UIButton *_btn_;
    IBOutlet UIButton *_btn__;
    IBOutlet UIButton *_btnCom;
    IBOutlet UIButton *_btnCn;
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+ (void)attachToInputView:(UIResponder<UITextInput> *)inputView
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        viewInputToolBar = [[NSBundle mainBundle] loadNibNamed:@"UIViewInputToolBar" owner:self options:nil][0];
    });
    [(id)inputView setInputAccessoryView:viewInputToolBar];
    viewInputToolBar.inputView = inputView;
}

+ (void)clearAttach
{
    viewInputToolBar.inputView = nil;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    for (UIButton *item in self.subviews) {
        [item addTarget:self action:@selector(onTouchKey:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithFilename:@"InputToolBar.bundle/background.png"]];
    
    [_btnLeft setImage:[UIImage imageWithFilename:@"InputToolBar.bundle/left.png"]
              forState:UIControlStateNormal];
    [_btnLeft setImage:[UIImage imageWithFilename:@"InputToolBar.bundle/left_selected.png"]
              forState:UIControlStateHighlighted];
    
    [_btnRight setImage:[UIImage imageWithFilename:@"InputToolBar.bundle/right.png"]
              forState:UIControlStateNormal];
    [_btnRight setImage:[UIImage imageWithFilename:@"InputToolBar.bundle/right_selected.png"]
              forState:UIControlStateHighlighted];
    
    [_btnWWW setImage:[UIImage imageWithFilename:@"InputToolBar.bundle/www.png"]
              forState:UIControlStateNormal];
    [_btnWWW setImage:[UIImage imageWithFilename:@"InputToolBar.bundle/www_selected.png"]
              forState:UIControlStateHighlighted];
    
    [_btnXie setImage:[UIImage imageWithFilename:@"InputToolBar.bundle/xie.png"]
              forState:UIControlStateNormal];
    [_btnXie setImage:[UIImage imageWithFilename:@"InputToolBar.bundle/xie_selected.png"]
              forState:UIControlStateHighlighted];
    
    [_btn_ setImage:[UIImage imageWithFilename:@"InputToolBar.bundle/-.png"]
              forState:UIControlStateNormal];
    [_btn_ setImage:[UIImage imageWithFilename:@"InputToolBar.bundle/-_selected.png"]
              forState:UIControlStateHighlighted];
    
    [_btn__ setImage:[UIImage imageWithFilename:@"InputToolBar.bundle/_.png"]
              forState:UIControlStateNormal];
    [_btn__ setImage:[UIImage imageWithFilename:@"InputToolBar.bundle/__selected.png"]
              forState:UIControlStateHighlighted];
    
    [_btnCom setImage:[UIImage imageWithFilename:@"InputToolBar.bundle/com.png"]
              forState:UIControlStateNormal];
    [_btnCom setImage:[UIImage imageWithFilename:@"InputToolBar.bundle/com_selected.png"]
              forState:UIControlStateHighlighted];
    
    [_btnCn setImage:[UIImage imageWithFilename:@"InputToolBar.bundle/cn.png"]
              forState:UIControlStateNormal];
    [_btnCn setImage:[UIImage imageWithFilename:@"InputToolBar.bundle/cn_selected.png"]
              forState:UIControlStateHighlighted];
    
}

#pragma mark - enableInputClicksWhenVisible
- (BOOL)enableInputClicksWhenVisible
{
    return YES;
}

- (void)onTouchKey:(UIButton *)item
{
    [[UIDevice currentDevice] playInputClick];
    NSString *text = [UITextInputUtil selectedTextOfInput:viewInputToolBar.inputView];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [viewInputToolBar.inputView insertText:text];
    
    if (item==_btnLeft) {
        [UITextInputUtil textPosition:viewInputToolBar.inputView offset:-1];
    }
    else if (item==_btnRight) {
        [UITextInputUtil textPosition:viewInputToolBar.inputView offset:1];
    }
    else if (item==_btnWWW) {
        [_inputView insertText:@"www."];
    }
    else if (item==_btnXie) {
        [_inputView insertText:@"/"];
    }
    else if (item==_btn_) {
        [_inputView insertText:@"-"];
    }
    else if (item==_btn__) {
        [_inputView insertText:@"_"];
    }
    else if (item==_btnCom) {
        [_inputView insertText:@".com"];
    }
    else if (item==_btnCn) {
        [_inputView insertText:@".cn"];
    }
    [UITextInputUtil setTextInput:viewInputToolBar.inputView position:[UITextInputUtil textPositionOfInput:viewInputToolBar.inputView]];
}

@end
