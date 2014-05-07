//
//  ControllerScrawl.m
//  scrawl
//
//  Created by Glex on 14-3-25.
//  Copyright (c) 2014年 Glex. All rights reserved.
//

#import "ControllerScrawl.h"

#import "ViewIndicator.h"

#import "ViewScrawl.h"

@interface ControllerScrawl () {
    __weak IBOutlet UIView      *_viewBox;
    __weak IBOutlet UIImageView *_ivScrawlBg;
    __weak IBOutlet ViewScrawl  *_viewScrawl;
    
    __weak IBOutlet UIButton *_btnBack;
    __weak IBOutlet UISlider *_sliderWidth;
    __weak IBOutlet UIControl *_viewColor;
    __weak IBOutlet UIButton *_btnColor;
    
    __weak IBOutlet UIControl *_viewMask;
    
    __weak IBOutlet UIView   *_viewList;
    __weak IBOutlet UIButton *_btnBrush;
    __weak IBOutlet UIButton *_btnErase;
    __weak IBOutlet UIButton *_btnUndo;
    __weak IBOutlet UIButton *_btnRedo;
    __weak IBOutlet UIButton *_btnCamera;
    __weak IBOutlet UIButton *_btnShare;
    __weak IBOutlet UIButton *_btnSave;
    
    UIImagePickerController *_vcPicker;
}

@end

@implementation ControllerScrawl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_btnBack setBackgroundImage:ImageFromSkinByName(@"ipd-btn-back.png") forState:UIControlStateNormal];
    
    CALayer *layer = _viewBox.layer;
    layer.shadowOpacity = 1;
    layer.shadowRadius  = 6.0;
    layer.shadowOffset  = CGSizeZero;
    layer.shadowColor   = [UIColor grayColor].CGColor;
    
    layer = _viewColor.layer;
    layer.borderWidth = 0.6;
    layer.borderColor = [UIColor grayColor].CGColor;
    layer.cornerRadius = _viewColor.bounds.size.height*0.5;
    
    _btnColor.backgroundColor = _viewScrawl.lineColor;
    layer = _btnColor.layer;
    layer.borderWidth = 0.6;
    layer.borderColor = [UIColor grayColor].CGColor;
    layer.cornerRadius = _btnColor.bounds.size.height*0.5;
    [self calcBtnColorScale];

    _viewMask.userInteractionEnabled = NO;
    
    [self fixViewList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_vcPicker) { return; }
    
    CGRect rcRaw = _viewBox.frame;
    _viewBox.frame = self.view.bounds;
    [self.view bringSubviewToFront:_viewBox];
    [UIView animateWithDuration:0.25 animations:^{
        _viewBox.transform = CGAffineTransformMakeScale(1.05, 1.05);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            _viewBox.transform = CGAffineTransformIdentity;
            _viewBox.frame = rcRaw;
        } completion:^(BOOL finished) {
            [self.view sendSubviewToBack:_viewBox];
        }];
    }];
#ifdef __IPHONE_7_0
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
#endif
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
#ifdef __IPHONE_7_0
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
#endif
}

- (void)fixViewList {
    _viewList.alpha = 0;
    CALayer *layer = _viewList.layer;
    layer.shadowOpacity = 1;
    layer.shadowRadius  = 5.0;
    layer.shadowOffset  = CGSizeZero;
    layer.shadowColor   = [UIColor grayColor].CGColor;
    CGPoint oldAnchorPoint = layer.anchorPoint;
    layer.anchorPoint = CGPointMake(0.5, 1);
    layer.position = CGPointMake(layer.position.x+layer.bounds.size.width*(layer.anchorPoint.x-oldAnchorPoint.x), layer.position.y+layer.bounds.size.height*(layer.anchorPoint.y-oldAnchorPoint.y));

    CGColorRef borderColor = [UIColor lightGrayColor].CGColor;
    for (UIButton *btn in _viewList.subviews) {
        if (![UIButton class]) { return; }

        btn.layer.borderWidth = 0.3;
        btn.layer.borderColor = borderColor;
    }
}

- (void)calcBtnColorScale {
    _btnColor.transform = CGAffineTransformIdentity;
    CGFloat ratio = 0;
    if (_viewScrawl.eraseMode) {
        _btnColor.backgroundColor = [UIColor whiteColor];
        ratio = _viewScrawl.eraserWidth/_btnColor.bounds.size.width;
    }
    else {
        _btnColor.backgroundColor = _viewScrawl.lineColor;
        ratio = _viewScrawl.lineWidth/_btnColor.bounds.size.width;
    }
    _btnColor.transform = CGAffineTransformMakeScale(ratio, ratio);
}

- (void)setScreenshot:(UIImage *)screenshot {
    _screenshot = screenshot;
    _ivScrawlBg.image = screenshot;
    
    CGSize szSelf = self.view.bounds.size;
    CGRect rc = _viewBox.frame;
    rc.size.width = szSelf.width*(rc.size.height/szSelf.height);
    rc.origin.x = (szSelf.width-rc.size.width)*0.5;
    _viewBox.frame = rc;
    
    _viewBox.layer.shadowPath = [UIBezierPath bezierPathWithRect:_viewBox.bounds].CGPath;
}

