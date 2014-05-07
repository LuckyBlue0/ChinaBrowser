//
//  CellHomeHis.h
//

#import <UIKit/UIKit.h>

#import "CellSuper_ipad.h"

@interface CellHomeHis : CellSuper_ipad

@property (nonatomic, strong) IBOutlet UIImageView *imageViewIcon;
@property (nonatomic, strong) IBOutlet UILabel *labelTitle;
@property (nonatomic, strong) IBOutlet UIImageView *imageViewArrow;
@property (nonatomic, strong) IBOutlet UILabel *labelLink;

+ (CellHomeHis *)cellHomeHisFromXib;

@end
