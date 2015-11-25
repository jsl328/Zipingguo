//
//  DCImagePreview.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-5-20.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCImagePreview.h"
#import "DCDirectionDispatcher.h"
#import "DCMatrix.h"
#import "DCAnimationImage.h"

@implementation DCImagePreview {
    
    
    NSString* _filePath;
    UIImage* _image;
    
    DCFileSource* _source;
    

    float _x;
    float _y;
    
    float _touchX;
    float _touchY;
    
    float _minScale;
    float _maxScale;
    float _pinchScale;
    
    float _initialVelocityX;
    float _initialVelocityY;
    
    float _initialOvershootX;
    float _initialOvershootY;
    float _prevOvershootX;
    float _prevOvershootY;
    
    DCMatrix* _matrix;
    
    DCAnimationImage* _animationImage;
    int _frameIndex;
    
    UIPinchGestureRecognizer* _pinchRecognizer;
    UIPanGestureRecognizer* _panRecognizer;
    
    NSTimer* _frameTimer;
    DCTickTimer* _inertiaTimer;
    DCTickTimer* _moveOvershootTimer;
    DCTickTimer* _scaleOvershootTimer;
}

@synthesize isMoveOvershootable;
@synthesize isScaleOvershootable;
@synthesize isScalable = _isScalable;

-(id) init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [self initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void) initialize {
    _pinchScale = 1;
    _matrix = [[DCMatrix alloc] init];
    [self setOpaque:NO];
    _source = [[DCFileSource alloc] init];
    _source.delegate = self;
}

-(DCFileSource*) source {
    return _source;
}

-(void) acceptFile:(NSString *)filePath {
    
    _filePath = filePath;
    
    if (!_filePath || _filePath.length == 0) {
        _animationImage = nil;
        _image = nil;
        [self stopTimer];
    }
    
    if ([filePath endsWithString:@"gif"]) {
        
        _animationImage = [[DCAnimationImage alloc] init];
        [_animationImage loadFromGifAtFilePath:_filePath decodeFirstFrame:NO];
        _frameIndex = -1;
        
        if (_animationImage.frameCount > 0) {
            _frameIndex = 0;
            _image = [_animationImage frameAtIndex:_frameIndex].image;
        }
        

        if (!_frameTimer) {
            _frameTimer = [NSTimer scheduledTimerWithTimeInterval:0.12 target:self selector:@selector(onFrameTick:) userInfo:nil repeats:YES];
        }
    }
    else {
        _image = [UIImage imageWithContentsOfFile:filePath];
        _animationImage = nil;
        [self stopTimer];
    }
    
    [self findScaleRange];
    [self initializeTransform];
}

-(void) onFrameTick:(NSTimer*) sender {

    [self setNeedsDisplay];
    
    _frameIndex = (_frameIndex + 1) % _animationImage.frameCount;
    _image = [_animationImage frameAtIndex:_frameIndex].image;
}

-(void) stopTimer {
    if (_frameTimer) {
        [_frameTimer invalidate];
        _frameTimer = nil;
    }
}


-(void) initializeTransform {
    
    float scale = _minScale;
    
    _x = (self.frame.size.width - _image.size.width * scale) / 2;
    _y = (self.frame.size.height - _image.size.height * scale) / 2;

    [_matrix mapRect:CGRectMake(0, 0, _image.size.width, _image.size.height) toRect:CGRectMake(_x, _y + _image.size.height, _image.size.width * scale, -_image.size.height * scale)];
    [self setNeedsDisplay];
}

-(void) setIsScalable:(BOOL)isScalable {
    _isScalable = isScalable;
    if (isScalable) {
        [self enableScaling];
    }
    else {
        [self disableScaling];
    }
}


-(DCDirectionDecision) decisionFromDirection:(DCMoveDirection)direction touch:(UITouch *)touch xDirection:(int)xDirection yDirection:(int)yDirection {
    
    if (!_isScalable) {
        return DCDirectionDecisionDiscard;
    }
    

    float width = _image.size.width * _matrix.scaleX;

    float minX;
    float maxX;
    
    if (width <= self.frame.size.width) {
        minX = (self.frame.size.width - width) / 2;
        maxX = minX;
    }
    else {
        minX = 0;
        maxX = self.frame.size.width - width;
    }
    
    if ((_x == minX && xDirection == 1) || (_x == maxX && xDirection == -1)) {
        return isMoveOvershootable ? DCDirectionDecisionAccept : DCDirectionDecisionDiscard;
    }
    else {
        return DCDirectionDecisionSieze;
    }
}

-(BOOL) isProperDirection:(DCMoveDirection) direction {
    return NO;
}


