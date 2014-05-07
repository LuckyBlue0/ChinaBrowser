//
//  ViewHomeSearch_ipad.m
//
//  Created by Glex on 14-3-07.
//  Copyright (c) 2014年 arBao. All rights reserved.
//

#import "ViewHomeSearch_ipad.h"

#import "UITextFieldEx.h"

#import "ControllerSuper_ipad.h"

#import "CellSearchOption.h"

#import "ModelUrl_ipad.h"

#define kRowHeight 50

@interface ViewHomeSearch_ipad () {
    UIView *_viewType;
    
    UIView   *_viewSearch;
    UIButton *_btnIcon;
    UIButton *_btnArrow;
    UITextFieldEx *_txtWord;
    UIButton *_btnSearch;
    
    UIControl   *_viewMaskBg;
    UITableView *_tbOptions;
    UIImageView *_ivTbBg;
    NSArray     *_arrOptions;
    
    NSArray *_arrType;
    NSMutableDictionary *_dicItems;
    NSString *_currTypeName;
    NSInteger _currTypeOptionIdx;
    ModelUrl_ipad *_currModelUrl;
}

@end

@implementation ViewHomeSearch_ipad

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGRect rc = self.bounds;
        rc.size.height = 38;
        _viewType = [[UIView alloc] initWithFrame:rc];
        [self addSubview:_viewType];
        
        rc.origin.y += rc.size.height;
        rc.size.height = frame.size.height-rc.origin.y;
        _viewSearch = [[UIView alloc] initWithFrame:rc];
        _viewSearch.backgroundColor = [UIColor clearColor];
        [self addSubview:_viewSearch];

        rc.origin = CGPointZero;
        rc.size.width = rc.size.height;
        _btnIcon = [[UIButton alloc] initWithFrame:rc];
        [_btnIcon addTarget:self action:@selector(onTouchSearchOption) forControlEvents:UIControlEventTouchUpInside];
        [_viewSearch addSubview:_btnIcon];
        
        rc.origin.x = rc.size.width-3;
        rc.size.width = 20;
        _btnArrow = [[UIButton alloc] initWithFrame:rc];
        [_btnArrow setImage:BundleImageForSearch(@"btn-arrow-d") forState:UIControlStateNormal];

        [_btnArrow addTarget:self action:@selector(onTouchSearchOption) forControlEvents:UIControlEventTouchUpInside];
        [_viewSearch addSubview:_btnArrow];
        
        rc.size.width = 87;
        rc.origin.x = _viewSearch.bounds.size.width-rc.size.width;
        _btnSearch = [[UIButton alloc] initWithFrame:rc];
        [_btnSearch addTarget:self action:@selector(onTouchSearch) forControlEvents:UIControlEventTouchUpInside];
        [_viewSearch addSubview:_btnSearch];
        
        rc.origin.x = _btnArrow.frame.origin.x+_btnArrow.bounds.size.width+5;
        rc.size.width = _btnSearch.frame.origin.x-rc.origin.x;
        _txtWord = [[UITextFieldEx alloc] initWithFrame:rc];
        _txtWord.font = [UIFont systemFontOfSize:15];
        _txtWord.returnKeyType = UIReturnKeySearch;
        _txtWord.clearButtonMode = UITextFieldViewModeWhileEditing;
        _txtWord.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_viewSearch addSubview:_txtWord];
        
        _dicItems = [[NSMutableDictionary alloc] init];
        _arrType = [[NSArray alloc] initWithObjects:@"网页", @"新闻", @"小说", @"购物", @"音乐", @"视频", nil];

        [self loadSearchItems];
    }
    
    return self;
}

- (void)loadSearchItems {
    [_dicItems removeAllObjects];
    
    NSArray *arrData = [AppManager homeSearchItems];
    if (![arrData isKindOfClass:[NSArray class]]) {
        return;
    }
    
    for (NSDictionary *dic in arrData) {
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        NSString *typeName = [dic objectForKey:@"name"];
        NSArray *arrItems = [dic objectForKey:@"item"];
        if (![arrItems isKindOfClass:[NSArray class]]) {
            continue;
        }
        
        NSMutableArray *arrModels = [[NSMutableArray alloc] init];
        for (NSDictionary *dicModel in arrItems) {
            ModelUrl_ipad *model = [ModelUrl_ipad modelWithDic:dicModel];
            if (model) {
                [arrModels addObject:model];
            }
        }
        [_dicItems setObject:arrModels forKey:typeName];
    }
    
    if (!_dicItems.count) {
        return;
    }
    
    UIButton *btnSelType = nil;
    CGFloat spaceX = 18;
    CGRect rc = CGRectMake(0, 0, 63, _viewType.bounds.size.height);
    for (NSInteger idx=0; idx<_arrType.count; idx++) {
        rc.origin.x = (rc.size.width+spaceX)*idx+spaceX*2;
        UIButton *btnType = [[UIButton alloc] initWithFrame:rc];
        btnType.tag = idx;
        btnType.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [btnType setTitle:[_arrType objectAtIndex:idx] forState:UIControlStateNormal];
        [btnType setTitleColor:isDayMode?kTextColorDay:kTextColorNight forState:UIControlStateNormal];
        [btnType setTitleColor:kTextColorSelected forState:UIControlStateSelected];
        [btnType setTitleColor:kTextColorSelected forState:UIControlStateHighlighted];
        [btnType addTarget:self action:@selector(onTouchType:) forControlEvents:UIControlEventTouchUpInside];
        [_viewType addSubview:btnType];
        
        if (idx == 0) {
            btnSelType = btnType;
        }
    }
    [self onTouchType:btnSelType];
}

