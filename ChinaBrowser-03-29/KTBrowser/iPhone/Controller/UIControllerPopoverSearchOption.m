//
//  UIControllerPopoverSearchOption.m
//  KTBrowser
//
//  Created by David on 14-2-26.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIControllerPopoverSearchOption.h"

#import <QuartzCore/QuartzCore.h>

#import "UIViewSearchOptionItem.h"

@interface UIControllerPopoverSearchOption ()

- (void)createUIWithSearchOptioins:(NSArray *)arrOptions;
- (void)onTouchMenuItem:(UIViewSearchOptionItem *)viewMenuItem;

@end

@implementation UIControllerPopoverSearchOption

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _imageViewPop.image = [[UIImage imageWithFilename:[NSString stringWithFormat:@"Search.bundle/search_icon_popover_bg_%d.png", [AppConfig config].uiMode==UIModeDay?0:1]] stretchableImageWithLeftCapWidth:40 topCapHeight:40];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showInController:(UIViewController *)controller
                 options:(NSArray *)optioins
                position:(CGPoint)position
              completion:(void(^)(void))completion
{
    self.view.frame = controller.view.bounds;
    [controller addChildViewController:self];
    [controller.view addSubview:self.view];
    
    [self createUIWithSearchOptioins:optioins];
    
    _viewPopover.layer.anchorPoint = CGPointMake(17.0f/_viewContent.bounds.size.width, 0);
    _viewPopover.layer.position = position;
    _viewPopover.frame = CGRectIntegral(_viewPopover.frame);
    _viewPopover.transform = CGAffineTransformMakeScale(0, 0);
    _viewPopover.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        _viewPopover.transform = CGAffineTransformIdentity;
        _viewPopover.alpha = 1;
    } completion:^(BOOL finished) {
        if (completion) completion();
    }];
}

- (void)dismissWithCompletion:(void(^)(void))completion
{
    [UIView animateWithDuration:0.3 animations:^{
        _viewPopover.transform = CGAffineTransformMakeScale(0, 0);
        _viewPopover.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        
        if (completion) completion();
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchInSelf = [[touches anyObject] locationInView:self.view];
    
    if (!CGRectContainsPoint(_viewPopover.frame, touchInSelf)) {
        [self dismissWithCompletion:nil];
    }
}

- (void)createUIWithSearchOptioins:(NSArray *)arrOptions
{
    CGFloat maxContentWidth = MIN(self.view.bounds.size.width, 360)-25*2;
    CGSize itemSize = CGSizeMake(50, 55);
    CGFloat spaceX = 10;
    CGFloat spaceY = 5;
    NSInteger (^getColCount)() = ^(){
        CGFloat w = itemSize.width;
        NSInteger colCount = 0;
        while (w<=maxContentWidth) {
            colCount++;
            w+=itemSize.width+spaceX;
        }
        return colCount;
    };
    
    NSInteger colCount = MIN(getColCount(), arrOptions.count);
    NSInteger rowCount = ceilf((CGFloat)arrOptions.count/colCount);
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(15, 5, 5, 5);
    CGRect rc = _viewPopover.frame;
    rc.size.width = edgeInsets.left+edgeInsets.right+spaceX+(itemSize.width+spaceX)*colCount;
    rc.size.height = edgeInsets.top+edgeInsets.bottom+spaceY+(itemSize.height+spaceY)*rowCount;
    _viewPopover.frame = rc;
    
    for (NSInteger i=0; i<arrOptions.count; i++) {
        UIViewSearchOptionItem *viewMenuItem = [UIViewSearchOptionItem viewSearchOptionItemFromXib];
        viewMenuItem.tag = i;
        [viewMenuItem addTarget:self action:@selector(onTouchMenuItem:) forControlEvents:UIControlEventTouchUpInside];
        NSDictionary *dicSearch = arrOptions[i];
        UIImage *image = [UIImage imageWithFilename:[NSString stringWithFormat:@"Search.bundle/%@.png", dicSearch[@"icon"]]];
        viewMenuItem.imageViewIcon.image = image;
        viewMenuItem.labelTitle.text = dicSearch[@"name"];
        viewMenuItem.labelTitle.textColor = [AppConfig config].uiMode==UIModeDay?[UIColor darkGrayColor]:[UIColor whiteColor];
        
        NSInteger col = GetColWithIndexCol(i, colCount);
        NSInteger row = GetRowWithIndexCol(i, colCount);
        
        CGRect rcItem;
        rcItem.size = itemSize;
        rcItem.origin.x = spaceX+(rcItem.size.width+spaceX)*col;
        rcItem.origin.y = spaceY+(rcItem.size.height+spaceY)*row;
        viewMenuItem.frame = rcItem;
        
        [_viewContent addSubview:viewMenuItem];
    }
}

- (void)onTouchMenuItem:(UIViewSearchOptionItem *)viewMenuItem
{
    if([_delegate respondsToSelector:@selector(controllerPopoverSearchOption:didSelectIndex:)])
    {
        [_delegate controllerPopoverSearchOption:self didSelectIndex:viewMenuItem.tag];
    }
    
    [self dismissWithCompletion:nil];
}

@end
