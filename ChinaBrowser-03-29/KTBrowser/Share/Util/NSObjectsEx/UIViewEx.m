//
//  UIView+EX.m
//
//  Created by Glex on 13-7-19.
//  Copyright (c) 2013年 VeryApps. All rights reserved.
//

#import "UIViewEx.h"

#import <objc/runtime.h>

static const void *UserDataKey = &UserDataKey;

#define kTagForImageViewBg 99999

@implementation UIView (UIViewEx)

@dynamic userData;

- (id)userData {
    return objc_getAssociatedObject(self, UserDataKey);
}

- (void)setUserData:(id)userData {
    objc_setAssociatedObject(self, UserDataKey, userData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setBgImageWithStretchImage:(UIImage *)img {
    UIImageView *ivBg = (UIImageView *)[self viewWithTag:kTagForImageViewBg];
    if (!ivBg || ![ivBg isKindOfClass:[UIImageView class]]) {
        ivBg = [[UIImageView alloc] initWithFrame:self.bounds];
        ivBg.tag = kTagForImageViewBg;
        ivBg.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    
    ivBg.image = img;
    [self insertSubview:ivBg atIndex:0];
}

- (void)setBgColorWithImageName:(NSString *)imgName {
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:imgName ofType:@"png"];
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:imgPath]];
}

@end