-(BOOL) sendWindowEvents {
    return YES;
}

-(void) directionTouchesBegan:(UITouch *)touch {
    
    CGPoint point = [touch locationInView:[AppContext controller].view];
    _touchX = point.x;
    _touchY = point.y;
}

-(void) directionTouchesMoved:(UITouch *)touch {
    
    CGPoint point = [touch locationInView:[AppContext controller].view];
    
    [self moveByX:point.x - _touchX y:point.y - _touchY coercePosition:!isMoveOvershootable];
    _touchX = point.x;
    _touchY = point.y;
}

-(void) directionTouchesEnded:(UITouch *)touch {
    
    if (!isMoveOvershootable) {
        return;
    }
    
    
    if (!_moveOvershootTimer) {
        _moveOvershootTimer = [[DCTickTimer alloc] init];
        _moveOvershootTimer.delegate = self;
    }
    
    _initialOvershootX = _x;
    _initialOvershootY = _y;
    _prevOvershootX = _x;
    _prevOvershootY = _y;
    
    [_moveOvershootTimer setRangeFrom:1 to:0 changedInDuration:0.2];
    [_moveOvershootTimer start];
}


-(float) coercePositionX:(float) x {

    float width = _image.size.width * _matrix.scaleX;
    
    if (width <= self.frame.size.width) {
        x = (self.frame.size.width - width) / 2;
    }
    else {
        if (x < self.frame.size.width - width) {
            x = self.frame.size.width - width;
        }
        if (x > 0) {
            x = 0;
        }
    }
    
    return x;
}

-(float) coercePositionY:(float) y {

    float height = -_image.size.height * _matrix.scaleY;
    
    if (height <= self.frame.size.height) {
        y = (self.frame.size.height - height) / 2;
    }
    else {
        if (y < self.frame.size.height - height) {
            y = self.frame.size.height - height;
        }
        if (y > 0) {
            y = 0;
        }
    }
    
    return y;
}

-(void) moveByX:(float) x y:(float) y coercePosition:(BOOL) coercePosition {

    float newX = _x + x;
    float newY = _y + y;

    if (coercePosition) {
        newX = [self coercePositionX:newX];
        newY = [self coercePositionY:newY];
    }
    
    
    float width = _image.size.width * _matrix.scaleX;
    float height = -_image.size.height * _matrix.scaleY;

    [_matrix mapRect:CGRectMake(0, 0, _image.size.width, _image.size.height) toRect:CGRectMake(newX, newY + height, width, -height)];
    
    _x = newX;
    _y = newY;
    
    [self setNeedsDisplay];
}

-(void) enableScaling {

    _pinchRecognizer = [[UIPinchGestureRecognizer alloc] init];
    _pinchRecognizer.cancelsTouchesInView = NO;
    [_pinchRecognizer addTarget:self action:@selector(onPinch:)];
    [self addGestureRecognizer:_pinchRecognizer];
    
    _panRecognizer = [[UIPanGestureRecognizer alloc] init];
    _panRecognizer.cancelsTouchesInView = NO;
    [_panRecognizer addTarget:self action:@selector(onPan:)];
    [self addGestureRecognizer:_panRecognizer];
}

-(void) disableScaling {

    [_pinchRecognizer removeTarget:self action:@selector(onPinch:)];
    [self removeGestureRecognizer:_pinchRecognizer];
    _pinchRecognizer = nil;
    
    [_panRecognizer removeTarget:self action:@selector(onPan:)];
    [self removeGestureRecognizer:_panRecognizer];
    _panRecognizer = nil;
    
    [self findScaleRange];
    [self initializeTransform];
}

-(void) willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    
    [_source ownerWillMoveToWindow:newWindow];
    
    if (!newWindow) {
        [[DCDirectionDispatcher defaultDispatcher] unregisterHandler:self];
        if (_isScalable) {
            [self disableScaling];
        }
    }
    else {
        [[DCDirectionDispatcher defaultDispatcher] registerHandler:self];
        if (_isScalable) {
            [self enableScaling];
        }
    }
}

-(void) scaleTo:(float) scale centerAtPoint:(CGPoint) point {

    [_matrix scaleToScaleX:scale scaleY:-scale centerAtPoint:point];
    
    CGRect rect = [_matrix rectMappedFromRect:CGRectMake(0, 0, _image.size.width, _image.size.height)];
    
    _x = rect.origin.x;
    _y = rect.origin.y + rect.size.height;
    
    [self moveByX:0 y:0 coercePosition:YES];
}

