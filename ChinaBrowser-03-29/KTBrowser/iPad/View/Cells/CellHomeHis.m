//
//  CellHomeHis.m
//

#import "CellHomeHis.h"

#import <QuartzCore/QuartzCore.h>

@implementation CellHomeHis {
    CALayer *_line;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.clipsToBounds = YES;
        
        [self whenDayModeChanged];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self setNeedsDisplay];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
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

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.clipsToBounds = YES;
    
    [self whenDayModeChanged];
}

+ (CellHomeHis *)cellHomeHisFromXib {
    return [[NSBundle mainBundle] loadNibNamed:@"CellHomeHis" owner:nil options:nil][0];
}

#pragma mark - notif
- (void)whenDayModeChanged {
    BOOL dayMode = isDayMode;
    UIColor *textColor = dayMode?kTextColorDay:kTextColorNight;
    self.selectedBackgroundView.backgroundColor = dayMode?RGB_COLOR(230, 230, 230):RGB_COLOR(70, 70, 70);
    _labelTitle.textColor = textColor;
    _labelLink.textColor = textColor;
}

@end
