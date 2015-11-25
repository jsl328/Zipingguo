//
//  DCDeviceShell.m
//  AmaranthDemo
//
//  Created by Bob Li on 14-8-4.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCDeviceShell.h"
#import "DCSelectImageDialogDefaultImpl.h"
#import "DCLocalizedStrings.h"
#import "DCRecordDialogDefaultImpl.h"
#import "DCRecorderImpl.h"
#import "DCPlayerImpl.h"
#import "DCDrawImageDialog.h"
#import "DCDrawImageDialogDefaultImpl.h"
#import "DCVolumnMeterViewDefaultImpl.h"
#import "DCAppEventDispatcher.h"


static DCDeviceShell* _defaultShell;

@implementation DCDeviceShell {
    
    
    NSTimer* _pollVolumnTimer;
    
    long _startRecordingTime;
    

    NSTimer* _pollProgressTimer;
    
    BOOL _isPlaying;
    
    int _tickCount;
    
    NSString* _playingAudioFilePath;
    
    NSString* _scheduledAudioFilePath;
    
    float _duration;
}


+(void) load {
    _defaultShell = [[DCDeviceShell alloc] init];
}

+(DCDeviceShell*) defaultShell {
    return _defaultShell;
}

-(NSTimeInterval) durationOfPlayingFile {
    return _duration;
}


-(DCRecorder*) recorder {
    return [AppContext settings].recorder;
}

-(DCRecordDialog*) recordDialog {
    return [AppContext settings].recordDialog;
}

-(DCSelectImageDialog*) selectImageDialog {
    return [AppContext settings].selectImageDialog;
}

-(DCPlayer*) player {
    return [AppContext settings].player;
}

-(DCDrawImageDialog*) drawImageDialog {
    return [AppContext settings].drawImageDialog;
}

-(UIView*) volumnMeterView {
    return [AppContext settings].volumnMeterView;
}


-(void) playDidStop {

    [_pollProgressTimer invalidate];
    _pollProgressTimer = nil;
    _tickCount = 0;
    _duration = 0;
    _isPlaying = NO;
    
    [DCAppEventDispatcher dispatchStopPlayingAudioFile:_playingAudioFilePath];
    _playingAudioFilePath = nil;

    if (_scheduledAudioFilePath) {
        [self playAudioAtFilePath:_scheduledAudioFilePath];
        _scheduledAudioFilePath = nil;
    }
}

-(void) playAudioAtFilePath:(NSString *)filePath {

    if (_playingAudioFilePath) {
        _scheduledAudioFilePath = filePath;
        [[self player] stopPlaying];
    }
    else if (filePath && filePath.length > 0) {
        
        _playingAudioFilePath = filePath;
        [DCAppEventDispatcher dispatchStartPlayingAudioFile:filePath];
        
        [[self player] playAudioFileAtPath:filePath stopCallback:^{
            [self playDidStop];
        }];
        
        _isPlaying = YES;
        _duration = [[self player] durationOfAudio];
        _tickCount = 0;
        _pollProgressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(onPollProgressTimerTick:) userInfo:nil repeats:YES];
    }
}

-(void) stopPlaying {
    [[self player] stopPlaying];
}

-(void) onPollProgressTimerTick:(NSTimer*) sender {
    
    _tickCount++;
    [DCAppEventDispatcher dispatchPlayAudioFile:_playingAudioFilePath toTime:(float)_tickCount * 0.1 outOfTotalTime:_duration];
}


-(void) recordVoiceUpToDuration:(NSTimeInterval) duration usingCallback:(void (^)(NSString*)) callback {
    
    if (_isPlaying) {
        [self stopPlaying];
    }
    

    NSString* filePath = [[AppContext storageResolver] pathForPickedFile:@"mp4"];
    
    [self recorder].maxDuration = duration;
    [[self recorder] initRecordingToFileAtPath:filePath];
    
    if (![self recorder].isAudioAvailable) {
        [DCAppEventDispatcher dispatchReceiveErrorMessageFromStringKey:DCStringKeyAudioUnavailable];
        return;
    }
    
    
    long startRecordingTime = [[[NSDate alloc] init] timeIntervalSince1970];
    _startRecordingTime = startRecordingTime;
    

    [self recordDialog].volumnMeterView = (DCVolumnMeterView*)[self volumnMeterView];
    
    [self recordDialog].keepRecordedAudio = YES;
    [[self recordDialog] showDialog:^{
        [[self recorder] stopRecording];
    }];
    
    
    [[self recorder] startRecordingWithExpireCallback:^{
        
        if (_pollVolumnTimer) {
            [_pollVolumnTimer invalidate];
            _pollVolumnTimer = nil;
        }
        
        [[self recordDialog] setTimeExipired];
        
    } completeCallback:^{
        
        BOOL keepFile = YES;
        
        if (![self recorder].isRecordingSucceeded) {
            [DCAppEventDispatcher dispatchReceiveErrorMessageFromStringKey:DCStringKeyRecordingFail];
            keepFile = NO;
        }
        
        long endRecordingTime = [[[NSDate alloc] init] timeIntervalSince1970];
        if (endRecordingTime - startRecordingTime < 1) {
            [DCAppEventDispatcher dispatchReceiveErrorMessageFromStringKey:DCStringKeyAudioTooShort];
            keepFile = NO;
        }
        
        if (![self recordDialog].keepRecordedAudio) {
            keepFile = NO;
        }
        
        
        if (!keepFile) {
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
        
        if (_pollVolumnTimer) {
            [_pollVolumnTimer invalidate];
            _pollVolumnTimer = nil;
        }
        
        [self recordDialog].volumnMeterView = nil;
        callback(keepFile ? filePath : nil);
    }];
    

    _pollVolumnTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(onPollVolumnTimerTick:) userInfo:nil repeats:YES];
}

-(void) onPollVolumnTimerTick:(NSTimer*) timer {
    
    if ([self recordDialog].volumnMeterView) {
        [[self recordDialog].volumnMeterView setVolumn:[self recorder].volumn];
    }
        
    [[self recordDialog] setTimeInSeconds:[[NSDate alloc] init].timeIntervalSince1970 - _startRecordingTime];
}


-(void) takePhotoUsingCallback:(void (^)(NSString*)) callback {
    
    if (![self selectImageDialog].isCameraAvailable) {
        [DCAppEventDispatcher dispatchReceiveErrorMessageFromStringKey:DCStringKeyCameraUnavailable];
        callback(nil);
        return;
    }
    else {
        [[self selectImageDialog] openSelectImageDialog:YES callback:^{
            callback([self selectImageDialog].selectedFilePath);
            [self selectImageDialog].selectedFilePath = nil;
        }];
    }
}

-(void) pickPhotoUsingCallback:(void (^)(NSString*)) callback {
    
    [[self selectImageDialog] openSelectImageDialog:NO callback:^{
        callback([self selectImageDialog].selectedFilePath);
        [self selectImageDialog].selectedFilePath = nil;
    }];
}


-(void) drawImageUsingCallback:(void (^)(NSString*))callback {

    [[self drawImageDialog] showDialog:^{
        callback([self drawImageDialog].drawnImageFilePath);
        [self drawImageDialog].drawnImageFilePath = nil;
    }];
}


@end
