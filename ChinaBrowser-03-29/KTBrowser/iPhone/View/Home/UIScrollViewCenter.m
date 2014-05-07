//
//  UIScrollViewCenter.m
//  KTBrowser
//
//  Created by David on 14-2-17.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIScrollViewCenter.h"

#import <QuartzCore/QuartzCore.h>

#import "UICellCateSite.h"
#import "UICellHistoryHome.h"
#import "UIViewHeader.h"
#import "BlockUI.h"
#import "UIViewCateSiteItem.h"

#import "ADOFavorite.h"
#import "ModelFavorite.h"

#import "WKSync.h"

#define kWebItemHeight 36.0f
#define kWebItemColCount 4

@interface UIScrollViewCenter ()

- (void)setup;

- (void)onTouchHeader:(UIViewHeader *)viewHeader;

@end

@implementation UIScrollViewCenter
{
    
}

- (void)setup
{
    _currSectionIndex = -1;
    
    _arrViewHeader = [NSMutableArray array];
    _arrMostVisitedHistory = [NSMutableArray array];
    _arrCateSite = [NSArray arrayWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"home.bundle/home_cate_list.plist"]];
    _arrHeaderSite = [NSArray arrayWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"home.bundle/home_cate_header.plist"]];
    _arrIconSite = [NSArray arrayWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"home_default.bundle/home_default.plist"]];
    
    NSInteger row = ceilf(_arrHeaderSite.count/(CGFloat)kWebItemColCount);
    CGRect rc = CGRectMake(0, 0, _tableViewCateSite.bounds.size.width, row*kWebItemHeight);
    
    _viewCateSiteContent = [[UIViewCateSiteContent alloc] initWithFrame:rc];
    _viewCateSiteContent.backgroundColor = [UIColor colorWithWhite:0.99 alpha:0.95];
    _viewCateSiteContent.delegate = self;
    _viewCateSiteContent.numberOfCol = kWebItemColCount;
    _viewCateSiteContent.borderColor = [UIColor colorWithWhite:0.7 alpha:1];
    _viewCateSiteContent.borderWidth = 0.4;
    _viewCateSiteContent.highlightColor = [UIColor colorWithWhite:0.8 alpha:0.7];
    _viewCateSiteContent.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    _viewCateSiteContentCell = [[UIViewCateSiteContent alloc] initWithFrame:rc];
    _viewCateSiteContentCell.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.5];
    _viewCateSiteContentCell.delegate = self;
    _viewCateSiteContentCell.numberOfCol = kWebItemColCount;
    _viewCateSiteContentCell.borderColor = [UIColor colorWithWhite:0.7 alpha:1];
    _viewCateSiteContentCell.borderWidth = 0.2;
    _viewCateSiteContentCell.dashLine = YES;
    _viewCateSiteContentCell.tag = -1;
    _viewCateSiteContentCell.highlightColor = [UIColor colorWithWhite:0.8 alpha:0.7];
    _viewCateSiteContentCell.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    rc.size.height += 10;
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:rc];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    tableHeaderView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
    [tableHeaderView addSubview:_viewCateSiteContent];
    
    _tableViewCateSite.tableHeaderView = tableHeaderView;
    _tableViewCateSite.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableViewCateSite.layer.cornerRadius =
    _viewCateSiteContent.layer.cornerRadius = 4;
    _tableViewCateSite.backgroundColor = [UIColor clearColor];
    _tableViewCateSite.backgroundView = nil;
    
    for (NSInteger i=0; i<_arrCateSite.count; i++) {
        NSDictionary *dicSection = _arrCateSite[i];
        UIViewHeader *viewHeader = [UIViewHeader viewHeaderFromXib];
        if (i==0) {
            [viewHeader setViewCorner:UIRectCornerTopLeft|UIRectCornerTopRight];
        }
        else if (i==_arrCateSite.count-1) {
            [viewHeader setViewCorner:UIRectCornerBottomLeft|UIRectCornerBottomRight];
        }
        viewHeader.labelTitle.text = dicSection[@"title"];
        viewHeader.labelSubTitle.text = dicSection[@"sub_title"];
        viewHeader.imageViewIcon.image = [UIImage imageWithFilename:[NSString stringWithFormat:@"home.bundle/%@.png", dicSection[@"icon"]]];
        viewHeader.imageViewAccessory.image =[UIImage imageWithFilename:@"home.bundle/bt-2.png"];
        viewHeader.labelTitle.textColor = [UIColor colorWithHexString:dicSection[@"color"]];
        viewHeader.tag = i;
        [viewHeader addTarget:self action:@selector(onTouchHeader:) forControlEvents:UIControlEventTouchUpInside];
        
        [_arrViewHeader addObject:viewHeader];
    }
    
    [_viewCateSiteContent setArrSite:_arrHeaderSite];

    [_tableViewCateSite reloadData];
    
    double delayInSeconds = 0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_scrollViewIconSite setArrSite:_arrIconSite];
        [_scrollViewIconSite appendArrSite:[ADOFavorite queryWityUid:[WKSync shareWKSync].modelUser.uid dataType:WKSyncDataTypeHome withGuest:NO]];
    });
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
        
        if (item.tag==_arrCateSite.count-1) {
            if (item.selected) {
                [item setViewCorner:0];
            }
            else {
                [item setViewCorner:UIRectCornerBottomLeft|UIRectCornerBottomRight];
            }
        }
    }];
    
    if (viewHeader.tag==_arrCateSite.count-1)
    {
        [_arrMostVisitedHistory removeAllObjects];
        [_arrMostVisitedHistory addObjectsFromArray:[ADOFavorite queryMostVisitedCount:10 WityUid:[WKSync shareWKSync].modelUser.uid dataType:WKSyncDataTypeHistory withGuest:NO]];
    }
    
    _currSectionIndex = viewHeader.selected?viewHeader.tag:-1;
        [_tableViewCateSite reloadSections:[NSIndexSet indexSetWithIndex:viewHeader.tag] withRowAnimation:UITableViewRowAnimationFade];
    
    if (viewHeader.selected) {
        if ([_tableViewCateSite numberOfRowsInSection:_currSectionIndex]>0)
        [_tableViewCateSite scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_currSectionIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    NSInteger page = self.contentOffset.x/self.bounds.size.width;
    
    [super setFrame:frame];
    
    if (!_scrollViewIconSite) {
        return;
    }
    NSInteger itemCount = self.subviews.count;
    for (NSInteger i=0; i<itemCount; i++) {
        UIView *viewItem = self.subviews[i];
        CGRect rc = CGRectInset(self.bounds, 10, 10);
        rc.origin.x = self.bounds.size.width*i+10;
        viewItem.frame = rc;
    }
    
    self.contentSize = CGSizeMake(frame.size.width*itemCount, frame.size.height);
    self.contentOffset = CGPointMake(frame.size.width*page, 0);
    
    [self setNeedsDisplay];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    [self.subviews[2] removeFromSuperview];
    
    NSInteger itemCount = self.subviews.count;
    for (NSInteger i=0; i<itemCount; i++) {
        UIView *viewItem = self.subviews[i];
        CGRect rc = CGRectInset(self.bounds, 10, 10);
        rc.origin.x += self.bounds.size.width*i;
        viewItem.frame = rc;
    }
    
    self.contentSize = CGSizeMake(self.bounds.size.width*itemCount, self.bounds.size.height);
    [self setup];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _arrCateSite.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 1;
    if (section==_arrCateSite.count-1)
    {
        count = _arrMostVisitedHistory.count;
    }
    else
    {
        count = 1;
    }
    return count;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section==_arrCateSite.count-1) {
        UICellHistoryHome *cellHistory = (UICellHistoryHome *)[tableView dequeueReusableCellWithIdentifier:@"UICellHistoryHome"];
        if (!cellHistory) {
            cellHistory = [UICellHistoryHome cellHistoryFromXib];
            cellHistory.accessoryType = UITableViewCellAccessoryNone;
            cellHistory.selectionStyle = UITableViewCellSelectionStyleDefault;
            cellHistory.imageViewIcon.image = [UIImage imageWithFilename:@"home.bundle/History_1.png"];
            cellHistory.imageViewArrow.image = [UIImage imageWithFilename:@"home.bundle/bt-2.png"];
        }
        
        ModelFavorite *model = _arrMostVisitedHistory[indexPath.row];
        cellHistory.labelTitle.text = model.title;
        cellHistory.labelLink.text = model.link;
        
        cell = cellHistory;
    }
    else {
        UICellCateSite *cellCateSite = (UICellCateSite *)[tableView dequeueReusableCellWithIdentifier:@"UICellCateSite"];
        if (!cellCateSite) {
            cellCateSite = [UICellCateSite cellCateSiteFromXib];
            cellCateSite.accessoryType = UITableViewCellAccessoryNone;
            cellCateSite.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell = cellCateSite;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==_currSectionIndex) {
        if (indexPath.section==_arrCateSite.count-1)
            return 40;
        else {
            CGRect rc = _viewCateSiteContentCell.frame;
            NSArray *arrSite = _arrCateSite[_currSectionIndex][@"item"];
            NSInteger row = ceilf(arrSite.count/(CGFloat)kWebItemColCount);
            rc.size.height = row*kWebItemHeight;
            rc.size.width = _tableViewCateSite.bounds.size.width;
            _viewCateSiteContentCell.frame = rc;
            return rc.size.height;
        }
    }
    else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithWhite:0.97 alpha:0];
    
    if (indexPath.section==_arrCateSite.count-1) {
        cell.backgroundColor = _viewCateSiteContentCell.backgroundColor;
        [cell setNeedsDisplay];
        if (_currSectionIndex==indexPath.section) {
            cell.contentView.alpha = 1;
        }
        else {
            cell.contentView.alpha = 0;
        }
    }
    else if (indexPath.section==_currSectionIndex) {
        NSArray *arrSite = _arrCateSite[_currSectionIndex][@"item"];
        [_viewCateSiteContentCell setArrSite:arrSite];
        _viewCateSiteContentCell.tag = _currSectionIndex;
        [cell addSubview:_viewCateSiteContentCell];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIViewHeader *viewHeader = _arrViewHeader[section];
    [viewHeader layoutSubviews];
    return viewHeader;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==_arrCateSite.count-1) {
        ModelFavorite *model = _arrMostVisitedHistory[indexPath.row];
        [_delegateCenter scrollViewCenter:self reqLink:model.link action:ReqLinkActionOpenInSelf];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - UIViewCateSiteContentDelegate
- (void)viewCateSiteContent:(UIViewCateSiteContent *)viewCateSiteContent didSelectItem:(UIViewCateSiteItem *)viewCateSiteItem
{
    if (viewCateSiteContent==_viewCateSiteContent) {
        NSDictionary *dicSite = _arrHeaderSite[viewCateSiteItem.tag];
        // table header
        [_delegateCenter scrollViewCenter:self reqLink:dicSite[@"link"] action:ReqLinkActionOpenInSelf];
    }
    else if (_currSectionIndex>=0) {
        NSDictionary *dicCateSite = _arrCateSite[_currSectionIndex];
        NSDictionary *dicSite = dicCateSite[@"item"][viewCateSiteItem.tag];
        [_delegateCenter scrollViewCenter:self reqLink:dicSite[@"link"] action:ReqLinkActionOpenInSelf];
    }
}

@end