-(void) onPinch:(UIPinchGestureRecognizer*) sender {
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        
        CGPoint p1 = [_pinchRecognizer locationOfTouch:0 inView:self];
        CGPoint p2 = [_pinchRecognizer locationOfTouch:1 inView:self];

        float scale = _matrix.scaleX * (float)_pinchRecognizer.scale / _pinchScale;

        if (!isScaleOvershootable) {
            if (scale < 1) {
                scale = _minScale;
            }
            else if (scale > _maxScale) {
                scale = _maxScale;
            }
        }
        
        [self scaleTo:scale centerAtPoint:CGPointMake((p1.x + p2.x) / 2, (p1.y + p2.y) / 2)];

        _pinchScale = _pinchRecognizer.scale;
    }
    else if (sender.state == UIGestureRecognizerStateEnded) {
        
        _pinchScale = 1;
        
        if (!isScaleOvershootable) {
            return;
        }
        
        
        if (!_scaleOvershootTimer) {
            _scaleOvershootTimer = [[DCTickTimer alloc] init];
            _scaleOvershootTimer.delegate = self;
        }
        
        float from = _matrix.scaleX;
        float to;
        
        if (from < _minScale) {
            to = _minScale;
        }
        else if (from > _maxScale) {
            to = _maxScale;
        }
        else {
            to = from;
        }
        
        if (to != from) {
            [_scaleOvershootTimer setRangeFrom:from to:to changedInDuration:ABS(to - from) * 0.2];
            [_scaleOvershootTimer start];
        }
    }
}

-(void) onPan:(UIPanGestureRecognizer*) sender {

    if (sender.state == UIGestureRecognizerStateEnded) {
    
        CGPoint velocity = [sender velocityInView:self];
        
        if (ABS(velocity.x) < 1500 && ABS(velocity.y) < 1500) {
            return;
        }
        
        
        if ([self coercePositionX:_x] == _x && [self coercePositionY:_y] == _y) {
            
            _initialVelocityX = velocity.x;
            _initialVelocityY = velocity.y;
            
            if (!_inertiaTimer) {
                _inertiaTimer = [[DCTickTimer alloc] init];
                _inertiaTimer.delegate = self;
            }
            
            [_inertiaTimer setRangeFrom:1 to:0 changedInDuration:0.5];
            [_inertiaTimer start];
        }
    }
}

-(void) timer:(id)timer didTickWithValue:(float)value {
    
    if (timer == _inertiaTimer) {
        
        float currentVelocityX = _initialVelocityX * value;
        float currentVelocityY = _initialVelocityY * value;
    
        [self moveByX:currentVelocityX * _inertiaTimer.tickInterval y:currentVelocityY * _inertiaTimer.tickInterval coercePosition:YES];
    }
    else if (timer == _moveOvershootTimer) {

        float properX = [self coercePositionX:_initialOvershootX];
        float properY = [self coercePositionY:_initialOvershootY];
        
        float currentOvershootX = properX + (_initialOvershootX - properX) * value;
        float currentOvershootY = properY + (_initialOvershootY - properY) * value;
        
        [self moveByX:currentOvershootX - _prevOvershootX y:currentOvershootY - _prevOvershootY coercePosition:NO];
        _prevOvershootX = currentOvershootX;
        _prevOvershootY = currentOvershootY;
    }
    else {
        
        [self scaleTo:value centerAtPoint:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)];
    }
}

-(void) timerDidStop:(id)timer {
}


-(void) drawRect:(CGRect)rect {

    CGContextRef context = UIGraphicsGetCurrentContext();

    [_matrix applyTransformInContext:context];
    CGContextDrawImage(context, CGRectMake(0, 0, _image.size.width, _image.size.height), _image.CGImage);
}


-(CGRect) rectCoercedFromRect:(CGRect) rect inRect:(CGRect) bounds {
    
    float x1 = MAX(rect.origin.x, bounds.origin.x);
    float y1 = MAX(rect.origin.y, bounds.origin.y);
    float x2 = MIN(rect.origin.x + rect.size.width, bounds.origin.x + bounds.size.width);
    float y2 = MIN(rect.origin.y + rect.size.height, bounds.origin.y + bounds.size.height);
    
    return CGRectMake(x1, y1, x2 - x1, y2 - y1);
}

-(void) findScaleRange {
    
    if ((float)_image.size.width / _image.size.height > (float)self.frame.size.width / self.frame.size.height) {
        _minScale = MIN((float)self.frame.size.width / _image.size.width, 1);
    }
    else {
        _minScale = MIN((float)self.frame.size.height / _image.size.height, 1);
    }

    _maxScale = _minScale * 5;
}

-(void) layoutSubviews {
    
    [super layoutSubviews];
    
    [self findScaleRange];
    [self initializeTransform];
}

@end
