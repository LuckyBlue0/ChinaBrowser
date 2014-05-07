//
//  ViewHome_ipad.m
//
//  Created by arBao on 8/23/13.
//  Copyright (c) 2013 arBao. All rights reserved.
//

#import "ViewHome_ipad.h"

#import "ViewIndicator.h"

#import "UIImageView+MYSDWebImage.h"

#import "ViewHomeSearch_ipad.h"
#import "ViewHomeItem_ipad.h"

#import "ModelUrl_ipad.h"
#import "ADOFavorite.h"

#import "WKSync.h"

#define ItemW 200
#define ItemH 120
#define SpaceX 10
#define SpaceY 10
#define PaddingY 10

#define kIconCustom @"wed-bt-11"
#define kIconAddBtn @"wed-add-bai"

@interface ViewHome_ipad () {
    NSMutableArray *_arrItemViews;
    NSMutableArray *_arrItemModels;
    NSInteger _countSysItems;
    
    UIView *_viewMask;
    ViewHomeItem_ipad *_itemAddBtn;
}

@end

@implementation ViewHome_ipad

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];

    // 搜索选项卡
    CGRect rc = CGRectMake(0, 20, 550, 78);
    rc.origin.x = (self.bounds.size.width-rc.size.width)*0.5;
    _viewHomeSearch = [[ViewHomeSearch_ipad alloc] initWithFrame:rc];
    [self addSubview:_viewHomeSearch];
    
    //_viewMask
    _viewMask = [[UIView alloc] initWithFrame:self.bounds];
    _viewMask.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _viewMask.backgroundColor = [UIColor clearColor];
    [_viewMask setHidden:YES];
    [self addSubview:_viewMask];
}

- (void)hideKeyboard {
    [_viewHomeSearch hideKeyboard];
}

#pragma mark - notif
- (void)whenDeviceDidRotate {
    [UIView animateWithDuration:0.25 animations:^{
        [self fixSubviews];
        
        if (!_arrItemViews) {
            _arrItemViews = [[NSMutableArray alloc] init];
            _arrItemModels = [[NSMutableArray alloc] init];

            [self loadSiteItems];
        }
        
        [self resizeSiteItems];
    }];
}

- (void)whenLangChanged {

}

- (void)whenDayModeChanged {
    BOOL dayMode = isDayMode;
    
    for (NSInteger index=0; index<_arrItemViews.count; index++) {
        ViewHomeItem_ipad *homeItem = [_arrItemViews objectAtIndex:index];
        ModelUrl_ipad *model = [_arrItemModels objectAtIndex:index];
        if (homeItem == _itemAddBtn
            || [kIconCustom compare:model.icon] == NSOrderedSame) {
            continue;
        }
        
        homeItem.imageView.image = BundlePngImageForHome([model.icon stringByAppendingString:(dayMode?@"-0":@"-1")]);
    }
}

#pragma mark - private methods
- (void)setEditing:(BOOL)editing {
    if (_editing==editing || !_countSysItems) {
        return;
    }
    _editing = editing;
    
    for (NSInteger idx=_countSysItems; idx<_arrItemViews.count-1; idx++) {
        ViewHomeItem_ipad *homeItem = [_arrItemViews objectAtIndex:idx];
        homeItem.shaking = editing;
    }
}

