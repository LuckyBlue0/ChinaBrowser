//
//  ViewSlider_ipad.h
//

#import <UIKit/UIKit.h>

@protocol ViewSliderDelegate_ipad;

@interface ViewSlider_ipad : UIControl {
    UIImageView *_imgEmpty;
    UIImageView *_imgFull;
    UIImageView *_imgDot;
    
    UIPanGestureRecognizer *_pan;
    
    float _lastOffset;
    float _percent;
}

@property (weak,nonatomic) id<ViewSliderDelegate_ipad> delegate;

- (void)setValue:(CGFloat)value;

@end

@protocol ViewSliderDelegate_ipad <NSObject>

- (void)valueChange:(float)value;

@end
