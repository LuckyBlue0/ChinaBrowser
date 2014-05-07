//
//  UIControllerLogin.m
//  WKBrowser
//
//  Created by David on 13-10-16.
//  Copyright (c) 2013年 VeryApps. All rights reserved.
//

#import "UIControllerLogin.h"

#import "UIControllerRegister.h"

#import "ViewIndicator.h"
#import "UIControllerSync.h"

#import "ASIFormDataRequest.h"

#import "CJSONDeserializer.h"

#import "ModelUser.h"
#import "CHKeychain.h"
#import "ModelUserSettings.h"
#import "ADOUserSettings.h"

#import <AGCommon/UIImage+Common.h>
#import <ShareSDK/ShareSDK.h>

#import "WKSync.h"

@interface UIControllerLogin ()

- (IBAction)onTouchCancel;
- (IBAction)onTouchRemember:(UIButton *)sender;
- (IBAction)onTouchFindpwd:(UIButton *)sender;
- (IBAction)onTouchDoLogin;
- (IBAction)onTouchRegister;

- (BOOL)checkForm;
- (void)doLogin;
- (void)doLoginWithShareType:(ShareType)shareType;

- (void)keyboardWillShowNotification:(NSNotification *)notification;
- (void)keyboardWillHideNotification:(NSNotification *)notification;

- (IBAction)onTouchLoginOption:(UIViewSNSItem *)option;

@end

@implementation UIControllerLogin

