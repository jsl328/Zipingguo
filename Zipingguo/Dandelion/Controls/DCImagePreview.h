//
//  DCImagePreview.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-5-20.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCHandleDirection.h"
#import "DCTickTimer.h"
#import "DCFileSource.h"

@interface DCImagePreview : UIView <DCFileSourceDelegate, DCTickTimerDelegate, DCHandleDirection>

@property (nonatomic) BOOL isMoveOvershootable;
@property (nonatomic) BOOL isScaleOvershootable;
@property (nonatomic) BOOL isScalable;

-(DCFileSource*) source;

@end
