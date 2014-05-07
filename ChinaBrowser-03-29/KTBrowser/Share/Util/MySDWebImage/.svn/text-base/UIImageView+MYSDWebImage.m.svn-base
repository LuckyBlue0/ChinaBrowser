//
//  UIImageView+MYSDWebImage.m
//  MySDWebImage
//
//  Created by arBao on 7/30/13.
//  Copyright (c) 2013 arBao. All rights reserved.
//

#import "UIImageView+MYSDWebImage.h"
#import "MYSDWebImageManager.h"


@implementation UIImageView (MYSDWebImage)

-(void)setCircleImageWithUrl:(NSString *)url
{
    if(url == nil) {
        return;
    }
    
    self.image = nil;
    
    MYSDWebImageManager *manager = [MYSDWebImageManager shareMYSDWebImageManager];
    
    [manager cancelForDelegate:self];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:typeOfCircle],@"type",[NSNumber numberWithInt:0],@"width",[NSNumber numberWithInt:0],@"height",[NSNumber numberWithInt:0],@"corners", nil];
    
    [manager setImageWithUrl:url Delegate:self withInfo:dic];
}

- (void)setImageWithUrl:(NSString *)url
{
    if(url == nil) {
        return;
    }
    
    
    self.image = nil;
     
    MYSDWebImageManager *manager = [MYSDWebImageManager shareMYSDWebImageManager];
    
    [manager cancelForDelegate:self];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:typeOfNormal],@"type",[NSNumber numberWithInt:0],@"width",[NSNumber numberWithInt:0],@"height",[NSNumber numberWithInt:0],@"corners", nil];
    
    [manager setImageWithUrl:url Delegate:self withInfo:dic];
//    NSLog(@"setImageWithUrl:url Delegate:self withInfo:dic  %p",dic);
}

-(void)setImageWithUrl:(NSString *)url withImageWidth:(int)width Height:(int)height andCorners:(int)corners
{
    if(url == nil) {
        return;
    }
    
    self.image = nil;
    
    MYSDWebImageManager *manager = [MYSDWebImageManager shareMYSDWebImageManager];
    
    [manager cancelForDelegate:self];

    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:typeOfSizeAndCorners],@"type",[NSNumber numberWithInt:width],@"width",[NSNumber numberWithInt:height],@"height",[NSNumber numberWithInt:corners],@"corners", nil];
    
    [manager setImageWithUrl:url Delegate:self withInfo:dic];
}

- (void)mywebImageManager:(MYSDWebImageManager *)imageManager didFailWithError:(NSError *)error
{
    
}

- (void)mywebImageManager:(MYSDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image withAnimation:(BOOL)yesOrNo
{
    self.image = image;
    
    if(yesOrNo == YES) {
        self.alpha=0;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.alpha=1;
        }
                         completion:^(BOOL finished){
                             if(self.tag == imageViewShouldClearBackgroundColor)
                                 self.backgroundColor = [UIColor clearColor];
                         }];
    }
    else
    {
        if(self.tag == imageViewShouldClearBackgroundColor)
            self.backgroundColor = [UIColor clearColor];
    }
    
}

@end
