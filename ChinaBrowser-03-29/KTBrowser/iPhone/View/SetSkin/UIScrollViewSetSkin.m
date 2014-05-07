//
//  UIScrollViewSetSkin.m
//  ChinaBrowser
//
//  Created by David on 14-3-17.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIScrollViewSetSkin.h"

#import "ADOSkin.h"
#import "ViewIndicator.h"

@interface UIScrollViewSetSkin ()

- (void)createAddtionButton;
- (NSInteger)getColCount;
- (void)resizeItem;

- (void)tapGesture:(UITapGestureRecognizer *)gesture;
- (void)longPressGesture:(UILongPressGestureRecognizer *)gesture;
- (void)onTouchDel:(UIButton *)btnDel;

@end

@implementation UIScrollViewSetSkin

- (void)setEdit:(BOOL)edit
{
    if (_arrViewItem.count==0 && edit) {
        return;
    }
    _edit = edit;
    for (NSInteger i=_sysItemCount; i<_arrViewItem.count; i++) {
        UIViewSetSkinItem *item = _arrViewItem[i];
        item.edit = _edit;
    }
    [UIView animateWithDuration:0.3 animations:^{
        _viewSetSkinItemAdd.alpha = _edit?0:1;
    }];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _arrViewItem = [NSMutableArray array];
        _arrSkin = [NSMutableArray array];
        
        [self createAddtionButton];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _arrViewItem = [NSMutableArray array];
    _arrSkin = [NSMutableArray array];
    
    [self createAddtionButton];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (_viewSetSkinItemAdd) {
        [self resizeItem];
    }
    
    [self setNeedsDisplay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - private method 
// --------------------------------- private
- (void)createAddtionButton
{
    self.itemW = 75;
    self.itemH = 130;
    self.minPaddingLR = 10;
    self.paddingTB = 20;
    self.spaceX = 25;
    self.spaceY = 20;
    
    _viewSetSkinItemAdd = [UIViewSetSkinItem viewSetSkinItemFromXib];
    _viewSetSkinItemAdd.imageView.image = [UIImage imageWithFilename:@"SetSkin.bundle/bg_pifu_0.png"];
    _viewSetSkinItemAdd.labelTitle.text = @"添加";
    NSInteger colCount = [self getColCount];
    CGFloat paddingLR = (self.bounds.size.width-(colCount-1)*_spaceX-colCount*_itemW)/2;
    
    CGRect rc = CGRectMake(paddingLR, _paddingTB, _itemW, _itemH);
    _viewSetSkinItemAdd.frame = CGRectIntegral(rc);
    
    [self addSubview:_viewSetSkinItemAdd];
    
    // 添加事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [_viewSetSkinItemAdd addGestureRecognizer:tap];
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
    [arrItem addObject:_viewSetSkinItemAdd];
    NSInteger itemCount = arrItem.count;
    
    for (NSInteger i=0; i<itemCount; i++) {
        NSInteger col = GetColWithIndexCol(i, colCount);
        NSInteger row = GetRowWithIndexCol(i, colCount);
        CGRect rc = CGRectMake(paddingLR+(_itemW+_spaceX)*col,
                               _paddingTB+(_itemH+_spaceY)*row,
                               _itemW,
                               _itemH);
        UIViewSetSkinItem *viewSetSkinItem = arrItem[i];
        viewSetSkinItem.frame = CGRectIntegral(rc);
    }
    
    UIViewSetSkinItem *viewSetSkinItem = [arrItem lastObject];
    self.contentSize = CGSizeMake(self.bounds.size.width, viewSetSkinItem.frame.origin.y+viewSetSkinItem.bounds.size.height+_paddingTB);
}

- (void)tapGesture:(UITapGestureRecognizer *)gesture
{
    if (UIGestureRecognizerStateRecognized==gesture.state) {
        UIViewSetSkinItem *viewSetSkinItem = (UIViewSetSkinItem *)gesture.view;
        if (_edit) {
            self.edit = NO;
        }
        else {
            if (viewSetSkinItem==_viewSetSkinItemAdd) {
                // TODO:添加操作
                [_delegateSetSkin scrollViewSetSkinWillAddSkin:self];
            }
            else {
                // 点击皮肤
                for (UIViewSetSkinItem *viewSetSkinItemEach in _arrViewItem) {
                    BOOL selected = viewSetSkinItem==viewSetSkinItemEach;
                    viewSetSkinItemEach.selected = selected;
                }
                
                ModelSkin *model = _arrSkin[[_arrViewItem indexOfObject:viewSetSkinItem]];
                [_delegateSetSkin scrollViewSetSkin:self selectSkinImagePath:model.imagePath];
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
    }
}

- (void)onTouchDel:(UIButton *)btnDel
{
    [self removeItemAtIndex:btnDel.tag];
}

#pragma mark - public methods
// --------------------------------- public
- (void)addItemWithModel:(ModelSkin *)model
{
    UIViewSetSkinItem *viewSetSkinItem = [UIViewSetSkinItem viewSetSkinItemFromXib];
    
    [_arrSkin addObject:model];
    [_arrViewItem addObject:viewSetSkinItem];
    [self addSubview:viewSetSkinItem];
    
    [viewSetSkinItem.btnDel addTarget:self action:@selector(onTouchDel:) forControlEvents:UIControlEventTouchUpInside];
    viewSetSkinItem.imageView.image = [UIImage imageWithContentsOfFile:model.thumbPath];
    viewSetSkinItem.labelTitle.text = model.name;
    
    viewSetSkinItem.frame = _viewSetSkinItemAdd.frame;
    viewSetSkinItem.transform = CGAffineTransformMakeScale(0, 0);
    viewSetSkinItem.alpha = 0.2;
    
    NSInteger colCount = [self getColCount];
    CGFloat paddingLR = (self.bounds.size.width-(colCount-1)*_spaceX-colCount*_itemW)/2;
    NSInteger index = _arrViewItem.count;
    NSInteger col = GetColWithIndexCol(index, colCount);
    NSInteger row = GetRowWithIndexCol(index, colCount);
    CGRect rc = CGRectMake(paddingLR+(_itemW+_spaceX)*col, _paddingTB+(_itemH+_spaceY)*row, _itemW, _itemH);
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _viewSetSkinItemAdd.frame = CGRectIntegral(rc);
        viewSetSkinItem.alpha = 1;
        viewSetSkinItem.transform = CGAffineTransformIdentity;
        
        self.contentSize = CGSizeMake(self.bounds.size.width, _viewSetSkinItemAdd.frame.origin.y+_viewSetSkinItemAdd.bounds.size.height+_paddingTB);
    } completion:^(BOOL finished) {
        
    }];
    
    // 添加事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [viewSetSkinItem addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    [viewSetSkinItem addGestureRecognizer:longPress];
    
    [viewSetSkinItem.btnDel addTarget:self action:@selector(onTouchDel:) forControlEvents:UIControlEventTouchUpInside];
    viewSetSkinItem.btnDel.tag = viewSetSkinItem.tag = _arrViewItem.count-1;
    
    // 是否是当前的皮肤
    if ([[AppConfig config].skinImagePath isEqualToString:model.imagePath]) {
        viewSetSkinItem.selected = YES;
    }
}

- (void)removeItemAtIndex:(NSInteger)index
{
    ModelSkin *model = _arrSkin[index];
    
    if ([model.imagePath isEqualToString:[AppConfig config].skinImagePath]) {
        [ViewIndicator showWarningWithStatus:@"不能删除当前皮肤哦~" duration:1];
        return;
    }
    
    if (![ADOSkin deleteWithSid:model.sid]) {
        return;
    }
    UIViewSetSkinItem *viewIconWebItemWillRemove = _arrViewItem[index];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _viewSetSkinItemAdd.frame = [(UIViewSetSkinItem *)[_arrViewItem lastObject] frame];
        for (NSInteger i=_arrViewItem.count-1; i>index; i--) {
            NSInteger prevIndex = i-1;
            UIViewSetSkinItem *viewIconWebItemCurr = _arrViewItem[i];
            UIViewSetSkinItem *viewIconWebItemPrev = _arrViewItem[prevIndex];
            viewIconWebItemCurr.frame = viewIconWebItemPrev.frame;
            viewIconWebItemCurr.tag = viewIconWebItemCurr.btnDel.tag = prevIndex;
        }
        
        self.contentSize = CGSizeMake(self.bounds.size.width, _viewSetSkinItemAdd.frame.origin.y+_viewSetSkinItemAdd.bounds.size.height+_paddingTB);
        
        viewIconWebItemWillRemove.transform = CGAffineTransformMakeScale(0, 0);
        viewIconWebItemWillRemove.alpha = 0;
        
        [viewIconWebItemWillRemove.btnDel removeFromSuperview];
        [_arrViewItem removeObject:viewIconWebItemWillRemove];
        [_arrSkin removeObjectAtIndex:index];
    } completion:^(BOOL finished) {
        [viewIconWebItemWillRemove removeFromSuperview];
        if (_arrViewItem.count==_sysItemCount) {
            self.edit = NO;
//            [_delegateIconSite scrollViewIconSite:self iconSiteEvent:IconSiteEventEndEdit];
        }
    }];
}

