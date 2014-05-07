//
//  ControllerAddSite.m
//

#import "ControllerAddSite.h"

#import <QuartzCore/QuartzCore.h>

#import "ModelUrl_ipad.h"
#import "ADOFavorite.h"

#import "WKSync.h"

@interface ControllerAddSite () {
    IBOutlet UIView *_viewTitle;
    IBOutlet UIView *_viewUrl;
    
    IBOutlet UITextField *_txtTitle;
    IBOutlet UITextField *_txtUrl;
    
    IBOutlet UIButton *_btnCancel;
    IBOutlet UIButton *_btnConfirm;
    
    IBOutlet UIButton *_btnFromFav;
    IBOutlet UIButton *_btnFromHis;
    
    IBOutlet UITableView *_tbData;
        
    NSMutableArray *_arrUrl;
    UrlType        _urlType;
    
    UIControl   *_viewBg;
    BOOL        _show;
    
    BOOL _phoneStyle;
}

- (void)hideKeyboard;
- (void)loadDataWithUrlType:(UrlType)urlType;

- (IBAction)onTouchCancel;
- (IBAction)onTouchConfirm;
- (IBAction)onTouchBtnFrom:(UIButton *)btn;
- (void)onTouchViewBg;

@end

@implementation ControllerAddSite

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB_COLOR(239, 239, 239);
    self.view.clipsToBounds = NO;
    self.view.layer.cornerRadius = 5;
    self.view.layer.shadowRadius = 5;
    self.view.layer.shadowOpacity = 1;
    self.view.layer.shadowOffset = CGSizeZero;
    self.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
    
    if (isIOS(7) && (UIUserInterfaceIdiomPhone==UI_USER_INTERFACE_IDIOM())) {
        CGRect rc = _btnCancel.superview.frame;
        rc.origin.y = 20;
        rc.size.height -= rc.origin.y;
        _btnCancel.superview.frame = rc;
    }
    
    _txtTitle.delegate = _txtUrl.delegate = self;
    _txtTitle.placeholder = NSLocalizedString(@"title", 0);
    [_btnCancel setTitle:NSLocalizedString(@"cancel", 0) forState:UIControlStateNormal];
    [_btnConfirm setTitle:NSLocalizedString(@"ok", 0) forState:UIControlStateNormal];
    
    UIColor *borderColor = [UIColor colorWithWhite:0.85 alpha:1];
    _btnCancel.layer.cornerRadius = 5;
    _btnCancel.layer.borderWidth = 1;
    _btnCancel.layer.borderColor = borderColor.CGColor;
    
    _btnConfirm.layer.cornerRadius = 5;
    _btnConfirm.layer.borderWidth = 1;
    _btnConfirm.layer.borderColor = borderColor.CGColor;
    _btnFromHis.tag = UrlTypeHistory;
    _btnFromHis.layer.borderWidth = 1;
    _btnFromHis.layer.borderColor = borderColor.CGColor;
    _btnFromFav.tag = UrlTypeBookmark;
    _btnFromFav.layer.borderWidth = 0;
    _btnFromFav.layer.borderColor = borderColor.CGColor;
    
    _viewTitle.superview.layer.cornerRadius = 8;
    _viewTitle.layer.borderWidth = 1;
    _viewTitle.layer.borderColor = borderColor.CGColor;
    _viewTitle.clipsToBounds = NO;
    _viewTitle.layer.shadowRadius = 2;
    _viewTitle.layer.shadowOpacity = 0;
    _viewTitle.layer.shadowOffset = CGSizeZero;
    _viewTitle.layer.shadowColor = [UIColor redColor].CGColor;
    _viewTitle.layer.shadowPath = [UIBezierPath bezierPathWithRect:_viewTitle.bounds].CGPath;
    
    _viewUrl.layer.borderWidth = 1;
    _viewUrl.layer.borderColor = borderColor.CGColor;
    _viewUrl.clipsToBounds = NO;
    _viewUrl.layer.shadowRadius = 2;
    _viewUrl.layer.shadowOpacity = 0;
    _viewUrl.layer.shadowOffset = CGSizeZero;
    _viewUrl.layer.shadowColor = [UIColor redColor].CGColor;
    _viewUrl.layer.shadowPath = [UIBezierPath bezierPathWithRect:_viewUrl.bounds].CGPath;
    
    _viewUrl.superview.layer.borderWidth = 1;
    _viewUrl.superview.layer.borderColor = borderColor.CGColor;
    
    _tbData.layer.cornerRadius = 8;
    _tbData.delegate = self;
    _tbData.dataSource = self;
    _tbData.rowHeight = 60;
    _tbData.layer.borderWidth = 1;
    _tbData.layer.borderColor = borderColor.CGColor;
    
    [self onTouchBtnFrom:_btnFromHis];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadDataWithUrlType:_urlType];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self hideKeyboard];
}

