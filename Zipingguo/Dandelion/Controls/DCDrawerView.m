//
//  DLDrawerView.m
//  Nanumanga
//
//  Created by Bob Li on 13-9-2.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCDrawerView.h"
#import "DCDirectionDetector.h"
#import "DCDirectionDispatcher.h"
#import <QuartzCore/QuartzCore.h>

@implementation DCDrawerProperties
@synthesize width;
@synthesize handleWidth;
@synthesize interleavePercent;
@synthesize letLooseThreshold;
@synthesize pixelsPerSecond;
@synthesize maskColor = _maskColor;
@synthesize isDragEnabled;

-(id) initWithDrawerView:(DCDrawerView*) drawerView location:(int) location {
    self = [super init];
    if (self) {
        _drawerView = drawerView;
        _location = location;
        width = 120;
        handleWidth = 75;
        letLooseThreshold = 10;
        pixelsPerSecond = 500;
        isDragEnabled = YES;
    }
    return self;
}

-(void) setMaskColor:(UIColor *)maskColor {
    
    _maskColor = maskColor;
    
    CGFloat red = 0;
    CGFloat green = 0;
    CGFloat blue = 0;
    CGFloat alpha = 0;
    
    [_maskColor getRed:&red green:&green blue:&blue alpha:&alpha];
    
    _maskColorRed = red;
    _mackColorGreen = green;
    _mackColorBlue = blue;
    _maskColorAlpha = alpha;
    
    [_drawerView createMaskViewForDrawerAtLocaion:_location];
}

-(BOOL) isMaskColorVisible {
    return _maskColorAlpha > 0;
}

-(BOOL) isExpanded {
    return _location == DCDrawerLocationLeft ? [_drawerView isLeftDrawerExpanded] : [_drawerView isRightDrawerExpanded];
}

-(void) expand {
    if (_location == DCDrawerLocationLeft) {
        [_drawerView expandLeftDrawer];
    }
    else {
        [_drawerView expandRightDrawer];
    }
}

-(void) collapse {
    if ([self isExpanded]) {
        [_drawerView collapseDrawer];
    }
}

-(UIColor*) maskColorAppliedWithPercent:(float) percent {
    return [UIColor colorWithRed:_maskColorRed green:_mackColorGreen blue:_mackColorBlue alpha:percent * _maskColorAlpha];
}

@end


@implementation DCDrawerView
@synthesize drawerLocation = _drawerLocation;
@synthesize isFullSlidable;
@synthesize drawnOutScale;
@synthesize delegate;

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
    self.clipsToBounds = YES;
    [self extractSubViews];
    [self layoutSubviews];
    self.userInteractionEnabled = YES;
    drawnOutScale = 1;
}

-(void) setDrawerLocation:(DCDrawerLocation)drawerLocation {
    _drawerLocation = drawerLocation;
    [self extractSubViews];
}

-(DCDrawerProperties*) left {
    return _left;
}

-(DCDrawerProperties*) right {
    return _right;
}

-(BOOL) isLeftDrawerExpanded {
    return _isLeftDrawerExpanded;
}

-(BOOL) isRightDrawerExpanded {
    return _isRightDrawerExpanded;
}

-(void) extractSubViews {
    
    if (self.subviews.count == 3) {
        _leftDrawer = [self.subviews objectAtIndex:0];
        _rightDrawer = [self.subviews objectAtIndex:1];
        _content = [self.subviews objectAtIndex:2];
        _left = [[DCDrawerProperties alloc] initWithDrawerView:self location:DCDrawerLocationLeft];
        _right = [[DCDrawerProperties alloc] initWithDrawerView:self location:DCDrawerLocationRight];
    }
    else {
        if (_drawerLocation == DCDrawerLocationLeft) {
            _leftDrawer = [self.subviews objectAtIndex:0];
            _content = [self.subviews objectAtIndex:1];
            _left = [[DCDrawerProperties alloc] initWithDrawerView:self location:DCDrawerLocationLeft];
        }
        else {
            _rightDrawer = [self.subviews objectAtIndex:0];
            _content = [self.subviews objectAtIndex:1];
            _right = [[DCDrawerProperties alloc] initWithDrawerView:self location:DCDrawerLocationRight];
        }
    }
}

-(void) createMaskViewForDrawerAtLocaion:(int) location {
    
    if (location == DCDrawerLocationLeft) {
        _leftDrawerMask = [[UIView alloc] init];
        [self insertSubview:_leftDrawerMask aboveSubview:_leftDrawer];
    }
    else {
        _rightDrawerMask = [[UIView alloc] init];
        [self insertSubview:_rightDrawerMask aboveSubview:_rightDrawer];
    }
}


