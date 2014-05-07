//
//  UIControllerProfile.m
//  WKBrowser
//
//  Created by David on 13-11-5.
//  Copyright (c) 2013年 VeryApps. All rights reserved.
//

#import "UIControllerProfile.h"

#import "ASIFormDataRequest.h"

#import "ViewIndicator.h"
#import "ADOUserSettings.h"
#import "CHKeychain.h"
#import "CJSONDeserializer.h"

#import "UIImageView+WebCache.h"

#import <QuartzCore/QuartzCore.h>
#import "SDWebImageManager.h"
#import "UIImage+Resize.h"

#import <AGCommon/UIDevice+Common.h>
#import "WKSync.h"

#import "UIButton+WebCache.h"
#import "BlockUI.h"

@interface UIControllerProfile ()

- (IBAction)onTouchBack;
- (IBAction)onTouchCancel;

- (IBAction)onTouchAvatar;

- (IBAction)onTouchSubmit;

- (BOOL)checkForm;
- (void)doModify;

@end

@implementation UIControllerProfile

- (void)dealloc
{
    [_reqModify clearDelegatesAndCancel];
    SAFE_RELEASE(_reqModify);
    
    SAFE_RELEASE(_navBar);
    SAFE_RELEASE(_tableView);
    
    SAFE_RELEASE(_textFiledUsername);
    SAFE_RELEASE(_textFiledNickname);
    SAFE_RELEASE(_textFiledPwdOld);
    SAFE_RELEASE(_textFiledPwdNew);
    SAFE_RELEASE(_textFiledPwdNew2);
    
    SAFE_RELEASE(_btnImageAvatar);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_textFiledUsername resignFirstResponder];
    [_textFiledPwdOld resignFirstResponder];
    [_textFiledPwdNew resignFirstResponder];
    [_textFiledNickname resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (UI_USER_INTERFACE_IDIOM()!=UIUserInterfaceIdiomPad) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    _viewCell00.border = UIBorderTopBottom;
    
    if ([WKSync shareWKSync].modelUser.autoCreate) {
        // 设置密码，没有原密码这项
        CGFloat offset = _viewCell10.bounds.size.height;
        
        _labelSectionHeader1.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"set", 0), NSLocalizedString(@"pwd", 0)];
        
        _viewCell11.frame = CGRectOffset(_viewCell11.frame, 0, -offset);
        _viewCell12.frame = CGRectOffset(_viewCell12.frame, 0, -offset);
        _labelSectionFooter1.frame = CGRectOffset(_labelSectionFooter1.frame, 0, -offset);
        _btnSubmit.frame = CGRectOffset(_btnSubmit.frame, 0, -offset);
        
        _viewCell11.border = UIBorderTopBottom;
        
    }
    else {
        // 修改密码
        _labelSectionHeader1.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"modify", 0), NSLocalizedString(@"pwd", 0)];
        _viewCell10.border = UIBorderTopBottom;
    }
    
    CGRect rc;
    if (UIUserInterfaceIdiomPad==UI_USER_INTERFACE_IDIOM()) {
        rc = _viewNav.frame;
        rc.size.height = 44;
        _viewNav.frame = rc;
        
        rc = _scrollView.frame;
        rc.origin.y = _viewNav.frame.origin.y+_viewNav.frame.size.height;
        rc.size.height = self.view.bounds.size.height-rc.origin.y;
        _scrollView.frame = rc;
    }
    
    _imageViewBg.image = [AppConfig config].bgImage;
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, _btnSubmit.frame.origin.y+_btnSubmit.frame.size.height+10);
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.2];
    
    _textFiledUsername.placeholder = [WKSync shareWKSync].modelUser.username;
    _textFiledUsername.delegate = self;
    _textFiledUsername.returnKeyType = UIReturnKeyDone;
    
    _textFiledNickname.placeholder = [WKSync shareWKSync].modelUser.nickname;
    _textFiledNickname.delegate = self;
    _textFiledNickname.returnKeyType = UIReturnKeyDone;
    
    _textFiledPwdOld.secureTextEntry = YES;
    _textFiledPwdOld.placeholder = NSLocalizedString(@"placeholder_pwd_old", 0);
    _textFiledPwdOld.delegate = self;
    _textFiledPwdOld.returnKeyType = UIReturnKeyNext;
    
    _textFiledPwdNew.secureTextEntry = YES;
    _textFiledPwdNew.placeholder = NSLocalizedString([WKSync shareWKSync].modelUser.autoCreate?@"placeholder_pwd":@"placeholder_pwd_new", 0);
    _textFiledPwdNew.delegate = self;
    _textFiledPwdNew.returnKeyType = UIReturnKeyNext;
    
    _textFiledPwdNew2.secureTextEntry = YES;
    _textFiledPwdNew2.placeholder = NSLocalizedString(@"placeholder_pwd2", 0);
    _textFiledPwdNew2.delegate = self;
    _textFiledPwdNew2.returnKeyType = UIReturnKeyDone;
    
    _labelSectionHeader0.text = [NSString stringWithFormat:@"%@ %@/%@", NSLocalizedString(@"modify", 0), NSLocalizedString(@"username", 0), NSLocalizedString(@"nickname", 0)];
    _labelSectionFooter0.text =
    _labelSectionFooter1.text = NSLocalizedString(@"modify_tip", 0);
    
    _labelUsername.text = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"username", 0)];
    _labelNickname.text = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"nickname", 0)];
    _labelOldPwd.text = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"pwd_old", 0)];
    _labelNewPwd.text = [NSString stringWithFormat:@"%@：", NSLocalizedString([WKSync shareWKSync].modelUser.autoCreate?@"pwd":@"pwd_new", 0)];
    _labelNewPwd2.text = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"pwd2", 0)];
    
    NSArray *arrLabel = @[_labelUsername, _labelNickname, _labelOldPwd, _labelNewPwd, _labelNewPwd2];
    NSArray *arrField = @[_textFiledUsername, _textFiledNickname, _textFiledPwdOld, _textFiledPwdNew, _textFiledPwdNew2];
    for (NSInteger i=0; i<arrField.count; i++) {
        UILabel *label = arrLabel[i];
        UITextField *textFiled = arrField[i];
        rc = label.frame;
        [label sizeToFit];
        rc.size.width = label.bounds.size.width;
        label.frame = rc;
        
        textFiled.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textFiled.autocorrectionType = UITextAutocorrectionTypeNo;
        rc = textFiled.frame;
        rc.origin.x = label.frame.origin.x+label.frame.size.width+5;
        rc.size.width = self.view.bounds.size.width-rc.origin.x-5;
        textFiled.frame = rc;
        
        textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    
    // tableview header view
    _btnImageAvatar.backgroundColor = [UIColor whiteColor];
    _btnImageAvatar.contentMode = UIViewContentModeScaleAspectFill;
    _btnImageAvatar.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_btnImageAvatar setImageWithURL:[NSURL URLWithString:[WKSync shareWKSync].modelUser.avatar] forState:UIControlStateNormal];
    
    _btnImageAvatar.layer.shadowColor = [UIColor grayColor].CGColor;
    _btnImageAvatar.layer.shadowOffset = CGSizeZero;
    _btnImageAvatar.layer.shadowOpacity = 1;
    
    UIImageView *imageViewEdit = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pen"]];
    rc = imageViewEdit.bounds;
    rc.origin.x = _btnImageAvatar.bounds.size.width-rc.size.width;
    rc.origin.y = _btnImageAvatar.bounds.size.height-rc.size.height;
    imageViewEdit.frame = rc;
    [_btnImageAvatar addSubview:imageViewEdit];
    
    [_btnSubmit setFlatStyle:RGBCOLOR(220, 0, 0) andHighlightedColor:RGBCOLOR(200, 0, 0)];
    [_btnSubmit setBorderStyle:nil andInnerColor:nil];
    
    if ([WKSync shareWKSync].modelUser.autoCreate) {
        [_viewCell10 removeFromSuperview];
        _viewCell10 = nil;
        _labelOldPwd = nil;
        _textFiledPwdOld = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#pragma mark - private methods
- (IBAction)onTouchBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onTouchCancel
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (IBAction)onTouchAvatar
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"cancel", 0)
                                               destructiveButtonTitle:_btnImageAvatar.selected?NSLocalizedString(@"reset", 0):nil
                                                    otherButtonTitles:NSLocalizedString(@"image_from_camera", 0), NSLocalizedString(@"image_from_albums", 0), nil];
    [actionSheet showInView:self.navigationController.view];
    
}

