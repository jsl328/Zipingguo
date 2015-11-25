//
//  DCRecorder.m
//  AmaranthDemo
//
//  Created by Bob Li on 14-7-24.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCRecorder.h"

@implementation DCRecorder {

    BOOL _isStopped;
    
    BOOL _isDialogClosed;
    
    id _expireCallback;
    id _completeCallback;
}

@synthesize maxDuration;
@synthesize isAudioAvailable;
@synthesize isRecordingSucceeded;


-(void) startRecordingWithExpireCallback:(void (^)(void)) expireCallback completeCallback:(void (^)(void)) completeCallback {
    _expireCallback = expireCallback;
    _completeCallback = completeCallback;
    _isStopped = NO;
    _isDialogClosed = NO;
    [self didStartRecording];
}

-(void) stopRecording {
    
    _isDialogClosed = YES;
    
    if (!_isStopped) {
        [self didStopRecording];
    }
    else {
        [self clear];
        ((void (^)(void))_completeCallback)();
        _completeCallback = nil;
        _expireCallback = nil;
    }
}

-(void) didStop {
    _isStopped = YES;
    if (_isDialogClosed) {
        [self clear];
        ((void (^)(void))_completeCallback)();
        _completeCallback = nil;
    }
    else {
        ((void (^)(void))_expireCallback)();
        _expireCallback = nil;
    }
}


// abstract methods

-(void) initRecordingToFileAtPath:(NSString*) filePath {
}

-(void) didStartRecording {
}

-(void) didStopRecording {
}

-(float) volumn {
    return 0;
}

-(void) clear {
}

//

@end
