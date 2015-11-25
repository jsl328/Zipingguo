//
//  Interpolator.m
//  AmaranthDemo
//
//  Created by Sofia Work on 14-11-15.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "Interpolator.h"

@implementation Interpolator

-(float) interpolateWithPercent:(float) percent from:(float) from to:(float) to {
    return 0;
}

@end


@implementation LinearInterpolator

-(float) interpolateWithPercent:(float) percent from:(float) from to:(float) to {
    return from + (to - from) * percent;
}

@end


@implementation SinInterpolator

-(float) interpolateWithPercent:(float) percent from:(float) from to:(float) to {
    return from + (to - from) * sin(percent * M_PI_2);
}

@end


@implementation OscillateInterpolator

-(float) interpolateWithPercent:(float) percent from:(float) from to:(float) to {
    
    float p = MIN(percent / 0.6, 1);
    
    float value = from + (to - from) * p;
    
    if (percent == 1) {
        value = to;
    }
    else if (percent >= 0.6) {
        value = to + sin((percent - 0.6) * 20) * 50 * (1 - percent);
    }
    
    return value;
}

@end