//
//  ControllerSuper_ipad.h
//

#import <UIKit/UIKit.h>

@interface ControllerSuper_ipad : UIViewController

@property (nonatomic, strong)UIView *viewContent;
@property (nonatomic, strong)CALayer *layerSuper;
@property (nonatomic, strong)CALayer *layerAdd;
@property (nonatomic, strong)UIView *viewAdd;
@property (nonatomic, assign)int index;

- (void)pushIn:(ControllerSuper_ipad *)controller ;
- (void)popOut;

@end
