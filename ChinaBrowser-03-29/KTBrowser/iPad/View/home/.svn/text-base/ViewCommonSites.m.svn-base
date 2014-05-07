//
//  ViewCommonSites.m
//

#import "ViewCommonSites.h"

#import <QuartzCore/QuartzCore.h>

#import "UICellCateSite.h"
#import "CellHomeHis.h"
#import "UIViewHeader.h"
#import "BlockUI.h"
#import "ViewSiteItem.h"

#import "ADOFavorite.h"
#import "ModelFavorite.h"

#import "WKSync.h"

#define kHeaderItemHeight 80.0f
#define kWebItemHeight 60.0f
#define kWebItemColCount 4

@interface ViewCommonSites ()

- (void)onTouchHeader:(UIViewHeader *)viewHeader;

@end

@implementation ViewCommonSites

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(whenDayModeChanged) name:kNotifDayModeChanged object:nil];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    NSInteger page = self.contentOffset.x/self.bounds.size.width;
    
    self.contentSize = frame.size;
    self.contentOffset = CGPointMake(frame.size.width*page, 0);
    
    [self setNeedsDisplay];
}

- (void)whenDayModeChanged {
    BOOL dayMode = isDayMode;
    CGFloat colorVal = (dayMode?250:50);
    CGFloat selColorVal = (dayMode?239:60);
    UIColor *textColor = dayMode?kTextColorDay:kTextColorNight;
    for (NSInteger i=0; i<_arrViewHeader.count; i++) {
        UIViewHeader *viewHeader = _arrViewHeader[i];
        [viewHeader setColorNor:RGBA_COLOR(colorVal, colorVal, colorVal, 0.8)];
        [viewHeader setColorSelect:RGBA_COLOR(selColorVal, selColorVal, selColorVal, 1)];
        [viewHeader setColorHighlight:RGBA_COLOR(selColorVal, selColorVal, selColorVal, 1)];
        viewHeader.labelTitle.textColor = textColor;
        viewHeader.labelSubTitle.textColor = textColor;
    }
    
    UIColor *hColor = dayMode?RGB_COLOR(230, 230, 230):RGB_COLOR(70, 70, 70);
    _viewHeaderSites.highlightColor = hColor;
    _viewHeaderSites.backgroundColor = RGBA_COLOR(colorVal, colorVal, colorVal, 0.8);
    _viewExpandCell.highlightColor = hColor;
    _viewExpandCell.backgroundColor = RGBA_COLOR(colorVal, colorVal, colorVal, 0.6);
    [_viewHeaderSites setArrSite:_arrHeaderSite];
    [_tbSites reloadData];
}

- (void)setup {
    _currSectionIndex = -1;
    
    _arrViewHeader = [NSMutableArray array];
    _arrMostVisitedHistory = [NSMutableArray array];
    _arrCateSite = [NSArray arrayWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"home.bundle/home_cate_list.plist"]];
    _arrHeaderSite = [NSArray arrayWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"home.bundle/home_cate_header.plist"]];
    
    CGRect rc = self.bounds;
    rc.origin = CGPointMake(50, 30);
    rc.size.width -= rc.origin.x*2;
    rc.size.height -= rc.origin.y;
    _tbSites = [[UITableView alloc] initWithFrame:rc];
    _tbSites.delegate = self;
    _tbSites.dataSource = self;
    _tbSites.layer.cornerRadius = 5;
    _tbSites.backgroundView = nil;
    _tbSites.backgroundColor = [UIColor clearColor];
    _tbSites.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tbSites.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self addSubview:_tbSites];
    
    NSInteger row = ceilf(_arrHeaderSite.count/(CGFloat)kWebItemColCount);
    rc = _tbSites.bounds;
    rc.size.height = row*kHeaderItemHeight;
    _viewHeaderSites = [[ViewSiteContent alloc] initWithFrame:rc];
    _viewHeaderSites.objDelegate = self;
    _viewHeaderSites.numberOfCol = kWebItemColCount;
    _viewHeaderSites.borderWidth = 0.4;
    _viewHeaderSites.layer.cornerRadius = 5;
    _viewHeaderSites.borderColor = [UIColor colorWithWhite:0.7 alpha:1];
    _viewHeaderSites.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    rc.size.height += 20;
    UIView *viewHeader = [[UIView alloc] initWithFrame:rc];
    viewHeader.backgroundColor = [UIColor clearColor];
    [viewHeader addSubview:_viewHeaderSites];
    _tbSites.tableHeaderView = viewHeader;
    
    _viewExpandCell = [[ViewSiteContent alloc] initWithFrame:self.bounds];
    _viewExpandCell.tag = -1;
    _viewExpandCell.dashLine = YES;
    _viewExpandCell.objDelegate = self;
    _viewExpandCell.numberOfCol = kWebItemColCount;
    _viewExpandCell.borderWidth = 0.2;
    _viewExpandCell.borderColor = [UIColor colorWithWhite:0.7 alpha:1];
    _viewExpandCell.highlightColor = [UIColor colorWithWhite:0.8 alpha:0.7];
    _viewExpandCell.autoresizingMask = UIViewAutoresizingFlexibleWidth;
 
    UIViewHeader *firstViewHeader = nil;
    for (NSInteger i=0; i<_arrCateSite.count; i++) {
        NSDictionary *dicSection = _arrCateSite[i];
        UIViewHeader *viewHeader = [UIViewHeader viewHeaderFromXib];
        if (i == 0) {
            firstViewHeader = viewHeader;
            [viewHeader setViewCorner:UIRectCornerTopLeft|UIRectCornerTopRight];
        }
        else if (i==_arrCateSite.count-1) {
            [viewHeader setViewCorner:UIRectCornerBottomLeft|UIRectCornerBottomRight];
        }
        viewHeader.tag = i;
        viewHeader.labelTitle.text = dicSection[@"title"];
        viewHeader.labelSubTitle.text = dicSection[@"sub_title"];
        viewHeader.labelTitle.font = viewHeader.labelSubTitle.font = [UIFont systemFontOfSize:13];
        viewHeader.imageViewIcon.image = [UIImage imageWithFilename:[NSString stringWithFormat:@"home.bundle/%@.png", dicSection[@"icon"]]];
        viewHeader.imageViewAccessory.image =[UIImage imageWithFilename:@"home.bundle/bt-2.png"];
        [viewHeader addTarget:self action:@selector(onTouchHeader:) forControlEvents:UIControlEventTouchUpInside];
        
        [_arrViewHeader addObject:viewHeader];
    }
    [self whenDayModeChanged];
    
    double delayInSeconds = 0.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (isPortrait) {
            [self onTouchHeader:firstViewHeader];
        }
    });
}

