//
//  UIViewHome.h
//  KTBrowser
//
//  Created by David on 14-3-8.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMPageControl.h"
#import "UIScrollViewCenter.h"

@interface UIViewHome : UIView <UIScrollViewDelegate>
{
    
    IBOutlet UIScrollViewCenter *_scrollViewCenter;
    IBOutlet SMPageControl *_pageControl;
}

@end
