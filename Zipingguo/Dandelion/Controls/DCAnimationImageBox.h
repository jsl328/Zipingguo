//
//  DCAnimationImageBox.h
//  DandelionDemo
//
//  Created by Bob Li on 14-2-7.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCAnimationImage.h"
#import "DCFileSource.h"

@interface DCAnimationImageBox : UIImageView <DCFileSourceDelegate>

@property (retain, nonatomic) DCAnimationImage* animationImage;
@property (nonatomic) BOOL isPlaying;

-(DCFileSource*) source;

-(void) play;
-(void) stop;

@end