- (void)onTouchHeader:(UIViewHeader *)viewHeader {
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
    
    if (viewHeader.tag==_arrCateSite.count-1) {
        [_arrMostVisitedHistory removeAllObjects];
        [_arrMostVisitedHistory addObjectsFromArray:[ADOFavorite queryMostVisitedCount:10 WityUid:[WKSync shareWKSync].modelUser.uid dataType:WKSyncDataTypeHistory withGuest:NO]];
    }
    
    _currSectionIndex = viewHeader.selected?viewHeader.tag:-1;
        [_tbSites reloadSections:[NSIndexSet indexSetWithIndex:viewHeader.tag] withRowAnimation:UITableViewRowAnimationFade];
    
    if (viewHeader.selected) {
        if ([_tbSites numberOfRowsInSection:_currSectionIndex]>0)
        [_tbSites scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_currSectionIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _arrCateSite.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 1;
    if (section==_arrCateSite.count-1) {
        count = _arrMostVisitedHistory.count;
    }
    else {
        count = 1;
    }
    
    return count;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL dayMode = isDayMode;
    UIColor *textColor = dayMode?kTextColorDay:kTextColorNight;
    
    UITableViewCell *cell = nil;
    if (indexPath.section==_arrCateSite.count-1) {
        CellHomeHis *cellHistory = (CellHomeHis *)[tableView dequeueReusableCellWithIdentifier:@"CellHomeHis"];
        if (!cellHistory) {
            cellHistory = [CellHomeHis cellHomeHisFromXib];
            cell.backgroundColor = [UIColor clearColor];
            cellHistory.accessoryType = UITableViewCellAccessoryNone;
            cellHistory.selectionStyle = UITableViewCellSelectionStyleDefault;
            cellHistory.imageViewIcon.image = [UIImage imageWithFilename:@"home.bundle/History_1.png"];
            cellHistory.imageViewArrow.image = [UIImage imageWithFilename:@"home.bundle/bt-2.png"];
        }
        
        ModelFavorite *model = _arrMostVisitedHistory[indexPath.row];
        cellHistory.labelTitle.text = model.title;
        cellHistory.labelLink.text = model.link;
        cellHistory.labelTitle.textColor = textColor;
        cellHistory.labelLink.textColor = textColor;
        
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==_currSectionIndex) {
        if (indexPath.section == _arrCateSite.count-1)
            return kWebItemHeight;
        else {
            CGRect rc = _viewExpandCell.frame;
            NSArray *arrSite = _arrCateSite[_currSectionIndex][@"item"];
            NSInteger row = ceilf(arrSite.count/(CGFloat)kWebItemColCount);
            rc.size.height = row*kWebItemHeight;
            rc.size.width = _tbSites.bounds.size.width;
            _viewExpandCell.frame = rc;
            
            return rc.size.height;
        }
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
    
    if (indexPath.section==_arrCateSite.count-1) {
        cell.backgroundColor = _viewExpandCell.backgroundColor;
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
        [_viewExpandCell setArrSite:arrSite];
        _viewExpandCell.tag = _currSectionIndex;
        [cell addSubview:_viewExpandCell];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kWebItemHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIViewHeader *viewHeader = _arrViewHeader[section];
    [viewHeader layoutSubviews];
    
    return viewHeader;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==_arrCateSite.count-1) {
        ModelFavorite *model = _arrMostVisitedHistory[indexPath.row];
        [_objDelegate viewCommonSites:self reqLink:model.link action:ReqLinkActionOpenInSelf];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - ViewSiteContentDelegate
- (void)viewSiteContent:(ViewSiteContent *)viewSiteContent didSelectItem:(ViewSiteItem *)viewSiteItem {
    NSDictionary *dicSite = nil;
    if (viewSiteContent == _viewHeaderSites) {
        dicSite = _arrHeaderSite[viewSiteItem.tag];
    }
    else if (_currSectionIndex >= 0) {
        NSDictionary *dicCateSite = _arrCateSite[_currSectionIndex];
        dicSite = dicCateSite[@"item"][viewSiteItem.tag];
    }
    [_objDelegate viewCommonSites:self reqLink:dicSite[@"link"] action:ReqLinkActionOpenInSelf];
}

@end