// 快捷链接列表
- (void)loadSiteItems {
    _itemAddBtn = nil;
    [_svSites.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_arrItemViews removeAllObjects];
    [_arrItemModels removeAllObjects];
    
    NSMutableArray *arrSites = [NSMutableArray arrayWithArray:[AppManager homeSites]];
    _countSysItems = arrSites.count;
    for (NSInteger idx=0; idx<_countSysItems; idx++) {
        NSDictionary *dicModel = [arrSites objectAtIndex:idx];
        if (![dicModel isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        ModelUrl_ipad *model = [ModelUrl_ipad modelWithDic:dicModel];
        [self addItem:model type:HomeSiteTypeDefault];
    }
    
    NSArray *arrCustom = [ADOFavorite queryWityUid:[WKSync shareWKSync].modelUser.uid dataType:WKSyncDataTypeHome withGuest:NO];
    for (ModelFavorite *modelFav in arrCustom) {
        ModelUrl_ipad *model = [ModelUrl_ipad model];
        model.title = modelFav.title;
        model.link = modelFav.link;
        [self addItem:model type:HomeSiteTypeCustom];
    }
    // _itemAddBtn model
    ModelUrl_ipad *model = [ModelUrl_ipad model];
    model.icon = kIconAddBtn;
    [self addItem:model type:HomeSiteTypeAddBtn];
}

- (void)fixSubviews {
    BOOL portrait = ([RotateManager_ipad screenOrientation] == ScreenOrientationPortrait);
    CGRect rc = _svSites.frame;
    rc.size = CGSizeMake(portrait?620:830, portrait?660:400);
    rc.origin.x = (self.bounds.size.width-rc.size.width)*0.5;
    _svSites.frame = rc;
}

- (NSInteger)getColCount {
    return isPortrait?3:4;
}

- (void)addItem:(ModelUrl_ipad *)model type:(HomeSiteType)type {
    NSInteger colCount = [self getColCount];
    CGFloat totalRowWidth = colCount*ItemW+MAX(0, colCount-1)*SpaceX;
    CGFloat paddingX = floorf((_svSites.bounds.size.width-totalRowWidth)*0.5);
    NSInteger itemIdx = _arrItemViews.count;
    NSInteger col = itemIdx%colCount;
    NSInteger row = itemIdx/colCount;
    CGRect rc = CGRectMake(0, 0, ItemW, ItemH);
    rc.origin.x = paddingX+(ItemW+SpaceX)*col;
    rc.origin.y = PaddingY+(ItemH+SpaceY)*row;

    ViewHomeItem_ipad *viewHomeItem = [[ViewHomeItem_ipad alloc] initWithFrame:rc];
    viewHomeItem.tag = itemIdx;
    viewHomeItem.lbTitle.text = model.title;
    if (!model.icon) {
        model.icon = kIconCustom;
    }
    if (type != HomeSiteTypeDefault) {
        viewHomeItem.imageView.image = BundlePngImageForHome(model.icon);
    }
    [viewHomeItem addTarget:self action:@selector(onTouchItem:) forControlEvents:UIControlEventTouchUpInside];
    switch (type) {
        case HomeSiteTypeCustom:
        {
            UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressItem:)];
            [viewHomeItem addGestureRecognizer:longPressGes];
            
            viewHomeItem.btnClose.tag = itemIdx;
            [viewHomeItem.btnClose addTarget:self action:@selector(onTouchBtnClose:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case HomeSiteTypeAddBtn:
        {
            _itemAddBtn = viewHomeItem;
        }
            break;
            
        default: // HomeSiteTypeDefault
            break;
    }
    
    [_svSites addSubview:viewHomeItem];
    [_arrItemViews addObject:viewHomeItem];
    [_arrItemModels addObject:model];
    
    _svSites.contentSize = CGSizeMake(_svSites.bounds.size.width, rc.origin.y+rc.size.height+PaddingY*2);
}

- (void)addCustomItem:(ModelUrl_ipad *)model {
    [self addItem:model type:HomeSiteTypeCustom];
    
    ViewHomeItem_ipad *lastItem = [_arrItemViews lastObject];
    lastItem.tag = lastItem.btnClose.tag = _itemAddBtn.tag;
    _itemAddBtn.tag = _arrItemViews.count-1;
    CGRect rc = lastItem.frame;
    lastItem.frame = _itemAddBtn.frame;
    _itemAddBtn.frame = rc;
    
    [_arrItemViews removeLastObject];
    [_arrItemViews insertObject:lastItem atIndex:lastItem.tag];
    
    ModelUrl_ipad *lastModel = [_arrItemModels lastObject];
    [_arrItemModels removeLastObject];
    [_arrItemModels insertObject:lastModel atIndex:lastItem.tag];
}

- (void)resizeSiteItems {
    if (_arrItemViews.count == 0) {
        return;
    }
    
    CGRect rc = CGRectZero;
    NSInteger colCount = [self getColCount];
    CGFloat totalRowWidth = colCount*ItemW+MAX(0, colCount-1)*SpaceX;
    CGFloat paddingX = floorf((_svSites.bounds.size.width-totalRowWidth)*0.5);
    for (NSInteger index=0; index<_arrItemViews.count; index++) {
        ViewHomeItem_ipad *homeItem = [_arrItemViews objectAtIndex:index];
        homeItem.tag = homeItem.btnClose.tag = index;
        rc = homeItem.frame;
        NSInteger col = index%colCount;
        NSInteger row = index/colCount;
        rc.origin.x = paddingX+(ItemW+SpaceX)*col;
        rc.origin.y = PaddingY+(ItemH+SpaceY)*row;
        homeItem.frame = rc;
    }

    rc = ((ViewHomeItem_ipad *)[_arrItemViews lastObject]).frame;
    _svSites.contentSize = CGSizeMake(_svSites.bounds.size.width, rc.origin.y+rc.size.height+PaddingY*2);
}

#pragma mark - buttons action
- (void)onTouchItem:(ViewHomeItem_ipad *)viewItem {
    if ([viewItem isKindOfClass:[ViewHomeItem_ipad class]]) {
        if (viewItem == _itemAddBtn) { // 添加项
            [UIView animateWithDuration:0.1 animations:^{
                _itemAddBtn.transform = CGAffineTransformMakeScale(1.05, 1.05);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    _itemAddBtn.transform = CGAffineTransformMakeScale(1, 1);
                } completion:^(BOOL finished) {
                    if ([_objDelegate respondsToSelector:@selector(viewHomeWillAdd:)]) {
                        [_objDelegate viewHomeWillAdd:self];
                    }
                }];
            }];
            
            return;
        }
        
        [viewItem animWithDuration:0.3];
        
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if ([_objDelegate respondsToSelector:@selector(viewHome:modelUrl:)]) {
                ModelUrl_ipad *model = [_arrItemModels objectAtIndex:[_arrItemViews indexOfObject:viewItem]];
                [_objDelegate viewHome:self modelUrl:model];
            }
        });
    }
}

- (void)onTouchBtnClose:(UIButton *)btn {
    ViewHomeItem_ipad *customItem = [_arrItemViews objectAtIndex:btn.tag];
    ModelUrl_ipad *model = [_arrItemModels objectAtIndex:btn.tag];
    if ([ADOFavorite deleteWithDataType:WKSyncDataTypeHome link:model.link uid:[WKSync shareWKSync].modelUser.uid]) {
        [UIView animateWithDuration:0.25
                         animations:^{
                             customItem.alpha = 0.3;
                             customItem.transform = CGAffineTransformMakeScale(0.3, 0.3);
                         }
                         completion:^(BOOL finished) {
                             [customItem removeFromSuperview];
                             [_arrItemViews removeObject:customItem];
                             [_arrItemModels removeObject:model];
                             [UIView animateWithDuration:0.25 animations:^{
                                 [self resizeSiteItems];
                             }];
                         }
         ];
    }
}

- (void)longPressItem:(UILongPressGestureRecognizer *)longPress {
    if(!_editing) {
        if(longPress.state == UIGestureRecognizerStateBegan) {
            self.editing = YES;
        }
    }
}

@end
