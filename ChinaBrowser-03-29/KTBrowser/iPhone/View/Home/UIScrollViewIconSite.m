//
//  UIScrollViewIconSite.m
//  KTBrowser
//
//  Created by David on 14-2-19.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIScrollViewIconSite.h"

#import <QuartzCore/QuartzCore.h>
#import <AGCommon/UIImage+Common.h>
#import "ADOFavorite.h"

@interface UIScrollViewIconSite ()

- (void)createAddtionButton;
- (NSInteger)getColCount;
- (void)resizeItem;

- (void)tapGesture:(UITapGestureRecognizer *)gesture;
- (void)longPressGesture:(UILongPressGestureRecognizer *)gesture;
- (void)onTouchDel:(UIButton *)btnDel;

- (void)updateUIMode;

@end

@implementation UIScrollViewIconSite

- (void)setEdit:(BOOL)edit
{
    if (_arrViewItem.count==0 && edit) {
        return;
    }
    _edit = edit;
    for (NSInteger i=_sysItemCount; i<_arrViewItem.count; i++) {
        UIViewIconWebItem *item = _arrViewItem[i];
        item.edit = _edit;
    }
    [UIView animateWithDuration:0.3 animations:^{
        _viewIconWebItemAdd.alpha = _edit?0:1;
    }];
    
    ((UIScrollView *)self.superview).scrollEnabled = !_edit;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _arrViewItem = [NSMutableArray array];
        _arrSite = [NSMutableArray array];
        
        _arrViewItem = [NSMutableArray array];
        [self createAddtionButton];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _arrViewItem = [NSMutableArray array];
    _arrSite = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUIMode) name:KTNotificationUpdateUIMode object:nil];
    
    [self createAddtionButton];
    
    [self updateUIMode];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (_viewIconWebItemAdd) {
        [self resizeItem];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - private
- (void)createAddtionButton
{
    self.itemW = 50;
    self.itemH = 75;
    self.minPaddingLR = 10;
    self.paddingTB = 20;
    self.spaceX = 25;
    self.spaceY = 20;
    
    _viewIconWebItemAdd = [UIViewIconWebItem viewIconWebItemFromXib];
//    _viewIconWebItemAdd.labelTitle.text = @"添加";
    NSInteger colCount = [self getColCount];
    CGFloat paddingLR = (self.bounds.size.width-(colCount-1)*_spaceX-colCount*_itemW)/2;
    
    CGRect rc = CGRectMake(paddingLR, _paddingTB, _itemW, _itemH);
    _viewIconWebItemAdd.frame = CGRectIntegral(rc);
    
    [self addSubview:_viewIconWebItemAdd];
    
    // 添加事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [_viewIconWebItemAdd addGestureRecognizer:tap];
    
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
//    [_viewIconWebItemAdd addGestureRecognizer:longPress];
}

- (NSInteger)getColCount {
    CGFloat w = _minPaddingLR+_itemW;
    NSInteger colCount = 0;
    while (w+_minPaddingLR<=self.bounds.size.width) {
        colCount++;
        w+=_itemW+_spaceX;
    }
    return colCount;
}

- (void)resizeItem
{
    NSInteger colCount = [self getColCount];
    CGFloat paddingLR = (self.bounds.size.width-(colCount-1)*_spaceX-colCount*_itemW)/2;
    
    NSMutableArray *arrItem = [NSMutableArray arrayWithArray:_arrViewItem];
    [arrItem addObject:_viewIconWebItemAdd];
    NSInteger itemCount = arrItem.count;
    
    for (NSInteger i=0; i<itemCount; i++) {
        NSInteger col = GetColWithIndexCol(i, colCount);
        NSInteger row = GetRowWithIndexCol(i, colCount);
        CGRect rc = CGRectMake(paddingLR+(_itemW+_spaceX)*col,
                               _paddingTB+(_itemH+_spaceY)*row,
                               _itemW,
                               _itemH);
        UIViewIconWebItem *viewIconWebItem = arrItem[i];
        viewIconWebItem.frame = CGRectIntegral(rc);
    }
    
    UIViewIconWebItem *viewIconWebItem = [arrItem lastObject];
    self.contentSize = CGSizeMake(self.bounds.size.width, viewIconWebItem.frame.origin.y+viewIconWebItem.bounds.size.height+_paddingTB);
}

- (void)tapGesture:(UITapGestureRecognizer *)gesture
{
    if (UIGestureRecognizerStateRecognized==gesture.state) {
        UIViewIconWebItem *viewIconWebItem = (UIViewIconWebItem *)gesture.view;
        if (_edit) {
            self.edit = NO;
            [_delegateIconSite scrollViewIconSite:self iconSiteEvent:IconSiteEventEndEdit];
        }
        else {
            if (viewIconWebItem==_viewIconWebItemAdd) {
//                ModelFavorite *model = [ModelFavorite modelFavorite];
//                [self addIconWebWithModel:model];
                [_delegateIconSite scrollViewIconSite:self iconSiteEvent:IconSiteEventAdd];
            }
            else {
                UIView *viewTarget = [AppConfig config].rootController.view;
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:[viewIconWebItem convertRect:viewIconWebItem.bounds toView:viewTarget]];
                imageView.image = [UIImage imageFromView:viewIconWebItem];
                [viewTarget addSubview:imageView];
                imageView.alpha = 0.9;
                [UIView animateWithDuration:0.5 animations:^{
                    imageView.transform = CGAffineTransformMakeScale(2, 2);
                    imageView.alpha = 0;
                } completion:^(BOOL finished) {
                    [imageView removeFromSuperview];
                }];
                
                ModelFavorite *model = _arrSite[[_arrViewItem indexOfObject:gesture.view]];
                [_delegateIconSite scrollViewIconSite:self reqLink:model.link action:ReqLinkActionOpenInSelf];
            }
        }
    }
}

