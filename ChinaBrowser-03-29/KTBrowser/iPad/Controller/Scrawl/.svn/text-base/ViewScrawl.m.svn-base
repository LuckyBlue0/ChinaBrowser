//
//  ViewScrawl.m
//  scrawl
//
//  Created by Glex on 14-3-25.
//  Copyright (c) 2014年 Glex. All rights reserved.
//

#import "ViewScrawl.h"

#define kLineColor      @"kLineColor"
#define kLineWidth      @"kLineWidth"
#define kEraseMode      @"kEraseMode"
#define kEraserWidth    @"kEraserWidth"
#define kCurrPoints     @"kCurrPoints"
#define kPrevFromPoints @"kPrevFromPoints"
#define kPrevToPoints   @"kPrevToPoints"

#define kDefaultLineWidth   8.0f
#define kDefaultEraserWidth 12.0f
#define kDefaultColor RGB_COLOR(0, 172, 239)

CGPoint midPoint(CGPoint fromPoint, CGPoint toPoint) {
    return CGPointMake((fromPoint.x+toPoint.x)*0.5, (fromPoint.y+toPoint.y)*0.5);
}

@interface ViewScrawl () {
    BOOL _undo;
    BOOL _redo;
    
    CGPoint _currPoint;
    CGPoint _prevFromPoint;
    CGPoint _prevToPoint;
    
    UIImage *_currentImage;
    NSMutableArray *_arrStrokes;
    NSMutableArray *_arrThrowStrokes;
}

@end

@implementation ViewScrawl

#pragma mark - private methods
- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    
    _lineColor   = kDefaultColor;
    _lineWidth   = kDefaultLineWidth;
    _eraserWidth = kDefaultEraserWidth;
    _arrStrokes      = [[NSMutableArray alloc] init];
    _arrThrowStrokes = [[NSMutableArray alloc] init];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (_currentImage) {
        [_currentImage drawAtPoint:CGPointMake(0, 0)];
        _currentImage = nil;
    }

    if (_arrStrokes.count) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.layer renderInContext:context];
        
        if (!_undo && !_redo) {
            [self addLineWithContext:context];
        }
        else {
            for (NSDictionary *dicStroke in _arrStrokes) {
                _lineColor = [dicStroke  objectForKey:kLineColor];
                _lineWidth = [[dicStroke objectForKey:kLineWidth] floatValue];
                _eraseMode = [[dicStroke objectForKey:kEraseMode] boolValue];
                _eraserWidth = [[dicStroke objectForKey:kEraserWidth] floatValue];
                NSMutableArray *arrCurrPoints     = [dicStroke objectForKey:kCurrPoints];
                NSMutableArray *arrPrevFromPoints = [dicStroke objectForKey:kPrevFromPoints];
                NSMutableArray *arrPrevToPoints   = [dicStroke objectForKey:kPrevToPoints];
                for (NSInteger idx=0; idx<arrCurrPoints.count; idx++) {
                    _currPoint     = CGPointFromString(arrCurrPoints[idx]);
                    _prevFromPoint = CGPointFromString(arrPrevFromPoints[idx]);
                    _prevToPoint   = CGPointFromString(arrPrevToPoints[idx]);
                    
                    [self addLineWithContext:context];
                }
            }
        }
    }

    _undo = _redo = NO;
}

- (void)addLineWithContext:(CGContextRef)context {
    CGPoint prevMidPoint = midPoint(_prevFromPoint, _prevToPoint);
    CGPoint currMidPoint = midPoint(_currPoint, _prevFromPoint);
    
    CGContextMoveToPoint(context, prevMidPoint.x, prevMidPoint.y);
    CGContextAddQuadCurveToPoint(context, _prevFromPoint.x, _prevFromPoint.y, currMidPoint.x, currMidPoint.y);
    CGContextSetLineCap(context, kCGLineCapRound);
    if (_eraseMode) {
        CGContextSetBlendMode(context, kCGBlendModeClear);
        CGContextSetLineWidth(context, _eraserWidth);
    }
    else {
        CGContextSetBlendMode(context, kCGBlendModeNormal);
        CGContextSetLineWidth(context, _lineWidth);
    }
    CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
    CGContextStrokePath(context);
}

