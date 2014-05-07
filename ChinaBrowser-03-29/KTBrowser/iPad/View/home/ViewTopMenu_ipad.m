
//
//  ViewTopMenu_ipad.m
//  BrowserApp
//
//  Created by arBao on 14-1-28.
//  Copyright (c) 2014年 arBao. All rights reserved.
//

#import "ViewTopMenu_ipad.h"

#import "ViewTagsBar_ipad.h"

#import "ViewTopSearch_ipad.h"

@implementation ViewTopMenu_ipad

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    
    CGRect rc = self.frame;
    if (!isIOS(7)) {
        rc.size.height -= 20;
        self.frame = rc;
    }
    
    _viewUrl.clipsToBounds = YES;
    // 搜索选项卡
    rc = _viewUrl.frame;
    rc.origin.x += rc.size.width+10;
    rc.size.width = 185;
    _viewTopSearch = [[ViewTopSearch_ipad alloc] initWithFrame:rc];
    _viewTopSearch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [_viewTools addSubview:_viewTopSearch];

    [_btnAddTag addTarget:self action:@selector(onTouchAddTag) forControlEvents:UIControlEventTouchUpInside];
    _viewTagsTab.btnAdd = _btnAddTag;
    
    _txtUrl.returnKeyType = UIReturnKeyGo;
    _txtUrl.placeholder = GetTextFromKey(@"topMenuTextUrlPlaceholder");
    
    [_btnAddFav setImage:getTopBarImageWithName(@"btn-fav-0") forState:UIControlStateNormal];
    [_btnAddFav setImage:getTopBarImageWithName(@"btn-fav-1") forState:UIControlStateHighlighted];
    [_btnAddFav setImage:getTopBarImageWithName(@"btn-fav-1") forState:UIControlStateSelected];
}

- (void)hideKeyboard {
    [_txtUrl resignFirstResponder];
    [_viewTopSearch hideKeyboard];
}

#pragma mark - notif
// 重写该方法来更改多语言选项  在父类增加的监听通知
- (void)whenLangChanged {
}

// 重写该方法来接收旋转  在父类增加的监听通知
- (void)whenDeviceDidRotate {

}

// 重写该方法来更改日间黑夜模式  在父类增加的监听通知
- (void)whenDayModeChanged {
    BOOL dayMode = isDayMode;
    
    _viewTagsTab.backgroundColor = dayMode ? kTabsBgColorDay:kTabsBgColorNight;

    _txtUrl.textColor = dayMode?kTextColorDay:kTextColorNight;
    [_btnQRCode setImage:BundleImageForSearch(dayMode?@"bt-erwei-bai-0":@"bt-erwei-ye-0") forState:UIControlStateNormal];
    [_viewUrl setBgImageWithStretchImage:[BundleImageForSearch(dayMode?@"bg-kuang-bai-1":@"bg-kuang-ye-1") stretchableImageWithLeftCapWidth:50 topCapHeight:30]];
    _ivLineV.image = BundleImageForSearch(dayMode?@"url-line-bai":@"url-line-ye");
    
    NSString *imgNameN = dayMode?@"tab-2-0":@"tab-2-1";
    NSString *imgNameH = dayMode?@"tab-2-1":@"tab-2-0";
    [_btnHome setImage:getTopBarImageWithName(imgNameN) forState:UIControlStateNormal];
    [_btnHome setImage:getTopBarImageWithName(imgNameH) forState:UIControlStateHighlighted];
    imgNameN = dayMode?@"tab-0-0":@"tab-0-1";
    imgNameH = dayMode?@"tab-0-1":@"tab-0-0";
    [_btnPageBack setImage:getTopBarImageWithName(imgNameN) forState:UIControlStateNormal];
    [_btnPageBack setImage:getTopBarImageWithName(imgNameH) forState:UIControlStateHighlighted];
    imgNameN = dayMode?@"tab-1-0":@"tab-1-1";
    imgNameH = dayMode?@"tab-1-1":@"tab-1-0";
    [_btnPageFront setImage:getTopBarImageWithName(imgNameN) forState:UIControlStateNormal];
    [_btnPageFront setImage:getTopBarImageWithName(imgNameH) forState:UIControlStateHighlighted];
    imgNameN = dayMode?@"tab-3-0":@"tab-3-1";
    imgNameH = dayMode?@"tab-3-1":@"tab-3-0";
    [_btnBookmarker setImage:getTopBarImageWithName(imgNameN) forState:UIControlStateNormal];
    [_btnBookmarker setImage:getTopBarImageWithName(imgNameH) forState:UIControlStateHighlighted];
    imgNameN = dayMode?@"tab-6-0":@"tab-6-1";
    imgNameH = dayMode?@"tab-6-1":@"tab-6-0";
    [_btnMenu setImage:getTopBarImageWithName(imgNameN) forState:UIControlStateNormal];
    [_btnMenu setImage:getTopBarImageWithName(imgNameH) forState:UIControlStateHighlighted];

    [_btnAddTag setImage:ImageFromSkinByName(@"title-btn-1.png") forState:UIControlStateNormal];
    [_btnUser setImage:ImageFromSkinByName(@"btn-3-1.png") forState:UIControlStateNormal];
    [_btnUser setImage:ImageFromSkinByName(@"btn-3-0.png") forState:UIControlStateHighlighted];
}

#pragma mark btns
- (void)onTouchAddTag {
    _clickedAddTag = YES;
    [_viewTagsTab addTag];
}

#pragma mark public methods
- (void)setBtnsEnable:(BOOL)enable {
    _btnPageBack.enabled = _btnPageFront.enabled = enable;
    _btnAddFav.enabled = _btnHome.enabled = enable;
    _btnRefresh.enabled = enable;
}

@end
