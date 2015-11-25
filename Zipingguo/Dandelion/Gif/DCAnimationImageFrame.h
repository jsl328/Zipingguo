//
//  PRAnimationImageFrame.h
//  DandelionDemo
//
//  Created by Bob Li on 13-12-10.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCAnimationImageFrame : NSObject

@property (retain, nonatomic) UIImage* image;
@property (nonatomic) int duration;

-(id) initWithImage:(UIImage*) image duration:(int) duration;

@end