#pragma mark - touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch  *touch = [touches anyObject];

	_currPoint = [touch locationInView:self];
	_prevFromPoint = _prevToPoint = [touch previousLocationInView:self];
    
	NSMutableDictionary *dicStroke = [NSMutableDictionary dictionary];
    [dicStroke setObject:_lineColor     forKey:kLineColor];
    [dicStroke setObject:@(_lineWidth)  forKey:kLineWidth];
    [dicStroke setObject:@(_eraseMode)  forKey:kEraseMode];
    [dicStroke setObject:@(_eraserWidth) forKey:kEraserWidth];
	[dicStroke setObject:[NSMutableArray array] forKey:kCurrPoints];
	[dicStroke setObject:[NSMutableArray array] forKey:kPrevFromPoints];
	[dicStroke setObject:[NSMutableArray array] forKey:kPrevToPoints];
	[_arrStrokes addObject:dicStroke];

    [self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch  = [touches anyObject];
    
    _prevToPoint   = _prevFromPoint;
    _prevFromPoint = [touch previousLocationInView:self];
    _currPoint     = [touch locationInView:self];
    CGPoint prevMidPoint = midPoint(_prevFromPoint, _prevToPoint);
    CGPoint currMidPoint = midPoint(_currPoint, _prevFromPoint);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, prevMidPoint.x, prevMidPoint.y);
    CGPathAddQuadCurveToPoint(path, NULL, _prevFromPoint.x, _prevFromPoint.y, currMidPoint.x, currMidPoint.y);
    CGRect bounds = CGPathGetBoundingBox(path);
    CGPathRelease(path);
    
    CGRect drawBox = bounds;
    drawBox.origin.x    -= _lineWidth*2;
    drawBox.origin.y    -= _lineWidth*2;
    drawBox.size.width  += _lineWidth*4;
    drawBox.size.height += _lineWidth*4;
    
    UIGraphicsBeginImageContext(drawBox.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	_currentImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    [self setNeedsDisplayInRect:drawBox];

    NSMutableDictionary *dicStroke = [_arrStrokes lastObject];
	NSMutableArray *arrCurrPoints  = [dicStroke objectForKey:kCurrPoints];
	NSMutableArray *arrPrevFromPoints = [dicStroke objectForKey:kPrevFromPoints];
	NSMutableArray *arrPrevToPoints   = [dicStroke objectForKey:kPrevToPoints];
    [arrCurrPoints     addObject:NSStringFromCGPoint(_currPoint)];
    [arrPrevFromPoints addObject:NSStringFromCGPoint(_prevFromPoint)];
    [arrPrevToPoints   addObject:NSStringFromCGPoint(_prevToPoint)];
}

#pragma mark - user interaction
// 撤销
- (void)undo {
	if (_arrStrokes.count) {
        _undo = YES;
        
		NSDictionary *dicThrowStroke = [_arrStrokes lastObject];
		[_arrThrowStrokes addObject:dicThrowStroke];
		[_arrStrokes removeLastObject];
        
        [self setNeedsDisplay];
	}
}

// 回撤
- (void)redo {
	if (_arrThrowStrokes.count) {
        _redo = YES;

		NSDictionary *dicReusedStroke = [_arrThrowStrokes lastObject];
		[_arrStrokes addObject:dicReusedStroke];
		[_arrThrowStrokes removeLastObject];
        
        [self setNeedsDisplay];
	}
}

// 清除画布
- (void)clearCanvas {
	[_arrStrokes removeAllObjects];
	[_arrThrowStrokes removeAllObjects];
    
	[self setNeedsDisplay];
}

@end