- (void)dealloc
{
    SAFE_RELEASE(_navBar);
    SAFE_RELEASE(_tableView);
    
    SAFE_RELEASE(_textFiledUsername);
    SAFE_RELEASE(_textFiledPwd);
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rc;
    
    // Do any additional setup after loading the view from its nib.
    if (UI_USER_INTERFACE_IDIOM()!=UIUserInterfaceIdiomPad) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    }
    
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
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, _viewSNSItemSina.frame.origin.y+_viewSNSItemSina.frame.size.height+10);
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.2];
    
    _viewCell00.border =
    _viewCell10.border = UIBorderTopBottom;
    
    _viewCell01.borderColor =
    _viewCell00.borderColor = [UIColor whiteColor];
    
    [_viewNav.btnRight setTitle:NSLocalizedString(@"cancel", nil) forState:UIControlStateNormal];
    [_viewNav.btnLeft removeFromSuperview];
    
    _viewNav.labelTitle.text = NSLocalizedString(@"login", nil);
    
    if (UIModeDay==[AppConfig config].uiMode) {
        [_btnRemember setImage:[UIImage imageWithFilename:@"User/user_bt_xuan_bai_0.png"] forState:UIControlStateNormal];
        [_btnRemember setImage:[UIImage imageWithFilename:@"User/user_bt_xuan_bai_1.png"] forState:UIControlStateSelected];
    }
    else {
        [_btnRemember setImage:[UIImage imageWithFilename:@"User/user_bt_xuan_ye_0.png"] forState:UIControlStateNormal];
        [_btnRemember setImage:[UIImage imageWithFilename:@"User/user_bt_xuan_ye_1.png"] forState:UIControlStateSelected];
    }
    
    _btnRemember.selected = [AppConfig config].rememberPwd;
    
    [_btnRemember setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_btnRemember setTitle:[@" " stringByAppendingString:NSLocalizedString(@"remember_pwd", nil)] forState:UIControlStateNormal];
    rc = _btnRemember.frame;
    rc.origin.x = 10;
    [_btnRemember sizeToFit];
    rc.size.width = _btnRemember.frame.size.width;
    _btnRemember.frame = rc;
    
    [_btnFindPwd setTitle:[NSLocalizedString(@"forgot_password", nil) stringByAppendingString:@"?"] forState:UIControlStateNormal];
    rc = _btnFindPwd.frame;
    [_btnFindPwd sizeToFit];
    rc.size.width = _btnFindPwd.bounds.size.width;
    rc.origin.x = self.view.bounds.size.width-rc.size.width-10;
    _btnFindPwd.frame = rc;
    [_btnRemember setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
    _labelUsername.text = [NSLocalizedString(@"username", nil) stringByAppendingString:@"："];
    _labelPwd.text = [NSLocalizedString(@"pwd", nil) stringByAppendingString:@"："];
    
    rc = _labelUsername.frame;
    [_labelUsername sizeToFit];
    rc.size.width = _labelUsername.bounds.size.width;
    _labelUsername.frame = rc;
    
    rc = _labelPwd.frame;
    [_labelPwd sizeToFit];
    rc.size.width = _labelPwd.bounds.size.width;
    _labelPwd.frame = rc;
    
    _textFiledUsername.placeholder = NSLocalizedString(@"placeholder_username", 0);
    _textFiledUsername.delegate = self;
    _textFiledUsername.returnKeyType = UIReturnKeyNext;
    _textFiledUsername.clearButtonMode = UITextFieldViewModeWhileEditing;
    rc = _labelUsername.frame;
    rc.origin.x +=  rc.size.width+5;
    rc.size.width = _viewCell00.bounds.size.width-rc.origin.x;
    _textFiledUsername.frame = rc;
    
    _textFiledPwd.secureTextEntry = YES;
    _textFiledPwd.placeholder = NSLocalizedString(@"placeholder_pwd", 0);
    _textFiledPwd.delegate = self;
    _textFiledPwd.returnKeyType = UIReturnKeyDone;
    _textFiledPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    rc = _labelPwd.frame;
    rc.origin.x +=  rc.size.width+5;
    rc.size.width = _viewCell01.bounds.size.width-rc.origin.x;
    _textFiledPwd.frame = rc;
    
    _labelOtherLogin.text = NSLocalizedString(@"sign_in_with", nil);
    [_labelOtherLogin sizeToFit];
    rc = _labelOtherLogin.frame;
    [_labelOtherLogin sizeToFit];
    rc.size.width = _labelOtherLogin.bounds.size.width;
    rc.origin.x = floorf((self.view.bounds.size.width-rc.size.width)/2);
    _labelOtherLogin.frame = rc;
    
    rc = _imageViewLineLeft.frame;
    rc.origin.x = 10;
    rc.size.width = _labelOtherLogin.frame.origin.x-rc.origin.x-5;
    rc.size.height = 1;
    rc.origin.y = _labelOtherLogin.frame.origin.y+(_labelOtherLogin.bounds.size.height-rc.size.height)/2;
    _imageViewLineLeft.frame = rc;
    
    rc = _imageViewLineRight.frame;
    rc.origin.x = _labelOtherLogin.frame.origin.x+_labelOtherLogin.bounds.size.width+5;
    rc.size.width = self.view.bounds.size.width-5-rc.origin.x;
    rc.size.height = 1;
    rc.origin.y = _labelOtherLogin.frame.origin.y+(_labelOtherLogin.bounds.size.height-rc.size.height)/2;
    _imageViewLineRight.frame = rc;
    
    [_btnLogin setTitle:NSLocalizedString(@"login", nil) forState:UIControlStateNormal];
    [_btnRegister setTitle:NSLocalizedString(@"register", nil) forState:UIControlStateNormal];
    
    [_btnLogin setFlatStyleType:ACPButtonOK];
    [_btnLogin setBorderStyle:nil andInnerColor:nil];
    [_btnRegister setFlatStyleType:ACPButtonBlue];
    [_btnRegister setBorderStyle:nil andInnerColor:nil];
    

    // ---- 第三方登录
    NSArray *arrShareType = @[@(ShareTypeSinaWeibo), @(ShareTypeTencentWeibo), @(ShareTypeQQ)];
    NSArray *arrItem = @[_viewSNSItemSina, _viewSNSItemTQQ, _viewSNSItemQQ];
    for (NSInteger i=0; i<arrShareType.count; i++) {
        UIViewSNSItem *viewSNSItem = arrItem[i];
        ShareType shareType = [arrShareType[i] integerValue];
        NSString *filename = [NSString stringWithFormat:@"Resource.bundle/Icon_7/sns_icon_%d.png", shareType];
        viewSNSItem.imageViewIcon.image = [UIImage imageWithFilename:filename];
        NSString *key = [NSString stringWithFormat:@"ShareType_%d", shareType];
        viewSNSItem.labelTitle.text = NSLocalizedStringFromTable(key, @"ShareSDKLocalizable", nil);
        viewSNSItem.labelTitle.textColor = [UIColor whiteColor];
        viewSNSItem.tag = shareType;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
//    [_textFiledUsername becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_textFiledUsername resignFirstResponder];
    [_textFiledPwd resignFirstResponder];
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
- (IBAction)onTouchCancel
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (IBAction)onTouchRemember:(UIButton *)sender
{
    sender.selected = !sender.selected;
    [AppConfig config].rememberPwd = sender.selected;
}

- (IBAction)onTouchFindpwd:(UIButton *)sender
{
    
}

- (IBAction)onTouchDoLogin
{
    [self doLogin];
}

- (IBAction)onTouchRegister
{
    UIControllerRegister *controller = [[UIControllerRegister alloc] initWithNibName:@"UIControllerRegister" bundle:nil];
    controller.title = NSLocalizedString(@"register", 0);
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==_textFiledUsername) {
        [_textFiledPwd becomeFirstResponder];
    }
    else {
        [self doLogin];
    }
    return YES;
}

#pragma mark - private methods
- (BOOL)checkForm
{
    NSString *msg = nil;
    do {
        if (_textFiledUsername.text.length==0) {
            msg = @"msg_username_empty";
            [_textFiledUsername becomeFirstResponder];
            break;
        }
        if (_textFiledPwd.text.length==0) {
            [_textFiledPwd becomeFirstResponder];
            msg = @"msg_pwd_empty";
            break;
        }
    } while (NO);
    if (msg) {
        [ViewIndicator showWarningWithStatus:NSLocalizedString(msg, 0) duration:2];
        return NO;
    }
    else
        return YES;
    
}

- (void)doLogin
{
    if ([self checkForm]) {
        [_reqLogin clearDelegatesAndCancel];
        SAFE_RELEASE(_reqLogin);
        
        [ViewIndicator showWithStatus:@"正在登录..." indicatorType:IndicatorTypeDefault];
        
        _reqLogin = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:API_User]];
        [_reqLogin setPostValue:API_AppName forKey:@"app"];
        [_reqLogin setPostValue:@"login" forKey:@"ac"];
        [_reqLogin setPostValue:_textFiledUsername.text forKey:@"username"];
        [_reqLogin setPostValue:_textFiledPwd.text forKey:@"password"];
        [_reqLogin setTimeOutSeconds:10];
        [_reqLogin setCompletionBlock:^{
            NSDictionary *dicResult = [[CJSONDeserializer deserializer] deserialize:_reqLogin.responseData error:nil];
            NSString *msg = [dicResult objectForKey:@"msg"];
            NSDictionary *dicInfo = [dicResult objectForKey:@"data"];
            
            if (msg && !dicInfo) {
                [ViewIndicator showErrorWithStatus:msg duration:2];
            }
            else {
                
                ModelUser *model = [ModelUser modelUserWithDictionary:dicInfo];
                NSData *data = [model modelUserToData];
                NSString *szUserId = [NSString stringWithFormat:@"%d", model.uid];
                
                // keychain 保存当前用户Id和用户信息
                [CHKeychain save:szUserId data:data];
                [CHKeychain save:kCurrUserId data:szUserId];
                
                [WKSync shareWKSync].modelUser = model;
                
                if ([ADOUserSettings isExsitsWithUid:model.uid]) {
                    [WKSync shareWKSync].modelUserSettings = [ADOUserSettings queryWithUid:model.uid];
                }
                else {
                    ModelUserSettings *modelUserSettings = [ModelUserSettings modelUserSettings];
                    modelUserSettings.uid = model.uid;
                    modelUserSettings.updateTimeInterval = 0;
                    modelUserSettings.shouldSyncHome = YES;
                    modelUserSettings.shouldSyncFavorite = YES;
                    modelUserSettings.shouldSyncHistory = NO;
                    [ADOUserSettings addWithModel:modelUserSettings];
                    
                    [WKSync shareWKSync].modelUserSettings = modelUserSettings;
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDidLogin object:nil];
                
                [[WKSync shareWKSync] syncAll];
                
                [ViewIndicator showSuccessWithStatus:msg duration:2];
                UIControllerSync *controller = [[UIControllerSync alloc] initWithNibName:@"UIControllerSync" bundle:nil];
                controller.title = NSLocalizedString(@"sync", 0);
                [self.navigationController pushViewController:controller animated:YES];
            }
            SAFE_RELEASE(_reqLogin);
        }];
        [_reqLogin setFailedBlock:^{
            [ViewIndicator showErrorWithStatus:_reqLogin.error.localizedDescription duration:2];
            SAFE_RELEASE(_reqLogin);
        }];
        [_reqLogin startAsynchronous];
        
    }
}

