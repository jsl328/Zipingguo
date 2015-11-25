//
//  TAAnimatedDotView.m
//  TAPageControl
//
//  Created by Tanguy Aladenise on 2015-01-22.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

#import "TAAnimatedDotView.h"

static CGFloat const kAnimateDuration = 1;

@implementation TAAnimatedDotView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialization];
    }
    
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialization];
    }
    
    return self;
}

- (void)setDotColor:(UIColor *)dotColor
{
    _dotColor = dotColor;
//    self.layer.borderColor  = dotColor.CGColor;
}

- (void)initialization
{
    _dotColor = [UIColor lightGrayColor];
    self.backgroundColor    = [UIColor lightGrayColor];
    self.layer.cornerRadius = CGRectGetWidth(self.frame) / 2;
//    self.layer.borderColor  = [UIColor whiteColor].CGColor;
//    self.layer.borderWidth  = 2;
}


- (void)changeActivityState:(BOOL)active
{
    if (active) {
        [self animateToActiveState];
    } else {
        [self animateToDeactiveState];
    }
}


- (void)animateToActiveState
{
    
    [UIView animateWithDuration:kAnimateDuration animations:^{
       
    } completion:^(BOOL finished) {
        self.backgroundColor = _dotColor;
        self.transform = CGAffineTransformIdentity;
//        self.transform = CGAffineTransformMakeScale(1.1, 1.1);
    }];
//    [UIView animateWithDuration:kAnimateDuration delay:0 usingSpringWithDamping:.5 initialSpringVelocity:-20 options:UIViewAnimationOptionCurveLinear animations:^{
//        
//    } completion:nil];
}

- (void)animateToDeactiveState
{
   
    [UIView animateWithDuration:kAnimateDuration animations:^{
       
    } completion:^(BOOL finished) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.transform = CGAffineTransformIdentity;

    }];
//    [UIView animateWithDuration:kAnimateDuration delay:0 usingSpringWithDamping:.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
//        
//    } completion:nil];
}

@end
