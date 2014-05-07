//
//  UIViewCateSiteContent.m
//  KTBrowser
//
//  Created by David on 14-2-17.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewCateSiteContent.h"

#import <QuartzCore/QuartzCore.h>
#import "UIViewCateSiteItem.h"
#import "BlockUI.h"

@interface UIViewCateSiteContent ()

@end

@implementation UIViewCateSiteContent

- (void)setNumberOfCol:(NSUInteger)numberOfCol
{
    _numberOfCol = numberOfCol;
    [self setNeedsLayout];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        self.exclusiveTouch = NO;
        
        _numberOfCol = 1;
        _dashLine = YES;
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Initialization code
    self.clipsToBounds = YES;
    self.exclusiveTouch = NO;
    
    _numberOfCol = 1;
    _dashLine = YES;
}

- (void)layoutSubviews
{
    if (_numberOfCol>0 && _numberOfRow>0) {
        _itemHeight = self.bounds.size.height/_numberOfRow;
        _itemWidth = self.bounds.size.width/_numberOfCol;
        NSUInteger itemCount = self.subviews.count;
        
        CGRect rc = CGRectMake(0, 0, _itemWidth, _itemHeight);
        
        for (NSInteger i=0; i<itemCount; i++) {
            UIView *subView = self.subviews[i];
            NSInteger col = GetColWithIndexCol(i, _numberOfCol);
            NSInteger row = GetRowWithIndexCol(i, _numberOfCol);
            rc.origin.x = rc.size.width*col;
            rc.origin.y = rc.size.height*row;
            subView.frame = rc;
        }
        
        [self setNeedsDisplay];
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (_numberOfCol>0 && _numberOfRow>0) {
        _itemHeight = self.bounds.size.height/_numberOfRow;
        _itemWidth = self.bounds.size.width/_numberOfCol;
        NSUInteger itemCount = self.subviews.count;
        
        CGRect rc = CGRectMake(0, 0, _itemWidth, _itemHeight);
        
        for (NSInteger i=0; i<itemCount; i++) {
            UIView *subView = self.subviews[i];
            NSInteger col = GetColWithIndexCol(i, _numberOfCol);
            NSInteger row = GetRowWithIndexCol(i, _numberOfCol);
            rc.origin.x = rc.size.width*col;
            rc.origin.y = rc.size.height*row;
            subView.frame = rc;
        }
        
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    if (_numberOfCol>0 && _numberOfRow>0) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetLineWidth(context, _borderWidth);
        CGContextSetStrokeColorWithColor(context, [_borderColor CGColor]);
        if (_dashLine) {
            CGFloat dash[] = {5, 1.5};//第一个是8.0是实线的长度，第2个8.0是空格的长度
            CGContextSetLineDash(context, 1, dash, 2); //给虚线设置下类型，其中2是dash数组大小，如果想设置个性化的虚线 可以将dash数组扩展下即可
        }
        
        // 竖线
        for (NSInteger i=0; i<_numberOfCol-1; i++) {
            CGContextMoveToPoint(context, (i+1)*_itemWidth, 0);
            CGContextAddLineToPoint(context, (i+1)*_itemWidth, self.bounds.size.height);
        }
        
        // 横线
        for (NSInteger i=0; i<_numberOfRow-1; i++) {
            CGContextMoveToPoint(context, 0, (i+1)*_itemHeight);
            CGContextAddLineToPoint(context, self.bounds.size.width, (i+1)*_itemHeight);
        }
        
        CGContextStrokePath(context);
    }
}

#pragma mark -

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self highlight:YES atPoint:[touch locationInView:self] response:NO];
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    BOOL b =[super continueTrackingWithTouch:touch withEvent:event];
    [self highlight:b atPoint:[touch locationInView:self] response:NO];
    return b;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self highlight:NO atPoint:[touch locationInView:self] response:YES];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    [self highlight:NO atPoint:CGPointZero response:NO];
}

- (void)highlight:(BOOL)higthlight atPoint:(CGPoint)point response:(BOOL)response
{
    for (NSInteger i=0; i<self.subviews.count; i++) {
        UIViewCateSiteItem *subView = self.subviews[i];
        if (CGRectContainsPoint(subView.frame, point)) {
            if (higthlight) {
                subView.backgroundColor = _highlightColor?_highlightColor:[UIColor clearColor];
            }
            else if (response) {
                UIView *viewTarget = [AppConfig config].rootController.view;
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:[subView convertRect:subView.bounds toView:viewTarget]];
                imageView.image = [UIImage imageFromView:subView];
                [viewTarget addSubview:imageView];
                imageView.alpha = 0.9;
                [UIView animateWithDuration:0.5 animations:^{
                    imageView.transform = CGAffineTransformMakeScale(2, 2);
                    imageView.alpha = 0;
                } completion:^(BOOL finished) {
                    [imageView removeFromSuperview];
                }];
                
                [_delegate viewCateSiteContent:self didSelectItem:subView];
                [UIView animateWithDuration:0.3 animations:^{
                    subView.backgroundColor = [UIColor clearColor];
                }];
            }
        }
        else {
            [UIView animateWithDuration:0.3 animations:^{
                subView.backgroundColor = [UIColor clearColor];
            }];
        }
    }
}

- (void)setArrSite:(NSArray *)arrSite
{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _arrSite = arrSite;
    
    _numberOfRow = ceil(_arrSite.count/(CGFloat)_numberOfCol);
    
    NSInteger itemCount = _arrSite.count;
    for (NSInteger i=0; i<itemCount; i++) {
        NSDictionary *dicItem = _arrSite[i];
        UIViewCateSiteItem *viewItem = [UIViewCateSiteItem viewCateSiteItemFromXib];
        viewItem.tag = i;
        UIImage *image = [UIImage imageWithFilename:[NSString stringWithFormat:@"home.bundle/%@.png", dicItem[@"icon"]]];
        if (image) {
            viewItem.imageViewIcon.image = image;
            viewItem.imageViewIcon.contentMode = UIViewContentModeCenter;
        }
        else {
            [viewItem.imageViewIcon removeFromSuperview];
            viewItem.imageViewIcon = nil;
            viewItem.labelTitle.frame = viewItem.bounds;
            viewItem.labelTitle.textAlignment = UITextAlignmentCenter;
        }
        viewItem.labelTitle.text = dicItem[@"title"];
        viewItem.labelTitle.font = [UIFont systemFontOfSize:10];
        viewItem.labelTitle.textColor = [UIColor darkGrayColor];
        viewItem.userInteractionEnabled = NO;
        [self addSubview:viewItem];
        
    }
    
    [self setNeedsLayout];
}

@end
