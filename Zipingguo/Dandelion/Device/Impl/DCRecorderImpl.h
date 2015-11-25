//
//  InvokeRecorderScript.h
//  AmaranthDemo
//
//  Created by Bob Li on 14-7-24.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCRecorder.h"
#import <AVFoundation/AVFoundation.h>

@interface DCRecorderImpl : DCRecorder <AVAudioRecorderDelegate>

@end
