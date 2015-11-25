//
//  DCDoubleSidedView.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-15.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCDoubleSidedView.h"

@implementation DCDoubleSidedView
@synthesize frontView = _frontView;
@synthesize backView = _backView;
@synthesize rotateDurationInSeconds;
@synthesize minimumScale;
@synthesize rotateAxisAngle;

-(id) init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}


-(void) initialize {
    rotateDurationInSeconds = 0.9;
    minimumScale = 0.8;
    rotateAxisAngle = 90;
    _isFrontSide = YES;
    [self configViews];
}

-(void) configViews {

    if (self.subviews.count > 0) {
        _frontView = [self.subviews objectAtIndex:0];
        _frontView.hidden = NO;
    }
    
    if (self.subviews.count > 1) {
        _backView = [self.subviews objectAtIndex:1];
        _backView.hidden = YES;
    }
}


-(void) setFrontView:(UIView *)frontView {
    [_frontView removeFromSuperview];
    _frontView = frontView;
    [self insertSubview:frontView atIndex:0];
}

-(void) setBackView:(UIView *)backView {
    [_backView removeFromSuperview];
    _backView = backView;
    _backView.hidden = YES;
    [self insertSubview:backView atIndex:1];
}

-(BOOL) isFrontSide {
    return _isFrontSide;
}


-(void) rotateToFrontSide {
    if (!_isFrontSide) {
        [self rotate];
    }
}

-(void) rotateToBackSide {
    if (_isFrontSide) {
        [self rotate];
    }
}


-(void) rotate {
    _isAnimatingFirstHalf = YES;
    [self.layer addAnimation:[self firstHalfAnimation] forKey:@"animation1"];
    self.transform = CGAffineTransformIdentity;
}

-(NSValue*) middleFrame {

    CATransform3D middleFrame = CATransform3DMakeScale(minimumScale, minimumScale, 1);
    middleFrame = CATransform3DRotate(middleFrame, M_PI / 2, cos(-rotateAxisAngle *  M_PI / 180), sin(-rotateAxisAngle * M_PI / 180), 0);
    
    return [NSValue valueWithCATransform3D:middleFrame];
}

-(CAAnimation*) firstHalfAnimation {
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)], [self middleFrame] ];
    animation.duration = rotateDurationInSeconds / 2;
    animation.delegate = self;
    
    return animation;
}

-(CAAnimation*) secondHalfAnimation {
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.values = @[[self middleFrame], [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)] ];
    animation.duration = rotateDurationInSeconds / 2;
    animation.delegate = self;
    
    return animation;
}

- (void) animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    
    if (_isAnimatingFirstHalf) {

        [self.layer addAnimation:[self secondHalfAnimation] forKey:@"animation2"];
        
        _isAnimatingFirstHalf = NO;
        
        _isFrontSide = !_isFrontSide;
        _frontView.hidden = !_isFrontSide;
        _backView.hidden = _isFrontSide;
    }
    else {
        [self.layer removeAllAnimations];
    }
}


-(void) layoutSubviews {
    [super layoutSubviews];
    _frontView.frame = self.bounds;
    _backView.frame = self.bounds;
}

@end