- (IBAction)onTouchSubmit
{
    [self doModify];
}

- (BOOL)checkForm
{
    NSString *msg = nil;
    do {        
        if ([WKSync shareWKSync].modelUser.autoCreate) {
            if (_textFiledPwdNew.text.length!=0 || _textFiledPwdNew2.text.length!=0) {
                if (_textFiledPwdNew.text.length==0) {
                    [_textFiledPwdNew becomeFirstResponder];
                    msg = @"msg_pwd_new_empty";
                    break;
                }
                if (_textFiledPwdNew2.text.length==0) {
                    [_textFiledPwdNew2 becomeFirstResponder];
                    msg = @"msg_pwd2_empty";
                    break;
                }
                if (![_textFiledPwdNew.text isEqualToString:_textFiledPwdNew2.text]) {
                    [_textFiledPwdNew becomeFirstResponder];
                    msg = @"msg_pwd2_nomatch";
                    break;
                }
            }
            else if (!_btnImageAvatar.selected && _textFiledUsername.text.length==0 && _textFiledNickname.text.length==0) {
                msg = @"msg_modify_nochanaged";
            }
        }
        else {
            if (_textFiledPwdOld.text.length!=0 || _textFiledPwdNew.text.length!=0 || _textFiledPwdNew2.text.length!=0) {
                if (_textFiledPwdOld.text.length==0) {
                    [_textFiledPwdOld becomeFirstResponder];
                    msg = @"msg_pwd_old_empty";
                    break;
                }
                if (_textFiledPwdNew.text.length==0) {
                    [_textFiledPwdNew becomeFirstResponder];
                    msg = @"msg_pwd_new_empty";
                    break;
                }
                if (_textFiledPwdNew2.text.length==0) {
                    [_textFiledPwdNew2 becomeFirstResponder];
                    msg = @"msg_pwd2_empty";
                    break;
                }
                if (![_textFiledPwdNew.text isEqualToString:_textFiledPwdNew2.text]) {
                    [_textFiledPwdNew becomeFirstResponder];
                    msg = @"msg_pwd2_nomatch";
                    break;
                }
            }
            else if (!_btnImageAvatar.selected && _textFiledUsername.text.length==0 && _textFiledNickname.text.length==0) {
                msg = @"msg_modify_nochanaged";
            }
        }
    } while (NO);
    if (msg) {
        [ViewIndicator showWarningWithStatus:NSLocalizedString(msg, 0) duration:2];
        return NO;
    }
    else
        return YES;
}

