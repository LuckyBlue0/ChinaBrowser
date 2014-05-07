//
//  UIControllerPainting.m
//  KTBrowser
//
//  Created by David on 14-2-21.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIControllerPainting.h"

#import <AGCommon/CMRandom.h>

#import <QuartzCore/QuartzCore.h>

#import "BlockUI.h"

#import "ViewIndicator.h"
#import "SIAlertView.h"
#import "UIViewSNSOption.h"

#import <ShareSDK/ShareSDK.h>

@interface UIControllerPainting ()

- (IBAction)onTouchBack;
- (IBAction)onTouchBrush;
- (IBAction)onTouchEraser;
- (IBAction)onTouchRedo;
- (IBAction)onTouchMore;

- (void)               image: (UIImage *) image
    didFinishSavingWithError: (NSError *) error
                 contextInfo: (void *) contextInfo;

@end

@implementation UIControllerPainting

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [AppConfig config].rotateLock = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AppConfig config].rotateLock = YES;
    [AppConfig config].shouldShowRotateLock = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [AppConfig config].rotateLock = NO;
    [AppConfig config].shouldShowRotateLock = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.userInteractionEnabled = YES;
    
    _viewPainting.opaque = YES;
    _viewPainting.backgroundColor = [UIColor whiteColor];
    _viewPainting.clearModal = NO;
    _viewPainting.image = _image;
    
//    CGFloat factor = (_viewPainting.bounds.size.height-_viewBottom.bounds.size.height*2)/self.view.bounds.size.height;
//    CGAffineTransform tfScale = CGAffineTransformMakeScale(factor, factor);
//    CGAffineTransform tfTrans = CGAffineTransformMakeTranslation(0, -_viewBottom.bounds.size.height/2);
//    _viewPainting.transform = CGAffineTransformConcat(tfScale, tfTrans);
    
    _viewPainting.lineColor = [[UIColor redColor] colorWithAlphaComponent:1];
    _viewPainting.lineWidth = 10;
    _viewPainting.eraserWidth = 20;
//    _viewPainting.layer.shadowColor = [UIColor darkGrayColor].CGColor;
//    _viewPainting.layer.shadowOffset = CGSizeZero;
//    _viewPainting.layer.shadowOpacity = 0.8;
    
    _viewBottom.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_viewPainting setupBuffer];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Applications should use supportedInterfaceOrientations and/or shouldAutorotate..
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation NS_DEPRECATED_IOS(2_0, 6_0)
{
    if ([AppConfig config].rotateLock) {
        return NO;
    }
    else {
        return YES;
    }
}

// New Autorotation support.
- (BOOL)shouldAutorotate NS_AVAILABLE_IOS(6_0)
{
    if ([AppConfig config].rotateLock) {
        return NO;
    }
    else {
        return YES;
    }
}

- (NSUInteger)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0)
{
    if ([AppConfig config].rotateLock) {
        return [AppConfig config].interfaceOrientationMask;
    }
    else {
        return UIInterfaceOrientationMaskAll;
    }
}

#pragma mark - private
//手指开始触屏开始
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _pointPrev = [[touches anyObject] locationInView:_viewPainting];
}

//手指移动时候发出
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touchNow = [touches anyObject];
    CGPoint pointTo = [touchNow locationInView:_viewPainting];
    [_viewPainting drawPointFrom:_pointPrev
                         pointTo:pointTo];
    [_viewPainting setNeedsDisplay];
    
    _pointPrev = pointTo;
}

//当手指离开屏幕时候
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touchNow = [touches anyObject];
    CGPoint pointTo = [touchNow locationInView:_viewPainting];
    [_viewPainting drawPointFrom:_pointPrev
                         pointTo:pointTo];
    [_viewPainting setNeedsDisplay];
}

//电话呼入等事件取消时候发
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touchNow = [touches anyObject];
    CGPoint pointTo = [touchNow locationInView:_viewPainting];
    [_viewPainting drawPointFrom:_pointPrev
                         pointTo:pointTo];
    [_viewPainting setNeedsDisplay];
}

#pragma mark - IBAction
- (IBAction)onTouchBack
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)onTouchBrush
{
    _viewPainting.clearModal = NO;
    _btnBrush.selected = YES;
    _btnEraser.selected = NO;
    
    UIViewBrushSet *viewBrushSet = [UIViewBrushSet viewBrushSetFromXib];
    viewBrushSet.delegate = self;
    [viewBrushSet setColor:_viewPainting.lineColor width:_viewPainting.lineWidth];
    [viewBrushSet showInView:self.view completion:nil];
}

- (IBAction)onTouchEraser
{
    _viewPainting.clearModal = YES;
    _btnBrush.selected = NO;
    _btnEraser.selected = YES;
    
    UIViewEraserSet *viewBrushSet = [UIViewEraserSet viewEraserSetFromXib];
    viewBrushSet.delegate = self;
    [viewBrushSet setEraserWidth:_viewPainting.eraserWidth];
    [viewBrushSet showInView:self.view completion:nil];
}

