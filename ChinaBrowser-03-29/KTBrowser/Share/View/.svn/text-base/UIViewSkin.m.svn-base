//
//  UIViewSkin.m
//  KTBrowser
//
//  Created by David on 14-2-17.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewSkin.h"

@interface UIViewSkin ()

- (void)updateUIModeNotification;

@end

@implementation UIViewSkin

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateUIModeNotification)
                                                     name:KTNotificationUpdateUIMode
                                                   object:nil];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUIModeNotification)
                                                 name:KTNotificationUpdateUIMode
                                               object:nil];
}

- (void)updateUIModeNotification
{
    [self updateUIMode];
}


- (void)updateUIMode
{
    
}

@end
