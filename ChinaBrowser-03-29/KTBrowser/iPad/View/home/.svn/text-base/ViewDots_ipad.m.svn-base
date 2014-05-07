//
//  ViewDots_ipad.m
//  BrowserApp
//
//  Created by arBao on 14-2-24.
//  Copyright (c) 2014年 arBao. All rights reserved.
//

#import "ViewDots_ipad.h"

@implementation ViewDots_ipad

- (void)setPage:(int)pageNum {
    NSString *imgName = (pageNum==0)?@"ipad-btn-dot2-1.png":@"ipad-btn-dot2-0.png";
    [_imgDot1 setImage:ImageFromSkinByName(imgName)];
    imgName = (pageNum==0)?@"ipad-btn-dot2-0.png":@"ipad-btn-dot2-1.png";
    [_imgDot2 setImage:ImageFromSkinByName(imgName)];
}

- (void)setIphoneState {
    CGRect rc = _imgDot1.frame;
    rc.origin.x += 5;
    _imgDot1.frame = rc;
    
    rc = _imgDot2.frame;
    rc.origin.x -= 5;
    _imgDot2.frame = rc;
    
    [self whenDeviceDidRotate];
}

//重写该方法来更改多语言选项  在父类增加的监听通知
- (void)whenLangChanged {
    
}

//重写该方法来接收旋转  在父类增加的监听通知
- (void)whenDeviceDidRotate {

}

//重写该方法来更改日间黑夜模式  在父类增加的监听通知
- (void)whenDayModeChanged {
    
}

@end
