//
//  UIButton+Ex.m
//  ExpressQuickQuery
//
//  Created by Glex on 13-7-19.
//  Copyright (c) 2013年 VeryApps. All rights reserved.
//

#import "UIButtonEx.h"

@implementation UIButton (UIButtonEx)

- (void)setImageWithName:(NSString *)imgName {
    [self setImageWithName:imgName forState:UIControlStateNormal];
}

- (void)setImageWithName:(NSString *)imgName forState:(UIControlState)state {
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:imgName ofType:@"png"];
    [self setImage:[UIImage imageWithContentsOfFile:imgPath] forState:state];
}

- (void)setBackgroundImageWithName:(NSString *)imgName {
    [self setBackgroundImageWithName:imgName forState:UIControlStateNormal];
}

- (void)setBackgroundImageWithName:(NSString *)imgName forState:(UIControlState)state {
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:imgName ofType:@"png"];
    [self setBackgroundImage:[UIImage imageWithContentsOfFile:imgPath] forState:state];
}

@end
