//
//  UIControllerRegister.m
//  WKBrowser
//
//  Created by David on 13-10-16.
//  Copyright (c) 2013年 VeryApps. All rights reserved.
//

#import "UIControllerRegister.h"

#import "ViewIndicator.h"
#import "CJSONDeserializer.h"
#import "ASIFormDataRequest.h"

#import "UIControllerSync.h"
#import "CHKeychain.h"
#import "ModelUser.h"
#import "ModelUserSettings.h"
#import "ADOUserSettings.h"

#import "WKSync.h"


@interface UIControllerRegister ()

- (IBAction)onTouchBack;
- (IBAction)onTouchCancel;

- (BOOL)checkForm;
- (IBAction)doRegister;

@end

@implementation UIControllerRegister

- (void)dealloc
{
    [_reqRegister clearDelegatesAndCancel];
    SAFE_RELEASE(_reqRegister);
    
    SAFE_RELEASE(_navBar);
    SAFE_RELEASE(_tableView);
    
    SAFE_RELEASE(_textFiledUsername);
    SAFE_RELEASE(_textFiledNickname);
    SAFE_RELEASE(_textFiledEmail);
    SAFE_RELEASE(_textFiledPwd);
    SAFE_RELEASE(_textFiledPwd2);
    
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

- (void)viewDidAppear:(BOOL)animated
{
//    [_textFiledUsername becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_textFiledUsername resignFirstResponder];
    [_textFiledNickname resignFirstResponder];
    [_textFiledPwd resignFirstResponder];
    [_textFiledPwd2 resignFirstResponder];
    [_textFiledEmail resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (UI_USER_INTERFACE_IDIOM()!=UIUserInterfaceIdiomPad) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
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
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, _viewCell10.frame.origin.y+_viewCell10.frame.size.height+10);
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.2];
    
    _viewCell00.border =
    _viewCell10.border = UIBorderTopBottom;

    _viewNav.labelTitle.text = NSLocalizedString(@"register", nil);
    [_viewNav.btnLeft setTitle:NSLocalizedString(@"back", nil) forState:UIControlStateNormal];
    [_viewNav.btnRight setTitle:NSLocalizedString(@"cancel", nil) forState:UIControlStateNormal];
    
    _labelUsername.text = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"username", 0)];
    _labelNickname.text = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"nickname", 0)];
    _labelEmail.text = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"email", 0)];
    _labelPwd.text = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"pwd", 0)];
    _labelPwd2.text = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"pwd2", 0)];
    
    NSArray *arrLabel = @[_labelUsername, _labelNickname, _labelEmail, _labelPwd, _labelPwd2];
    NSArray *arrField = @[_textFiledUsername, _textFiledNickname, _textFiledEmail, _textFiledPwd, _textFiledPwd2];
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
    
    _textFiledUsername.placeholder = NSLocalizedString(@"placeholder_username", 0);
    _textFiledUsername.delegate = self;
    _textFiledUsername.returnKeyType = UIReturnKeyNext;
    
    _textFiledNickname.placeholder = NSLocalizedString(@"placeholder_nickname", 0);
    _textFiledNickname.delegate = self;
    _textFiledNickname.returnKeyType = UIReturnKeyNext;
    
    _textFiledEmail.placeholder = NSLocalizedString(@"placeholder_email", 0);
    _textFiledEmail.delegate = self;
    _textFiledEmail.returnKeyType = UIReturnKeyNext;
    _textFiledEmail.keyboardType = UIKeyboardTypeEmailAddress;
    
    _textFiledPwd.secureTextEntry = YES;
    _textFiledPwd.placeholder = NSLocalizedString(@"placeholder_pwd", 0);
    _textFiledPwd.delegate = self;
    _textFiledPwd.returnKeyType = UIReturnKeyNext;
    
    _textFiledPwd2.secureTextEntry = YES;
    _textFiledPwd2.placeholder = NSLocalizedString(@"placeholder_pwd2", 0);
    _textFiledPwd2.delegate = self;
    _textFiledPwd2.returnKeyType = UIReturnKeyDone;
    
    [_btnRegister setTitle:NSLocalizedString(@"register", nil) forState:UIControlStateNormal];
    
    [_btnRegister setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnRegister setTitleColor:[UIColor colorWithWhite:0.9 alpha:1] forState:UIControlStateHighlighted];
    
    [_btnRegister setFlatStyleType:ACPButtonBlue];
    [_btnRegister setBorderStyle:nil andInnerColor:nil];
    
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

