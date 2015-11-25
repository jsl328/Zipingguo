//
//  DCDoubleSidedView.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-15.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCDoubleSidedView : UIView {

    BOOL _isFrontSide;
    
    BOOL _isAnimatingFirstHalf;
}

@property (assign, nonatomic) UIView* frontView;
@property (assign, nonatomic) UIView* backView;
@property (nonatomic) double rotateDurationInSeconds;
@property (nonatomic) double minimumScale;
@property (nonatomic) float rotateAxisAngle;

@property (nonatomic) BOOL isFrontSide;

-(void) rotateToFrontSide;
-(void) rotateToBackSide;

-(void) rotate;

@end