- (void)doLoginWithShareType:(ShareType)shareType
{
    [_reqLogin clearDelegatesAndCancel];
    SAFE_RELEASE(_reqLogin);
    
    [ViewIndicator showWithStatus:@"正在登录..." indicatorType:IndicatorTypeDefault];
    
    _reqLogin = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:API_User]];
    [_reqLogin setPostValue:API_AppName forKey:@"app"];
    [_reqLogin setPostValue:@"oauth" forKey:@"ac"];
    
    id<ISSPlatformUser> oauthUserInfo = [ShareSDK currentAuthUserWithType:shareType];
    
    NSDictionary *dicSourceData = [oauthUserInfo sourceData];
    NSTimeInterval expires_in = fabs([[[oauthUserInfo credential] expired] timeIntervalSinceNow]);
    NSString *access_token = [[oauthUserInfo credential] token];
    
    [_reqLogin setPostValue:[NSNumber numberWithInteger:expires_in] forKey:@"expires_in"];
    [_reqLogin setPostValue:access_token forKey:@"access_token"];
    
    switch (shareType) {
        case ShareTypeSinaWeibo:
            [_reqLogin setPostValue:@"weibo" forKey:@"type"];
            break;
        case ShareTypeTencentWeibo:
            [_reqLogin setPostValue:[dicSourceData objectForKey:@"openid"] forKey:@"openid"];
            [_reqLogin setPostValue:[dicSourceData objectForKey:@"refresh_token"] forKey:@"refresh_token"];
            [_reqLogin setPostValue:@"tqq" forKey:@"type"];
            break;
        case ShareTypeQQSpace:
            [_reqLogin setPostValue:[dicSourceData objectForKey:@"openid"] forKey:@"openid"];
            [_reqLogin setPostValue:@"qq" forKey:@"type"];
            break;
        default:
            break;
    }
    [_reqLogin setUserInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:shareType] forKey:@"share_type"]];
    [_reqLogin setTimeOutSeconds:30];
    [_reqLogin setCompletionBlock:^{
        NSDictionary *dicResult = [[CJSONDeserializer deserializer] deserialize:_reqLogin.responseData error:nil];
        NSString *msg = [dicResult objectForKey:@"msg"];
        NSDictionary *dicInfo = [dicResult objectForKey:@"data"];
        
        if (msg && !dicInfo) {
            [ViewIndicator showErrorWithStatus:msg duration:2];
        }
        else {
            
            ModelUser *model = [ModelUser modelUserWithDictionary:dicInfo];
            NSData *data = [model modelUserToData];
            NSString *szUserId = [NSString stringWithFormat:@"%d", model.uid];
            
            // keychain 保存当前用户Id和用户信息
            [CHKeychain save:szUserId data:data];
            [CHKeychain save:kCurrUserId data:szUserId];
            [CHKeychain save:kCurrLoginShareType data:[[_reqLogin userInfo] objectForKey:@"share_type"]];
            
            [WKSync shareWKSync].modelUser = model;
            
            if ([ADOUserSettings isExsitsWithUid:model.uid]) {
                [WKSync shareWKSync].modelUserSettings = [ADOUserSettings queryWithUid:model.uid];
            }
            else {
                ModelUserSettings *modelUserSettings = [ModelUserSettings modelUserSettings];
                modelUserSettings.uid = model.uid;
                modelUserSettings.updateTimeInterval = 0;
                modelUserSettings.shouldSyncHome = YES;
                modelUserSettings.shouldSyncFavorite = YES;
                modelUserSettings.shouldSyncHistory = NO;
                [ADOUserSettings addWithModel:modelUserSettings];
                
                [WKSync shareWKSync].modelUserSettings = modelUserSettings;
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDidLogin object:nil];
            
            [[WKSync shareWKSync] syncAll];
            
            [ViewIndicator showSuccessWithStatus:msg duration:2];
            UIControllerSync *controller = [[UIControllerSync alloc] initWithNibName:@"UIControllerSync" bundle:nil];
            controller.title = NSLocalizedString(@"sync", 0);
            [self.navigationController pushViewController:controller animated:YES];
        }
        SAFE_RELEASE(_reqLogin);
    }];
    [_reqLogin setFailedBlock:^{
        [ViewIndicator showErrorWithStatus:_reqLogin.error.localizedDescription duration:2];
        SAFE_RELEASE(_reqLogin);
    }];
    [_reqLogin startAsynchronous];
}

