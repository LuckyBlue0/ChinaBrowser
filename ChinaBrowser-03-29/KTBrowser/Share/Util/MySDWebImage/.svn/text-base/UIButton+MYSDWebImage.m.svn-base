//
//  UIButton+MYSDWebImage.m
//  MySDWebImage
//
//  Created by arBao on 7/30/13.
//  Copyright (c) 2013 arBao. All rights reserved.
//

#import "UIButton+MYSDWebImage.h"
#import "MYSDWebImageManager.h"

@implementation UIButton (MYSDWebImage)
- (void)setImageWithUrl:(NSString *)url
{
    if(url == nil) {
        return;
    }
    MYSDWebImageManager *manager = [MYSDWebImageManager shareMYSDWebImageManager];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:typeOfNormal],@"type",[NSNumber numberWithInt:0],@"width",[NSNumber numberWithInt:0],@"height",[NSNumber numberWithInt:0],@"corners", nil];

    [manager setImageWithUrl:url Delegate:self withInfo:dic];
    
}

- (void)mywebImageManager:(MYSDWebImageManager *)imageManager didFailWithError:(NSError *)error
{
    
}

- (void)mywebImageManager:(MYSDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image withAnimation:(BOOL)yesOrNo
{
    [self setImage:image forState:UIControlStateNormal];
    
    if(yesOrNo==YES) {
        self.alpha=0;
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.alpha=1;
        }
                         completion:^(BOOL finished){
                             self.backgroundColor = [UIColor clearColor];
                         }];
    }
    else
    {
        self.backgroundColor = [UIColor clearColor];
    }
    
}



@end