- (void)longPressGesture:(UILongPressGestureRecognizer *)gesture
{
    if (UIGestureRecognizerStateBegan==gesture.state) {
        if (_arrViewItem.count<=_sysItemCount) {
            return;
        }
        self.edit = !_edit;
        [_delegateIconSite scrollViewIconSite:self iconSiteEvent:self.edit?IconSiteEventBeginEdit:IconSiteEventEndEdit];
    }
}

- (void)onTouchDel:(UIButton *)btnDel
{
    [self removeItemAtIndex:btnDel.tag];
}

- (void)updateUIMode
{
    _viewIconWebItemAdd.imageViewIcon.image = [UIImage imageWithFilename:[NSString stringWithFormat:@"home_default.bundle/bt-red-%@.png", [AppConfig config].uiMode==UIModeDay?@"bai":@"ye"]];
}

#pragma mark - public
- (void)addIconWebWithIcon:(UIImage *)image title:(NSString *)title
{
    UIViewIconWebItem *viewIconWebItem = [UIViewIconWebItem viewIconWebItemFromXib];
    viewIconWebItem.imageViewIcon.image = image?:[UIImage imageWithFilename:@"home_default.bundle/red-10.png"];
    viewIconWebItem.labelTitle.text = title?:[@(_arrViewItem.count+1) stringValue];
    [self addIconWeb:viewIconWebItem];
}

- (void)addIconWebWithModel:(ModelFavorite *)model
{
    UIViewIconWebItem *viewIconWebItem = [UIViewIconWebItem viewIconWebItemFromXib];
    viewIconWebItem.imageViewIcon.image = [UIImage imageWithFilename:@"home_default.bundle/red-10.png"];
    viewIconWebItem.labelTitle.text = model.title;
    
    [_arrSite addObject:model];
    [self addIconWeb:viewIconWebItem];
}

- (void)addIconWeb:(UIViewIconWebItem *)viewIconWebItem
{
    [_arrViewItem addObject:viewIconWebItem];
    [self addSubview:viewIconWebItem];
    
    viewIconWebItem.frame = _viewIconWebItemAdd.frame;
    viewIconWebItem.transform = CGAffineTransformMakeScale(0, 0);
    viewIconWebItem.alpha = 0.2;
    
    NSInteger colCount = [self getColCount];
    CGFloat paddingLR = (self.bounds.size.width-(colCount-1)*_spaceX-colCount*_itemW)/2;
    NSInteger index = _arrViewItem.count;
    NSInteger col = GetColWithIndexCol(index, colCount);
    NSInteger row = GetRowWithIndexCol(index, colCount);
    CGRect rc = CGRectMake(paddingLR+(_itemW+_spaceX)*col, _paddingTB+(_itemH+_spaceY)*row, _itemW, _itemH);
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _viewIconWebItemAdd.frame = CGRectIntegral(rc);
        viewIconWebItem.alpha = 1;
        viewIconWebItem.transform = CGAffineTransformIdentity;
        
        self.contentSize = CGSizeMake(self.bounds.size.width, _viewIconWebItemAdd.frame.origin.y+_viewIconWebItemAdd.bounds.size.height+_paddingTB);
    } completion:^(BOOL finished) {
        
    }];
    
    // 添加事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [viewIconWebItem addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    [viewIconWebItem addGestureRecognizer:longPress];
    
    [viewIconWebItem.btnDel addTarget:self action:@selector(onTouchDel:) forControlEvents:UIControlEventTouchUpInside];
    viewIconWebItem.btnDel.tag = viewIconWebItem.tag = _arrViewItem.count-1;
}

