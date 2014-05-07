//
//  UIViewToolBar.m
//  KTBrowser
//
//  Created by David on 14-2-14.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewToolBar.h"

#import <QuartzCore/QuartzCore.h>

@interface UIViewToolBar ()

- (IBAction)onTouchEditDone:(UIButton *)btn;
- (IBAction)onTouchRefresh:(UIButton *)btn;
- (IBAction)onTouchStop:(UIButton *)btn;
- (IBAction)onTouchGoBack:(UIButton *)btn;
- (IBAction)onTouchGoForward:(UIButton *)btn;
- (IBAction)onTouchMenu:(UIButton *)btn;
- (IBAction)onTouchWindows:(UIButton *)btn;
- (IBAction)onTouchHome:(UIButton *)btn;

@end


@implementation UIViewToolBar

- (void)setWindowsNumber:(NSInteger)windowsNumber animated:(BOOL)animated
{
    if (animated) {
        CATransition *anim = [CATransition animation];
        anim.type = kCATransitionPush;
        if (windowsNumber>_windowsNumber) {
            // 增加
            anim.subtype = kCATransitionFromTop;
        }
        else {
            // 减少
            anim.subtype = kCATransitionFromBottom;
        }
        anim.duration = 0.25;
        anim.fillMode = kCAFillModeForwards;
        [_labelNumb.layer addAnimation:anim forKey:@"moveIn"];
        
        _windowsNumber = windowsNumber;
        _labelNumb.text = [@(_windowsNumber) stringValue];
    }
    else {
        _windowsNumber = windowsNumber;
        _labelNumb.text = [@(_windowsNumber) stringValue];
    }
}

- (void)setWindowsNumber:(NSInteger)windowsNumber
{
    [self setWindowsNumber:windowsNumber animated:NO];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self setNeedsDisplay];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _btnEditDone = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnEditDone.layer.cornerRadius = 2;
    _btnEditDone.autoresizingMask = _btnMenu.autoresizingMask;
    _btnEditDone.frame = CGRectInset(_btnMenu.frame, -20, 2);
    _btnEditDone.titleLabel.font = [UIFont systemFontOfSize:14];
    [_btnEditDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnEditDone setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_btnEditDone addTarget:self action:@selector(onTouchEditDone:) forControlEvents:UIControlEventTouchUpInside];
    _btnEditDone.alpha = 0;
    [self addSubview:_btnEditDone];
    _btnEditDone.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
    [_btnEditDone setTitle:NSLocalizedString(@"done", @"完成") forState:UIControlStateNormal];
    
    self.layer.contentsScale = [UIScreen mainScreen].scale;
    CGRect rc = [self convertRect:_labelNumb.frame toView:_btnWindows];
    UIView *mask = [[UIView alloc] initWithFrame:rc];
    mask.userInteractionEnabled = NO;
    mask.clipsToBounds = YES;
    [_btnWindows addSubview:mask];
    [mask addSubview:_labelNumb];
    _labelNumb.frame = mask.bounds;
    
    _labelNumb.highlightedTextColor = [UIColor lightGrayColor];
    
    self.windowsNumber = 1;
    
    [_btnStop setImage:[UIImage imageWithFilename:@"ToolBar.bundle/iconStop.png"]
              forState:UIControlStateNormal];
    
    _btnStop.hidden = YES;
    
    [self updateUIMode];
}

- (void)updateUIMode
{
    [super updateUIMode];
    
    NSArray *arrTab = @[_btnGoBack, _btnGoForward, _btnMenu, _btnWindows, _btnHome];
    for (NSInteger i=0; i<arrTab.count; i++) {
        UIButton *btn = arrTab[i];
        [btn setImage:[UIImage imageWithFilename:[NSString stringWithFormat:@"tab.bundle/tab_%d_%d.png", i, [AppConfig config].uiMode==UIModeDay?0:1]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageWithFilename:[NSString stringWithFormat:@"tab.bundle/tab_%d_%d.png", i, [AppConfig config].uiMode!=UIModeDay?0:1]] forState:UIControlStateDisabled];
        [btn setImage:[UIImage imageWithFilename:[NSString stringWithFormat:@"tab.bundle/tab_%d_%d.png", i, [AppConfig config].uiMode!=UIModeDay?0:1]] forState:UIControlStateHighlighted];
    }
    
    NSString *skin = [AppConfig config].uiMode==UIModeDay?@"bai":@"ye";
    _labelNumb.textColor = [UIColor colorWithWhite:[AppConfig config].uiMode==UIModeDay?0.1:0.9 alpha:1];
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithFilename:[NSString stringWithFormat:@"tab.bundle/tab_bg_%@_0.png", skin]]];
}

