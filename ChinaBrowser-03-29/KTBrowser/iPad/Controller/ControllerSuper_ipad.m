//
//  ControllerSuper_ipad.m
//

#import "ControllerSuper_ipad.h"

#import "ViewIndicator.h"

@interface ControllerSuper_ipad () {
    float _lastOffset;
    BOOL _animating;
}

@end

@implementation ControllerSuper_ipad

- (void)viewDidLoad {
    [super viewDidLoad];

    _lastOffset = 0;
    
    CGRect rc = self.view.bounds;
    _viewContent = [[UIView alloc] initWithFrame:rc];
    _viewContent.clipsToBounds = YES;
    _viewContent.backgroundColor = [UIColor clearColor];
    _viewContent.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [_viewContent addGestureRecognizer:panGesture];
    [self.view addSubview:_viewContent];
}

- (void)dismiss:(BOOL)dismiss {
    if(dismiss) {
        [self popOut];
    }
    else {
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             CGRect rc = _viewContent.frame;
                             rc.origin.x = 0;
                             _viewContent.frame = rc;
                         }
                         completion:^(BOOL finished) {
                             
                         }
         ];
    }
}

- (void)onPan:(UIPanGestureRecognizer *)pan {
    if(self.navigationController.viewControllers.count <= 1)
        return;
    
    CGPoint point = [pan translationInView:pan.view];
    [pan setTranslation:point inView:pan.view];
    
    float offsset = point.x - _lastOffset;
    
    CGRect rc = _viewContent.frame;
    rc.origin.x += offsset ;
    
    _lastOffset = point.x;
    
    if(rc.origin.x <= 0) {
        return;
    }
    
    _viewContent.frame = rc;

    if(pan.state == UIGestureRecognizerStateEnded) {
        _lastOffset = 0;
        [self dismiss:(rc.origin.x>250)];
    }
}

- (void)pushIn:(ControllerSuper_ipad *)controller {
    [self.navigationController pushViewController:controller animated:NO];
    controller.index = [self.viewContent.superview.layer.sublayers indexOfObject:self.viewContent.layer];
    controller.layerAdd = self.viewContent.layer;
    controller.viewAdd = self.viewContent;
    controller.layerSuper = self.viewContent.superview.layer;

    CGRect rc = controller.viewContent.frame;
    rc.origin.x = rc.size.width;
    controller.viewContent.frame = rc;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rc = controller.viewContent.frame;
        rc.origin.x = 0;
        controller.viewContent.frame = rc;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)popOut {
    [ViewIndicator dismiss];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rc = _viewContent.frame;
        rc.origin.x = rc.size.width;
        _viewContent.frame = rc;
    } completion:^(BOOL finished) {
        [_layerSuper insertSublayer:_layerAdd atIndex:_index];
        [self.navigationController popViewControllerAnimated:NO];
    }];
}

@end