- (void)showViewList:(BOOL)show {
    _viewList.transform = CGAffineTransformIdentity;
    _viewList.transform = CGAffineTransformMakeScale(show?0.01:1, show?0.01:1);
    if (show) {
        _viewList.alpha = 1;
        CGRect rc0 = _viewColor.frame;
        CGRect rc1 = _viewList.frame;
        rc1.origin.x = rc0.origin.x-(rc1.size.width-rc0.size.width)*0.5;
        _viewList.frame = rc1;
    }
    [UIView animateWithDuration:0.25 animations:^{
        _viewList.transform = CGAffineTransformMakeScale(1.05, 1.05);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            _viewList.transform = CGAffineTransformMakeScale(show?1:0.01, show?1:0.01);
        } completion:^(BOOL finished) {
            if (!show) {
                _viewList.alpha = 0;
            }
        }];
    }];
}

#pragma mark - autorotate
- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

// iOS < 6.0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return [self shouldAutorotate];
}

#pragma mark - user interaction 
- (IBAction)onTouchBack:(id)sender {
    _viewScrawl.alpha = 0;
    _ivScrawlBg.image = _screenshot;
    
    [self.view bringSubviewToFront:_viewBox];
    [UIView animateWithDuration:0.25 animations:^{
        _viewBox.frame = self.view.bounds;
        _viewBox.transform = CGAffineTransformMakeScale(1.05, 1.05);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            _viewBox.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            _viewBox.center = self.view.window.center;
            _viewBox.transform = CGAffineTransformMakeRotation(degreesToRadians(InterfaceDegrees()));
            [self.view.window addSubview:_viewBox];

            [self dismissViewControllerAnimated:NO completion:nil];
            
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [_viewBox removeFromSuperview];
            });
        }];
    }];
}

// 遮罩层
- (IBAction)onTouchViewMask:(id)sender {
    [self showViewList:NO];
    _viewMask.userInteractionEnabled = NO;
}

// 粗细
- (IBAction)onSliderValueChanged:(UISlider *)sender forEvent:(UIEvent *)event {
    if (_viewScrawl.eraseMode) {
        _viewScrawl.eraserWidth = sender.value;
    }
    else {
        _viewScrawl.lineWidth = sender.value;
    }
    
    [self calcBtnColorScale];
}

// 显示颜色列表
- (IBAction)onTouchShowColor:(id)sender {
    [self showViewList:YES];
    _viewMask.userInteractionEnabled = YES;
}

// 选择颜色
- (IBAction)onTouchColor:(UIButton *)btn {
    _viewScrawl.lineColor = btn.backgroundColor;
    [self calcBtnColorScale];
}

// 画笔
- (IBAction)onTouchBrush:(UIButton *)sender {
    _viewScrawl.eraseMode = NO;
    
    _sliderWidth.value = _viewScrawl.lineWidth;
    [self calcBtnColorScale];
    
    _btnBrush.enabled = NO;
    _btnErase.enabled = YES;
    _viewColor.userInteractionEnabled = YES;
}

// 擦除
- (IBAction)onTouchErase:(UIButton *)sender {
    _viewScrawl.eraseMode = YES;
    
    _sliderWidth.value = _viewScrawl.eraserWidth;
    [self calcBtnColorScale];
    
    _btnBrush.enabled = YES;
    _btnErase.enabled = NO;
    _viewColor.userInteractionEnabled = NO;
}

// 撤销
- (IBAction)onTouchUndo:(id)sender {
    [_viewScrawl undo];
}


// 回撤
- (IBAction)onTouchRedo:(id)sender {
    [_viewScrawl redo];
}

// 清除画布
- (IBAction)onTouchClear:(id)sender {
    [_viewScrawl clearCanvas];
}

- (void)showImagePicker:(BOOL)show {
    if (show) {
        _vcPicker = [[UIImagePickerController alloc] init];
        _vcPicker.allowsEditing = YES;
        _vcPicker.delegate      = self;

        CGRect rc = _viewMask.frame;
        rc.origin.y = rc.size.height;
        _vcPicker.view.frame = rc;
        
        [self.view addSubview:_vcPicker.view];
        [UIView animateWithDuration:0.25 animations:^{
            _vcPicker.view.transform = CGAffineTransformMakeTranslation(0, -rc.size.height);
        } completion:^(BOOL finished) {
            [self addChildViewController:_vcPicker];
        }];
    }
    else {
        [UIView animateWithDuration:0.25 animations:^{
            _vcPicker.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [_vcPicker removeFromParentViewController];
            [_vcPicker.view removeFromSuperview];
            _vcPicker = nil;
        }];
    }
}

// 相册
- (IBAction)onTouchPhotoLib:(id)sender {
    [self showImagePicker:YES];
}

// 分享
- (IBAction)onTouchShare:(id)sender {
    
}

// 保存
- (IBAction)onTouchSave:(id)sender {
    UIImageWriteToSavedPhotosAlbum([UIImage imageFromView:_viewBox], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [ViewIndicator showSuccessWithStatus:GetTextFromKey(error==nil?@"SavedPhotoSucceed":@"SavedPhotoFailed") duration:1.0];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    [_viewScrawl clearCanvas];
    _ivScrawlBg.image = image;
    
    [self showImagePicker:NO];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self showImagePicker:NO];
}

@end
