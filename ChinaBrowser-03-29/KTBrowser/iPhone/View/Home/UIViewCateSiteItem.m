//
//  UIViewCateSiteItem.m
//  KTBrowser
//
//  Created by David on 14-3-6.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewCateSiteItem.h"

@implementation UIViewCateSiteItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+ (UIViewCateSiteItem *)viewCateSiteItemFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:@"UIViewCateSiteItem" owner:nil options:nil][0];
}
@end
