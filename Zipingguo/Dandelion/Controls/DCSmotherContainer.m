//
//  DCJumpList.m
//  AmaranthDemo
//
//  Created by Sofia Work on 14-8-21.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCSmotherContainer.h"
#import "DCContentPresenter.h"
#import "DCDirectionDispatcher.h"

@implementation DCSmotherContainer {
    
    UIView* _currentView;
}

@synthesize highlightBarView = _highlightBarView;
@synthesize animationMode;
@synthesize delegate;

-(void) setHighlightBarView:(UIView *)highlightBarView {
    [_highlightBarView removeFromSuperview];
    _highlightBarView = highlightBarView;
    [self insertSubview:_highlightBarView atIndex:0];
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouchEvent:event isMoving:NO];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouchEvent:event isMoving:YES];
}


-(void) handleTouchEvent:(UIEvent*) event isMoving:(BOOL) isMoving {

    UITouch* touch = [[event touchesForWindow:[AppContext window]] anyObject];
    CGPoint point = [touch locationInView:self];
    
    UIView* view = [self hitTest:point.x y:point.y];
    
    if (view && view != _currentView && [self isViewSmotherable:view]) {
        [self didLeaveView:_currentView];
        _currentView = view;
        [self didEnterView:_currentView isAnimated:animationMode == ( DCHighlightBarAnimationModeWhenTouching && !isMoving) || animationMode == DCHighlightBarAnimationModeWhenSmothering];
    }
}

-(void) didLeaveView:(UIView*) view {
    
    BOOL handlesSmotherLeave = view && [view conformsToProtocol:@protocol(DCSmotherCellView)] && [view respondsToSelector:@selector(didSmotherLeave)];

    if (handlesSmotherLeave) {
        [(id <DCSmotherCellView>)view didSmotherLeave];
    }
    
    if (delegate && view) {
        [delegate smotherContainer:self didLeaveView:view];
    }
}

-(void) didEnterView:(UIView*) view isAnimated:(BOOL) isAnimated {
        
    BOOL handlesSmotherEnter = view && [view conformsToProtocol:@protocol(DCSmotherCellView)] && [view respondsToSelector:@selector(didSmotherEnter)];
    
    if (handlesSmotherEnter) {
        [self moveHighlightBarToRect:view.frame isAnimated:isAnimated];
        [(id <DCSmotherCellView>)view didSmotherEnter];
    }
    
    if (delegate && view) {
        [delegate smotherContainer:self didEnterView:view];
    }
}

-(void) moveHighlightBarToRect:(CGRect) rect isAnimated:(BOOL) isAnimated {

    if (!_highlightBarView) {
        return;
    }
    
    if (!isAnimated) {
        _highlightBarView.frame = rect;
        return;
    }
    
    
    if (_highlightBarView.frame.size.width == 0) {
        _highlightBarView.frame = rect;
    }
    else {
        float dx = _highlightBarView.frame.origin.x - rect.origin.x;
        float dy = _highlightBarView.frame.origin.y - rect.origin.y;
        float d = sqrtf(dx * dx + dy * dy);
        NSTimeInterval duration = [[AppContext settings] durationForPixelDistance:d];
        [UIView animateWithDuration:duration animations:^{
            _highlightBarView.frame = rect;
        }];
    }
}

-(BOOL) isViewSmotherable:(UIView*) view {

    BOOL isViewSmotherable;
    
    if (view && [view conformsToProtocol:@protocol(DCSmotherCellView)] && [view respondsToSelector:@selector(isSmotherable)]) {
        isViewSmotherable = [(id <DCSmotherCellView>)view isSmotherable];
    }
    else {
        isViewSmotherable = YES;
    }
    
    return isViewSmotherable;
}


-(UIView*) containedView {
    return [self.subviews objectAtIndex:_highlightBarView ? 1 : 0];
}

-(UIView*) hitTest:(float) x y:(float) y {

    for (UIView* view in [self containedView].subviews) {
        if (x >= view.frame.origin.x && x <= view.frame.origin.x + view.frame.size.width && y >= view.frame.origin.y && y <= view.frame.origin.y + view.frame.size.height) {
            return view;
        }
    }
    
    return nil;
}


-(void) layoutSubviews {
    
    [super layoutSubviews];
    
    [self containedView].frame = self.bounds;
    [self moveHighlightBarToRect:_currentView.frame isAnimated:animationMode == DCHighlightBarAnimationModeWhenTouching];
}

@end
