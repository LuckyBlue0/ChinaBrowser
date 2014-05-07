//
//  ViewTagsBar_ipad.m
//

#import "ViewTagsBar_ipad.h"

#import "CtrlTag_ipad.h"

#import "ViewIndicator.h"

#define kTabWidth 215
#define kTabHeight 30

@interface ViewTagsBar_ipad () {
    CGFloat _tabOriginY;
}

@end

@implementation ViewTagsBar_ipad

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

static int yinshenWidth = 42;

- (void)awakeFromNib  {
    [super awakeFromNib];
    
    _tabOriginY = _btnAdd.frame.origin.y;
    
    _viewYinShen = [[UIView alloc] initWithFrame:CGRectMake(0-yinshenWidth, _tabOriginY, yinshenWidth, 32)];
    _viewYinShen.hidden = YES;
    _viewYinShen.backgroundColor = [UIColor clearColor];
    [self addSubview:_viewYinShen];
    
    _img = [[UIImageView alloc] initWithFrame:_viewYinShen.bounds];
    CGRect rc = _img.frame;
    rc.size.width = 52;
    rc.origin = CGPointZero;
    _img.frame = rc;
    _img.contentMode = UIViewContentModeScaleAspectFit;
    [_img setImage:ImageFromSkinByName(@"title-btn-0.png")];
    [_viewYinShen addSubview:_img];
    
    rc = self.bounds;
    rc.size.width -= 30;
    _svTags = [[UIScrollView alloc] initWithFrame:rc];
    _svTags.bounces = YES;
    _svTags.delegate = self;
    _svTags.showsHorizontalScrollIndicator = NO;
    _svTags.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self insertSubview:_svTags belowSubview:_viewYinShen];
    
    [self addTag];
    [self changeStealthMode];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStealthMode) name:kNotifStealthModeChanged object:nil];
}

- (void)whenDeviceDidRotate {
    BOOL stealthMode = [AppManager stealthMode];
    CGRect rc = _svTags.frame;
    rc.origin.x = (stealthMode ? yinshenWidth:0);
    rc.size.width = SCREEN_SIZE_IPAD.width-rc.origin.x-_btnAdd.bounds.size.width;
    _svTags.frame = rc;
}

- (void)changeStealthMode {
    BOOL stealthMode = [AppManager stealthMode];

    if (stealthMode) {
        _viewYinShen.hidden = NO;
    }
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect rc = _svTags.frame;
                         rc.origin.x = (stealthMode ? yinshenWidth:0);
                         rc.size.width = SCREEN_SIZE_IPAD.width-rc.origin.x-_btnAdd.bounds.size.width;
                         _svTags.frame = rc;
                         
                         rc = _viewYinShen.frame;
                         rc.origin.x = stealthMode?0:-yinshenWidth;
                         _viewYinShen.frame = rc;
                         _viewYinShen.alpha = stealthMode;
                         
                     }
                     completion:^(BOOL finished) {
                         if (!stealthMode) {
                             _viewYinShen.hidden = YES;
                         }
                     }
     ];
}

- (void)whenDayModeChanged {
     [_img setImage:ImageFromSkinByName(@"title-btn-0.png")];
}

#pragma mark - scrollview
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

#pragma mark - btns
- (void)onClickTag:(CtrlTag_ipad *)tag {
    if(_tmpTag == tag) {
        return;
    }
    else {
        [_tmpTag setSelectState:NO];
        [tag setSelectState:YES];
        _tmpTag = tag;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifTagSelected object:[NSNumber numberWithInteger:tag.tag]];
    }
}