- (void)removeItem:(UIViewSetSkinItem *)viewSetSkinItem
{
    [self removeItemAtIndex:[_arrViewItem indexOfObject:viewSetSkinItem]];
}

- (void)removeAll
{
    if (_arrViewItem.count>0) {
        CGRect rcFirst = [(UIView *)_arrViewItem[0] frame];
        [UIView animateWithDuration:0.3 animations:^{
            for (UIViewSetSkinItem *viewItem in _arrViewItem) {
                viewItem.transform = CGAffineTransformMakeScale(0, 0);
            }
            _viewSetSkinItemAdd.frame = rcFirst;
            
        } completion:^(BOOL finished) {
            // 从视图中移除
            [_arrViewItem makeObjectsPerformSelector:@selector(removeFromSuperview)];
            self.contentSize = CGSizeMake(self.bounds.size.width, _viewSetSkinItemAdd.frame.origin.y+_viewSetSkinItemAdd.bounds.size.height+_paddingTB);
        }];
        
        [_arrViewItem removeAllObjects];
        [_arrSkin removeAllObjects];
    }
}

- (void)setArrSkin:(NSArray *)arrSkin
{
    _sysItemCount = arrSkin.count;
    for (ModelSkin *model in arrSkin) {
        [self addItemWithModel:model];
    }
}

- (void)appendArrSkin:(NSArray *)arrSkin
{
    for (ModelSkin *model in arrSkin) {
        [self addItemWithModel:model];
    }
}

@end
