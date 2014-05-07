//
//  ViewHomeItem_ipad.m
//

#import "ViewHomeItem_ipad.h"

@implementation ViewHomeItem_ipad

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBgImageWithStretchImage:BundlePngImageForHome(isDayMode?@"wed-bg-bai":@"wed-bg-ye")];
        
        CGRect rc = self.bounds;
        rc.origin.x = 10;
        rc.size.width -= rc.origin.x*2;
        rc.size.height = 20;
        rc.origin.y = self.bounds.size.height-rc.size.height*1.5;
        _lbTitle = [[UILabel alloc] initWithFrame:rc];
        _lbTitle.backgroundColor = [UIColor clearColor];
        _lbTitle.font = [UIFont boldSystemFontOfSize:16];
        _lbTitle.textAlignment = UITextAlignmentCenter;
        _lbTitle.textColor = isDayMode?kTextColorDay:kTextColorNight;
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeCenter;
        
        rc.size = CGSizeMake(30, 30);
        rc.origin.y = 0;
        rc.origin.x = self.bounds.size.width-rc.size.width-2;
        _btnClose = [[BtnItemClose alloc] initWithFrame:rc];
        [_btnClose setImage:BundlePngImageForHome(@"btn-del") forState:UIControlStateNormal];
        _btnClose.hidden = YES;
        
        [self addSubview:_imageView];
        [self addSubview:_lbTitle];
        [self addSubview:_btnClose];
        
        int64_t delayInSeconds = 0.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self animWithDuration:0.6];
        });
    }
    
    return self;
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

- (void)animWithDuration:(NSTimeInterval)duration {
	CGContextRef context = UIGraphicsGetCurrentContext();

	[UIView beginAnimations:nil context:context];
    
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:duration];
    UIViewAnimationTransition transition = (UIViewAnimationTransition)(arc4random()%2+1);
	[UIView setAnimationTransition:transition forView:self cache:YES];

	[UIView commitAnimations];
}

#pragma mark - notif
- (void)whenDayModeChanged {
    _lbTitle.textColor = isDayMode?kTextColorDay:kTextColorNight;
    [self setBgImageWithStretchImage:BundlePngImageForHome(isDayMode?@"wed-bg-bai":@"wed-bg-ye")];
}

@end
