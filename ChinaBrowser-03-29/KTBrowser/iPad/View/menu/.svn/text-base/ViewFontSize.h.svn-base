//
//  ViewFontSize.h
//

#import "UIViewPanel.h"

#import "ViewFontSizeDelegate.h"

@interface ViewFontSize : UIViewPanel {
    IBOutlet UISlider *_slider;
    
    IBOutlet UILabel *_labelContent;
    IBOutlet UILabel *_labelFontsize;
    
    CGFloat _fontAdjust;
}

@property (nonatomic, weak) IBOutlet id<ViewFontSizeDelegate> delegate;

- (void)setFontAdjust:(CGFloat)fontAdjust;

+ (ViewFontSize *)viewFontSizeFromXib;

@end
