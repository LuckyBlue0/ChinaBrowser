//
//  UIControllerSetSkin.m
//  ChinaBrowser
//
//  Created by David on 14-3-14.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIControllerSetSkin.h"

#import "ADOSkin.h"
#import "BlockUI.h"

#import <AGCommon/UIImage+Common.h>

#import "UIImage+BlurredFrame.h"
#import "UIImage+ImageEffects.h"

@interface UIControllerSetSkin ()

- (IBAction)onTouchCancel;

- (void)resizeWithInterfaceOrientation:(UIInterfaceOrientation)interfaceOriention;

@end

@implementation UIControllerSetSkin

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
    
    _imageViewBg.image = [AppConfig config].bgImage;
    
    _viewBarTop.borderWidth = _viewBarBottom.borderWidth = 1;
    _viewBarTop.borderColor = _viewBarBottom.borderColor = [UIColor whiteColor];
    _viewBarTop.border = UIBorderBottom;
    _viewBarBottom.border = UIBorderTop;
    
    //
    UIColor *placeColor, *textColor, *barBgColor;
    if ([AppConfig config].uiMode == UIModeDay) {
        placeColor = [UIColor darkGrayColor];
        textColor = [UIColor darkGrayColor];
        barBgColor = [UIColor colorWithWhite:0.97 alpha:0.5];
    }
    else {
        placeColor = [UIColor whiteColor];
        textColor = [UIColor whiteColor];
        barBgColor = [UIColor colorWithWhite:0.3 alpha:0.5];
    }
    
    [_btnCancel setTitle:NSLocalizedString(@"back", nil) forState:UIControlStateNormal];
    _labelTitle.text = NSLocalizedString(@"set_skin", nil);
    
    _viewBarTop.backgroundColor = _viewBarBottom.backgroundColor = barBgColor;
//    [_textFieldTitle setValue:placeColor forKeyPath:@"_placeholderLabel.textColor"];
//    [_textFieldUrl setValue:placeColor forKeyPath:@"_placeholderLabel.textColor"];
//    _textFieldTitle.textColor = _textFieldUrl.textColor = textColor;
    
    [self resizeWithInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation];
    _scrollView.delegateSetSkin = self;
    [_scrollView setArrSkin:[ADOSkin queryWithType:SkinTypeSys]];
    [_scrollView appendArrSkin:[ADOSkin queryWithType:SkinTypeCustom]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Applications should use supportedInterfaceOrientations and/or shouldAutorotate..
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation NS_DEPRECATED_IOS(2_0, 6_0)
{
    return ![AppConfig config].rotateLock;
}

// New Autorotation support.
- (BOOL)shouldAutorotate NS_AVAILABLE_IOS(6_0)
{
    return ![AppConfig config].rotateLock;
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

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [_delegate controllerSetSkin:self willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self resizeWithInterfaceOrientation:toInterfaceOrientation];
}

- (void)resizeWithInterfaceOrientation:(UIInterfaceOrientation)interfaceOriention
{
    BOOL fs = [AppConfig config].fullScreen || [AppConfig config].fullScreenLandscope;
    if (UIInterfaceOrientationIsLandscape(interfaceOriention)) {
        // 横屏 
        CGRect rc = _viewBarTop.frame;
        rc.origin = CGPointZero;
        rc.size.height = 44;
        if (IsiOS7 && !fs) {
            rc.size.height += 20;
        }
        _viewBarTop.frame = rc;
        
        rc = _viewBarBottom.frame;
        rc.size.height = 34;
        rc.origin.y = self.view.bounds.size.height-rc.size.height;
        _viewBarBottom.frame = rc;
        
        rc = _scrollView.frame;
        rc.origin.y = _viewBarTop.frame.origin.y+_viewBarTop.frame.size.height;
        rc.size.height = _viewBarBottom.frame.origin.y-rc.origin.y;
        _scrollView.frame = rc;
    }
    else {
        // 竖屏
        CGRect rc = _viewBarTop.frame;
        rc.origin = CGPointZero;
        rc.size.height = 44;
        if (IsiOS7 && !fs) {
            rc.size.height += 20;
        }
        _viewBarTop.frame = rc;
        
        rc = _viewBarBottom.frame;
        rc.size.height = 44;
        rc.origin.y = self.view.bounds.size.height-rc.size.height;
        _viewBarBottom.frame = rc;
        
        rc = _scrollView.frame;
        rc.origin.y = _viewBarTop.frame.origin.y+_viewBarTop.frame.size.height;
        rc.size.height = _viewBarBottom.frame.origin.y-rc.origin.y;
        _scrollView.frame = rc;
    }
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

- (IBAction)onTouchCancel
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UIScrollViewSetSkinDelegate
- (void)scrollViewSetSkin:(UIScrollViewSetSkin *)scrollViewSetSkin selectSkinImagePath:(NSString *)skinImagePath
{
    if (![skinImagePath isEqualToString:_skinImagePath]) {
        _skinImagePath = skinImagePath;
        [AppConfig config].skinImagePath = _skinImagePath;
        [_delegate controllerSetSkinDidChanageSkin:self];
        _imageViewBg.image = [AppConfig config].bgImage;
        [KTAnimationKit animationEaseIn:_imageViewBg];
    }
}

- (void)scrollViewSetSkinWillAddSkin:(UIScrollViewSetSkin *)scrollViewSetSkin
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"cancel", @"取消") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"skin_take_photo", @"拍照"), NSLocalizedString(@"skin_select_from_album", @"从相册选取"), nil];
    [action showInView:self.view withCompletionHandler:^(NSInteger buttonIndex) {
        if (buttonIndex==action.cancelButtonIndex) {
            return;
        }
        
        void (^showPicker)(UIImagePickerController *) = ^(UIImagePickerController *picker){
            [self addChildViewController:picker];
            CGRect rc = self.view.bounds;
            picker.view.frame = rc;
            
            picker.view.alpha = 0;
            picker.view.transform = CGAffineTransformMakeScale(0, 0);
            [self.view addSubview:picker.view];
            [UIView animateWithDuration:0.35 animations:^{
                picker.view.alpha = 1;
                picker.view.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
            }];
        };
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        if (0==buttonIndex) {
            // take photo
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//                [self presentModalViewController:imagePicker animated:YES];
                showPicker(imagePicker);
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"camera_not_available", @"摄像头不可用") delegate:nil cancelButtonTitle:NSLocalizedString(@"cancel", @"取消") otherButtonTitles:NSLocalizedString(@"skin_select_from_album", @"从相册选取"), nil];
                [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
                    if (buttonIndex==1) {
                        // select from album
                        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//                        [self presentModalViewController:imagePicker animated:YES];
                        showPicker(imagePicker);
                    }
                }];
            }
            
        }
        else if (1==buttonIndex) {
            // select from album
            imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//            [self presentModalViewController:imagePicker animated:YES];
            showPicker(imagePicker);
        }
    }];
}

