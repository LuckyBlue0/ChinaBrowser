//
//  ControllerHistory.m
//

#import "ControllerHistory.h"

#import "ViewIndicator.h"
#import "CtrlSwitch.h"

#import "ModelUrl_ipad.h"
#import "ADOFavorite.h"

#import "WKSync.h"

@interface ControllerHistory () {
    CtrlSwitch *_ctrlSwitch;
    UIButton *_btnFavorite;
    UIButton *_btnHistory;
    UIButton *_btnEdit;
    
    UITableView *_tbData;
}

- (void)onTouchBtnSwitch:(UIButton *)btn;
- (void)onTouchEdit:(UIButton *)btnEdit;

@end

@implementation ControllerHistory

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rc = self.view.bounds;
    rc.origin.y = 20;
    rc.size = CGSizeMake(250, 39);
    rc.origin.x = (self.view.bounds.size.width-rc.size.width)*0.5;
    _ctrlSwitch = [[CtrlSwitch alloc] initWithFrame:rc];
    _ctrlSwitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:_ctrlSwitch];

//    rc.size = CGSizeMake(150, 60);
//    _btnHistory = [[UIButton alloc] initWithFrame:CGRectIntegral(rc)];

    _btnHistory = _ctrlSwitch.btnFirst;
    _btnHistory.tag = UrlTypeHistory;
    _btnHistory.showsTouchWhenHighlighted = YES;
    _btnHistory.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    _btnHistory.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    _btnHistory.titleLabel.font = [UIFont systemFontOfSize:16];
    [_btnHistory setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_btnHistory setTitle:GetTextFromKey(@"LiShi") forState:UIControlStateNormal];
    [_btnHistory setImage:ImageFromSkinByName(@"ipad-btn-clock-1.png") forState:UIControlStateNormal];
    [_btnHistory setImage:ImageFromSkinByName(@"ipad-btn-clock.png") forState:UIControlStateSelected];
    [_btnHistory setImage:ImageFromSkinByName(@"ipad-btn-clock.png") forState:UIControlStateHighlighted];
    [_btnHistory addTarget:self action:@selector(onTouchBtnSwitch:) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.view addSubview:_btnHistory];

//    rc.origin.x = rc.size.width;
//    _btnFavorite = [[UIButton alloc] initWithFrame:CGRectIntegral(rc)];
    
    _btnFavorite = _ctrlSwitch.btnSecond;
    _btnFavorite.tag = UrlTypeBookmark;
    _btnFavorite.showsTouchWhenHighlighted = YES;
    _btnFavorite.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    _btnFavorite.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    _btnFavorite.titleLabel.font = [UIFont systemFontOfSize:16];
    [_btnFavorite setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_btnFavorite setTitle:GetTextFromKey(@"ShouCang") forState:UIControlStateNormal];
    [_btnFavorite setImage:ImageFromSkinByName(@"ipad-btn-star-1.png") forState:UIControlStateNormal];
    [_btnFavorite setImage:ImageFromSkinByName(@"ipad-btn-star.png") forState:UIControlStateSelected];
    [_btnFavorite setImage:ImageFromSkinByName(@"ipad-btn-star.png") forState:UIControlStateHighlighted];
    [_btnFavorite addTarget:self action:@selector(onTouchBtnSwitch:) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.view addSubview:_btnFavorite];
    
    rc = self.view.bounds;
    rc.size.height = 50;
    rc.origin.y = _ctrlSwitch.frame.origin.y+_ctrlSwitch.bounds.size.height+5;
    _btnEdit = [[UIButton alloc] initWithFrame:rc];
    _btnEdit.showsTouchWhenHighlighted = YES;
    _btnEdit.titleLabel.font = [UIFont systemFontOfSize:16];
    [_btnEdit setTitle:GetTextFromKey(@"BianJi") forState:UIControlStateNormal];
    _btnEdit.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_btnEdit addTarget:self action:@selector(onTouchEdit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnEdit];
    
    rc = self.view.bounds;
    rc.origin.y = _btnEdit.frame.origin.y+_btnEdit.bounds.size.height;
    rc.size.height = self.view.bounds.size.height-rc.origin.y;
    _tbData = [[UITableView alloc] initWithFrame:rc];
    _tbData.delegate = self;
    _tbData.dataSource = self;
    _tbData.rowHeight = 60;
    _tbData.backgroundColor = [UIColor clearColor];
    _tbData.separatorColor = [UIColor lightGrayColor];
    _tbData.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_tbData];
    
    [self onTouchBtnSwitch:_btnHistory];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(whenDayModeChanged) name:kNotifDayModeChanged object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self whenDayModeChanged];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (_tbData.isEditing && UrlTypeBookmark==_urlType) {
        [_btnEdit setTitle:GetTextFromKey(@"BianJi") forState:UIControlStateNormal];
        [_tbData setEditing:NO animated:YES];
    }
}

#pragma mark - notif
- (void)whenDayModeChanged {
    BOOL dayMode = isDayMode;
    self.view.backgroundColor = [UIColor colorWithWhite:dayMode?1:0.5 alpha:0.6];
    
    UIColor *textColor = dayMode?kTextColorDay:kTextColorNight;
    [_btnHistory setTitleColor:textColor forState:UIControlStateSelected];
    [_btnFavorite setTitleColor:textColor forState:UIControlStateSelected];
    [_btnEdit setTitleColor:textColor forState:UIControlStateNormal];
    
    CGFloat colorVal = dayMode?230:120;
    UIColor *bgColor = RGBA_COLOR(colorVal, colorVal, colorVal, 0.6);
    _ctrlSwitch.backgroundColor = bgColor;
    _btnEdit.backgroundColor = bgColor;
    
    [self reloadData];
}