- (void)hideKeyboard {
    [_txtTitle resignFirstResponder];
    [_txtUrl resignFirstResponder];
}

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

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrUrl.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *historyIdentifier = @"historyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:historyIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:historyIdentifier];
        
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    
    [cell.imageView setImageWithName:(_urlType==UrlTypeBookmark?@"cell-collection":@"cell-history")];
    ModelUrl_ipad *modelUrl = [_arrUrl objectAtIndex:indexPath.row];
    cell.textLabel.text = modelUrl.title;
    cell.detailTextLabel.text = modelUrl.link;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ModelUrl_ipad *modelUrl = [_arrUrl objectAtIndex:indexPath.row];
    _txtTitle.text = modelUrl.title;
    _txtUrl.text = modelUrl.link;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self hideKeyboard];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _txtUrl) {
        textField.text = @"http://";
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _txtTitle) {
        if (_txtTitle.text.length==0) {
            _viewTitle.layer.shadowOpacity = 1;
        }
        else {
            _viewTitle.layer.shadowOpacity = 0;
            [_txtUrl becomeFirstResponder];
        }
    }
    else {
        [self onTouchConfirm];
    }
    
    return YES;
}

#pragma mark - methods
- (void)showSubviews:(BOOL)show {
    if (_show == show) {
        return;
    }
    _show = show;

    if (!_viewBg) {
        _viewBg = [[UIControl alloc] initWithFrame:_delegate.view.bounds];
        _viewBg.alpha = 0;
        _viewBg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _viewBg.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [_viewBg addTarget:self action:@selector(onTouchViewBg) forControlEvents:UIControlEventTouchDown];
    }

    CGRect rc = self.view.frame;
    BOOL idiomPhone = UIUserInterfaceIdiomPhone==UI_USER_INTERFACE_IDIOM();
    if (idiomPhone) {
        rc = _delegate.view.bounds;
        rc.origin.y = show?_delegate.view.bounds.size.height:0;
    }
    else {
        rc.origin.x = (_delegate.view.bounds.size.width-rc.size.width)*0.5;
        rc.origin.y = show?_delegate.view.bounds.size.height:((_delegate.view.bounds.size.height-rc.size.height)*0.5);
    }
    self.view.frame = rc;
    if (idiomPhone && !_phoneStyle) {
        self.view.clipsToBounds = YES;
        self.view.layer.cornerRadius = 0;
        self.view.layer.shadowRadius = 0;
        self.view.layer.shadowOpacity = 0;
        self.view.layer.shadowOffset = CGSizeZero;
        self.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
        
        _viewTitle.layer.shadowPath = [UIBezierPath bezierPathWithRect:_viewTitle.bounds].CGPath;
        _viewUrl.layer.shadowPath = [UIBezierPath bezierPathWithRect:_viewUrl.bounds].CGPath;
        
        _phoneStyle = YES;
    }
    
    if (show) {
//        [_txtTitle becomeFirstResponder];
        _viewBg.frame = _delegate.view.bounds;
        [_delegate.view addSubview:_viewBg];
        [_delegate.view addSubview:self.view];
    }
    else {
        [self hideKeyboard];
    }
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         _viewBg.alpha = (CGFloat)show;
                         self.view.alpha = (CGFloat)show;
                         
                         CGRect rc = self.view.frame;
                         rc.origin.y = show?(idiomPhone?0:(_delegate.view.bounds.size.height-rc.size.height)*0.5):_delegate.view.bounds.size.height;
                         self.view.frame = rc;
                     }
                     completion:^(BOOL finished) {
                         if (!show) {
                             [_viewBg removeFromSuperview];
                             [self.view removeFromSuperview];
                         }
                     }
     ];
}

- (IBAction)onTouchCancel {
    [self showSubviews:NO];
}

- (IBAction)onTouchConfirm {
    BOOL bFlag = YES;
    
    if (_txtTitle.text.length==0) {
        bFlag = NO;
        _viewTitle.layer.shadowOpacity = 1;
    }
    else {
        _viewTitle.layer.shadowOpacity = 0;
    }
    
    if (_txtUrl.text.length==0) {
        bFlag = NO;
        _viewUrl.layer.shadowOpacity = 1;
    }
    else {
        _viewUrl.layer.shadowOpacity = 0;
    }
    
    if (!bFlag) {
        return;
    }
    
    [_txtTitle resignFirstResponder];
    [_txtUrl resignFirstResponder];
    
    if ([_delegate respondsToSelector:@selector(vcAddSite:title:url:)]) {
        NSString *link = _txtUrl.text;
        if (!([link hasPrefix:@"http://"] || [link hasPrefix:@"https://"])) {
            link = [@"http://" stringByAppendingString:link];
        }
        
        NSString *url = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                              (CFStringRef)link,
                                                                              NULL,
                                                                              NULL,//(CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                                                              kCFStringEncodingUTF8));
        [_delegate vcAddSite:self title:_txtTitle.text url:url];
    }
}

- (IBAction)onTouchBtnFrom:(UIButton *)btn {
    [self loadDataWithUrlType:(UrlType)btn.tag];
    
    _btnFromHis.selected = _btnFromFav.selected = NO;
    _btnFromHis.layer.borderWidth = _btnFromFav.layer.borderWidth = 1;
    _btnFromHis.backgroundColor = _btnFromFav.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    
    btn.selected = YES;
    btn.layer.borderWidth = 0;
    btn.backgroundColor = [UIColor clearColor];
    
    [self hideKeyboard];
}

- (void)onTouchViewBg {
    [self showSubviews:NO];
}

@end