- (void)doModify
{
    if ([self checkForm]) {
        [_reqModify clearDelegatesAndCancel];
        SAFE_RELEASE(_reqModify);
        
        [ViewIndicator showWithStatus:@"正在提交..." indicatorType:IndicatorTypeDefault];
        
        _reqModify = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:API_User]];
        
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         API_AppName, @"app",
                                         [NSNumber numberWithLongLong:[WKSync shareWKSync].modelUser.uid], @"uid",
                                         [WKSync shareWKSync].modelUser.hash, @"hash",
                                         nil];
        
        if (_textFiledUsername.text.length>0) [dicParam setObject:_textFiledUsername.text forKey:@"username"];
        if (_textFiledNickname.text.length>0) [dicParam setObject:_textFiledNickname.text forKey:@"nickname"];
        if (_textFiledPwdNew.text.length>0) {
            if ([WKSync shareWKSync].modelUser.autoCreate) {
//                [dicParam setObject:[WKSync shareWKSync].modelUser.username forKey:@"oldpwd"];
            }
            else {
                [dicParam setObject:_textFiledPwdOld.text forKey:@"oldpwd"];
            }
            [dicParam setObject:_textFiledPwdNew.text forKey:@"newpwd"];
        }
        
        [dicParam setObject:[NSString signWithParams:dicParam] forKey:@"sign"];
        
        [dicParam setObject:@"modify" forKey:@"ac"];
        [dicParam enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [_reqModify setPostValue:obj forKey:key];
        }];
        [_reqModify setTimeOutSeconds:30];
        [_reqModify setRequestMethod:@"POST"];
        if (_btnImageAvatar.selected) {
            UIImage *image = [_btnImageAvatar imageForState:UIControlStateNormal];
            NSData *data = UIImagePNGRepresentation(image);
            [_reqModify addData:data forKey:@"avatar"];
        }
        [_reqModify setCompletionBlock:^{
            NSDictionary *dicResult = [[CJSONDeserializer deserializer] deserialize:_reqModify.responseData error:nil];
            NSString *msg = [dicResult objectForKey:@"msg"];
            NSDictionary *dicInfo = [dicResult objectForKey:@"data"];
            
            if (msg && !dicInfo) {
                [ViewIndicator showErrorWithStatus:msg duration:2];
            }
            else {
                ModelUser *model = [ModelUser modelUserWithDictionary:dicInfo];
                [WKSync shareWKSync].modelUser = model;
                
                if ([_delegate respondsToSelector:@selector(controllerProfileDidModify:)]) {
                    [_delegate controllerProfileDidModify:self];
                }
                
                NSData *data = [model modelUserToData];
                NSString *szUserId = [NSString stringWithFormat:@"%d", model.uid];
                
                // keychain 保存当前用户信息
                [CHKeychain save:szUserId data:data];
                
                [ViewIndicator showSuccessWithStatus:msg duration:2];
                [self.navigationController popViewControllerAnimated:YES];
            }
            SAFE_RELEASE(_reqModify);
        }];
        [_reqModify setFailedBlock:^{
            [ViewIndicator showErrorWithStatus:_reqModify.error.localizedDescription duration:2];
            SAFE_RELEASE(_reqModify);
        }];
        [_reqModify startAsynchronous];
    }
}

