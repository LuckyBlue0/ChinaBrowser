//
//  UIControllerBookmarkHistory.m
//  KTBrowser
//
//  Created by David on 14-3-10.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIControllerBookmarkHistory.h"

#import "ADOFavorite.h"

#import "BlockUI.h"
#import "SIAlertView.h"
#import "UIViewHeader.h"

#import "UICellHistory.h"

#import "ViewIndicator.h"

#import "WKSync.h"

#import "UIControllerLogin.h"
#import "UINavControllerUser.h"

@interface UIControllerBookmarkHistory ()

- (IBAction)onTouchBookmark;
- (IBAction)onTouchHistory;

- (IBAction)onTouchEdit;
- (IBAction)onTouchDone;
- (IBAction)onTouchClear;
- (IBAction)onTouchSync;
- (IBAction)onTouchBack;

- (void)onTouchHeader:(UIViewHeader *)viewHeader;

- (void)loadDataWithUrlType:(UrlType)urlType;

- (void)resizeWithInterfaceOrientation:(UIInterfaceOrientation)interfaceOriention;

@end

@implementation UIControllerBookmarkHistory

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
    
    _viewBarTop.backgroundColor = _viewBarBottom.backgroundColor = barBgColor;
//    [_textFieldTitle setValue:placeColor forKeyPath:@"_placeholderLabel.textColor"];
//    [_textFieldUrl setValue:placeColor forKeyPath:@"_placeholderLabel.textColor"];
//    _textFieldTitle.textColor = _textFieldUrl.textColor = textColor;
    
    
    _imageViewBg.image = [AppConfig config].bgImage;
    
    _currSectionIndex = -1;
    _arrBookmark = [NSMutableArray array];
    _arrArrHistory = [NSMutableArray arrayWithObjects:[NSMutableArray array], [NSMutableArray array], [NSMutableArray array], nil];
    _arrViewHeader = [NSMutableArray arrayWithCapacity:_arrArrHistory.count];
    
    for (NSInteger i=0; i<_arrArrHistory.count; i++) {
        UIViewHeader *viewHeader = [UIViewHeader viewHeaderFromXib];
        if (i==0) {
            viewHeader.labelTitle.text = @"今天";
        }
        else if (i==1) {
            viewHeader.labelTitle.text = @"昨天";
        }
        else {
            viewHeader.labelTitle.text = @"更早";
        }
        viewHeader.colorNor = [UIColor colorWithWhite:0.8 alpha:0.7];
        viewHeader.colorSelect = [UIColor colorWithWhite:0.9 alpha:0.7];
        viewHeader.labelSubTitle.text = nil;
        viewHeader.imageViewAccessory.image = [UIImage imageWithFilename:@"History.bundle/History_2_1.png"];
        viewHeader.imageViewIcon.image =[UIImage imageWithFilename:@"History.bundle/History_1.png"];
        viewHeader.labelTitle.textColor = [UIColor colorWithWhite:1 alpha:1];
        viewHeader.tag = i;
        [viewHeader addTarget:self action:@selector(onTouchHeader:) forControlEvents:UIControlEventTouchUpInside];
        
        [_arrViewHeader addObject:viewHeader];
    }
    
    // 书签
    _arrBookmark = [NSMutableArray arrayWithArray:[ADOFavorite queryWityUid:[WKSync shareWKSync].modelUser.uid
                                                                   dataType:WKSyncDataTypeFavorite
                                                                  withGuest:NO]];
    
    // 历史记录
    NSArray *arrHistoryOrigin = [ADOFavorite queryWityUid:[WKSync shareWKSync].modelUser.uid
                                                 dataType:WKSyncDataTypeHistory
                                                withGuest:NO];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    dateComponents.hour = 0;
    dateComponents.minute = 0;
    dateComponents.second = 0;
    NSDate *dateToday = [calendar dateFromComponents:dateComponents];
    
    NSTimeInterval tiToday = [dateToday timeIntervalSince1970];
    NSTimeInterval tiYesterday = tiToday-86400;
    for (ModelFavorite *model in arrHistoryOrigin) {
        if (model.time>=tiToday) {
            // 今天
            NSMutableArray *arrHistory = _arrArrHistory[0];
            [arrHistory addObject:model];
        }
        else if (model.time>=tiYesterday) {
            // 昨天
            NSMutableArray *arrHistory = _arrArrHistory[1];
            [arrHistory addObject:model];
        }
        else {
            // 更早
            NSMutableArray *arrHistory = _arrArrHistory[2];
            [arrHistory addObject:model];
        }
    }
    
    [self onTouchBookmark];
    
    [self resizeWithInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation];
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

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [_delegate controllerBookmarkHistory:self willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self resizeWithInterfaceOrientation:toInterfaceOrientation];
}