- (void)hideKeyboard {
    [_txtWord resignFirstResponder];
}

- (void)fixSubviews {
    CGRect rc = self.frame;
    rc.origin.x = (self.superview.bounds.size.width-rc.size.width)*0.5;
    self.frame = rc;
    
    rc = _ivTbBg.frame;
    rc.origin.x = self.frame.origin.x;
    _ivTbBg.frame = rc;
}

#pragma mark - private methods
- (void)setObjDelegate:(ControllerSuper_ipad<ViewHomeSearchDelegate_ipad> *)objDelegate {
    _objDelegate = objDelegate;
    [self addSubviewsToDelegate];
}

- (void)addSubviewsToDelegate {
    if (!self.superview) {
        return;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // _viewSearchOptionBg
        CGRect rc = _objDelegate.viewContent.bounds;
        _viewMaskBg = [[UIControl alloc] initWithFrame:rc];
        _viewMaskBg.alpha = 0;
        _viewMaskBg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _viewMaskBg.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [_viewMaskBg addTarget:self action:@selector(onTouchMaskBg) forControlEvents:UIControlEventTouchDown];
        [_objDelegate.viewContent addSubview:_viewMaskBg];
        
        // _ivTbBg
        {
            rc.origin = [_objDelegate.viewContent convertPoint:self.frame.origin fromView:self.superview];
            rc.origin.y += self.bounds.size.height-(isIOS(7)?0:20);
            rc.size = CGSizeMake(200, kRowHeight*_arrOptions.count);
            _ivTbBg = [[UIImageView alloc] initWithFrame:rc];
            _ivTbBg.clipsToBounds = YES;
            _ivTbBg.userInteractionEnabled = YES;
            
            _ivTbBg.layer.anchorPoint = CGPointZero;
            _ivTbBg.layer.position = CGPointMake(rc.origin.x+1, rc.origin.y+1);
        }
        
        // _tbSearchOption
        {
            rc = _ivTbBg.bounds;
            rc.origin = CGPointMake(5, 5);
            rc.size.width -= rc.origin.x*2;
            _tbOptions = [[UITableView alloc] initWithFrame:rc];
            _tbOptions.delegate = self;
            _tbOptions.dataSource = self;
            _tbOptions.bounces = NO;
            _tbOptions.rowHeight = kRowHeight;
            _tbOptions.backgroundColor = [UIColor clearColor];
            _tbOptions.separatorColor = RGB_COLOR(230, 230, 230);
            
            _tbOptions.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            [_ivTbBg addSubview:_tbOptions];
        }
    });
}

- (void)onTouchType:(UIButton *)btn {
    for (UIButton *btnType in _viewType.subviews) {
        if (![btnType isKindOfClass:[UIButton class]]) {
            continue;
        }
        
        btnType.selected = (btnType.tag==btn.tag);
        btnType.userInteractionEnabled = !btnType.selected;
    }

    _currTypeName = [_arrType objectAtIndex:btn.tag];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *dicTmp = [ud dictionaryForKey:kHomeSearchSelItems];
    NSMutableDictionary *dicSelItems = nil;
    if (!dicTmp) {
        dicSelItems = [[NSMutableDictionary alloc] init];
    }
    else {
        NSNumber *idx = [dicTmp objectForKey:_currTypeName];
        if (!idx) {
            dicSelItems = [NSMutableDictionary dictionaryWithDictionary:dicTmp];
        }
    }
    _currTypeOptionIdx = [self getCurrTypeOptionIdx];
    if (dicSelItems) {
        [dicSelItems setObject:@(_currTypeOptionIdx) forKey:_currTypeName];
        [ud setObject:dicSelItems forKey:kHomeSearchSelItems];
        [ud synchronize];
    }

    _arrOptions = [_dicItems objectForKey:_currTypeName];
    _currModelUrl = [_arrOptions objectAtIndex:_currTypeOptionIdx];
    _txtWord.placeholder = _currModelUrl.title;
    [_btnIcon setImage:BundleImageForSearch(_currModelUrl.icon) forState:UIControlStateNormal];
    if (_ivTbBg) {
        _ivTbBg.transform = CGAffineTransformIdentity;
        CGRect rc = _ivTbBg.frame;
        rc.size.height = kRowHeight*_arrOptions.count;
        _ivTbBg.frame = rc;
        _ivTbBg.transform = CGAffineTransformMakeScale(0.01, 0.01);
        
        [_tbOptions reloadData];
    }
}

