//
//  UIControllerQRCode.m
//  KTBrowser
//
//  Created by David on 14-3-13.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIControllerQRCode.h"

#import <AVFoundation/AVFoundation.h>

@interface UIControllerQRCode ()

- (IBAction)onTouchBack;
- (IBAction)onTouchTorMode;

@end

@implementation UIControllerQRCode

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _imageViewMask.image = [UIImage imageWithFilename:@"QRCode.bundle/qrcode_mask.png"];
    _imageViewMask.contentMode = UIViewContentModeCenter;
    
    _imageViewMask.userInteractionEnabled = NO;
    
    
    [_btnCancel setTitle:NSLocalizedString(@"cancel", nil) forState:UIControlStateNormal];
    _labelTitle.text = NSLocalizedString(@"", nil);
    
    
    _viewReader = [[ZBarReaderView alloc] init];
    _viewReader.readerDelegate = self;
    _viewReader.frame = _imageViewMask.frame;
    {
        CGSize size = CGSizeMake(205, 205);
//        CGRect rcScan;
//        rcScan.size = size;
//        rcScan.origin.x = (_viewReader.bounds.size.width-size.width)/2.0;
//        rcScan.origin.y = (_viewReader.bounds.size.height-size.height)/2.0;
//        
//        UIView *view = [[UIView alloc] initWithFrame:rcScan];
//        view.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
//        [_imageViewMask addSubview:view];
        
        _viewReader.scanCrop = CGRectMake(((_viewReader.bounds.size.width-size.width)/2)/_viewReader.bounds.size.width, ((_viewReader.bounds.size.height-size.height)/2)/_viewReader.bounds.size.height, size.width/_viewReader.bounds.size.width, size.height/_viewReader.bounds.size.height);
    }
    _viewReader.autoresizesSubviews = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    [_btnTorchMode setImage:[UIImage imageWithFilename:@"QRCode.bundle/bt_erwei_0.png"] forState:UIControlStateNormal];
    [_btnTorchMode setImage:[UIImage imageWithFilename:@"QRCode.bundle/bt_erwei_1.png"] forState:UIControlStateSelected];
    
    _viewReader.torchMode = AVCaptureTorchModeOff;
    
    [self.view insertSubview:_viewReader atIndex:0];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_viewReader start];
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
    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

// New Autorotation support.
- (BOOL)shouldAutorotate NS_AVAILABLE_IOS(6_0)
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0)
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [_delegate controllerQRCode:self willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onTouchBack
{
    [_viewReader stop];
    [self dismissModalViewControllerAnimated:YES];
    [_delegate controllerQRCodeDidDismiss:self];
}

- (IBAction)onTouchTorMode
{
    [UIView transitionWithView:_btnTorchMode duration:0.3 options:UIViewAnimationOptionTransitionFlipFromLeft animations:nil completion:nil];
    
    _btnTorchMode.selected = !_btnTorchMode.selected;
    _viewReader.torchMode = _btnTorchMode.selected?AVCaptureTorchModeOn:AVCaptureTorchModeOff;
    
}

#pragma mark - ZBarReaderViewDelegate
- (void) readerView:(ZBarReaderView*)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    
    const zbar_symbol_t *symbol = zbar_symbol_set_first_symbol(symbols.zbarSymbolSet);
    NSString *strSymbol = [NSString stringWithUTF8String: zbar_symbol_get_data(symbol)];
    
    if (zbar_symbol_get_type(symbol) == ZBAR_QRCODE) { // QR二维码
        
    }
    
    NSLog(@"-----:%@---result:%@", NSStringFromCGSize(image.size), strSymbol);
    
    [_delegate controllerQRCode:self result:strSymbol];
    
    [self onTouchBack];
}

@end
;