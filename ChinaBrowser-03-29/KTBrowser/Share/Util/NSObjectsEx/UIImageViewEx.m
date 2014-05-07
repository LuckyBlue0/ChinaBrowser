//
//  UIImageView+UIImageViewEx.m
//  ExpressQuickQuery
//
//  Created by Glex on 13-7-19.
//  Copyright (c) 2013年 VeryApps. All rights reserved.
//

#import "UIImageViewEx.h"

@implementation UIImageView (UIImageViewEx)

- (void)setImageWithName:(NSString *)imgName {
    [self setImageWithName:imgName ofType:@"png"];
}

- (void)setImageWithName:(NSString *)imgName ofType:(NSString *)ext {
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:imgName ofType:ext];
    if ([UIScreen mainScreen].scale == 2) {
        NSString *imgPath2 = [[NSBundle mainBundle] pathForResource:[imgName stringByAppendingString:@"@2x"] ofType:ext];
        if ([[NSFileManager defaultManager] fileExistsAtPath:imgPath2]) {
            imgPath = imgPath2;
        }
    }
    self.image = [UIImage imageWithContentsOfFile:imgPath];
}

@end
