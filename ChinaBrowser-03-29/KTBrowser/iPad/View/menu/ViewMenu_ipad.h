//
//  ViewMenu_ipad.h
//

#import "ViewSuper_ipad.h"

#import "CtrlMenuItem_ipad.h"

@class ViewSlider_ipad;

@interface ViewMenu_ipad : ViewSuper_ipad <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imgSunFull;
@property (strong, nonatomic) IBOutlet UIImageView *imgSunZero;
@property (strong, nonatomic) ViewSlider_ipad *viewSlider;

@property (strong, nonatomic) IBOutlet UIImageView *imgBackground;

// 清除记录
@property (strong, nonatomic) IBOutlet CtrlMenuItem_ipad *ctrlClearHis;
@property (strong, nonatomic) IBOutlet UIImageView *imgClearHis;
@property (strong, nonatomic) IBOutlet UILabel *lbClearHis;
// 屏幕锁定
@property (strong, nonatomic) IBOutlet CtrlMenuItem_ipad *ctrlScreenLock;
@property (strong, nonatomic) IBOutlet UIImageView *imgScreenLock;
@property (strong, nonatomic) IBOutlet UILabel *lbScreenLock;
// 无痕浏览
@property (strong, nonatomic) IBOutlet CtrlMenuItem_ipad *ctrlStealthMode;
@property (strong, nonatomic) IBOutlet UIImageView *imgStealthMode;
@property (strong, nonatomic) IBOutlet UILabel *lbStealthMode;
// 黑夜/日间 模式
@property (strong, nonatomic) IBOutlet CtrlMenuItem_ipad *ctrlDayMode;
@property (strong, nonatomic) IBOutlet UIImageView *imgDayMode;
@property (strong, nonatomic) IBOutlet UILabel *lbDayMode;
// 无图模式
@property (strong, nonatomic) IBOutlet CtrlMenuItem_ipad *ctrlNoImgMode;
@property (strong, nonatomic) IBOutlet UIImageView *imgNoImgMode;
@property (strong, nonatomic) IBOutlet UILabel *lbNoImgMode;

// 字体大小
@property (strong, nonatomic) IBOutlet CtrlMenuItem_ipad *ctrlFontSize;
@property (strong, nonatomic) IBOutlet UIImageView *imgFontSize;
@property (strong, nonatomic) IBOutlet UILabel *lbFontSize;

@property (strong, nonatomic) IBOutlet UIScrollView *svMenu;

/*
 * view tools
 */
@property (strong, nonatomic) IBOutlet UIButton *btnSetting;
@property (strong, nonatomic) IBOutlet UIButton *btnTools;
@property (strong, nonatomic) IBOutlet UIImageView *ivSign;
// 截图涂鸦
@property (strong, nonatomic) IBOutlet CtrlMenuItem_ipad *ctrlScreenshot;
@property (strong, nonatomic) IBOutlet UIImageView *imgScreenshot;
@property (strong, nonatomic) IBOutlet UILabel *lbScreenshot;
// 二维码
@property (strong, nonatomic) IBOutlet CtrlMenuItem_ipad *ctrl2dCode;
@property (strong, nonatomic) IBOutlet UIImageView *img2dCode;
@property (strong, nonatomic) IBOutlet UILabel *lb2dCode;
// 页内查找
@property (strong, nonatomic) IBOutlet CtrlMenuItem_ipad *ctrlFindInPage;
@property (strong, nonatomic) IBOutlet UIImageView *imgFindInPage;
@property (strong, nonatomic) IBOutlet UILabel *lbFindInPage;

/////////////////////////////
@property (strong, nonatomic) IBOutlet UIView *viewBrightness;
@property (strong, nonatomic) IBOutlet UISlider *sliderBrightness;

// 皮肤
@property (strong, nonatomic) IBOutlet CtrlMenuItem_ipad *ctrlSkin;
@property (strong, nonatomic) IBOutlet UIImageView *imgSkin;
@property (strong, nonatomic) IBOutlet UILabel *lbSkin;
// 分享
@property (strong, nonatomic) IBOutlet CtrlMenuItem_ipad *ctrlShare;
@property (strong, nonatomic) IBOutlet UIImageView *imgShare;
@property (strong, nonatomic) IBOutlet UILabel *lbShare;
// 更新
@property (strong, nonatomic) IBOutlet CtrlMenuItem_ipad *ctrlUpdate;
@property (strong, nonatomic) IBOutlet UIImageView *imgUpdate;
@property (strong, nonatomic) IBOutlet UILabel *lbUpdate;
// 反馈
@property (strong, nonatomic) IBOutlet CtrlMenuItem_ipad *ctrlFeedback;
@property (strong, nonatomic) IBOutlet UIImageView *imgFeedback;
@property (strong, nonatomic) IBOutlet UILabel *lbFeedback;

@end
