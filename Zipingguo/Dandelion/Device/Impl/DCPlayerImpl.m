//
//  DCInternalPlayer.m
//  AmaranthDemo
//
//  Created by Bob Li on 14-7-29.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCPlayerImpl.h"
#import <AVFoundation/AVFoundation.h>

@implementation DCPlayerImpl {

    AVAudioPlayer* _audioPlayer;
    
    id _callback;
}

// abstract methods

-(void) playAudioFileAtPath:(NSString*) filePath stopCallback:(void (^)(void))callback {
    
    NSError* error = nil;

    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:filePath] error:&error];
    
    if (error || !_audioPlayer) {
        callback();
    }
    else {
        _callback = callback;
        _audioPlayer.delegate = self;
        [_audioPlayer play];
    }
}

-(void) stopPlaying {
    [_audioPlayer stop];
    [self playDidStop];
}

-(float) durationOfAudio {
    return _audioPlayer.duration;
}

//


-(void) playDidStop {
    _audioPlayer.delegate = nil;
    _audioPlayer = nil;
    ((void (^)(void))_callback)();
    _callback = nil;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self playDidStop];
}

@end
