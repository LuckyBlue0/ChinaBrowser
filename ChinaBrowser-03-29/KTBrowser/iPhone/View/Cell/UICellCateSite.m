//
//  UICellCateSite.m
//  KTBrowser
//
//  Created by David on 14-3-6.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UICellCateSite.h"

#import "UIViewCateSiteItem.h"

@implementation UICellCateSite
{
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

- (void)layoutSubviews
{
    if (_numberOfCol>0 && _numberOfRow>0) {
        _itemHeight = self.bounds.size.height/_numberOfRow;
        _itemWidth = self.bounds.size.width/_numberOfCol;
        NSUInteger itemCount = self.contentView.subviews.count;
        
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
        NSUInteger itemCount = self.contentView.subviews.count;
        
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
        CGFloat dash[] = {5, 1.5};//第一个是8.0是实线的长度，第2个8.0是空格的长度
        CGContextSetLineDash(context, 1, dash, 2); //给虚线设置下类型，其中2是dash数组大小，如果想设置个性化的虚线 可以将dash数组扩展下即可
        
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

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.clipsToBounds = YES;
}

+ (UICellCateSite *)cellCateSiteFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:@"UICellCateSite" owner:nil options:nil][0];
}

- (void)setArrSite:(NSArray *)arrSite
{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _numberOfRow = ceil(arrSite.count/(CGFloat)_numberOfCol);
    
    NSInteger itemCount = arrSite.count;
    for (NSInteger i=0; i<itemCount; i++) {
        NSDictionary *dicItem = arrSite[i];
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
        viewItem.userInteractionEnabled = NO;
        [self.contentView addSubview:viewItem];
        
    }
    
    [self setNeedsLayout];
}

@end
