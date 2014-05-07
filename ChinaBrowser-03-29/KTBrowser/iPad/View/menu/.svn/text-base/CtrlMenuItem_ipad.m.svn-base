//
//  CtrlMenuItem.m
//

#import "CtrlMenuItem_ipad.h"

@interface CtrlMenuItem_ipad ()

@property (nonatomic, weak) IBOutlet UILabel *labNormal;
@property (nonatomic, weak) IBOutlet UIImageView *imgNormal;

@end

@implementation CtrlMenuItem_ipad

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    
    CALayer *layer = self.layer;
    layer.borderWidth = 0;
    layer.borderColor = [UIColor colorWithWhite:0.7 alpha:1].CGColor;
    
    _labNormal.highlightedTextColor = [UIColor lightGrayColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(whenDayModeChanged) name:kNotifViewMenuShowed object:nil];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    _labNormal.highlighted = highlighted;
    _imgNormal.highlighted = highlighted;
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled {
    [super setUserInteractionEnabled:userInteractionEnabled];
    
    self.alpha = userInteractionEnabled?1:0.5;
}

#pragma mark - notif
- (void)whenDayModeChanged {
    _labNormal.textColor = isDayMode?kTextColorDay:kTextColorNight;
}

@end