#pragma mark - keyboard notification
- (void)keyboardWillShowNotification:(NSNotification *)notification
{
    if (!(_textFiledUsername.isFirstResponder || _textFiledPwd.isFirstResponder)) return;
    
    CGRect rcKeyboard = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve  curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationDuration:duration];
    
    CGRect rc = _scrollView.frame;
    rc.size.width = self.view.bounds.size.width;
    rc.size.height = self.view.bounds.size.height-rc.origin.y-(isPortrait?rcKeyboard.size.height:rcKeyboard.size.width);
    _scrollView.frame = rc;
    
    [UIView commitAnimations];
}

- (void)keyboardWillHideNotification:(NSNotification *)notification
{
    if (!(_textFiledUsername.isFirstResponder || _textFiledPwd.isFirstResponder)) return;
    
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

- (IBAction)onTouchLoginOption:(UIViewSNSItem *)option
{
    ShareType shareType = option.tag;
    if (ShareTypeQQ==shareType) {
        shareType = ShareTypeQQSpace;
    }
    
    id<ISSAuthOptions> options = [ShareSDK authOptionsWithAutoAuth:YES
                                                     allowCallback:NO
                                                     authViewStyle:SSAuthViewStyleModal
                                                      viewDelegate:nil
                                           authManagerViewDelegate:nil];
    [options setPowerByHidden:YES];
    
//    // 取消授权
//    [ShareSDK cancelAuthWithType:shareType];
    
    if ([ShareSDK hasAuthorizedWithType:shareType] && NO) {
        [self doLoginWithShareType:shareType];
    }
    else {
        [ShareSDK authWithType:shareType
                       options:options
                        result:^(SSAuthState state, id<ICMErrorInfo> error) {
                            if (SSAuthStateSuccess==state) {
                                [self doLoginWithShareType:shareType];
                            }
                            else {
                                _DEBUG_LOG(@"%@", error);
                            }
                        }];
    }
}

@end
