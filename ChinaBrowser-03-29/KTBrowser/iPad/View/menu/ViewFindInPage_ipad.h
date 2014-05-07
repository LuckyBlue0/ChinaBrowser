//
//  ViewFindInPage_ipad.h
//  ChinaBrowser
//
//  Created by Glex on 14-3-20.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ViewSuper_ipad.h"

@interface ViewFindInPage_ipad : ViewSuper_ipad

@property (nonatomic, strong) IBOutlet UITextFieldEx *txtWord;
@property (nonatomic, strong) IBOutlet UIButton *btnPrev;
@property (nonatomic, strong) IBOutlet UILabel *lbCount;
@property (nonatomic, strong) IBOutlet UIButton *btnNext;
@property (nonatomic, strong) IBOutlet UIButton *btnClose;

@property (nonatomic, assign) NSInteger findCount;
@property (nonatomic, assign) NSInteger findIndex;

@end