- (void)drawRect:(CGRect)rect
{
     CGContextRef ctx = UIGraphicsGetCurrentContext();
     CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithWhite:0.6 alpha:0.9].CGColor);
     CGContextSetLineWidth(ctx, 1);
     CGContextMoveToPoint(ctx, 0, 0);
     CGContextAddLineToPoint(ctx, self.bounds.size.width, 0);
     CGContextStrokePath(ctx);
}

#pragma mark - IBAction
- (IBAction)onTouchEditDone:(UIButton *)btn
{
    if([_delegate respondsToSelector:@selector(viewToolBar:toolBarEvent:point:)])
        [_delegate viewToolBar:self toolBarEvent:ToolBarEventEditDone point:CGPointMake(btn.center.x, self.frame.origin.y)];
}

- (IBAction)onTouchRefresh:(UIButton *)btn
{
    if([_delegate respondsToSelector:@selector(viewToolBar:toolBarEvent:point:)])
        [_delegate viewToolBar:self toolBarEvent:ToolBarEventRefresh point:CGPointMake(btn.center.x, self.frame.origin.y)];
}

- (IBAction)onTouchStop:(UIButton *)btn
{
    if([_delegate respondsToSelector:@selector(viewToolBar:toolBarEvent:point:)])
        [_delegate viewToolBar:self toolBarEvent:ToolBarEventStop point:CGPointMake(btn.center.x, self.frame.origin.y)];
}

- (IBAction)onTouchGoBack:(UIButton *)btn
{
    if([_delegate respondsToSelector:@selector(viewToolBar:toolBarEvent:point:)])
        [_delegate viewToolBar:self toolBarEvent:ToolBarEventGoBack point:CGPointMake(btn.center.x, self.frame.origin.y)];
}

- (IBAction)onTouchGoForward:(UIButton *)btn
{
    if([_delegate respondsToSelector:@selector(viewToolBar:toolBarEvent:point:)])
        [_delegate viewToolBar:self toolBarEvent:ToolBarEventGoForward point:CGPointMake(btn.center.x, self.frame.origin.y)];
}

- (IBAction)onTouchMenu:(UIButton *)btn
{
    if([_delegate respondsToSelector:@selector(viewToolBar:toolBarEvent:point:)])
        [_delegate viewToolBar:self toolBarEvent:ToolBarEventMenu point:CGPointMake(btn.center.x, self.frame.origin.y)];
}

- (IBAction)onTouchWindows:(UIButton *)btn
{
    if([_delegate respondsToSelector:@selector(viewToolBar:toolBarEvent:point:)])
        [_delegate viewToolBar:self toolBarEvent:ToolBarEventWindows point:CGPointMake(btn.center.x, self.frame.origin.y)];
}

- (IBAction)onTouchHome:(UIButton *)btn
{
    if([_delegate respondsToSelector:@selector(viewToolBar:toolBarEvent:point:)])
        [_delegate viewToolBar:self toolBarEvent:ToolBarEventHome point:CGPointMake(btn.center.x, self.frame.origin.y)];
}

#pragma mark - public
/**
 *  现实编辑完成按钮
 *
 *  @param show 是否现实 完成按钮
 */
- (void)showEditDone:(BOOL)show
{
    if (show) {
        _btnEditDone.hidden = NO;
    }
    [UIView animateWithDuration:0.3 animations:^{
        for (UIView *subView in self.subviews) {
            subView.alpha = show?0:1;
        }
        
        _btnEditDone.alpha = show?1:0;
    } completion:^(BOOL finished) {
        _btnEditDone.hidden = !show;
    }];
}

@end