- (void)onClickCloseTag:(UIButton *)btn {
    if(_arrTags.count == 1) {
        return;
    }
    
    CtrlTag_ipad *tag = [_arrTags objectAtIndex:btn.tag];
    [self tagShow:NO withTag:tag];
    
    int index = [_arrTags indexOfObject:tag];
    
    if(index != _arrTags.count - 1 && _arrTags.count > 2 && index == _tmpTag.tag) {
        _tmpTag = [_arrTags objectAtIndex:index + 1];
        [_tmpTag setSelectState:YES];
    }
    else if(index == 1 && _arrTags.count == 2) {
        _tmpTag = [_arrTags objectAtIndex:0];
        [_tmpTag setSelectState:YES];
        [self onClickTag:_tmpTag];
    }
    else if (index == _arrTags.count - 1) {
        _tmpTag = [_arrTags objectAtIndex:_arrTags.count - 2];
        [_tmpTag setSelectState:YES];
        [self onClickTag:_tmpTag];
    }
    else if (index == 0 && _tmpTag.tag == index) {
        _tmpTag = [_arrTags objectAtIndex:1];
        [_tmpTag setSelectState:YES];
        
        [self onClickTag:_tmpTag];
    }
    [WebviewsManager deleteWebviewByIndex:index];
    [_arrTags removeObjectAtIndex:index];

    [self reloadTheTagOfTag];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifTagSelected object:[NSNumber numberWithInteger:_tmpTag.tag]];
}

#pragma mark - methods
- (void)addTag {
    if (!_arrTags) {
        _arrTags = [[NSMutableArray alloc] init];
    }
    
    [_tmpTag setSelectState:NO];
    
    CtrlTag_ipad *tag = [[CtrlTag_ipad alloc] initWithFrame:CGRectMake(_arrTags.count*(kTabWidth-15), _tabOriginY, kTabWidth, kTabHeight)];
    tag.tag = tag.btnClose.tag = _arrTags.count;
    [tag addTarget:self action:@selector(onClickTag:) forControlEvents:UIControlEventTouchUpInside];
    [tag.btnClose addTarget:self action:@selector(onClickCloseTag:) forControlEvents:UIControlEventTouchUpInside];
    [_svTags addSubview:tag];
    [_arrTags addObject:tag];

    _btnAdd.enabled = (_arrTags.count<kMaxTagNum);
    
    _tmpTag = tag;
    [self tagShow:YES withTag:tag];
    [self resizeTagsTabWithScrollAnimation:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifNewTagAdded object:nil];
}

- (void)resizeTagsTabWithScrollAnimation:(BOOL)animated {
    int contentSizeWidth = 0;
    for (UIView *view in _svTags.subviews) {
        if (![view isKindOfClass:[CtrlTag_ipad class]]) {
            continue;
        }
        contentSizeWidth += (kTabWidth-15);
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        _svTags.contentSize = CGSizeMake(contentSizeWidth+15, 30);
    }];
    
    if(animated)
        [_svTags scrollRectToVisible:CGRectMake(contentSizeWidth, 0, 1024, 30) animated:YES];
}

- (void)reloadTheTagOfTag {
    _btnAdd.enabled = (_arrTags.count<kMaxTagNum);
    
    for(int i=0;i<_arrTags.count;i++) {
        CtrlTag_ipad *view = [_arrTags objectAtIndex:i];
        view.btnClose.tag = i;
        view.tag = i;
    }
}

#pragma mark - tagAnimation
- (void)tagShow:(BOOL)show withTag:(CtrlTag_ipad *)tag {
    if(show) {
        __block CGRect rc = tag.frame;
        rc.origin.y = tag.frame.size.height+_tabOriginY;
        tag.frame = rc;
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             rc.origin.y = _tabOriginY;
                             tag.frame = rc;
                         }
                         completion:nil];
    }
    else {
        __block CGRect rc = tag.frame;
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             rc.origin.y = tag.frame.size.height+_tabOriginY;
                             tag.frame = rc;
                             
                             for (int i=tag.tag+1; i<_arrTags.count; i++) {
                                 CtrlTag_ipad *view = [_arrTags objectAtIndex:i];
                                 rc = view.frame;
                                 rc.origin.x -= (kTabWidth-15);
                                 view.frame = rc;
                             }
                         }
                         completion:^(BOOL finished){
                             if(finished) {
                                 [[NSNotificationCenter defaultCenter] postNotificationName:kNotifTagDeleted object:[NSNumber numberWithInt:[_arrTags indexOfObject:tag]]];
                                 [tag removeFromSuperview];
                                 [_arrTags removeObject:tag];
                                 
                                 [self reloadTheTagOfTag];
                                 [self resizeTagsTabWithScrollAnimation:NO];
                             }
                         }];
    }
}

@end
