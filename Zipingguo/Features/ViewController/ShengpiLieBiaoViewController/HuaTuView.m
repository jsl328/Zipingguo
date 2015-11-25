//
//  HuaTuView.m
//  jianbihua
//
//  Created by Quanhong on 14-3-27.
//  Copyright (c) 2014年 Quanhong. All rights reserved.
//

#import "HuaTuView.h"
#import "Base64JiaJieMi.h"
#define kDefaultLineColor       [UIColor blackColor]
#define kDefaultLineWidth       5.0f
#define kDefaultLineAlpha       1.0f

#define PARTIAL_REDRAW          0
@implementation HuaTuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure
{
    _pathArray = [NSMutableArray array];
    lineColor = kDefaultLineColor;
    lineWidth = kDefaultLineWidth;
    lineAlpha = kDefaultLineAlpha;
    self.backgroundColor = [UIColor whiteColor];
}

- (void)drawRect:(CGRect)rect
{
    [self.image drawInRect:self.bounds];
    [gongJu draw];
}

- (void)updateCacheImage:(BOOL)redraw
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    
    if (redraw) {
        self.image = nil;
        for (huaTuGongJu *tool in _pathArray) {
            [tool draw];
        }
    } else {
        [self.image drawAtPoint:CGPointZero];
        [gongJu draw];
    }
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // init the bezier path
    gongJu = [[huaTuGongJu alloc] init];
    gongJu.lineWidth = lineWidth;
    gongJu.lineColor = lineColor;
    gongJu.lineAlpha = lineAlpha;
    [_pathArray addObject:gongJu];
    
    // add the first touch
    UITouch *touch = [touches anyObject];
    [gongJu setInitialPoint:[touch locationInView:self]];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // save all the touches in the path
    UITouch *touch = [touches anyObject];
    
    // add the current point to the path
    CGPoint currentLocation = [touch locationInView:self];
    CGPoint previousLocation = [touch previousLocationInView:self];
    [gongJu moveFromPoint:previousLocation toPoint:currentLocation];
    
#if PARTIAL_REDRAW
    // calculate the dirty rect
    CGFloat minX = fmin(previousLocation.x, currentLocation.x) - self.lineWidth * 0.5;
    CGFloat minY = fmin(previousLocation.y, currentLocation.y) - self.lineWidth * 0.5;
    CGFloat maxX = fmax(previousLocation.x, currentLocation.x) + self.lineWidth * 0.5;
    CGFloat maxY = fmax(previousLocation.y, currentLocation.y) + self.lineWidth * 0.5;
    [self setNeedsDisplayInRect:CGRectMake(minX, minY, (maxX - minX), (maxY - minY))];
#else
    [self setNeedsDisplay];
#endif
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
    [self updateCacheImage:NO];
    gongJu = nil;
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // make sure a point is recorded
    [self touchesEnded:touches withEvent:event];
}

#pragma mark - Actions

- (void)clear
{
    //[self.bufferArray removeAllObjects];
    [_pathArray removeAllObjects];
    [self updateCacheImage:YES];
    [self setNeedsDisplay];
}
@end