- (BOOL)checkForm
{
    NSString *msg = nil;
    do {
        if (_textFiledUsername.text.length==0) {
            msg = @"msg_username_empty";
            [_textFiledUsername becomeFirstResponder];
            break;
        }
        if (_textFiledNickname.text.length==0) {
            msg = @"msg_nickname_empty";
            [_textFiledNickname becomeFirstResponder];
            break;
        }
        if (_textFiledEmail.text.length==0) {
            msg = @"msg_email_empty";
            [_textFiledEmail becomeFirstResponder];
            break;
        }
        
        NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
        NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
        NSString *emailRegex = YES ? stricterFilterString : laxString;
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if (![emailTest evaluateWithObject:_textFiledEmail.text]) {
            msg = @"msg_email_invalid";
            break;
        }
        
        if (_textFiledPwd.text.length==0) {
            [_textFiledPwd becomeFirstResponder];
            msg = @"msg_pwd_empty";
            break;
        }
        if (_textFiledPwd2.text.length==0) {
            [_textFiledPwd2 becomeFirstResponder];
            msg = @"msg_pwd2_empty";
            break;
        }
        if (![_textFiledPwd2.text isEqualToString:_textFiledPwd.text]) {
            [_textFiledPwd2 becomeFirstResponder];
            msg = @"msg_pwd2_nomatch";
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

- (IBAction)doRegister
{
    if ([self checkForm]) {
        [_reqRegister clearDelegatesAndCancel];
        SAFE_RELEASE(_reqRegister);
        
        [ViewIndicator showWithStatus:@"正在注册..." indicatorType:IndicatorTypeDefault];
        
        _reqRegister = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:API_User]];
        
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         API_AppName, @"app",
                                         _textFiledUsername.text, @"username",
                                         _textFiledNickname.text, @"nickname",
                                         _textFiledEmail.text, @"email",
                                         _textFiledPwd.text, @"password", nil];
        [dicParam setObject:[NSString signWithParams:dicParam] forKey:@"sign"];
        [dicParam setObject:@"register" forKey:@"ac"];
        [dicParam enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [_reqRegister setPostValue:obj forKey:key];
        }];
        [_reqRegister setTimeOutSeconds:30];
        UIImage *image = [UIImage imageNamed:@"avatar-default@2x"];
        NSData *data = UIImagePNGRepresentation(image);
        [_reqRegister addData:data forKey:@"avatar"];
        [_reqRegister setCompletionBlock:^{
            NSDictionary *dicResult = [[CJSONDeserializer deserializer] deserialize:_reqRegister.responseData error:nil];
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
            SAFE_RELEASE(_reqRegister);
        }];
        [_reqRegister setFailedBlock:^{
            [ViewIndicator showErrorWithStatus:_reqRegister.error.localizedDescription duration:2];
            SAFE_RELEASE(_reqRegister);
        }];
        [_reqRegister startAsynchronous];
    }
}

#pragma mark - keyboard notification
- (void)keyboardWillShowNotification:(NSNotification *)notification
{
    if (!(_textFiledUsername.isFirstResponder
          || _textFiledNickname.isFirstResponder
          || _textFiledEmail.isFirstResponder
          || _textFiledPwd.isFirstResponder
          || _textFiledPwd2.isFirstResponder)) return;
    
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
          || _textFiledEmail.isFirstResponder
          || _textFiledPwd.isFirstResponder
          || _textFiledPwd2.isFirstResponder)) return;
    
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

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0==section) return 5;
    else return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Identifier = [NSString stringWithFormat:@"%d_%d", indexPath.section, indexPath.row];
    
    UITableViewCell *cell = nil;
    if (indexPath.section==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            CGRect rcContentView = cell.contentView.bounds;
            CGRect rc = rcContentView;
            UILabel *label = [[UILabel alloc] initWithFrame:rc];;
            label.font = [UIFont systemFontOfSize:15];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor darkGrayColor];
            
            UITextField *textFiled = nil;
            
            switch (indexPath.row) {
                case 0:
                {
                    textFiled = _textFiledUsername;
                }
                    break;
                case 1:
                {
                    textFiled = _textFiledNickname;
                    _labelNickname.text = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"nickname", 0)];
                }
                    break;
                case 2:
                {
                    textFiled = _textFiledEmail;
                    _labelEmail.text = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"email", 0)];
                }
                    break;
                case 3:
                {
                    textFiled = _textFiledPwd;
                    _labelPwd.text = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"pwd", 0)];
                }
                    break;
                case 4:
                {
                    textFiled = _textFiledPwd2;
                    _labelPwd2.text = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"pwd2", 0)];
                }
                    break;
                    
                default:
                    break;
            }
            
            [label sizeToFit];
            rc = rcContentView;
            rc.origin.x = 5;
            rc.size.width = label.bounds.size.width;
            label.frame = rc;
            
            rc.origin.x += rc.size.width+5;
            rc.size.width = rcContentView.size.width-rc.origin.x-5;
            textFiled.frame = rc;
            textFiled.textColor = [UIColor grayColor];
            textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
            textFiled.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            textFiled.backgroundColor = [UIColor clearColor];
            textFiled.font = [UIFont systemFontOfSize:15];
            textFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            textFiled.autocorrectionType = UITextAutocorrectionTypeNo;
            textFiled.autocapitalizationType = UITextAutocapitalizationTypeNone;
            
            [cell.contentView addSubview:label];
            [cell.contentView addSubview:textFiled];
        }
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
            cell.textLabel.text = NSLocalizedString(@"register", 0);
            cell.textLabel.backgroundColor = [UIColor clearColor];
            
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.highlightedTextColor = [UIColor colorWithWhite:0.7 alpha:1];
            
            UIView *bgView0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            bgView0.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iphone-bg-4"]];
            bgView0.layer.cornerRadius = 8;
            bgView0.layer.borderWidth = 1;
            bgView0.layer.borderColor = [UIColor grayColor].CGColor;
            bgView0.clipsToBounds = YES;
            
            UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            bgView1.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
            bgView1.layer.cornerRadius = 8;
            bgView1.layer.borderWidth = 1;
            bgView1.layer.borderColor = [UIColor grayColor].CGColor;
            bgView1.clipsToBounds = YES;
            
            cell.backgroundView = bgView0;
            cell.selectedBackgroundView = bgView1;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        cell.backgroundColor = [UIColor clearColor];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1 && indexPath.row == 0) {
        [self doRegister];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==_textFiledUsername) {
        [_textFiledNickname becomeFirstResponder];
    }
    else if (textField==_textFiledNickname) {
        [_textFiledEmail becomeFirstResponder];
    }
    else if (textField==_textFiledEmail) {
        [_textFiledPwd becomeFirstResponder];
    }
    else if (textField==_textFiledPwd) {
        [_textFiledPwd2 becomeFirstResponder];
    }
    else {
        [self doRegister];
    }
    return YES;
}

@end
