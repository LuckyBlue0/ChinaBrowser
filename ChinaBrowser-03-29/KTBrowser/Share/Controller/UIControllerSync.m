//
//  UIControllerSync.m
//  WKBrowser
//
//  Created by David on 13-10-16.
//  Copyright (c) 2013年 VeryApps. All rights reserved.
//

#import "UIControllerSync.h"

#import "CHKeychain.h"
#import "UIImageView+WebCache.h"

#import "UIControllerProfile.h"

#import <ShareSDK/ShareSDK.h>

#import "WKSync.h"

@interface UIControllerSync ()

- (IBAction)onTouchCancel;
- (IBAction)onTouchLogout;
- (IBAction)onTouchSyncNow;
- (IBAction)onTouchPersonal:(ACPButton *)sender;

- (void)willLogout;
- (void)doLogout;

- (IBAction)onValueChanaged:(UISwitch *)swi;

- (void)syncTimeUpdateNotification:(NSNotification *)notification;
- (void)setUpdateTime:(UILabel *)label;

@end

@implementation UIControllerSync

- (void)dealloc
{
    SAFE_RELEASE(_tableView);
    SAFE_RELEASE(_navBar);
    
    SAFE_RELEASE(_switchHome);
    SAFE_RELEASE(_switchFav);
    SAFE_RELEASE(_switchHistory);
    
    SAFE_RELEASE(_imageViewAvatar);
    SAFE_RELEASE(_labelUsername);
    
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncTimeUpdateNotification:) name:kNotificationUpdateSyncTime object:nil];
    
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
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, _viewCell30.frame.origin.y+_viewCell30.frame.size.height+10);
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.2];
    
    _viewNav.labelTitle.text = NSLocalizedString(@"sync", nil);
    [_viewNav.btnRight setTitle:NSLocalizedString(@"cancel", nil) forState:UIControlStateNormal];
    [_viewNav.btnLeft removeFromSuperview];
    
    _viewCell00.border = UIBorderTopBottom;
    _viewCell10.border = UIBorderTopBottom;
    _viewCell30.border = UIBorderTopBottom;
    
    [_imageViewAvatar setImageWithURL:[NSURL URLWithString:[WKSync shareWKSync].modelUser.avatar] placeholderImage:[UIImage imageWithFilename:@"User/user_bt_7.png"]];
    _labelUsername.text = [WKSync shareWKSync].modelUser.nickname.length>0?[WKSync shareWKSync].modelUser.nickname:[WKSync shareWKSync].modelUser.username;
    
    _labelSyncTimeKey.text = NSLocalizedString(@"sync_lasttime", nil);
    [self setUpdateTime:_labelSyncTimeValue];
    
    _labelHomeKey.text = NSLocalizedString(@"sync_home", nil);
    _labelFavKey.text = NSLocalizedString(@"sync_fav", nil);
    _labelHistoryKey.text = NSLocalizedString(@"sync_history", nil);
    
    NSArray *arrFieldKey = @[_labelSyncTimeKey,
                             _labelHomeKey,
                             _labelFavKey,
                             _labelHistoryKey];
    NSArray *arrViewValue = @[_labelSyncTimeValue,
                            _switchHome,
                            _switchFav,
                            _switchHistory];
    for (NSInteger i=0; i<arrFieldKey.count; i++) {
        UILabel *label = arrFieldKey[i];
        UIView *view = arrViewValue[i];
        
        rc = label.frame;
        [label sizeToFit];
        rc.size.width = label.frame.size.width;
        label.frame = rc;
        
        if (_labelSyncTimeValue==view) continue;
        
        rc = view.frame;
        [view sizeToFit];
        rc.size.width = view.frame.size.width;
        rc.origin.x = view.superview.bounds.size.width-rc.size.width-10;
        rc.size.height = view.frame.size.height;
        rc.origin.y = floorf((view.superview.bounds.size.height-rc.size.height)/2);
        view.frame = rc;
    }
    
    [_btnSync setTitle:NSLocalizedString(@"sync_now", nil) forState:UIControlStateNormal];
    
    _switchHome.on = [WKSync shareWKSync].modelUserSettings.shouldSyncHome;
    _switchFav.on = [WKSync shareWKSync].modelUserSettings.shouldSyncFavorite;
    _switchHistory.on = [WKSync shareWKSync].modelUserSettings.shouldSyncHistory;
    
    [_btnSync setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnSync setTitleColor:[UIColor colorWithWhite:0.9 alpha:1] forState:UIControlStateHighlighted];
    
    [_btnSync setFlatStyle:RGBCOLOR(0, 220, 0) andHighlightedColor:RGBCOLOR(0, 200, 0)];
    [_btnSync setBorderStyle:nil andInnerColor:nil];
    
    [_btnLogout setFlatStyle:RGBCOLOR(220, 0, 0) andHighlightedColor:RGBCOLOR(200, 0, 0)];
    [_btnLogout setBorderStyle:nil andInnerColor:nil];
    
    [_btnPersonal setFlatStyle:RGBA_COLOR(240, 240, 240, 0.7) andHighlightedColor:RGBA_COLOR(240, 240, 240, 0.3)];