#pragma mark - buttons action
- (void)loadDataWithUrlType:(UrlType)urlType {
    _urlType = urlType;
    if (!_arrUrl) {
        _arrUrl = [NSMutableArray array];
    }
    [_arrUrl removeAllObjects];
    
    if (UrlTypeBookmark == urlType)
        [_arrUrl addObjectsFromArray:[ADOFavorite queryWityUid:[WKSync shareWKSync].modelUser.uid dataType:WKSyncDataTypeFavorite withGuest:NO]];
    else
        [_arrUrl addObjectsFromArray:[ADOFavorite queryWityUid:[WKSync shareWKSync].modelUser.uid dataType:WKSyncDataTypeHistory withGuest:NO]];
    
    [_tbData reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)reloadData {
    [self loadDataWithUrlType:_urlType];
}

- (void)clearHistory {
    [[WKSync shareWKSync] syncDelAllHistory];
    
    [ADOFavorite deleteWithDataType:WKSyncDataTypeHistory uid:[WKSync shareWKSync].modelUser.uid];
    
    [self reloadData];
    
    [ViewIndicator showSuccessWithStatus:GetTextFromKey(@"QingChuJiLuChengGong")  duration:1.0];
}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrUrl.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *favCellId = @"favCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:favCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:favCellId]
               ;
        cell.backgroundColor = [UIColor clearColor];

        UILabel *lbTitle = cell.textLabel;
        lbTitle.font = [UIFont boldSystemFontOfSize:16];

        UILabel *lbLink = cell.detailTextLabel;
        lbLink.font = [UIFont systemFontOfSize:13];
    }
    
    BOOL dayMode = isDayMode;
    ModelUrl_ipad *modelUrl = [_arrUrl objectAtIndex:indexPath.row];
    
    UILabel *lbTitle = cell.textLabel;
    lbTitle.text = modelUrl.title;
    lbTitle.textColor = dayMode?kTextColorDay:kTextColorNight;
    
    UILabel *lbLink = cell.detailTextLabel;
    lbLink.text = modelUrl.link;
    lbLink.textColor = dayMode?[UIColor grayColor]:[UIColor lightGrayColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    ModelUrl_ipad *modelUrl = [_arrUrl objectAtIndex:indexPath.row];
    if (UrlTypeBookmark==_urlType) {
        // 同步相关
        [[WKSync shareWKSync] syncDelWithDataType:WKSyncDataTypeFavorite fid_server:modelUrl.fid_server];
        
        [[WKSync shareWKSync] syncDelWithDataType:WKSyncDataTypeFavorite fid_server:modelUrl.fid_server];
        if ([_delegate respondsToSelector:@selector(vcHistory:didDeleteFavUrl:)])
            [_delegate vcHistory:self didDeleteFavUrl:modelUrl.link];
    }
    else {
        // 同步相关
        [[WKSync shareWKSync] syncDelWithDataType:WKSyncDataTypeHistory fid_server:modelUrl.fid_server];
        
        [ADOFavorite deleteWithDataType:WKSyncDataTypeHistory link:modelUrl.link uid:[WKSync shareWKSync].modelUser.uid];
    }
    
    [_arrUrl removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ModelUrl_ipad *modelUrl = [_arrUrl objectAtIndex:indexPath.row];
    if ([_delegate respondsToSelector:@selector(vcHistory:didSelectUrl:)])
        [_delegate vcHistory:self didSelectUrl:modelUrl.link];
}

#pragma mark - buttons actions
- (void)onTouchBtnSwitch:(UIButton *)btn {
    [self loadDataWithUrlType:(UrlType)btn.tag];
    
    btn.selected = YES;
    
    if (UrlTypeBookmark == _urlType) {
        _btnHistory.selected = NO;
        // 选择 我的收藏
        [_btnEdit setTitle:GetTextFromKey(@"BianJi") forState:UIControlStateNormal];
    }
    else {
        _btnFavorite.selected = NO;
        // 选择 历史记录
        if (_tbData.isEditing) {
            [_tbData setEditing:NO animated:NO];
        }
        [_btnEdit setTitle:GetTextFromKey(@"QingChuLiShi") forState:UIControlStateNormal];
    }
}

- (void)onTouchEdit:(UIButton *)btnEdit {
    if (UrlTypeBookmark == _urlType) {
        // 我的收藏
        if (_tbData.isEditing) {
            [_btnEdit setTitle:GetTextFromKey(@"BianJi") forState:UIControlStateNormal];
            [_tbData setEditing:NO animated:YES];
        }
        else {
            [_btnEdit setTitle:GetTextFromKey(@"WanCheng") forState:UIControlStateNormal];
            [_tbData setEditing:YES animated:YES];
        }
    }
    else {
        // 清除历史记录
        if (isPadIdiom) {
            [[[UIAlertView alloc] initWithTitle:nil
                                         message:@"确认清除所有浏览记录？"
                                        delegate:self
                               cancelButtonTitle:GetTextFromKey(@"QuXiao")
                               otherButtonTitles:GetTextFromKey(@"QingChuLiShi"), nil]
            show];
        }
        else {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                      delegate:self
                                                             cancelButtonTitle:GetTextFromKey(@"QuXiao")
                                                        destructiveButtonTitle:GetTextFromKey(@"QingChuLiShi")
                                                             otherButtonTitles: nil]
                                        ;
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
            [actionSheet showInView:self.view];
        }
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [self clearHistory];
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.destructiveButtonIndex == buttonIndex) {
        [self clearHistory];
    }
}

@end
