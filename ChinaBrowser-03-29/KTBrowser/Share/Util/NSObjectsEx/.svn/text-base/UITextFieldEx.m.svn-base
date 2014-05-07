//
//  UITextFieldEx.m
//
//  Created by Glex on 13-7-09.
//  Copyright (c) 2013年 VeryApps. All rights reserved.
//

#import "UITextFieldEx.h"

@implementation UITextFieldEx

// 设置 placeHolder 颜色、字体
- (void)drawPlaceholderInRect:(CGRect)rect {
    if (!_placeholderColor) { // 不能用透明度
        _placeholderColor = [UIColor lightGrayColor];
    }
    if (!_placeholderFont) {
        _placeholderFont = self.font;
    }
    [_placeholderColor setFill];
    rect.origin.y = (rect.size.height-_placeholderFont.pointSize)*0.5;

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000 // 7.0sdk之前
    [self.placeholder drawInRect:rect withFont:_placeholderFont];
#else
    [self.placeholder drawInRect:rect withAttributes:@{NSFontAttributeName:_placeholderFont}];
#endif

}

- (UIImageView *)ivIcon {
    if (!_ivIcon) {
        CGRect rc = self.bounds;
        rc.size.width = rc.size.height;
        _ivIcon = [[UIImageView alloc] initWithFrame:rc];
        _ivIcon.contentMode = UIViewContentModeCenter;
        self.leftView = _ivIcon;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    
    return _ivIcon;
}

@end
