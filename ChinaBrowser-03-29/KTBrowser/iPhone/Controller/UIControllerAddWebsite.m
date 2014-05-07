//
//  UIControllerAddWebsite.m
//  KTBrowser
//
//  Created by David on 14-3-10.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIControllerAddWebsite.h"

#import "ADOFavorite.h"
#import <QuartzCore/QuartzCore.h>

#import "UIViewHeader.h"
#import "ViewIndicator.h"

#import "WKSync.h"

@interface UIControllerAddWebsite ()

- (IBAction)onTouchBookmark;
- (IBAction)onTouchHistory;

- (IBAction)onTouchCancel;
- (IBAction)onTouchOK;

- (void)onTouchHeader:(UIViewHeader *)viewHeader;

- (void)loadDataWithUrlType:(UrlType)urlType;

@end

@implementation UIControllerAddWebsite

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
    
    _imageViewBg.image = [AppConfig config].bgImage;
    
    
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
    [_textFieldTitle setValue:placeColor forKeyPath:@"_placeholderLabel.textColor"];
    [_textFieldUrl setValue:placeColor forKeyPath:@"_placeholderLabel.textColor"];
    _textFieldTitle.textColor = _textFieldUrl.textColor = textColor;
    
    
    
    _textFieldTitle.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
    _textFieldTitle.layer.borderWidth = 1;
    _textFieldTitle.layer.shadowColor = [UIColor redColor].CGColor;
    _textFieldTitle.layer.shadowOffset = CGSizeZero;
    _textFieldTitle.layer.shadowRadius = 2;
    _textFieldTitle.clipsToBounds = NO;
    _textFieldTitle.layer.shadowOpacity = 0;
    
    _textFieldUrl.layer.borderColor = _textFieldTitle.layer.borderColor;
    _textFieldUrl.layer.borderWidth = 1;
    _textFieldUrl.layer.shadowColor = [UIColor redColor].CGColor;
    _textFieldUrl.layer.shadowOffset = CGSizeZero;
    _textFieldUrl.layer.shadowRadius = 2;
    _textFieldUrl.clipsToBounds = NO;
    _textFieldUrl.layer.shadowOpacity = 0;
    
    _textFieldTitle.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _textFieldTitle.leftView.backgroundColor = [UIColor clearColor];
    _textFieldTitle.leftViewMode = UITextFieldViewModeAlways;
    _textFieldUrl.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _textFieldUrl.leftView.backgroundColor = [UIColor clearColor];
    _textFieldUrl.leftViewMode = UITextFieldViewModeAlways;
    
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
        viewHeader.colorNor = [UIColor colorWithWhite:0.8 alpha:0.4];
        viewHeader.colorSelect = [UIColor colorWithWhite:0.9 alpha:0.5];
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
    [_delegate controllerAddWebsite:self willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
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

- (IBAction)onTouchCancel
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)onTouchOK
{
    BOOL bFlag = YES;
    NSString *msg = nil;
    
    if (_textFieldTitle.text.length==0) {
        bFlag = NO;
        _textFieldTitle.layer.shadowOpacity = 1;
        msg = @"请输入标题";
    }
    else {
        _textFieldTitle.layer.shadowOpacity = 0;
    }
    
    if (_textFieldUrl.text.length==0) {
        bFlag = NO;
        _textFieldUrl.layer.shadowOpacity = 1;
        msg = @"请输入地址";
    }
    else {
        _textFieldUrl.layer.shadowOpacity = 0;
    }
    
    if (!bFlag) {
        [ViewIndicator showWarningWithStatus:msg duration:3];
        [_textFieldUrl resignFirstResponder];
        [_textFieldTitle resignFirstResponder];
        return;
    }
    
    [_textFieldTitle resignFirstResponder];
    [_textFieldUrl resignFirstResponder];
    
    if ([_delegate respondsToSelector:@selector(controllerAddWebsite:title:link:)]) {
        
        NSString *link = _textFieldUrl.text;
        if (!([link hasPrefix:@"http://"] || [link hasPrefix:@"https://"])) {
            link = [@"http://" stringByAppendingString:link];
        }
        link = [link urlEncodeNormal];
        
        if ([ADOFavorite isExistsWithDataType:WKSyncDataTypeHome link:link uid:[WKSync shareWKSync].modelUser.uid withGuest:NO]) {
            [ViewIndicator showWarningWithStatus:@"首页导航已存在" duration:3];
        }
        else {
            [_delegate controllerAddWebsite:self title:_textFieldTitle.text link:link];
        }
    }
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
        
        _tableView.editing = NO;
    }
    else {
        _btnBookmark.enabled = YES;
        _btnHistory.enabled = NO;
        
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
        rc.size.height = 110;
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
        rc.size.height = 110;
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
    
    _textFieldTitle.text = model.title;
    _textFieldUrl.text = model.link;
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_textFieldTitle resignFirstResponder];
    [_textFieldUrl resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==_textFieldUrl && [textField.text stringByReplacingOccurrencesOfString:@" " withString:
                                     @""].length==0) {
        textField.text = @"http://";
    }
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==_textFieldTitle) {
        [_textFieldUrl becomeFirstResponder];
    }
    else if (textField==_textFieldUrl) {
        [self onTouchOK];
    }
    return YES;
}

@end
