//
//  DCViewEffects.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-22.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCViewEffectsDelegate : NSObject

@property (retain, nonatomic) id callback;

@end


@interface DCViewEffects : NSObject

+(void) jitterView:(UIView*) view byOffset:(float) offset alongAngle:(float) angle withDuration:(double) duration forTimes:(int) times completeCallback:(void (^)(void)) completeCallback;

+(void) blink:(UIView*) view withDuration:(double) duration forTimes:(int) times completeCallback:(void (^)(void)) completeCallback;

+(void) expandViews:(NSArray*) views withDuration:(double) duration completeCallback:(void (^)(void)) completeCallback;

+(void) shrinkViews:(NSArray*) views withDuration:(double) duration completeCallback:(void (^)(void)) completeCallback;

+(void) startRotatingViews:(NSArray*) views clockwise:(BOOL) clockwise inDurationForOneRevolution:(NSTimeInterval) duration;

+(void) stopRotatingViews:(NSArray*) views;

@end
