//
//  UIControlTag.m
//  browser9374
//
//  Created by arBao on 8/23/13.
//  Copyright (c) 2013 arBao. All rights reserved.
//

#import "CtrlTag_ipad.h"

@interface CtrlTag_ipad () {
    UIImageView *_imgBackground;
    
    BOOL _stateIsSelected;
}

@end

@implementation CtrlTag_ipad

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGRect rc = self.bounds;
        rc.origin.y = 1;
        _imgBackground = [[UIImageView alloc] initWithFrame:rc];
        _imgBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:_imgBackground];
        
        rc = CGRectMake(20, 5, 18, 18);
        _imgIcon = [[UIImageView alloc] initWithFrame:rc];
        _imgIcon.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imgIcon];

        rc.origin.x += rc.size.width+5;
        rc.size.width = 130;
        _labTitle = [[UILabel alloc] initWithFrame:rc];
        _labTitle.font = [UIFont systemFontOfSize:14];
        _labTitle.text = GetTextFromKey(@"XinBiaoQian");
        _labTitle.backgroundColor = [UIColor clearColor];
        _labTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:_labTitle];
        
        rc = self.bounds;
        rc.size.width = rc.size.height;
        rc.origin.x = self.bounds.size.width-rc.size.width-13;
        _btnClose = [[UIButton alloc] initWithFrame:rc];
        [self addSubview:_btnClose];

        [self setSelectState:YES];
    }
    
    return self;
}

- (void)fixSubviews {
    BOOL dayMode = isDayMode;
    
    UIColor *textColor = [UIColor grayColor];
    UIColor *highlightedColor = dayMode?kTextColorDay:kTextColorNight;
    _labTitle.textColor = _stateIsSelected?highlightedColor:textColor;
    _labTitle.highlightedTextColor = highlightedColor;

    [_btnClose setImage:ImageFromSkinByName(@"btn-close.png") forState:UIControlStateNormal];

    NSString *imgName = _stateIsSelected?@"biaoqian.png":@"biaoqian-1.png";
    if(!_iconHaveSet) {
        [_imgIcon setImage:ImageFromSkinByName(imgName)];
    }
    
    imgName = _stateIsSelected?@"bt-bianqian-1.png":@"bt-bianqian-0.png";
    [_imgBackground setImage:ImageFromSkinByName(imgName)];
}

#pragma mark - notif
- (void)whenDayModeChanged {
    [self fixSubviews];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    _labTitle.highlighted = highlighted;
}

- (void)setSelectState:(BOOL)select {
    _stateIsSelected = select;
    if(select) {
        [self.superview bringSubviewToFront:self];
    }
    else {
        [self.superview sendSubviewToBack:self];
    }
    
    [self fixSubviews];
}

@end