#pragma mark - keyboard notification
- (void)keyboardWillShowNotification:(NSNotification *)notification
{
    if (!(_textFiledUsername.isFirstResponder
          || _textFiledNickname.isFirstResponder
          || _textFiledPwdOld.isFirstResponder
          || _textFiledPwdNew.isFirstResponder
          || _textFiledPwdNew2.isFirstResponder)) return;
    
    CGRect rcKeyboard = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve  curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationDuration:duration];

    CGRect rc = _scrollView.frame;
    rc.size = self.view.bounds.size;
    rc.size.height = self.view.bounds.size.height-rc.origin.y-(isPortrait?rcKeyboard.size.height:rcKeyboard.size.width);
    _scrollView.frame = rc;
    
    [UIView commitAnimations];
}

- (void)keyboardWillHideNotification:(NSNotification *)notification
{
    if (!(_textFiledUsername.isFirstResponder
          || _textFiledNickname.isFirstResponder
          || _textFiledPwdOld.isFirstResponder
          || _textFiledPwdNew.isFirstResponder
          || _textFiledPwdNew2.isFirstResponder)) return;
    
    //    CGRect rcKeyboard = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve  curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationDuration:duration];
    
    CGRect rc = _scrollView.frame;
    rc.size = self.view.bounds.size;
    rc.size.height = self.view.bounds.size.height-rc.origin.y;
    _scrollView.frame = rc;
    
    [UIView commitAnimations];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==_textFiledUsername) {
//        [_textFiledNickname becomeFirstResponder];
        [textField resignFirstResponder];
    }
    else if (textField==_textFiledNickname) {
//        [_textFiledPwdOld becomeFirstResponder];
        [textField resignFirstResponder];
    }
    else if (textField==_textFiledPwdOld) {
        [_textFiledPwdNew becomeFirstResponder];
    }
    else if (textField==_textFiledPwdNew) {
        [_textFiledPwdNew2 becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
        [self doModify];
    }
    return YES;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (MIN(image.size.width, image.size.height)>200) {
        image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(200, 200) interpolationQuality:kCGInterpolationHigh];
    }
    [_btnImageAvatar setImage:image forState:UIControlStateNormal];
    _btnImageAvatar.selected = YES;
    
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
//    [picker.navigationController popViewControllerAnimated:YES];
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==actionSheet.cancelButtonIndex) return;
    
    if (buttonIndex==actionSheet.destructiveButtonIndex) {
        // reset
        _btnImageAvatar.selected = NO;
        [_btnImageAvatar setImageWithURL:[NSURL URLWithString:[WKSync shareWKSync].modelUser.avatar] forState:UIControlStateNormal];
    }
    else if (1==buttonIndex+(_btnImageAvatar.selected?0:1)) {
        // camer
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            // 照相机可用
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.allowsEditing = YES;
            imagePicker.delegate = self;
            [self presentModalViewController:imagePicker animated:YES];
        }
        else {
            // 照相机不可用
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"camera_not_available", @"摄像头不可用") delegate:nil cancelButtonTitle:NSLocalizedString(@"cancel", @"取消") otherButtonTitles:NSLocalizedString(@"skin_select_from_album", @"从相册选取"), nil];
            [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
                if (alert.cancelButtonIndex!=buttonIndex) {
                    // ablums
                    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                    imagePicker.modalPresentationStyle = UIModalPresentationFormSheet;
                    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                    imagePicker.allowsEditing = YES;
                    imagePicker.delegate = self;
                    [self presentModalViewController:imagePicker animated:YES];
                    if ([[UIDevice currentDevice] isPad]) {
                        imagePicker.view.superview.bounds = CGRectMake(0, 0, 401, 500);
                    }
                }
            }];
        }
    }
    else if (2==buttonIndex+(_btnImageAvatar.selected?0:1)) {
        // ablums
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.modalPresentationStyle = UIModalPresentationFormSheet;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePicker.allowsEditing = YES;
        imagePicker.delegate = self;
        [self presentModalViewController:imagePicker animated:YES];
        if ([[UIDevice currentDevice] isPad]) {
            imagePicker.view.superview.bounds = CGRectMake(0, 0, 401, 500);
        }
    }
}

@end
