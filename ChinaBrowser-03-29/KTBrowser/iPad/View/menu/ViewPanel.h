//
//  ViewPanel.h
//

#import "ViewSuper_ipad.h"

@interface ViewPanel : ViewSuper_ipad {
    UIView *_viewContent;
    UILabel *_labelTitle;
}

@property (nonatomic, strong) IBOutlet UILabel *labelTitle;
@property (nonatomic, strong) IBOutlet UIView *viewContent;

- (void)showInView:(UIView *)view completion:(void(^)(void))completion;
- (void)dismissWithCompletion:(void(^)(void))completion;

@end
