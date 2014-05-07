//
//  ViewSkin.m
//  ChinaBrowser
//
//  Created by Glex on 14-3-27.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ViewSkin.h"

#import "ViewSkinItem.h"

#define kDefaultItemCount 2
#define kInsetLeft  30

#define kSkinItemW  120
#define kSkinItemH  120
#define kSkinItemSpaceX  10
#define kSkinItemOriginY 3

#define kSysItemsCount  2
#define kTagForAlertItemAdd  888
#define kTagForAlertItemDel  999

@interface ViewSkin () {
    ViewSkinItem *_itemAdd;
    UIScrollView *_svList;
    ViewSkinItem *_wllDelViewItem;

    NSMutableArray *_arrSkinItems;
    
    NSArray     *_arrSortKey;
    NSMutableDictionary *_dicSkinImages;
    
    UIImagePickerController *_vcPicker;
}

@end

@implementation ViewSkin

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
       
        _svList = [[UIScrollView alloc] initWithFrame:self.bounds];
        _svList.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _svList.contentInset = UIEdgeInsetsMake(0, kInsetLeft, 0, 0);
        _svList.showsHorizontalScrollIndicator = NO;
        [self addSubview:_svList];
        
        [self loadSkinItems];
    }
    
    return self;
}

- (void)setEditing:(BOOL)editing {
    if (_editing == editing) {
        return;
    }
    _editing = editing;
    
    for (NSInteger idx=kSysItemsCount; idx<_arrSkinItems.count; idx++) {
        ViewSkinItem *skinItem = [_arrSkinItems objectAtIndex:idx];
        if (!skinItem.isSelected) {
            skinItem.shaking = editing;
        }
    }
}

#pragma mark - items
- (void)loadSkinItems {
    [_svList.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (!_arrSkinItems) {
        _arrSkinItems  = [[NSMutableArray alloc] init];
        _dicSkinImages = [[NSMutableDictionary alloc] init];
        
    }
    [_arrSkinItems removeAllObjects];
    [_dicSkinImages removeAllObjects];
    
    // 按钮'+', 不加到_arrSkinItems
    CGRect rc = {{0, kSkinItemOriginY}, {kSkinItemW, kSkinItemH}};
    _itemAdd = [[ViewSkinItem alloc] initWithFrame:rc];
    NSString *picPath = [[NSBundle mainBundle] pathForResource:@"ipad-skin-add" ofType:@"png"];
    [_itemAdd setSkinPic:[UIImage imageWithContentsOfFile:picPath]];
    [_itemAdd addTarget:self action:@selector(onTouchItemAdd) forControlEvents:UIControlEventTouchUpInside];
    [_svList addSubview:_itemAdd];
    
    NSString *currentSkinKey = [AppManager currentSkinKey];
    [_dicSkinImages addEntriesFromDictionary:[AppManager skinImages]];
    _arrSortKey = [_dicSkinImages.allKeys sortedArrayUsingSelector:@selector(compare:)];
    for (NSInteger idx=0; idx<_arrSortKey.count; idx++) {
        NSString *key = _arrSortKey[idx];
        ViewSkinItem *viewItem = [[ViewSkinItem alloc] initWithFrame:rc];
        viewItem.skinKey = key;
        [viewItem setSkinPic:_dicSkinImages[key]];
        viewItem.selected = [key isEqualToString:currentSkinKey];
        [viewItem addTarget:self action:@selector(onTouchItem:) forControlEvents:UIControlEventTouchUpInside];
        if (idx >= kSysItemsCount) {
            UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressItem:)];
            [viewItem addGestureRecognizer:longPressGes];
            
            [viewItem.btnClose addTarget:self action:@selector(onTouchItemClose:) forControlEvents:UIControlEventTouchUpInside];
        }

        [self addItem:viewItem];
    }
}

- (void)addItem:(ViewSkinItem *)viewItem {
    CGRect rcRaw = _itemAdd.frame;
    CGRect rcNew = rcRaw;
    rcNew.origin.x += kSkinItemW+kSkinItemSpaceX;
    viewItem.frame = rcNew;
    
    [_svList addSubview:viewItem];
    [_arrSkinItems addObject:viewItem];

    _svList.contentSize = CGSizeMake(rcNew.origin.x+kSkinItemW+kSkinItemSpaceX, kViewSkinH);
    [UIView animateWithDuration:0.25 animations:^{
        _itemAdd.frame = rcNew;
        viewItem.frame = rcRaw;
    } completion:^(BOOL finished) {
        CGFloat contentW = _svList.contentSize.width;
        CGFloat boundsW  = _svList.bounds.size.width;
        if (contentW > boundsW) {
            [_svList setContentOffset:CGPointMake(contentW-boundsW, 0) animated:YES];
        }
    }];
    
    // 确保按钮'+'在最后
    [_svList addSubview:_itemAdd];
}

