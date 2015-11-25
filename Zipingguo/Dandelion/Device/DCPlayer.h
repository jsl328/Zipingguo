//
//  DCPlayer.h
//  AmaranthDemo
//
//  Created by Bob Li on 14-7-29.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCPlayer : NSObject


// abstract methods

-(void) playAudioFileAtPath:(NSString*) filePath stopCallback:(void (^)(void)) callback;

-(void) stopPlaying;

-(float) durationOfAudio;

//

@end
