//
//  ViewPanel.m
//

#import "ViewPanel.h"

@implementation ViewPanel

@synthesize viewContent = _viewContent;
@synthesize labelTitle = _labelTitle;

- (void)showInView:(UIView *)view completion:(void(^)(void))completion {
    self.frame = view.bounds;
    [view addSubview:self];
    
    _viewContent.transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height-_viewContent.frame.origin.y);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _viewContent.transform = CGAffineTransformIdentity;
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.3];
    } completion:^(BOOL finished) {
        if (completion) completion();
    }];
}

- (void)dismissWithCompletion:(void(^)(void))completion {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _viewContent.transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height-_viewContent.frame.origin.y);
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0];
    } completion:^(BOOL finished) {
        if (completion) completion();
        
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint pointTouch = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(_viewContent.frame, pointTouch)) {
        [self dismissWithCompletion:nil];
    }
}

@end
