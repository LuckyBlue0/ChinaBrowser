//
//  ViewSkinItem.m
//  ChinaBrowser
//
//  Created by Glex on 14-3-27.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ViewSkinItem.h"

@interface ViewSkinItem () {
    UIImageView *_ivPic;
    UIImageView *_ivCover;
    UIImageView *_ivCheck;
}

@end

@implementation ViewSkinItem

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGRect rc = self.bounds;
        rc.size = CGSizeMake(100, 100);
        _ivPic = [[UIImageView alloc] initWithFrame:rc];
        _ivPic.center = self.center;
        _ivPic.clipsToBounds = YES;
        _ivPic.layer.cornerRadius = 10;
        _ivPic.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_ivPic];

        _ivCover = [[UIImageView alloc] initWithFrame:rc];
        _ivCover.center = self.center;
        [_ivCover setImageWithName:@"ipad-skin-cover"];
        [self addSubview:_ivCover];
        
        rc.size = CGSizeMake(30, 30);
        _btnClose = [[BtnItemClose alloc] initWithFrame:rc];
        _btnClose.userData = self;
        [_btnClose setImage:BundlePngImageForHome(@"btn-del") forState:UIControlStateNormal];
        _btnClose.hidden = YES;
        [self addSubview:_btnClose];

        rc.size = CGSizeMake(30, 30);
        rc.origin.x = frame.size.width-rc.size.width;
        rc.origin.y = frame.size.height-rc.size.height;
        _ivCheck = [[UIImageView alloc] initWithFrame:rc];
        _ivCheck.alpha = 0;
        [_ivCheck setImageWithName:@"ipad-skin-check"];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected {
    if (self.isSelected == selected) {
        return;
    }
    
    [super setSelected:selected];

    if (selected) {
        [self addSubview:_ivCheck];
    }
    _ivCheck.transform = CGAffineTransformMakeScale(selected?0.1:1, selected?0.1:1);
    [UIView animateWithDuration:0.3 animations:^{
        _ivCheck.alpha = selected;
        _ivCheck.transform = CGAffineTransformMakeScale(selected?1:0.1, selected?1:0.1);
    } completion:^(BOOL finished) {
        if (!selected) {
            _ivCheck.transform = CGAffineTransformIdentity;
            [_ivCheck removeFromSuperview];
        }
    }];
}

- (void)setShaking:(BOOL)shaking {
    if (_shaking == shaking) {
        return;
    }
    _shaking = shaking;
    
    _btnClose.hidden = !shaking;
    _btnClose.userInteractionEnabled = shaking;
    
    static CABasicAnimation *animShake = nil;
    if (shaking && !animShake) {
        animShake = [CABasicAnimation animationWithKeyPath:@"transform"];
        animShake.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-0.03, 0, 0, 1.0)];
        animShake.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.03, 0, 0, 1.0)];
        animShake.autoreverses = YES;
        animShake.duration = 0.1;
        animShake.repeatCount = 0xFFFFFFFF;
    }
    if (shaking) {
        [self.layer addAnimation:animShake forKey:@"shake"];
    }
    else {
        [self.layer removeAnimationForKey:@"shake"];
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    self.alpha = highlighted?0.6:1;
    [UIView animateWithDuration:0.5 animations:^{
       self.transform = CGAffineTransformMakeScale(highlighted?1.05:1, highlighted?1.05:1);
    }];
}

- (void)setSkinPic:(UIImage *)skinPic {
    if (_skinPic != skinPic) {
        _skinPic = skinPic;
        _ivPic.image = skinPic;
    }
}

@end
