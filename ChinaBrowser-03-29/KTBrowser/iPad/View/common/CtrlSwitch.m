//
//  CtrlSwitch.m
//  KTBrowser
//
//  Created by Glex on 14-3-17.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "CtrlSwitch.h"

@interface CtrlSwitch () {
    UIView *_viewMove;
}

@end

@implementation CtrlSwitch

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = frame.size.height*0.5;
        
        CGRect rc = self.bounds;
        rc.origin = CGPointMake(2, 2);
        rc.size.width = rc.size.width*0.5-rc.origin.x*2;
        rc.size.height -= rc.origin.y*2;
        _viewMove = [[UIButton alloc] initWithFrame:rc];
        _viewMove.clipsToBounds = YES;
        _viewMove.userInteractionEnabled = NO;
        _viewMove.layer.cornerRadius = rc.size.height*0.5;
        [self addSubview:_viewMove];

        _btnFirst = [[UIButton alloc] initWithFrame:CGRectIntegral(rc)];
        _btnFirst.userInteractionEnabled = NO;
        _btnFirst.backgroundColor = [UIColor clearColor];
        [_btnFirst addTarget:self action:@selector(onTouchBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnFirst];
        
        rc.origin.x = self.bounds.size.width-rc.size.width-2;
        _btnSecond = [[UIButton alloc] initWithFrame:CGRectIntegral(rc)];
        _btnSecond.backgroundColor = [UIColor clearColor];
        [_btnSecond addTarget:self action:@selector(onTouchBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnSecond];
        
        [self whenDayModeChanged];
    }
    
    return self;
}

- (void)onTouchBtn:(UIButton *)btn {
    self.selected = (btn!=_btnFirst);
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    _btnFirst.userInteractionEnabled = selected;
    _btnSecond.userInteractionEnabled = !selected;
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rc = _viewMove.frame;
        rc.origin.x = (selected?_btnSecond:_btnFirst).frame.origin.x;
        _viewMove.frame = rc;
    } completion:^(BOOL finished) {
        _btnFirst.selected = !selected;
        _btnSecond.selected = selected;
    }];
}

#pragma mark - notif
- (void)whenDayModeChanged {
    BOOL dayMode = isDayMode;
    _viewMove.backgroundColor = [UIColor colorWithWhite:dayMode?1:0.5 alpha:1];
}

@end
