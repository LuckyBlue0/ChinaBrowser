//
//  UICellHistoryHome.m
//  KTBrowser
//
//  Created by David on 14-3-7.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UICellHistoryHome.h"

#import <QuartzCore/QuartzCore.h>

@implementation UICellHistoryHome
{
    CALayer *_line;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 0.4);
    CGContextSetStrokeColorWithColor(context, [[UIColor darkGrayColor] CGColor]);
    CGFloat dash[] = {5, 1};//第一个是实线的长度，第2个是空格的长度
    CGContextSetLineDash(context, 1, dash, 2); //给虚线设置下类型，其中2是dash数组大小，如果想设置个性化的虚线 可以将dash数组扩展下即可
    
    // 横线
    CGContextMoveToPoint(context, 0, self.bounds.size.height);
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
    
    CGContextStrokePath(context);
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.clipsToBounds = YES;
}

+ (UICellHistoryHome *)cellHistoryFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:@"UICellHistoryHome" owner:nil options:nil][0];
}

@end
