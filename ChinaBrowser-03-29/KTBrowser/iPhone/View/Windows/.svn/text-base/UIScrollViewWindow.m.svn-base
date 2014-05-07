//
//  UIScrollViewWindow.m
//  ChinaBrowser
//
//  Created by David on 14-3-20.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIScrollViewWindow.h"

@interface UIScrollViewWindow ()

- (void)onTouchViewWindowItem:(UIControl *)viewWindowItem;
- (void)onTouchViewWindowItemBtnDel:(UIButton *)btn;

- (void)resizeItem;

@end

@implementation UIScrollViewWindow

- (void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    for (NSInteger i=0; i<_arrScrollViewWindowItem.count; i++) {
        UIScrollViewWindowItem *item = _arrScrollViewWindowItem[i];
        item.selected = i==selectIndex;
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)resizeItem
{
    BOOL isLandscape = self.frame.size.width>self.frame.size.height;
    
    if (isLandscape) {
        // 横屏，横向布局
        self.alwaysBounceVertical = NO;
        self.alwaysBounceHorizontal = YES;
    }
    else {
        // 竖屏，纵向布局
        self.alwaysBounceHorizontal = NO;
        self.alwaysBounceVertical = YES;
    }
    
    NSInteger itemCount = _arrScrollViewWindowItem.count;
    if (!_arrScrollViewWindowItem && itemCount==0) {
        return;
    }
    
    if (isLandscape) {
        // 横
        self.contentSize = CGSizeMake(_paddingLR+(_itemW+_spaceX)*itemCount, self.bounds.size.height);
    }
    else {
        // 竖
        self.contentSize = CGSizeMake(self.bounds.size.width, _paddingTB+(_itemH+_spaceY)*itemCount);
    }
    
    CGRect rcItem = self.frame;
    for (NSInteger i=0; i<itemCount; i++) {
        UIScrollViewWindowItem *scrollViewWindowItem = _arrScrollViewWindowItem[i];
        scrollViewWindowItem.alwaysBounceHorizontal = !self.alwaysBounceHorizontal;
        scrollViewWindowItem.alwaysBounceVertical = !self.alwaysBounceVertical;
        scrollViewWindowItem.labelTitle.text = [NSString stringWithFormat:@"%d.%@", i+1, [_datasource scrollViewWindow:self titleAtIndex:i]];
        scrollViewWindowItem.imageViewThumb.image = [_datasource scrollViewWindow:self imageAtIndex:i];
        
        if (isLandscape) {
            rcItem.size.width = _itemW;
            rcItem.origin.y = 0;
            rcItem.origin.x = _paddingLR+(rcItem.size.width+_spaceX)*i;
        }
        else {
            rcItem.size.height = _itemH;
            rcItem.origin.x = 0;
            rcItem.origin.y = _paddingTB+(rcItem.size.height+_spaceY)*i;
        }
        scrollViewWindowItem.frame = rcItem;
        if (isLandscape) {
            scrollViewWindowItem.layoutDirection = UILayoutDirectionVertical;
        }
        else {
            scrollViewWindowItem.layoutDirection = UILayoutDirectionHorizontal;
        }

    }
    
    [self scrollToItemIndex:_selectIndex withAnimated:NO completion:nil];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self resizeItem];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _paddingLR = _paddingTB = 10;
    _spaceX = _spaceY = 10;
    _itemW = 160;
    _itemH = 100;
    _canRemovePercent = 0.8;
}

- (void)reload
{
    [self resizeItem];
}

- (void)addScrollViewWindowItem:(UIScrollViewWindowItem *)scrollViewWindowItem
{
    if (!_arrScrollViewWindowItem) {
        _arrScrollViewWindowItem = [NSMutableArray array];
    }
    
    scrollViewWindowItem.delegate = self;
    [scrollViewWindowItem.viewWindItem addTarget:self action:@selector(onTouchViewWindowItem:) forControlEvents:UIControlEventTouchUpInside];
    [scrollViewWindowItem.btnDel addTarget:self action:@selector(onTouchViewWindowItemBtnDel:) forControlEvents:UIControlEventTouchUpInside];
    
    scrollViewWindowItem.alwaysBounceHorizontal = !self.alwaysBounceHorizontal;
    scrollViewWindowItem.alwaysBounceVertical = !self.alwaysBounceVertical;
    BOOL isLandscape = self.bounds.size.width>self.bounds.size.height;
    CGRect rcItem = self.bounds;
    if (isLandscape) {
        rcItem.size.width = _itemW;
        rcItem.origin.y = 0;
        rcItem.origin.x = _paddingLR+(rcItem.size.width+_spaceX)*_arrScrollViewWindowItem.count;
    }
    else {
        rcItem.size.height = _itemH;
        rcItem.origin.x = 0;
        rcItem.origin.y = _paddingTB+(rcItem.size.height+_spaceY)*_arrScrollViewWindowItem.count;
    }
    scrollViewWindowItem.frame = rcItem;
    if (isLandscape) {
        scrollViewWindowItem.layoutDirection = UILayoutDirectionVertical;
    }
    else {
        scrollViewWindowItem.layoutDirection = UILayoutDirectionHorizontal;
    }
    [_arrScrollViewWindowItem addObject:scrollViewWindowItem];
    [self addSubview:scrollViewWindowItem];
    
    scrollViewWindowItem.alpha = 0;
    [UIView animateWithDuration:0.35 animations:^{
        scrollViewWindowItem.alpha = 1;
    }];
    
    if (isLandscape) {
        // 横
        self.contentSize = CGSizeMake(rcItem.origin.x+rcItem.size.width+_paddingLR, self.bounds.size.height);
    }
    else {
        // 竖
        self.contentSize = CGSizeMake(self.bounds.size.width, rcItem.origin.y+rcItem.size.height+_paddingTB);
    }
}