-(DCDirectionDecision) decisionFromDirection:(DCMoveDirection) direction touch:(UITouch*) touch xDirection:(int)xDirection yDirection:(int)yDirection {
    
    BOOL isExpanded = _isLeftDrawerExpanded || _isRightDrawerExpanded;
    
    float x = [touch locationInView:self].x;
    
    if (_left.isDragEnabled && (_drawerLocation == DCDrawerLocationLeft || _drawerLocation == DCDrawerLocationLeftAndRight)) {
        if ((x <= _left.handleWidth && xDirection == 1) || (isExpanded && xDirection == -1)) {
            return DCDirectionDecisionSieze;
        }
    }
    
    if (_right.isDragEnabled && (_drawerLocation == DCDrawerLocationRight || _drawerLocation == DCDrawerLocationLeftAndRight)) {
        if ((x >= self.frame.size.width - _right.handleWidth && xDirection == -1) || (isExpanded && xDirection == 1)) {
            return DCDirectionDecisionSieze;
        }
    }
    
    return DCDirectionDecisionDiscard;
}

-(BOOL) isProperDirection:(DCMoveDirection)direction {
    return direction == DCMoveDirectionLeft || direction == DCMoveDirectionRight;
}

-(void) directionTouchesBegan:(UITouch *)touch {
    _currentOffset = _offset;
    _isDragging = YES;
    _x = [touch locationInView:self].x;
}

-(void) directionTouchesMoved:(UITouch *)touch {
    CGPoint point = [touch locationInView:self];
    [self updateOffsetWithX:point.x];
}

-(void) directionTouchesEnded:(UITouch *)touch {
    _firstMoveDirection = DCDrawerViewDirectionNotSet;
    [self animateOffsetToNearestPoint];
}


-(void) updateOffsetWithX: (int) x {
    
    _currentDirection = x >= _x ? DCDrawerViewDirectionRight : DCDrawerViewDirectionLeft;
    if (_firstMoveDirection == DCDrawerViewDirectionNotSet) {
        _firstMoveDirection = _currentDirection;
    }
    
    _offset += x - _x;
    _x = x;
    
    
    float min;
    float max;
    
    if (_currentDirection == DCDrawerViewDirectionRight) {
        if (_offset < 0) {
            min = -_right.width;
            max = 0;
        }
        else {
            min = 0;
            max = _left.width;
        }
    }
    else if (_currentDirection == DCDrawerViewDirectionLeft) {
        if (_offset > 0) {
            min = 0;
            max = _left.width;
        }
        else {
            min = -_right.width;
            max = 0;
        }
    }
    else {
        min = 0;
        max = 0;
    }
    
    
    if (_offset < min) {
        _offset = min;
    }
    else if (_offset > max) {
        _offset = max;
    }
    
    if (!isFullSlidable) {
        if (_isLeftDrawerExpanded || (!_isLeftDrawerExpanded && !_isRightDrawerExpanded && _firstMoveDirection == DCDrawerViewDirectionRight)) {
            _offset = MAX(_offset, 0);
        }
        else if (_isRightDrawerExpanded || (!_isLeftDrawerExpanded && !_isRightDrawerExpanded && _firstMoveDirection == DCDrawerViewDirectionLeft)) {
            _offset = MIN(_offset, 0);
        }
    }
    
    _currentOffset = _offset;
    [self updateLayout];
}

-(void) animateOffsetToNearestPoint {
    
    float nextOffset;
    
    if (_currentDirection == DCDrawerViewDirectionRight) {
        if (_offset >= 0) {
            nextOffset = _offset > _left.letLooseThreshold ? _left.width : 0;
        }
        else {
            nextOffset = _offset > -(_right.width - _right.letLooseThreshold) ? 0 : -_right.width;
        }
    }
    else if (_currentDirection == DCDrawerViewDirectionLeft) {
        if (_offset <= 0) {
            nextOffset = _offset < -_right.letLooseThreshold ? -_right.width : 0;
        }
        else {
            nextOffset = _offset > _left.width - _left.letLooseThreshold ? _left.width : 0;
        }
    }
    else {
        nextOffset = 0;
    }
    
    [self animateOffsetTo:nextOffset];
}


