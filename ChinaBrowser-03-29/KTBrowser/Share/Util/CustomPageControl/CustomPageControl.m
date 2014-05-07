//
//  CustomPageControl.m
//
//  Created by glex on 13-7-21.
//  Copyright (c) 2013年 VeryApps. All rights reserved.
//

#import "CustomPageControl.h"

#define TagWithIndex(index) (index+800)

@interface CustomPageControl () {
    UIImage *_imgNormal;
    UIImage *_imgSelected;
}

@end

@implementation CustomPageControl

- (void)drawRect:(CGRect)rect {
    [self updateDots];
}

- (void)setImgNameNormal:(NSString *)imgNameNormal imgNameSelected:(NSString *)imgNameSelected {
    _imgNormal = [UIImage imageNamed:imgNameNormal];
    _imgSelected = [UIImage imageNamed:imgNameSelected];

    self.backgroundColor = [UIColor clearColor];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    
    [self updateDots];
}

- (void)updateDots {
    if (_imgNormal && _imgSelected) {
        NSArray *subviews = self.subviews;
        for (NSInteger idx=0; idx<subviews.count; idx++) {
            UIImageView *dot = [subviews objectAtIndex:idx];
            if ([dot isKindOfClass:[UIImageView class]]) {
                dot.image = (self.currentPage==idx)?_imgSelected:_imgNormal;
                if (dot.tag != TagWithIndex(idx)) {
                    dot.tag = TagWithIndex(idx);
                    
                    [dot sizeToFit];
                }
            }
            else { // iOS 7.0 and later
                [dot removeFromSuperview];
                
                UIImageView *ivDot = [[UIImageView alloc] initWithImage:((self.currentPage==idx)?_imgSelected:_imgNormal)];
                ivDot.tag = TagWithIndex(idx);
                
                CGRect rc = ivDot.frame;
                rc.origin.y = (self.bounds.size.height-rc.size.width)*0.5;
                CGFloat spaceX = (self.bounds.size.width-subviews.count*rc.size.width)/subviews.count;
                rc.origin.x = (rc.size.width+spaceX)*idx+spaceX*0.5;
                ivDot.frame = rc;
                
                [self addSubview:ivDot];
            }
        }
    }
}

@end