- (void)fixItemsWithMove:(BOOL)move {
    NSInteger idx = 0;
    __block CGFloat originY = kSkinItemOriginY;
    for (ViewSkinItem *viewItem in _svList.subviews) {
        if (![viewItem isKindOfClass:[ViewSkinItem class]]) {
            continue;
        }
        
        __block CGRect rc = viewItem.frame;
        if (move) {
            originY += 30;
        }
        rc.origin.y = originY;
        rc.origin.x = idx*(kSkinItemW+kSkinItemSpaceX)+kInsetLeft;
        viewItem.frame = rc;
        
        if (move) {
            [UIView animateWithDuration:idx*0.02+0.6 animations:^{
                rc.origin.y = kSkinItemOriginY;
                viewItem.frame = rc;
            }];
        }
        
        ++idx;
    }
    
    _svList.contentOffset = CGPointMake(-kInsetLeft, 0);
}

- (void)animateItems {return;
    [self fixItemsWithMove:YES];
}

- (void)changeBlurImage {
    if (self.alpha == 1) {
        [self setBgImageWithStretchImage:[SkinManager_ipad skinBlurImage]];
        [KTAnimationKit animationEaseIn:self];
    }
}

- (void)showImagePicker:(BOOL)show openCamera:(BOOL)openCamera {
    if (show) {
        _vcPicker = [[UIImagePickerController alloc] init];
        _vcPicker.allowsEditing = YES;
        _vcPicker.delegate      = self;

        if (openCamera
            && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            _vcPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }

        UIView *viewSuper = [AppManager vcRoot].viewContent;
        CGRect rc = viewSuper.bounds;
        rc.origin.y = rc.size.height;
        _vcPicker.view.frame = rc;
        [viewSuper addSubview:_vcPicker.view];
        
        [UIView animateWithDuration:0.25 animations:^{
            _vcPicker.view.transform = CGAffineTransformMakeTranslation(0, -rc.size.height);
        }];
    }
    else {
        [UIView animateWithDuration:0.25 animations:^{
            _vcPicker.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [_vcPicker.view removeFromSuperview];
            _vcPicker = nil;
        }];
    }
}

#pragma mark - user interaction
- (void)onTouchItem:(ViewSkinItem *)viewItem {
    self.editing = NO;
    
    for (ViewSkinItem *loopItem in _arrSkinItems) {
        loopItem.selected = (viewItem==loopItem);
    }
    
    [AppManager setCurrentSkin:viewItem.skinPic];
    [AppManager setCurrentSkinKey:viewItem.skinKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifSkinChanged object:nil];
    [self changeBlurImage];
}

- (void)onTouchItemAdd {
    self.editing = NO;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:GetTextFromKey(@"QingXuanZe")
                                                   delegate:self
                                          cancelButtonTitle:GetTextFromKey(@"cancel")
                                          otherButtonTitles:GetTextFromKey(@"skin_select_from_album"),
                          GetTextFromKey(@"skin_take_photo"), nil];
    alert.tag = kTagForAlertItemAdd;
    [alert show];
}

- (void)onTouchItemClose:(UIButton *)btn {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:GetTextFromKey(@"AreYouSure")
                                                   delegate:self
                                          cancelButtonTitle:GetTextFromKey(@"cancel")
                                          otherButtonTitles:GetTextFromKey(@"QueDing"), nil];
    alert.tag = kTagForAlertItemDel;
    [alert show];
    
    _wllDelViewItem = (ViewSkinItem *)btn.userData;
}

- (void)longPressItem:(UILongPressGestureRecognizer *)longPress {
    if(!_editing) {
        if(longPress.state == UIGestureRecognizerStateBegan) {
            self.editing = YES;
        }
    }
}

#pragma mark - notif
- (void)whenDayModeChanged {
    BOOL dayMode = isDayMode;
    ViewSkinItem *viewItem = [_arrSkinItems objectAtIndex:(dayMode?0:1)];
    [self onTouchItem:viewItem];
    
    [self changeBlurImage];
}

- (void)whenDeviceDidRotate {
    [self changeBlurImage];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        if (alertView.tag == kTagForAlertItemDel) {
            _wllDelViewItem.shaking = NO;
            [AppManager removeSkinForKey:_wllDelViewItem.skinKey];
            [UIView animateWithDuration:0.25
                             animations:^{
                                 _wllDelViewItem.alpha = 0.2;
                                 _wllDelViewItem.transform = CGAffineTransformMakeScale(0.2, 0.2);
                             }
                             completion:^(BOOL finished) {
                                 [_wllDelViewItem removeFromSuperview];
                                 [_arrSkinItems removeObject:_wllDelViewItem];
                                 _wllDelViewItem = nil;
                                 
                                 [UIView animateWithDuration:0.25 animations:^{
                                     [self fixItemsWithMove:NO];
                                 }];
                             }
             ];
            
            return;
        }
        
        switch (buttonIndex) {
            case 1:
            {
                [self showImagePicker:YES openCamera:NO];
            }
                break;
            case 2:
            {
                [self showImagePicker:YES openCamera:YES];
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    NSString *skinKey = [AppManager addSkin:image];
    
    ViewSkinItem *viewItem = [[ViewSkinItem alloc] initWithFrame:_itemAdd.frame];
    viewItem.skinKey = skinKey;
    [viewItem setSkinPic:image];
    [viewItem addTarget:self action:@selector(onTouchItem:) forControlEvents:UIControlEventTouchUpInside];
    [self addItem:viewItem];
    
    [self showImagePicker:NO openCamera:NO];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self showImagePicker:NO openCamera:NO];
}

@end
