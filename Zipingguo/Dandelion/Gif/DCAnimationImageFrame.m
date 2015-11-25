//
//  PRAnimationImageFrame.m
//  DandelionDemo
//
//  Created by Bob Li on 13-12-10.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCAnimationImageFrame.h"

@implementation DCAnimationImageFrame
@synthesize image = _image;
@synthesize duration = _duration;

-(id) initWithImage:(UIImage*) image duration:(int) duration {
    self = [super init];
    if (self) {
        _image = image;
        _duration = duration;
    }
    return self;
}

@end
