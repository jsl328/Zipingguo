//
//  DCPlayer.m
//  AmaranthDemo
//
//  Created by Bob Li on 14-7-29.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCPlayer.h"

@implementation DCPlayer {

    BOOL _isStopping;
    
    float _duration;
}


// abstract methods

-(void) playAudioFileAtPath:(NSString*) filePath stopCallback:(void (^)(void))callback {
}

-(void) stopPlaying {
}

-(float) durationOfAudio {
    return 0;
}

//


@end
