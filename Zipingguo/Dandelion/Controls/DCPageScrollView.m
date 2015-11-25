//
//  DCPageScrollView.m
//  Nanumanga
//
//  Created by Bob Li on 13-9-4.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCPageScrollView.h"
#import "DCDirectionDetector.h"
#import "DCViewGroup.h"
#import "DCDirectionDispatcher.h"

@implementation DCPageScrollView
@synthesize pageIndex;
@synthesize showDots;
@synthesize delegate;
@synthesize showSeparatorLineWhileSliding = _showSeparatorLineWhileSliding;

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

-(id) init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void) initialize {

    _pages = [[NSMutableArray alloc] init];
    [self createVisualTree];

    self.userInteractionEnabled = YES;
    pageIndex = 0;
    _pageIndexToLeft = -1;
    _pageIndexToRight = 1;
    [self makeVisiblePages];
}


-(void) addPage:(UIView*) page {
    [_viewsContainer addSubview:page];
    [_pages addObject:page];
}

-(void) clearPages {
    
    for (UIView* view in self.subviews) {
        [_viewsContainer removeFromSuperview];
    }
    
    [_pages removeAllObjects];
}

-(void) createVisualTree {
    
    NSMutableArray* subviews = [[NSMutableArray alloc] init];
    [subviews addObjectsFromArray:self.subviews];
    
    for (UIView* view in self.subviews) {
        [view removeFromSuperview];
    }

    _viewsContainer = [[UIView alloc] init];
    [self addSubview:_viewsContainer];
    
    for (UIView* view in subviews) {
        [_viewsContainer addSubview:view];
        [_pages addObject:view];
    }
}


-(void) animateOffsetToZero {
    
    double duration = (double)abs(_offset) / 1000;
    _offset = 0;
    
    [UIView animateWithDuration:duration animations:^{
        [self updateLayout];
    } completion:^(BOOL finished) {
        if (finished) {
            _offset = 0;
            _pageIndexToLeft = pageIndex - 1;
            _pageIndexToRight = pageIndex + 1;
            [self makeVisiblePages];
            [self layoutSubviews];
        }
    }];
}

-(void) setPageIndex:(int)newPageIndex {
    
    if (newPageIndex > pageIndex) {
        _pageIndexToLeft = pageIndex;
        _pageIndexToRight = newPageIndex + 1;
        _offset += self.frame.size.width;
    }
    else if (newPageIndex < pageIndex) {
        _pageIndexToRight = pageIndex;
        _pageIndexToLeft = newPageIndex - 1;
        _offset -= self.frame.size.width;
    }
    
    pageIndex = newPageIndex;
    
    [self makeVisiblePages];
    [self updateLayout];
    [self animateOffsetToZero];
    
    if (_pageControl) {
        _pageControl.currentPage = pageIndex;
    }
}

-(void) setShowDots:(BOOL)newShowDots {
    showDots = newShowDots;
    if (showDots) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = _pages.count;
        [self addSubview:_pageControl];
        [self layoutSubviews];
    }
    else {
        [_pageControl removeFromSuperview];
        _pageControl = nil;
    }
}

-(void) makeVisiblePages {
    
    if (_pages.count == 0) {
        return;
    }
    
    _leftView = _pageIndexToLeft == -1 ? nil : [_pages objectAtIndex:_pageIndexToLeft];
    _rightView = _pageIndexToRight == _pages.count ? nil : [_pages objectAtIndex:_pageIndexToRight];
    _centerView = [_pages objectAtIndex:pageIndex];
    
    for (int i = 0; i <= _pages.count - 1; i++) {
        UIView* view = [_pages objectAtIndex:i];
        if (i == _pageIndexToLeft || i == _pageIndexToRight || i == pageIndex) {
            view.hidden = NO;
        }
        else {
            view.hidden = YES;
        }
    }
}

-(void) setShowSeparatorLineWhileSliding:(BOOL)showSeparatorLineWhileSliding {
    _showSeparatorLineWhileSliding = showSeparatorLineWhileSliding;
    if (showSeparatorLineWhileSliding) {
        
        _separatorLine1 = [[UIView alloc] init];
        _separatorLine1.backgroundColor = [UIColor blackColor];
        
        _separatorLine2 = [[UIView alloc] init];
        _separatorLine2.backgroundColor = [UIColor blackColor];
    }
    else {
        _separatorLine1 = nil;
        _separatorLine2 = nil;
    }
}