#pragma mark - IBAction
- (IBAction)onTouchBookmark
{
    [self loadDataWithUrlType:UrlTypeBookmark];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint center = _imageViewMask.center;
        center.x = _btnBookmark.center.x;
        _imageViewMask.center = center;
    }];
}

- (IBAction)onTouchHistory
{
    [self loadDataWithUrlType:UrlTypeHistory];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint center = _imageViewMask.center;
        center.x = _btnHistory.center.x;
        _imageViewMask.center = center;
    }];
}

- (IBAction)onTouchEdit
{
    _btnEdit.hidden = YES;
    _btnDone.hidden = NO;
    [_tableView setEditing:YES animated:YES];
}

- (IBAction)onTouchDone
{
    _btnEdit.hidden = NO;
    _btnDone.hidden = YES;
    
    [_tableView setEditing:NO animated:YES];
}

- (IBAction)onTouchClear
{
    if (UrlTypeBookmark==_urlType) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定清空书签" delegate:nil cancelButtonTitle:NSLocalizedString(@"cancel", @"取消") otherButtonTitles:@"确定", nil];
        [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
            if (alert.cancelButtonIndex==buttonIndex) {
                return;
            }
            
            if (1==buttonIndex) {
                if ([ADOFavorite deleteWithDataType:WKSyncDataTypeFavorite uid:[WKSync shareWKSync].modelUser.uid]) {
                    [_arrBookmark removeAllObjects];
                    [_tableView reloadData];
                }
            }
        }];
    }
    else {
        void (^delHistoryWithSection)(NSInteger section) = ^(NSInteger section){
            NSMutableArray *arrHistory = _arrArrHistory[section];
            NSMutableString *fids = [NSMutableString stringWithString:@""];
            NSMutableString *fidsServer = [NSMutableString stringWithString:@""];
            for (ModelFavorite *model in arrHistory) {
                [fids appendString:[@(model.fid) stringValue]];
                [fids appendString:@","];
                
                [fidsServer appendString:[@(model.fid_server) stringValue]];
                [fidsServer appendString:@","];
            }
            if (fids.length>1) {
                [fids deleteCharactersInRange:NSMakeRange(fids.length-1, 1)];
                [fidsServer deleteCharactersInRange:NSMakeRange(fidsServer.length-1, 1)];
            }
            
            if ([ADOFavorite deleteWithFids:fids]) {
                // TODO: 同步操作
                [[WKSync shareWKSync] syncDelWithDataType:WKSyncDataTypeHistory fids_server:fidsServer];
                
                [arrHistory removeAllObjects];
                
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
                
                NSString *msg = nil;
                if (0==section) {
                    msg = NSLocalizedString(@"cleared_history_today", @"已清空今天的历史记录");
                }
                else if (1==section) {
                    msg = NSLocalizedString(@"cleared_history_yesturday", @"已清空昨天的历史记录");
                }
                else if (2==section) {
                    msg = NSLocalizedString(@"cleared_history_ealier", @"已清空更早的历史记录");
                }
                
                [ViewIndicator showSuccessWithStatus:msg duration:1];
            }
        };
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"选择要清空的历史记录"
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel")
                                              otherButtonTitles:@"今天", @"昨天", @"更早", @"所有", nil];
        
        [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
            if (alert.cancelButtonIndex==buttonIndex) {return;}
            NSInteger section = buttonIndex-1;
            if (section<3) {
                delHistoryWithSection(section);
                UIViewHeader *viewHeader = _arrViewHeader[section];
                viewHeader.selected = NO;
                _currSectionIndex = -1;
            }
            else {
                if ([ADOFavorite deleteWithDataType:WKSyncDataTypeHistory uid:[WKSync shareWKSync].modelUser.uid]) {
                    // TODO: 同步操作
                    [[WKSync shareWKSync] syncDelAllHistory];
                    
                    [_arrArrHistory makeObjectsPerformSelector:@selector(removeAllObjects)];
                    
                    for (UIViewHeader *viewHeader in _arrViewHeader) {
                        viewHeader.selected = NO;
                    }
                    
                    _currSectionIndex = -1;
                    [_tableView reloadData];
                    
                    [ViewIndicator showSuccessWithStatus:NSLocalizedString(@"cleared_history_all", @"已清空所有历史记录") duration:1];
                }
            }
        }];
        
        /*
        SIAlertView *alert = [[SIAlertView alloc] initWithTitle:nil andMessage:@"确定清除历史记录"];
        if ([_arrArrHistory[0] count]>0) {
            [alert addButtonWithTitle:@"清除今天的" type:SIAlertViewButtonTypeDestructive handler:^(SIAlertView *alertView) {
                delHistoryWithSection(0);
            }];
        }
        if ([_arrArrHistory[1] count]>0) {
            [alert addButtonWithTitle:@"清除昨天的" type:SIAlertViewButtonTypeDestructive handler:^(SIAlertView *alertView) {
                delHistoryWithSection(1);
            }];
        }
        if ([_arrArrHistory[2] count]>0){
            [alert addButtonWithTitle:@"清除更早的" type:SIAlertViewButtonTypeDestructive handler:^(SIAlertView *alertView) {
                delHistoryWithSection(2);
            }];
        }
        [alert addButtonWithTitle:@"清除所有" type:SIAlertViewButtonTypeDestructive handler:^(SIAlertView *alertView) {
            [_arrArrHistory makeObjectsPerformSelector:@selector(removeAllObjects)];
            if ([ADOFavorite deleteWithDataType:WKSyncDataTypeHistory uid:[WKSync shareWKSync].modelUser.uid]) {
                [_tableView reloadData];
            }
        }];
        [alert addButtonWithTitle:@"取消" type:SIAlertViewButtonTypeCancel handler:^(SIAlertView *alertView) {
            
        }];
         [alert show];
         */
    }
}

