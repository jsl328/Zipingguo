//
//  DCRecordDialog.h
//  AmaranthDemo
//
//  Created by Bob Li on 14-7-24.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCVolumnMeterView.h"

@interface DCRecordDialog : NSObject

@property (nonatomic) BOOL keepRecordedAudio;
@property (retain, nonatomic) DCVolumnMeterView* volumnMeterView;

-(void) showDialog:(void (^)(void)) closeCallback;

-(void) setTimeInSeconds:(int) seconds;

-(void) setTimeExipired;

@end
