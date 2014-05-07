//
//  ViewTagsBar_ipad.h
//

#import <UIKit/UIKit.h>

#import "ViewSuper_ipad.h"

@class CtrlTag_ipad;

@interface ViewTagsBar_ipad : ViewSuper_ipad <UIScrollViewDelegate> {
    UIView *_viewYinShen;
    CtrlTag_ipad *_tmpTag;
    UIImageView *_img;
}

@property (nonatomic, assign) UIButton *btnAdd;
@property (nonatomic, strong) NSMutableArray *arrTags;
@property (nonatomic, strong) UIScrollView *svTags;

- (void)addTag;
- (void)onClickTag:(CtrlTag_ipad *)tag;

@end
