//
//  DCInternalPlayer.h
//  AmaranthDemo
//
//  Created by Bob Li on 14-7-29.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface DCPlayerImpl : DCPlayer <AVAudioPlayerDelegate>

@end
