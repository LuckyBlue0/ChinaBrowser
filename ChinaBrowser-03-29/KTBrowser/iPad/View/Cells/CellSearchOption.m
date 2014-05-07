//
//  CellSearchOption.m
//  BrowserApp
//
//  Created by Glex on 14-3-08.
//  Copyright (c) 2014年 arBao. All rights reserved.
//

#import "CellSearchOption.h"

@interface CellSearchOption () {
    UIButton *_btnCheck;
}

@end

@implementation CellSearchOption

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *lbTitle = self.textLabel;
        lbTitle.font = [UIFont systemFontOfSize:14];
        lbTitle.backgroundColor = [UIColor clearColor];
        lbTitle.textColor = isDayMode?kTextColorDay:kTextColorNight;
        
        CGRect rc = self.bounds;
        rc.size.width = rc.size.height*1.2;
        rc.origin.x = self.bounds.size.width-rc.size.width;
        _btnCheck = [[UIButton alloc] initWithFrame:rc];
        _btnCheck.userInteractionEnabled = NO;
        [_btnCheck setImage:BundleImageForSearch(@"btn-check-dot") forState:UIControlStateSelected];
        _btnCheck.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:_btnCheck];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    _btnCheck.selected = selected;
}

#pragma mark - notif
- (void)whenDayModeChanged {
    self.textLabel.textColor = isDayMode?kTextColorDay:kTextColorNight;
}

@end