//    [_btnPersonal setFlatStyleType:ACPButtonGrey];
    [_btnPersonal setBorderStyle:nil andInnerColor:nil];
    
//    [_btnPersonal setFlatStyle:RGBCOLOR(220, 0, 0) andHighlightedColor:RGBCOLOR(200, 0, 0)];
//    [_btnPersonal setBorderStyle:nil andInnerColor:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
- (IBAction)onTouchCancel
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (IBAction)onTouchLogout
{
    [self willLogout];
}

- (IBAction)onTouchSyncNow
{
    [[WKSync shareWKSync] syncAll];
}

- (IBAction)onTouchPersonal:(ACPButton *)sender
{
    UIControllerProfile *controller = [[UIControllerProfile alloc] initWithNibName:@"UIControllerProfile" bundle:nil];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)willLogout
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", 0) destructiveButtonTitle:NSLocalizedString(@"logout", 0) otherButtonTitles:nil];
    
//    UIView *rootView = [[UIApplication sharedApplication] keyWindow].rootViewController.view;
    [actionSheet showInView:self.navigationController.view];
}

- (void)doLogout
{
    NSString *szUserId = [CHKeychain load:kCurrUserId];
    [CHKeychain delete:szUserId];
    [CHKeychain delete:kCurrUserId];
    
    // 取消授权
    id shareType = [CHKeychain load:kCurrLoginShareType];
    if (shareType) {
        [ShareSDK cancelAuthWithType:[shareType integerValue]];
        [CHKeychain delete:kCurrLoginShareType];
    }
    
    [WKSync shareWKSync].modelUserSettings = nil;
    [WKSync shareWKSync].modelUser = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDidLogout object:nil];
    
    [self onTouchCancel];
}

- (IBAction)onValueChanaged:(UISwitch *)swi
{
    if (swi==_switchHome) {
        [WKSync shareWKSync].modelUserSettings.shouldSyncHome = swi.on;
        if (swi.on) [[WKSync shareWKSync] syncWithDataType:WKSyncDataTypeHome];
        else [[WKSync shareWKSync] stopSyncWithDataType:WKSyncDataTypeHome];
    }
    else if (swi==_switchFav) {
        [WKSync shareWKSync].modelUserSettings.shouldSyncFavorite = swi.on;
        if (swi.on) [[WKSync shareWKSync] syncWithDataType:WKSyncDataTypeFavorite];
        else [[WKSync shareWKSync] stopSyncWithDataType:WKSyncDataTypeFavorite];
    }
    else if (swi==_switchHistory) {
        [WKSync shareWKSync].modelUserSettings.shouldSyncHistory = swi.on;
        if (swi.on) [[WKSync shareWKSync] syncWithDataType:WKSyncDataTypeHistory];
        else [[WKSync shareWKSync] stopSyncWithDataType:WKSyncDataTypeHistory];
    }
    
    [ADOUserSettings updateModel:[WKSync shareWKSync].modelUserSettings withUid:[WKSync shareWKSync].modelUserSettings.uid];
}

// 
- (void)syncTimeUpdateNotification:(NSNotification *)notification
{
    [self setUpdateTime:_labelSyncTimeValue];
}

- (void)setUpdateTime:(UILabel *)label
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[WKSync shareWKSync].modelUserSettings.updateTimeInterval];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:date];
    label.text = [NSString stringWithFormat:@"%04d/%02d/%02d %02d:%02d:%02d",
                                 components.year,
                                 components.month,
                                 components.day,
                                 components.hour,
                                 components.minute,
                                 components.second];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==actionSheet.cancelButtonIndex) return;
    
    [self doLogout];
}

#pragma mark - UIControllerProfileDelegate
- (void)controllerProfileDidModify:(UIControllerProfile *)controller
{
    _labelUsername.text = [WKSync shareWKSync].modelUser.nickname.length>0?[WKSync shareWKSync].modelUser.nickname:[WKSync shareWKSync].modelUser.username;
    [_imageViewAvatar setImageWithURL:[NSURL URLWithString:[WKSync shareWKSync].modelUser.avatar] placeholderImage:[UIImage imageNamed:@"avatar-default"]];
}

@end