- (IBAction)onTouchRedo
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要重做" delegate:nil cancelButtonTitle:NSLocalizedString(@"cancel", 0) otherButtonTitles:NSLocalizedString(@"ok", 0), nil];
    [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
        if (alert.cancelButtonIndex!=buttonIndex) {
            [_viewPainting setupBuffer];
            [_viewPainting setNeedsDisplay];
        }
    }];
}

- (IBAction)onTouchMore
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"操作" delegate:nil cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") destructiveButtonTitle:nil otherButtonTitles:@"保存", @"分享", nil];
    [action showInView:self.view withCompletionHandler:^(NSInteger buttonIndex) {
        if (0==buttonIndex) {
            // 保存
            [ViewIndicator showWithStatus:@"正在保存图片" indicatorType:IndicatorTypeDefault];
            double delayInSeconds = 0.3;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    UIImageWriteToSavedPhotosAlbum(_viewPainting.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                });
            });
        }
        else if (1==buttonIndex) {
            UIViewSNSOption *viewSNSOption = [UIViewSNSOption viewSNSOptionFromXib];
            viewSNSOption.delegate = self;
            NSArray *arrShareType = [ShareSDK getShareListWithType:
                                     ShareTypeSinaWeibo,
                                     ShareTypeTencentWeibo,
                                     ShareTypeQQ,
                                     ShareTypeQQSpace,
                                     ShareTypeWeixiSession,
                                     ShareTypeWeixiTimeline,
                                     ShareTypeSMS,
                                     ShareTypeMail, nil];
            [viewSNSOption showInView:self.view arrShareType:arrShareType completion:nil];
        }
    }];
}

- (void)               image: (UIImage *) image
    didFinishSavingWithError: (NSError *) error
                 contextInfo: (void *) contextInfo
{
    [self dismissModalViewControllerAnimated:YES];
    if (error) {
        [ViewIndicator showErrorWithStatus:error.debugDescription duration:2];
    }
    else {
        [ViewIndicator showSuccessWithStatus:@"图片保存成功" duration:2];
    }
}

#pragma mark - UIViewBrushSetDelegate, UIViewEraserSetDelegate
- (void)viewBrushSetLineColor:(UIColor *)lineColor
{
    _viewPainting.lineColor = lineColor;
}

- (void)viewBrushSetLineWidth:(CGFloat)lineWidth
{
    _viewPainting.lineWidth = lineWidth;
}

- (void)viewEraserSetWidth:(CGFloat)eraserWidth
{
    _viewPainting.eraserWidth = eraserWidth;
}

#pragma mark - UIViewSNSOptionDelegate
- (void)viewSNSOption:(UIViewSNSOption *)viewSNSOption didSelectShareTeyp:(ShareType)shareType
{
    id<ISSCAttachment> attachment = [ShareSDK pngImageWithImage:_viewPainting.image];
    NSString *bundleName = NSLocalizedStringFromTable(@"CFBundleDisplayName", @"InfoPlist", nil);
    id<ISSContent> content = [ShareSDK content:[NSString stringWithFormat:@"我用%@制作了一张涂鸦", bundleName]
                                defaultContent:nil
                                         image:attachment
                                         title:@"截图涂鸦"
                                           url:@"http://weibo.com/hooviel"
                                   description:nil
                                     mediaType:SSPublishContentMediaTypeImage];
    
    [AppConfig config].layerMask.hidden = YES;
    if (ShareTypeMail==shareType||ShareTypeSMS==shareType) {
        [ShareSDK showShareViewWithType:shareType
                              container:nil
                                content:content
                          statusBarTips:NO
                            authOptions:nil
                           shareOptions:nil
                                 result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end)
        {
                                     if (SSPublishContentStateSuccess==state) {
                                         [ViewIndicator showSuccessWithStatus:@"分享成功" duration:2];
                                     }
                                     else if (SSPublishContentStateFail==state) {
                                         [ViewIndicator showErrorWithStatus:@"分享失败" duration:2];
                                     }
                                     [AppConfig config].layerMask.hidden = NO;
                                 }];
    }
    else {
        [ViewIndicator showWithStatus:@"正在分享..." indicatorType:IndicatorTypeDefault];
        id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                             allowCallback:YES
                                                                    scopes:nil
                                                             powerByHidden:YES
                                                            followAccounts:nil
                                                             authViewStyle:SSAuthViewStyleFullScreenPopup
                                                              viewDelegate:nil
                                                   authManagerViewDelegate:nil];
        [ShareSDK shareContent:content
                          type:shareType
                   authOptions:authOptions
                  shareOptions:nil
                 statusBarTips:NO
                        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end)
         {
            if (SSPublishContentStateSuccess==state) {
                [ViewIndicator showSuccessWithStatus:@"分享成功" duration:2];
            }
            else if (SSPublishContentStateFail==state) {
                [ViewIndicator showErrorWithStatus:@"分享失败" duration:2];
            }
            [AppConfig config].layerMask.hidden = NO;
        }];
    }
}

@end