#pragma mark - UINavigationControllerDelegate, UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 图片在这里
    UIImage* imageOriginal = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSString *thumbPath = GetDocumentDirAppend(@"skin/thumb");
    NSString *imagePath = GetDocumentDirAppend(@"skin/image");
    
    CGFloat maxHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIImage *image = [imageOriginal scaleImageWithSize:CGSizeMake(maxHeight*scale, maxHeight*scale)];
    
    UIImage *thumb = [image scaleImageWithSize:CGSizeMake(300, 300)];
    
    ModelSkin *model = [ModelSkin modelSkin];
    model.skinType = SkinTypeCustom;
    model.name = @"";
    NSString *szTime = [[@([[NSDate date] timeIntervalSince1970]) stringValue] stringByAppendingPathExtension:@"png"];
    model.thumbPath = [thumbPath stringByAppendingPathComponent:szTime];
    model.imagePath = [imagePath stringByAppendingPathComponent:szTime];
    model.sid = [ADOSkin addModel:model];
    
    [UIImageJPEGRepresentation(thumb, 0) writeToFile:model.thumbPath atomically:YES];
    [UIImageJPEGRepresentation(image, 0) writeToFile:model.imagePath atomically:YES];
    
    [_scrollView addItemWithModel:model];
    
    [UIView animateWithDuration:0.35 animations:^{
        picker.view.transform = CGAffineTransformMakeScale(0, 0);
        picker.view.alpha = 0;
    } completion:^(BOOL finished) {
        [picker.view removeFromSuperview];
        [picker removeFromParentViewController];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [UIView animateWithDuration:0.35 animations:^{
        picker.view.transform = CGAffineTransformMakeScale(0, 0);
        picker.view.alpha = 0;
    } completion:^(BOOL finished) {
        [picker.view removeFromSuperview];
        [picker removeFromParentViewController];
    }];
}

@end