- (void)onTouchSearchOption {
    [self showSearchOption:YES];
}

- (void)onTouchSearch {
    if (_txtWord.text.length>0
        && [_objDelegate respondsToSelector:@selector(viewHomeSearch:openUrl:)]) {
        
        NSString *keyword = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                  (CFStringRef)_txtWord.text,
                                                                                                  NULL,
                                                                                                  NULL,//(CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                                                                                  kCFStringEncodingUTF8));
        NSString *urlStr = [_currModelUrl.link stringByAppendingString:keyword];
        [_objDelegate viewHomeSearch:self openUrl:urlStr];
        [_txtWord resignFirstResponder];
    }
}

- (void)onTouchMaskBg {
    [self showSearchOption:NO];
}

- (void)showSearchOption:(BOOL)show {
    if (show) {
        CGRect rc = _ivTbBg.frame;
        rc.origin.x = self.frame.origin.x;
        _ivTbBg.frame = rc;
        
        [_objDelegate.viewContent addSubview:_ivTbBg];
        _viewMaskBg.alpha = show;
    }
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         _ivTbBg.alpha = show;
                         // CGAffineTransformMakeScale(0.0, 0.0)会有奇怪的现象，原因不明
                         _ivTbBg.transform = CGAffineTransformMakeScale(show?1:0.01, show?1:0.01);
                     }
                     completion:^(BOOL finished) {
                         if (!show) {
                             _viewMaskBg.alpha = show;
                             [_ivTbBg removeFromSuperview];
                         }
                     }
     ];
}

- (NSInteger)getCurrTypeOptionIdx {
    NSInteger optionIdx = 0;
    
    if (_currTypeName) {
        NSDictionary *dicSelItems = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kHomeSearchSelItems];
        if (dicSelItems) {
            NSNumber *idx = [dicSelItems objectForKey:_currTypeName];
            if (idx) {
                optionIdx = idx.integerValue;
            }
        }
    }
    
    return optionIdx;
}

- (void)setOptionIndex:(NSInteger)optionIdx {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *dicTmp = [ud dictionaryForKey:kHomeSearchSelItems];
    if (!dicTmp) {
        return;
    }
    
    _currTypeOptionIdx = optionIdx;
    _currModelUrl = [_arrOptions objectAtIndex:optionIdx];
    _txtWord.placeholder = _currModelUrl.title;
    [_btnIcon setImage:BundleImageForSearch(_currModelUrl.icon) forState:UIControlStateNormal];

    NSMutableDictionary *dicSelItems = [NSMutableDictionary dictionaryWithDictionary:dicTmp];
    [dicSelItems setObject:@(optionIdx) forKey:_currTypeName];
    [ud setObject:dicSelItems forKey:kHomeSearchSelItems];
    [ud synchronize];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self onTouchSearch];
    
    return YES;
}

#pragma mark - UITableViewDelegate & UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrOptions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *searchIdentifier = @"searchIdentifier";
    CellSearchOption *cell = [tableView dequeueReusableCellWithIdentifier:searchIdentifier];
    if (!cell) {
        cell = [[CellSearchOption alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchIdentifier];
    }
    
    cell.tag = indexPath.row;
    ModelUrl_ipad *modelUrl = [_arrOptions objectAtIndex:indexPath.row];
    [cell.imageView setImage:BundleImageForSearch(modelUrl.icon)];
    cell.textLabel.text = modelUrl.title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.selected = (indexPath.row==_currTypeOptionIdx);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self showSearchOption:NO];
    [self setOptionIndex:indexPath.row];
    for (UITableViewCell *cell in tableView.visibleCells) {
        cell.selected = (cell.tag==_currTypeOptionIdx);
    }
}

#pragma mark - notif
- (void)whenDeviceDidRotate {
    [self fixSubviews];
}

- (void)whenDayModeChanged {
    BOOL dayMode = isDayMode;
    [_viewSearch setBgImageWithStretchImage:[BundleImageForSearch(dayMode?@"bg-kuang-bai-2":@"bg-kuang-ye-2") stretchableImageWithLeftCapWidth:30 topCapHeight:40]];
    
    [_btnSearch setImage:BundleImageForSearch(dayMode?@"bt-Search-bai-0":@"bt-Search-ye-0") forState:UIControlStateNormal];
    _ivTbBg.image = [BundleImageForSearch(dayMode?@"search_icon_popover_bg_0":@"search_icon_popover_bg_1") stretchableImageWithLeftCapWidth:25 topCapHeight:25];
    
    UIColor *textColor = dayMode?kTextColorDay:kTextColorNight;
    _txtWord.textColor = textColor;
    for (UIButton *btnType in _viewType.subviews) {
        if (![btnType isKindOfClass:[UIButton class]]) {
            continue;
        }
        
        [btnType setTitleColor:textColor forState:UIControlStateNormal];
    }
}

@end