/**
 *  同步
 */
- (IBAction)onTouchSync
{
    // TODO: 同步操作
    if ([WKSync shareWKSync].modelUser) {
        if (UrlTypeBookmark==_urlType) {
            [[WKSync shareWKSync] syncWithDataType:WKSyncDataTypeFavorite block:^{
                _arrBookmark = [NSMutableArray arrayWithArray:[ADOFavorite queryWityUid:[WKSync shareWKSync].modelUser.uid
                                                                               dataType:WKSyncDataTypeFavorite
                                                                              withGuest:NO]];
                
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
        }
        else if (UrlTypeHistory==_urlType) {
            [[WKSync shareWKSync] syncWithDataType:WKSyncDataTypeHistory block:^{
                // 历史记录
                [_arrArrHistory makeObjectsPerformSelector:@selector(removeAllObjects)];
                NSArray *arrHistoryOrigin = [ADOFavorite queryWityUid:[WKSync shareWKSync].modelUser.uid
                                                             dataType:WKSyncDataTypeHistory
                                                            withGuest:NO];
                
                NSCalendar *calendar = [NSCalendar currentCalendar];
                NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
                dateComponents.hour = 0;
                dateComponents.minute = 0;
                dateComponents.second = 0;
                NSDate *dateToday = [calendar dateFromComponents:dateComponents];
                
                NSTimeInterval tiToday = [dateToday timeIntervalSince1970];
                NSTimeInterval tiYesterday = tiToday-86400;
                for (ModelFavorite *model in arrHistoryOrigin) {
                    if (model.time>=tiToday) {
                        // 今天
                        NSMutableArray *arrHistory = _arrArrHistory[0];
                        [arrHistory addObject:model];
                    }
                    else if (model.time>=tiYesterday) {
                        // 昨天
                        NSMutableArray *arrHistory = _arrArrHistory[1];
                        [arrHistory addObject:model];
                    }
                    else {
                        // 更早
                        NSMutableArray *arrHistory = _arrArrHistory[2];
                        [arrHistory addObject:model];
                    }
                }
                
                if (_currSectionIndex>=0) {
                    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:_currSectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                else {
                    [_tableView reloadData];
                }
            }];
        }
    }
    else {
        UIControllerLogin *controller = [[UIControllerLogin alloc] initWithNibName:@"UIControllerLogin" bundle:nil];
        controller.title = NSLocalizedString(@"login", 0);
        
        UINavControllerUser *navController = [[UINavControllerUser alloc] initWithRootViewController:controller];
        navController.navigationBarHidden = YES;
        [self presentModalViewController:navController animated:YES];
    }
}

- (IBAction)onTouchBack
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)onTouchHeader:(UIViewHeader *)viewHeader
{
    [_arrViewHeader enumerateObjectsUsingBlock:^(UIViewHeader* item, NSUInteger idx, BOOL *stop) {
        if (item!=viewHeader) {
            item.selected = NO;
        }
        else {
            viewHeader.selected = !viewHeader.selected;
        }
    }];
    
    _currSectionIndex = viewHeader.selected?viewHeader.tag:-1;
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:viewHeader.tag] withRowAnimation:UITableViewRowAnimationFade];
    
    if (viewHeader.selected) {
        if ([_tableView numberOfRowsInSection:_currSectionIndex]>0)
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_currSectionIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)loadDataWithUrlType:(UrlType)urlType
{
    _urlType = urlType;
    if (UrlTypeBookmark==urlType)
    {
        _btnBookmark.enabled = NO;
        _btnHistory.enabled = YES;
        
        _btnEdit.hidden = NO;
        _btnDone.hidden = YES;
        _btnClear.hidden = YES;
        
        _tableView.editing = NO;
    }
    else {
        _btnBookmark.enabled = YES;
        _btnHistory.enabled = NO;
        
        _btnEdit.hidden = YES;
        _btnDone.hidden = YES;
        _btnClear.hidden = NO;
        
        _tableView.editing = NO;
    }
    
    [_tableView reloadData];
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
        
        rc = _tableView.frame;
        rc.origin.y = _viewBarTop.frame.origin.y+_viewBarTop.frame.size.height;
        rc.size.height = _viewBarBottom.frame.origin.y-rc.origin.y;
        _tableView.frame = rc;
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
        
        rc = _tableView.frame;
        rc.origin.y = _viewBarTop.frame.origin.y+_viewBarTop.frame.size.height;
        rc.size.height = _viewBarBottom.frame.origin.y-rc.origin.y;
        _tableView.frame = rc;
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (UrlTypeBookmark==_urlType) {
        return 1;
    }
    else {
        return _arrArrHistory.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (UrlTypeBookmark==_urlType) {
        return _arrBookmark.count;
    }
    else {
        return [_arrArrHistory[section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Identifier];
        cell.clipsToBounds = YES;
        cell.backgroundColor = nil;
        cell.backgroundView = nil;
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.textLabel.backgroundColor = cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
        
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        view.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
        cell.selectedBackgroundView = view;
    }
    
    ModelFavorite *model;
    if (UrlTypeBookmark==_urlType) {
        model = _arrBookmark[indexPath.row];
        cell.imageView.image = [UIImage imageWithFilename:@"History.bundle/History_0.png"];
    }
    else {
        model = _arrArrHistory[indexPath.section][indexPath.row];
        cell.imageView.image = [UIImage imageWithFilename:@"History.bundle/History_3_0.png"];
    }
    
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = [model.link urlDecode];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ModelFavorite *model = nil;
    if (UrlTypeBookmark==_urlType) {
        model = _arrBookmark[indexPath.row];
    }
    else {
        model = _arrArrHistory[indexPath.section][indexPath.row];
    }
    [_delegate controllerBookmarkHistory:self reqLink:model.link];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (UrlTypeBookmark==_urlType) {
        return nil;
    }
    else {
        return _arrViewHeader[section];
    }
}

/*
 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
 {
 if (UrlTypeBookmark==_urlType) {
 return nil;
 }
 else {
 if (0==section) {
 return @"今天";
 }
 else if (1==section) {
 return @"昨天";
 }
 else {
 return @"更早";
 }
 }
 }
 */

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (UrlTypeBookmark==_urlType) {
        return 0;
    }
    else {
        return 40;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UrlTypeBookmark==_urlType) {
        return 50;
    }
    else {
        if (indexPath.section==_currSectionIndex) {
            return 50;
        }
        else {
            return 0;
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelFavorite *model = nil;
    if (UrlTypeBookmark==_urlType) {
        model = _arrBookmark[indexPath.row];
        
        // TODO:同步操作
        [[WKSync shareWKSync] syncDelWithDataType:WKSyncDataTypeFavorite fid_server:model.fid_server];
        
        [ADOFavorite deleteWithFid:model.fid];
        [_delegate controllerBookmarkHistoryDidDeleteBookmark:self];
        
        [_arrBookmark removeObject:model];
    }
    else {
        model = _arrArrHistory[indexPath.section][indexPath.row];
        [ADOFavorite deleteWithFid:model.fid];
        
        // TODO:同步操作
        [[WKSync shareWKSync] syncDelWithDataType:WKSyncDataTypeHistory fid_server:model.fid_server];
        
        [_arrArrHistory[indexPath.section] removeObject:model];
    }
    
    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    
}

@end
