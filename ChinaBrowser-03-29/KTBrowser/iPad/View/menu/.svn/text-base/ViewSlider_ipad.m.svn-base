//
//  UIViewSlider.m
//  browser9374
//
//  Created by arBao on 14-1-22.
//  Copyright (c) 2014年 arBao. All rights reserved.
//

#import "ViewSlider_ipad.h"

@implementation ViewSlider_ipad

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        int width = 12;
        int height = 12;
        _imgDot = [[UIImageView alloc] initWithFrame:CGRectMake(3, self.frame.size.height / 2 - height/ 2, width, height)];
        [_imgDot setImage:getMenuImageWithName(@"switch-1-btn-1") ];
        
        _imgFull = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height / 2 - 16/2, self.frame.size.width, 16)];
        [_imgFull setImage:[getMenuImageWithName(@"switch-1-bg-1")  stretchableImageWithLeftCapWidth:8 topCapHeight:0]];
        
        _imgEmpty = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height / 2 - 16/2, self.frame.size.width, 16)];
        [_imgEmpty setImage:[getMenuImageWithName(@"switch-1-bg-0")  stretchableImageWithLeftCapWidth:8 topCapHeight:0]];
        
        _imgDot.contentMode = UIViewContentModeCenter;
        
        [self addSubview:_imgEmpty];
        [self addSubview:_imgFull];
        [self addSubview:_imgDot];
        
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
        [self addGestureRecognizer:_pan];
    }
    
    return self;
}

- (void)setValue:(CGFloat)value {
    _percent = value;
    
    [self changedValueFromPan:NO];
}

- (void)changedValueFromPan:(BOOL)fromPan {
    if(_percent < 0.02
       || _percent > 0.98) {
        BOOL minVal = _percent<0.02;
        
        _percent = minVal?0:1;
        CGRect rc = _imgFull.frame;
        rc.size.width = minVal?0:self.frame.size.width;
        _imgFull.frame = rc;
        
        rc = _imgEmpty.frame;
        rc.size.width = minVal?self.frame.size.width:0;
        _imgEmpty.frame = rc;
        
        if (!fromPan) {
            rc = _imgDot.frame;
            rc.origin.x = minVal?3:self.frame.size.width-rc.size.width-3;
            _imgDot.frame = rc;
        }
        
        [_imgDot setImage:getMenuImageWithName(minVal?@"switch-1-btn-0":@"switch-1-btn-1")];
    }
    else {
        CGRect rc = _imgFull.frame;
        rc.size.width = 6+_imgDot.frame.size.width+_percent*(self.frame.size.width-_imgDot.frame.size.width-6);
        _imgFull.frame = rc;
        
        rc = _imgEmpty.frame;
        rc.size.width = self.frame.size.width;
        _imgEmpty.frame = rc;
        
        if (!fromPan) {
            rc = _imgDot.frame;
            rc.origin.x = 3+(self.frame.size.width-rc.size.width-6)*_percent;
            _imgDot.frame = rc;
        }
        
        [_imgDot setImage:getMenuImageWithName(@"switch-1-btn-1")];
    }
}

- (void)onPan:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:pan.view];
    [pan setTranslation:point inView:pan.view];
    
    float offsset = point.x - _lastOffset;
    CGRect rc = _imgDot.frame;
    rc.origin.x += offsset;
    if (rc.origin.x >= 3
        && rc.origin.x <= self.frame.size.width-rc.size.width-3) {
        _percent =  (float)(rc.origin.x-3)/(self.frame.size.width-rc.size.width-6);
        _imgDot.frame = rc;
        
        [self changedValueFromPan:YES];
    }
    if([_delegate respondsToSelector:@selector(valueChange:)]) {
        [_delegate valueChange:_percent];
    }
    
    _lastOffset = point.x;
    
    if(pan.state == UIGestureRecognizerStateEnded) {
        _lastOffset = 0;
    }
}

@end
