//
//  UIView+EX.h
//
//  Created by Glex on 13-7-19.
//  Copyright (c) 2013年 VeryApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIViewEx)

@property (nonatomic, weak) id userData;

- (void)setBgImageWithStretchImage:(UIImage *)img;
- (void)setBgColorWithImageName:(NSString *)imgName;

@end