-(void) animateOffsetTo:(float) targetOffset {
    
    double duration;
    
    if (_offset == 0) {
        duration = 0;
    }
    else {
        duration = abs(targetOffset - _offset) / (_offset > 0 ? _left.pixelsPerSecond : _right.pixelsPerSecond);
    }
    
    _offset = targetOffset;
    _isLeftDrawerExpanded = _offset > 0;
    _isRightDrawerExpanded = _offset < 0;
    
    
    if (delegate) {
        if (_isLeftDrawerExpanded || _isRightDrawerExpanded) {
            [delegate drawerViewWillCollapse:self];
        }
        else {
            [delegate drawerViewWillExpand:self];
        }
    }
    
    
    [UIView animateWithDuration:duration animations:^{
        [self updateLayout];
    } completion:^(BOOL finished) {
        
        _currentOffset = _offset;
        _isDragging = NO;
        
        if (drawnOutScale < 1) {
            
            [self updateLayout];
            
            if (delegate) {
                if (_isLeftDrawerExpanded || _isRightDrawerExpanded) {
                    [delegate drawerViewDidExpand:self];
                }
                else {
                    [delegate drawerViewDidCollapse:self];
                }
            }
        }
    }];
}


-(void) updateLayout {
    
    if (drawnOutScale < 1 && (_isDragging || _offset != 0)) {
        
        float scale;
        int direction;
        
        if (_offset >= 0) {
            scale = 1 - (1 - drawnOutScale) * (_offset / self.left.width);
            direction = 1;
        }
        else {
            scale = 1 + (1 - drawnOutScale) * (_offset / self.right.width);
            direction = -1;
        }
        
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
        _content.transform = CGAffineTransformTranslate(scaleTransform, self.frame.size.width * (1 - scale) * direction + _offset, 0);
    }
    else {
        
        if (drawnOutScale < 1) {
            _content.transform = CGAffineTransformIdentity;
        }
        
        _content.frame = CGRectMake(_offset, 0, self.frame.size.width, self.frame.size.height);
    }
    
    [self setLeftDrawerPosition];
    [self setRightDrawerPosition];
    
    if ((_drawerLocation == DCDrawerLocationLeft || _drawerLocation == DCDrawerLocationLeftAndRight) && _left.isMaskColorVisible > 0) {
        [self updateLeftDrawerMask];
    }
    
    if ((_drawerLocation == DCDrawerLocationRight || _drawerLocation == DCDrawerLocationLeftAndRight) && _right.isMaskColorVisible > 0) {
        [self updateRightDrawerMask];
    }
}

-(void) updateLeftDrawerMask {
    
    float leftPercent = 1 - _offset / _left.width;
    _leftDrawerMask.backgroundColor = [_left maskColorAppliedWithPercent:leftPercent];
    
    _leftDrawerMask.frame = _leftDrawer.frame;
    _leftDrawerMask.hidden = !(_currentOffset > 0 && _currentOffset < _left.width);
}

-(void) updateRightDrawerMask {
    
    float rightPercent = 1 + _offset / _right.width;
    _rightDrawerMask.backgroundColor = [_right maskColorAppliedWithPercent:rightPercent];
    
    _rightDrawerMask.frame = _rightDrawer.frame;
    _rightDrawerMask.hidden = !(_currentOffset < 0 && _currentOffset > -_right.width);
}

-(void) setLeftDrawerPosition {
    
    float x1 = _left.width * (_left.interleavePercent - 1);
    float x2 = 0;
    
    float left = x1 + (x2 - x1) * (_offset / _left.width);
    
    _leftDrawer.frame = CGRectMake(left, 0, _left.width, self.frame.size.height);
    _leftDrawer.hidden = !(_currentOffset > 0);
}

-(void) setRightDrawerPosition {
    
    float x1 = self.frame.size.width - _right.width *  _right.interleavePercent;
    float x2 = self.frame.size.width - _right.width;
    
    float left = x1 + (x2 - x1) * (-_offset / _right.width);
    
    _rightDrawer.frame = CGRectMake(left, 0, _right.width, self.frame.size.height);
    _rightDrawer.hidden = !(_currentOffset < 0);
}

-(void) expandLeftDrawer {
    [self animateOffsetTo:_left.width];
}

-(void) expandRightDrawer {
    [self animateOffsetTo:-_right.width];
}

-(void) collapseDrawer {
    [self animateOffsetTo:0];
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
    
    [_leftDrawer layoutIfNeeded];
    [_content layoutIfNeeded];
    [_rightDrawer layoutIfNeeded];
    
    [self updateLayout];
}

@end