- (void)removeItemAtIndex:(NSInteger)index
{
    UIScrollViewWindowItem *item = _arrScrollViewWindowItem[index];
    
    [self removeItemAtIndex:index deleteDirection:(item.layoutDirection==UILayoutDirectionHorizontal)?WindowItemDeleteDirectionRight:WindowItemDeleteDirectionBottom];
}

- (void)removeItemAtIndex:(NSInteger)index deleteDirection:(WindowItemDeleteDirection)deleteDirection
{
    UIScrollViewWindowItem *scrollViewWindowItem = _arrScrollViewWindowItem[index];
    CGPoint offset = scrollViewWindowItem.contentOffset;
    switch (deleteDirection) {
        case WindowItemDeleteDirectionTop:
            offset.y = scrollViewWindowItem.bounds.size.height*2;
            break;
        case WindowItemDeleteDirectionBottom:
            offset.y = 0;
            break;
        case WindowItemDeleteDirectionLeft:
            offset.x = scrollViewWindowItem.bounds.size.width*2;
            break;
        case WindowItemDeleteDirectionRight:
            offset.x = 0;
            break;
            
        default:
            break;
    }
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         scrollViewWindowItem.contentOffset = offset;
                     } completion:^(BOOL finished) {
                         [scrollViewWindowItem removeFromSuperview];
                         [_arrScrollViewWindowItem removeObjectAtIndex:index];
                         
                         // 删除后 更新 选中索引
                         NSInteger newIndex = MIN(_selectIndex, _arrScrollViewWindowItem.count-1);
                         if (index<=_selectIndex) {
                             self.selectIndex = newIndex;
                             // TODO: 已删除
                             [_delegateWindow scrollViewWindow:self didRemoveAtIndex:index toIndex:_selectIndex];
                         }
                         
                         if (_arrScrollViewWindowItem.count==0) {
                             _canChanageAlpha = NO;
                             [_delegateWindow scrollViewWindowWillAddNewWindow:self];
                         }
                         else {
                             [UIView animateWithDuration:0.3 animations:^{
                                 // TODO:resize
                                 [self resizeItem];
                                 
                                 _canChanageAlpha = NO;
                             }];
                         }
                     }];
}

/**
 *  滚动到某项
 *
 *  @param index    索引
 *  @param animated 是否动画
 */
- (void)scrollToItemIndex:(NSInteger)index withAnimated:(BOOL)animated completion:(void(^)(void))completion
{
    if (index<0 || _arrScrollViewWindowItem.count==0) {
        return;
    }
    UIScrollViewWindowItem *item = _arrScrollViewWindowItem[index];
    CGRect rcItemOnScreen = item.frame;
    rcItemOnScreen.origin.x -= self.contentOffset.x;
    rcItemOnScreen.origin.y -= self.contentOffset.y;
    
    CGRect rcVisiable = self.bounds;
    rcVisiable.origin = self.contentOffset;
    if (self.bounds.size.width>self.bounds.size.height) {
        // 将选中的标签滚动到 可视区，在左边的贴左，在右边的贴右
        CGRect rcCurrTab = item.frame;
        CGRect intersection = CGRectIntersection(rcVisiable, rcCurrTab);
        
        if (intersection.size.width<rcCurrTab.size.width) {
            if (rcCurrTab.origin.x<rcVisiable.origin.x) {
                // 左边
                rcVisiable.origin.x = rcCurrTab.origin.x;
            }
            else {
                // 右边
                rcVisiable.origin.x = rcCurrTab.origin.x+rcCurrTab.size.width-rcVisiable.size.width;
            }
        }
    }
    else {
        // 竖屏
        CGRect rcCurrTab = item.frame;
        CGRect intersection = CGRectIntersection(rcVisiable, rcCurrTab);
        
        if (intersection.size.height<rcCurrTab.size.height) {
            if (rcCurrTab.origin.y<rcVisiable.origin.y) {
                // 上边
                rcVisiable.origin.y = rcCurrTab.origin.y;
            }
            else {
                // 下边
                rcVisiable.origin.y = rcCurrTab.origin.y+rcCurrTab.size.height-rcVisiable.size.height;
            }
            
        }
    }
    [self scrollRectToVisible:rcVisiable animated:animated];
    if (completion) completion();
}