- (void)removeItemAtIndex:(NSInteger)index
{
    ModelFavorite *model = _arrSite[index];
    if (![ADOFavorite deleteWithFid:model.fid]) {
        return;
    }
    UIViewIconWebItem *viewIconWebItemWillRemove = _arrViewItem[index];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _viewIconWebItemAdd.frame = [(UIViewIconWebItem *)[_arrViewItem lastObject] frame];
        for (NSInteger i=_arrViewItem.count-1; i>index; i--) {
            NSInteger prevIndex = i-1;
            UIViewIconWebItem *viewIconWebItemCurr = _arrViewItem[i];
            UIViewIconWebItem *viewIconWebItemPrev = _arrViewItem[prevIndex];
            viewIconWebItemCurr.frame = viewIconWebItemPrev.frame;
            viewIconWebItemCurr.tag = viewIconWebItemCurr.btnDel.tag = prevIndex;
        }
        
        self.contentSize = CGSizeMake(self.bounds.size.width, _viewIconWebItemAdd.frame.origin.y+_viewIconWebItemAdd.bounds.size.height+_paddingTB);
        
        viewIconWebItemWillRemove.transform = CGAffineTransformMakeScale(0, 0);
        viewIconWebItemWillRemove.alpha = 0;
        
        [viewIconWebItemWillRemove.btnDel removeFromSuperview];
        [_arrViewItem removeObject:viewIconWebItemWillRemove];
        [_arrSite removeObjectAtIndex:index];
    } completion:^(BOOL finished) {
        [viewIconWebItemWillRemove removeFromSuperview];
        if (_arrViewItem.count==_sysItemCount) {
            self.edit = NO;
            [_delegateIconSite scrollViewIconSite:self iconSiteEvent:IconSiteEventEndEdit];
        }
    }];
}

- (void)removeItem:(UIViewIconWebItem *)viewIconWebItem
{
    [self removeItemAtIndex:[_arrViewItem indexOfObject:viewIconWebItem]];
}

- (void)removeAll
{
    if (_arrViewItem.count>0) {
        CGRect rcFirst = [(UIView *)_arrViewItem[0] frame];
        [UIView animateWithDuration:0.3 animations:^{
            for (UIViewIconWebItem *viewItem in _arrViewItem) {
                viewItem.transform = CGAffineTransformMakeScale(0, 0);
            }
            _viewIconWebItemAdd.frame = rcFirst;
            
        } completion:^(BOOL finished) {
            // 从视图中移除
            [_arrViewItem makeObjectsPerformSelector:@selector(removeFromSuperview)];
            self.contentSize = CGSizeMake(self.bounds.size.width, _viewIconWebItemAdd.frame.origin.y+_viewIconWebItemAdd.bounds.size.height+_paddingTB);
        }];
        
        [_arrViewItem removeAllObjects];
        [_arrSite removeAllObjects];
    }
}

- (void)setArrSite:(NSArray *)arrSite
{
    _sysItemCount = arrSite.count;
    for (NSDictionary *dicSite in arrSite) {
        ModelFavorite *model = [ModelFavorite modelFavorite];
        model.title = dicSite[@"name"];
        model.link = dicSite[@"link"];
        [_arrSite addObject:model];
        
        [self addIconWebWithIcon:[UIImage imageWithFilename:[NSString stringWithFormat:@"home_default.bundle/%@.png", dicSite[@"icon"]]] title:dicSite[@"name"]];
    }
}

- (void)appendArrSite:(NSArray *)arrSite
{
    for (NSInteger i=0; i<arrSite.count; i++) {
        ModelFavorite *model = arrSite[i];
        [self addIconWebWithModel:model];
    }
}

@end
