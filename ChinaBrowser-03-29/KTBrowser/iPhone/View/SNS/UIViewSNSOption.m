//
//  UIViewSNSOption.m
//  KTBrowser
//
//  Created by David on 14-3-3.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewSNSOption.h"

#import "UIViewSNSItem.h"

#import <ShareSDK/ShareSDK.h>

@interface UIViewSNSOption ()

- (NSInteger)getColCount;
- (void)resizeItem;
- (void)setup;

- (void)onTouchItem:(UIViewSNSItem *)viewItem;
- (void)onTouchCancel;

@end

@implementation UIViewSNSOption

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}

- (void)setup
{
    self.itemW = 68;
    self.itemH = 85;
    self.minPaddingLR = 5;
    self.paddingTB = 10;
    self.spaceX = 10;
    self.spaceY = 10;
    
    _arrItem = [NSMutableArray array];
    
    [_btnCancel addTarget:self action:@selector(onTouchCancel) forControlEvents:UIControlEventTouchUpInside];
    
    _viewContent.backgroundColor = [UIColor colorWithWhite:0.96 alpha:0.85];
    _btnCancel.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.96];
    
    [_btnCancel setTitle:NSLocalizedString(@"cancel", 0) forState:UIControlStateNormal];
}

- (void)onTouchItem:(UIViewSNSItem *)viewItem
{
    [self dismissWithCompletion:^{
        if ([_delegate respondsToSelector:@selector(viewSNSOption:didSelectShareTeyp:)]) {
            [_delegate viewSNSOption:self didSelectShareTeyp:viewItem.tag];
        }
    }];
}

- (void)onTouchCancel
{
    [self dismissWithCompletion:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (_viewContent)
        [self resizeItem];
}

- (NSInteger)getColCount
{
    CGFloat w = _minPaddingLR+_itemW;
    NSInteger colCount = 0;
    while (w+_minPaddingLR <= self.bounds.size.width) {
        colCount++;
        w+=_itemW+_spaceX;
    }
    return colCount;
}

- (void)resizeItem
{
    NSInteger colCount = [self getColCount];
    CGFloat paddingLR = (self.bounds.size.width-(colCount-1)*_spaceX-colCount*_itemW)/2;
    
    NSInteger itemCount = _arrItem.count;
    
    for (NSInteger i=0; i<itemCount; i++) {
        NSInteger col = GetColWithIndexCol(i, colCount);
        NSInteger row = GetRowWithIndexCol(i, colCount);
        CGRect rc = CGRectMake(paddingLR+(_itemW+_spaceX)*col,
                               _paddingTB+(_itemH+_spaceY)*row,
                               _itemW,
                               _itemH);
        UIView *viewIconWebItem = _arrItem[i];
        viewIconWebItem.frame = CGRectIntegral(rc);
    }
    
    UIViewSNSItem *viewSNSItem = [_arrItem lastObject];
    
    CGRect rc = _viewContent.frame;
    rc.size.width = self.bounds.size.width;
    rc.size.height = viewSNSItem.frame.origin.y+viewSNSItem.frame.size.height+_paddingTB+_btnCancel.frame.size.height;
    rc.origin.y = self.bounds.size.height-rc.size.height;
    _viewContent.frame = rc;
}

+ (UIViewSNSOption *)viewSNSOptionFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:@"UIViewSNSOption" owner:nil options:nil][0];
}

- (void)showInView:(UIView *)view arrShareType:(NSArray *)arrShareType completion:(void(^)())completion
{
    
    for (NSInteger i=0; i<arrShareType.count; i++) {
        UIViewSNSItem *viewSNSItem = [UIViewSNSItem viewSNSItemFromItem];
        [viewSNSItem addTarget:self action:@selector(onTouchItem:) forControlEvents:UIControlEventTouchUpInside];
        ShareType shareType = [arrShareType[i] integerValue];
        NSString *filename = [NSString stringWithFormat:@"Resource.bundle/Icon_7/sns_icon_%d.png", shareType];
        viewSNSItem.imageViewIcon.image = [UIImage imageWithFilename:filename];
        NSString *key = [NSString stringWithFormat:@"ShareType_%d", shareType];
        viewSNSItem.labelTitle.text = NSLocalizedStringFromTable(key, @"ShareSDKLocalizable", nil);
        viewSNSItem.labelTitle.textColor = [AppConfig config].uiMode==UIModeDay?[UIColor blackColor]:[UIColor whiteColor];
        viewSNSItem.tag = shareType;

        [_arrItem addObject:viewSNSItem];
        [_viewContent addSubview:viewSNSItem];
    }
    
    self.frame = view.bounds;
    
    [view addSubview:self];
    _viewContent.transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height-_viewContent.frame.origin.y);
//    _viewContent.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        _viewContent.transform = CGAffineTransformIdentity;
        _viewContent.alpha = 1;
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.3];
    } completion:^(BOOL finished) {
        if (completion) completion();
    }];
}

- (void)dismissWithCompletion:(void(^)(void))completion
{
    [UIView animateWithDuration:0.3 animations:^{
        _viewContent.transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height-_viewContent.frame.origin.y);
//        _viewContent.alpha = 0;
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0];
    } completion:^(BOOL finished) {
        if (completion) completion();
        
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pt = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(_viewContent.frame, pt)) {
        [self dismissWithCompletion:nil];
    }
}

@end
