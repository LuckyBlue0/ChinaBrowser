//
//  ViewTopSearch_ipad.m
//
//  Created by Glex on 14-3-07.
//  Copyright (c) 2014年 arBao. All rights reserved.
//

#import "ViewTopSearch_ipad.h"

#import "ControllerSuper_ipad.h"

#import "CellSearchOption.h"

#import "ModelUrl_ipad.h"

#define kRowHeight 50

@interface ViewTopSearch_ipad () {
    UIView   *_viewSearch;
    UIButton *_btnIcon;
    UIButton *_btnArrow;
    UITextFieldEx *_txtWord;
    
    UIControl   *_viewMaskBg;
    UITableView *_tbOptions;
    UIImageView *_ivTbBg;
    NSMutableArray *_arrOptions;
    
    NSInteger _currTypeOptionIdx;
    ModelUrl_ipad *_currModelUrl;
}

@end

@implementation ViewTopSearch_ipad

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGRect rc = self.bounds;
        _viewSearch = [[UIView alloc] initWithFrame:rc];
        _viewSearch.backgroundColor = [UIColor clearColor];
        _viewSearch.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_viewSearch];

        rc.origin = CGPointMake(3, 3);
        rc.size.height -= rc.origin.y*2;
        rc.size.width = rc.size.height;
        _btnIcon = [[UIButton alloc] initWithFrame:rc];
        [_btnIcon addTarget:self action:@selector(onTouchSearchOption) forControlEvents:UIControlEventTouchUpInside];
        [_viewSearch addSubview:_btnIcon];
        
        rc.origin.x += rc.size.width;
        rc.size.width = 20;
        _btnArrow = [[UIButton alloc] initWithFrame:rc];
        [_btnArrow setImage:BundleImageForSearch(@"btn-arrow-d") forState:UIControlStateNormal];
        [_btnArrow addTarget:self action:@selector(onTouchSearchOption) forControlEvents:UIControlEventTouchUpInside];
        [_viewSearch addSubview:_btnArrow];
        
        rc.origin.x = _btnArrow.frame.origin.x+_btnArrow.bounds.size.width+5;
        rc.size.width = frame.size.width-rc.origin.x;
        rc.origin.y = 0;
        rc.size.height = frame.size.height;
        _txtWord = [[UITextFieldEx alloc] initWithFrame:rc];
        _txtWord.delegate = self;
        _txtWord.font = [UIFont systemFontOfSize:15];
        _txtWord.returnKeyType = UIReturnKeySearch;
        _txtWord.clearButtonMode = UITextFieldViewModeWhileEditing;
        _txtWord.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _txtWord.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_viewSearch addSubview:_txtWord];
        
        _arrOptions = [[NSMutableArray alloc] init];
        [self loadSearchItems];
    }
    
    return self;
}

- (void)loadSearchItems {
    [_arrOptions removeAllObjects];
    
    NSArray *arrItems = [AppManager topSearchItems];
    if (![arrItems isKindOfClass:[NSArray class]]) {
        return;
    }
    
    for (NSDictionary *dicModel in arrItems) {
        ModelUrl_ipad *model = [ModelUrl_ipad modelWithDic:dicModel];
        if (model) {
            [_arrOptions addObject:model];
        }
    }
    
    _currTypeOptionIdx = [[NSUserDefaults standardUserDefaults] integerForKey:kTopSearchOptionIdx];
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

- (void)hideKeyboard {
    [_txtWord resignFirstResponder];
}

- (void)searchWithKeyword:(NSString *)keyword {
    _txtWord.text = keyword;
    [self onTouchSearch];
}

#pragma mark - private methods
- (void)setObjDelegate:(ControllerSuper_ipad<ViewTopSearchDelegate_ipad> *)objDelegate {
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
            _tbOptions.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            [_ivTbBg addSubview:_tbOptions];
        }
    });
}

- (void)onTouchSearchOption {
    [self showSearchOption:YES];
}

- (void)onTouchSearch {
    if (_txtWord.text.length > 0
        && [_objDelegate respondsToSelector:@selector(viewTopSearch:openUrl:)]) {
        
        NSString *keyword = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                  (CFStringRef)_txtWord.text,
                                                                                                  NULL,
                                                                                                  NULL,//(CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                                                                                  kCFStringEncodingUTF8));
        NSString *urlStr = [_currModelUrl.link stringByAppendingString:keyword];
        [_objDelegate viewTopSearch:self openUrl:urlStr];
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

- (void)setOptionIndex:(NSInteger)optionIdx {
    _currTypeOptionIdx = optionIdx;
    _currModelUrl = [_arrOptions objectAtIndex:optionIdx];
    _txtWord.placeholder = _currModelUrl.title;
    [_btnIcon setImage:BundleImageForSearch(_currModelUrl.icon) forState:UIControlStateNormal];

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@(optionIdx) forKey:kTopSearchOptionIdx];
    [ud synchronize];
}

- (void)needWider:(BOOL)need {
    CGFloat stdW = 185;
    CGFloat widerX = 185;
    CGRect rc = self.frame;
    if (need) {
        rc.size.width += rc.origin.x-widerX;
        rc.origin.x = widerX;
    }
    else {
        rc.origin.x += rc.size.width-stdW;
        rc.size.width = stdW;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = rc;
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifTopSearchWidthChanged object:@(need)];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self needWider:YES];
   
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    
    [self needWider:NO];
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
    static NSString *searchId = @"searchId";
    CellSearchOption *cell = [tableView dequeueReusableCellWithIdentifier:searchId];
    if (!cell) {
        cell = [[CellSearchOption alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchId];
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
    if (_txtWord.isFirstResponder) {
        [self needWider:YES];
    }
    
    CGRect rc = _ivTbBg.frame;
    rc.origin.x = self.frame.origin.x;
    _ivTbBg.frame = rc;
}

- (void)whenDayModeChanged {
    BOOL dayMode = isDayMode;
    
    _txtWord.textColor = dayMode?kTextColorDay:[UIColor lightGrayColor];
    _txtWord.placeholderColor = dayMode?[UIColor grayColor]:[UIColor lightGrayColor];
    
    [self setBgImageWithStretchImage:[BundleImageForSearch(dayMode?@"bg-kuang-bai-0":@"bg-kuang-ye-0") stretchableImageWithLeftCapWidth:50 topCapHeight:30]];
    _ivTbBg.image = [BundleImageForSearch(dayMode?@"search_icon_popover_bg_0":@"search_icon_popover_bg_1") stretchableImageWithLeftCapWidth:25 topCapHeight:25];
    _tbOptions.separatorColor = dayMode?RGB_COLOR(230, 230, 230):RGB_COLOR(150, 150, 150);
}

@end
