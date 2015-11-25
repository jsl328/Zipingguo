//
//  Interpolator.h
//  AmaranthDemo
//
//  Created by Sofia Work on 14-11-15.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Interpolator : NSObject

-(float) interpolateWithPercent:(float) percent from:(float) from to:(float) to;

@end


@interface LinearInterpolator : Interpolator

-(float) interpolateWithPercent:(float) percent from:(float) from to:(float) to;

@end


@interface SinInterpolator : Interpolator

-(float) interpolateWithPercent:(float) percent from:(float) from to:(float) to;

@end


@interface OscillateInterpolator : Interpolator

-(float) interpolateWithPercent:(float) percent from:(float) from to:(float) to;

@end