-(void) updateLayout {
    
    _leftView.frame = CGRectMake(_offset + -_leftView.frame.size.width, 0, _leftView.frame.size.width, self.frame.size.height);
    _centerView.frame = CGRectMake(_offset, 0, _centerView.frame.size.width, self.frame.size.height);
    _rightView.frame = CGRectMake(_offset + _centerView.frame.size.width, 0, _rightView.frame.size.width, self.frame.size.height);
    
    if (_showSeparatorLineWhileSliding) {
        _separatorLine1.frame = CGRectMake(_centerView.frame.origin.x, 0, 1, self.frame.size.height);
        _separatorLine2.frame = CGRectMake(_centerView.frame.origin.x + _centerView.frame.size.width - 1, 0, 1, self.frame.size.height);
    }
}

-(void) showSeparatorLines {
    [self addSubview:_separatorLine1];
    [self addSubview:_separatorLine2];
    [self bringSubviewToFront:_separatorLine1];
    [self bringSubviewToFront:_separatorLine2];
}



-(DCDirectionDecision) decisionFromDirection:(DCMoveDirection)direction touch:(UITouch*) touch xDirection:(int)xDirection yDirection:(int)yDirection {
    return DCDirectionDecisionAccept;
}

-(BOOL) isProperDirection:(DCMoveDirection)direction {
    return direction == DCMoveDirectionLeft || direction == DCMoveDirectionRight;
}

-(void) directionTouchesBegan:(UITouch *)touch {
    
    _slideDirection = DCMoveDirectionInvalid;
    _x = [touch locationInView:self].x;
    
    if (_showSeparatorLineWhileSliding) {
        [self showSeparatorLines];
    }
}

-(void) directionTouchesMoved:(UITouch *)touch {
    CGPoint point = [touch locationInView:self];
    [self updateOffsetWithX:point.x];
}

-(void) directionTouchesEnded:(UITouch *)touch {
    _slideDirection = DCMoveDirectionInvalid;
    [self animateOffsetToNearestPoint];
}


-(void) animateOffsetToNearestPoint {
    
    if (abs(_offset) > 10) {
        
        int newPageIndex = pageIndex + (_offset < 0 ? 1 : -1);
        if (newPageIndex < 0) {
            newPageIndex = 0;
        }
        else if (newPageIndex > _pages.count - 1) {
            newPageIndex = _pages.count - 1;
        }
        
        [self setPageIndex:newPageIndex];
        if (delegate) {
            [delegate pageScrollView:self pageIndexDidChangeBySliding:pageIndex];
        }
    }
    else {
        [self animateOffsetToZero];
    }
    
    [_separatorLine1 removeFromSuperview];
    [_separatorLine2 removeFromSuperview];
}

-(void) updateOffsetWithX: (int) x {
    
    _offset += x - _x;
    _x = x;
    
    [self updateLayout];
}


-(void) willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    if (!newWindow) {
        [[DCDirectionDispatcher defaultDispatcher] unregisterHandler:self];
    }
    else {
        [[DCDirectionDispatcher defaultDispatcher] registerHandler:self];
    }
}

-(void) layoutSubviews {

    [super layoutSubviews];
    
    _viewsContainer.frame = self.bounds;

    for (UIView* view in _pages) {
        view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        if ([view.class isSubclassOfClass:[DCViewGroup class]]) {
            [(DCViewGroup*)view layoutAtPoint:CGPointMake(0, 0) withWidthSpec:DCMeasureSpecMake(DCMeasureSpecExactly, self.frame.size.width) heightSpec:DCMeasureSpecMake(DCMeasureSpecExactly, self.frame.size.height)];
        }
    }
    
    [self updateLayout];
    
    
    if (_pageControl) {
        _pageControl.frame = CGRectMake(0, self.frame.size.height - 50, self.frame.size.width, 50);
    }
}

@end