- (void)onTouchViewWindowItem:(UIControl *)viewWindowItem
{
    if (viewWindowItem==((UIScrollViewWindowItem *)_arrScrollViewWindowItem[_selectIndex]).viewWindItem) {
        [_delegateWindow scrollViewWindow:self didSelectFromIndex:_selectIndex toIndex:_selectIndex];
        return;
    }
    
    NSInteger fromIndex = _selectIndex;
    NSInteger itemIndex = [_arrScrollViewWindowItem indexOfObject:viewWindowItem.superview];
    self.selectIndex = itemIndex;
    [self scrollToItemIndex:_selectIndex withAnimated:YES completion:^{
        // 已选择
        [_delegateWindow scrollViewWindow:self didSelectFromIndex:fromIndex toIndex:_selectIndex];
    }];
}

- (void)onTouchViewWindowItemBtnDel:(UIButton *)btn
{
    _canChanageAlpha = YES;
    NSInteger itemIndex = [_arrScrollViewWindowItem indexOfObject:btn.superview.superview];
    UIScrollViewWindowItem *item = (UIScrollViewWindowItem *)btn.superview.superview;
    [self removeItemAtIndex:itemIndex deleteDirection:(item.layoutDirection==UILayoutDirectionHorizontal)?WindowItemDeleteDirectionRight:WindowItemDeleteDirectionBottom];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollViewWindowItem *)scrollView
{
    if (!_canChanageAlpha) return;
    
    if (UILayoutDirectionHorizontal==scrollView.layoutDirection) {
        //  偏移量
        CGFloat offsetX = scrollView.contentOffset.x-scrollView.bounds.size.width;
        CGFloat transRate = fabsf(offsetX)/(_canRemovePercent*scrollView.bounds.size.width);
        scrollView.viewWindItem.alpha = 1-transRate;
    }
    else {
        CGFloat offsetY = scrollView.contentOffset.y-scrollView.bounds.size.height;
        CGFloat transRate = fabsf(offsetY)/(_canRemovePercent*scrollView.bounds.size.height);
        scrollView.viewWindItem.alpha = 1-transRate;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollViewWindowItem *)scrollView
{
    _canChanageAlpha = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollViewWindowItem *)scrollView willDecelerate:(BOOL)decelerate
{
    if (UILayoutDirectionHorizontal==scrollView.layoutDirection) {
        CGFloat offsetX = scrollView.contentOffset.x-scrollView.bounds.size.width;
        if (fabsf(offsetX)>=scrollView.bounds.size.width/2) {
            // 系统自动 翻页
        }
        else {
            CGFloat delAlpha = fabsf(offsetX)/(_canRemovePercent*scrollView.bounds.size.width);
            if (delAlpha>_canRemovePercent) {
                [self removeItemAtIndex:[_arrScrollViewWindowItem indexOfObject:scrollView] deleteDirection:(offsetX<0)?WindowItemDeleteDirectionRight:WindowItemDeleteDirectionLeft];
            }
            else {
                [UIView animateWithDuration:0.3 animations:^{
                    scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
                } completion:^(BOOL finished) {
                    _canChanageAlpha = NO;
                }];
            }
        }
    }
    else {
        CGFloat offsetY = scrollView.contentOffset.y-scrollView.bounds.size.height;
        if (fabsf(offsetY)>=scrollView.bounds.size.height/2) {
            // 系统自动 翻页
        }
        else {
            CGFloat delAlpha = fabsf(offsetY)/(_canRemovePercent*scrollView.bounds.size.height);
            if (delAlpha>_canRemovePercent) {
                [self removeItemAtIndex:[_arrScrollViewWindowItem indexOfObject:scrollView] deleteDirection:(offsetY<0)?WindowItemDeleteDirectionBottom:WindowItemDeleteDirectionTop];
            }
            else {
                [UIView animateWithDuration:0.3 animations:^{
                    scrollView.contentOffset = CGPointMake(0 ,scrollView.bounds.size.height);
                } completion:^(BOOL finished) {
                    _canChanageAlpha = NO;
                }];
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollViewWindowItem *)scrollView
{
    if (UILayoutDirectionHorizontal==scrollView.layoutDirection) {
        CGFloat offsetX = scrollView.contentOffset.x-scrollView.bounds.size.width;
        if (fabsf(offsetX)!=0) {
            [self removeItemAtIndex:[_arrScrollViewWindowItem indexOfObject:scrollView] deleteDirection:(offsetX<0)?WindowItemDeleteDirectionRight:WindowItemDeleteDirectionLeft];
        }
    }
    else {
        CGFloat offsetY = scrollView.contentOffset.y-scrollView.bounds.size.height;
        if (fabsf(offsetY)!=0) {
            [self removeItemAtIndex:[_arrScrollViewWindowItem indexOfObject:scrollView] deleteDirection:(offsetY<0)?WindowItemDeleteDirectionBottom:WindowItemDeleteDirectionTop];
        }
    }
}

@end
