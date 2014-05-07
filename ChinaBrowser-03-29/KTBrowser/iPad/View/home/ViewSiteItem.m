//
//  ViewSiteItem.m
//  KTBrowser
//
//  Created by Glex on 14-3-12.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ViewSiteItem.h"

@implementation ViewSiteItem

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGRect rc = self.bounds;
        rc.size.width = rc.size.height;
        _ivIcon = [[UIImageView alloc] initWithFrame:rc];
        [self addSubview:_ivIcon];
        
        rc.origin.x = rc.size.width;
        rc.size.width = frame.size.width-rc.origin.x;
        _lbTitle = [[UILabel alloc] initWithFrame:rc];
        [self addSubview:_lbTitle];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    CGRect rc = self.bounds;
    if (!_ivIcon) {
        _lbTitle.frame = rc;
        _lbTitle.textAlignment = CustomTextAlignmentCenter;
        return;
    }

    if (!_lbTitle.text.length) {
        _ivIcon.frame = rc;
        _ivIcon.contentMode = UIViewContentModeCenter;
        return;
    }
    
    rc.size.width = rc.size.width/2-5;
    _ivIcon.frame = rc;
    _ivIcon.contentMode = UIViewContentModeRight;
    
    rc.origin.x = rc.size.width+10;
    _lbTitle.frame = rc;
    _lbTitle.textAlignment = CustomTextAlignmentLeft;
}

- (void)whenDayModeChanged {
//    _lbTitle.textColor = isDayMode?kTextColorDay:kTextColorNight;
}

@end
