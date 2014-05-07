//
//  ViewFindInPage_ipad.m
//  ChinaBrowser
//
//  Created by Glex on 14-3-20.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ViewFindInPage_ipad.h"

@interface ViewFindInPage_ipad ()

@property (nonatomic, strong) IBOutlet UIView *viewText;

@end

@implementation ViewFindInPage_ipad

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self fixSubviews];
    [self setFindDesc];
    
    _viewText.layer.cornerRadius = 5;
    _viewText.layer.borderWidth = 0.8;
    _viewText.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)setAlpha:(CGFloat)alpha {
    [super setAlpha:alpha];
    
    if (alpha == 1) {
        [self fixSubviews];
    }
    else {
        [_txtWord resignFirstResponder];
    }
}

- (void)setFindIndex:(NSInteger)findIndex {
    _findIndex = findIndex;
    
    [self setFindDesc];
}

- (void)setFindCount:(NSInteger)findCount {
    _findCount = findCount;
    
    [self setFindDesc];
}

- (void)setFindDesc {
    if (_findCount == 0) {
        _btnPrev.enabled = _btnNext.enabled = NO;
    }
    else {
        _btnPrev.enabled = _findIndex>0;
        _btnNext.enabled = _findIndex<_findCount-1;
    }

    _lbCount.text = [NSString stringWithFormat:@"%d/%d", (_findCount==0?0:_findIndex+1), _findCount];
}

- (void)whenDayModeChanged {
    [self fixSubviews];
}

- (void)fixSubviews {
    BOOL dayMode = isDayMode;
    
    [self setBgImageWithStretchImage:[getMenuImageWithName(dayMode?@"bg-set-bai":@"bg-set-ye") stretchableImageWithLeftCapWidth:32 topCapHeight:32]];
    
    _viewText.backgroundColor = dayMode?[UIColor whiteColor]:kMainBgColorNight;
    UIColor *textColor = dayMode?kTextColorDay:kTextColorNight;
    _txtWord.textColor = _lbCount.textColor = textColor;
    //    _btnPrev.backgroundColor = dayMode?kMainBgColorDay:kMainBgColorNight;
    //    _btnNext.backgroundColor = dayMode?kMainBgColorDay:kMainBgColorNight;
    NSString *imgName = dayMode?@"btn-prev-0":@"btn-prev-1";
    [_btnPrev setImage:getMenuImageWithName(imgName) forState:UIControlStateNormal];
    imgName = dayMode?@"btn-prev-1":@"btn-prev-0";
    [_btnPrev setImage:getMenuImageWithName(imgName) forState:UIControlStateDisabled];
    
    imgName = dayMode?@"btn-next-0":@"btn-next-1";
    [_btnNext setImage:getMenuImageWithName(imgName) forState:UIControlStateNormal];
    imgName = dayMode?@"btn-next-1":@"btn-next-0";
    [_btnNext setImage:getMenuImageWithName(imgName) forState:UIControlStateDisabled];
    
    imgName = dayMode?@"btn-close-0":@"btn-close-1";
    [_btnClose setImage:getMenuImageWithName(imgName) forState:UIControlStateNormal];
    imgName = dayMode?@"btn-close-1":@"btn-close-0";
    [_btnClose setImage:getMenuImageWithName(imgName) forState:UIControlStateDisabled];
}

@end
