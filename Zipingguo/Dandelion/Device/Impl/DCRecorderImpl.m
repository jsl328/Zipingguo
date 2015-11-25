//
//  InvokeRecorderScript.m
//  AmaranthDemo
//
//  Created by Bob Li on 14-7-24.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCRecorderImpl.h"

@implementation DCRecorderImpl {
    
    AVAudioRecorder* _audioRecorder;
    
    AVAudioSession* _audioSession;
}


-(void) initRecordingToFileAtPath:(NSString*) filePath {

    self.isAudioAvailable = NO;
    self.isRecordingSucceeded = NO;

    _audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [_audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    
    if (!_audioSession.inputAvailable) {
        return;
    }
    
    if(err){
        NSLog(@"audioSession: %@ %d %@", [err domain], (int)[err code], [[err userInfo] description]);
        return;
    }
    
    [_audioSession setActive:YES error:&err];
    err = nil;
    if(err){
        NSLog(@"audioSession: %@ %d %@", [err domain], (int)[err code], [[err userInfo] description]);
        return;
    }
    
    
    NSMutableDictionary* recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    [recordSetting setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    
    
    NSURL *url = [NSURL fileURLWithPath:filePath];
    err = nil;
    _audioRecorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
    
    if (!_audioRecorder) {
        return;
    }
    

    [_audioRecorder setDelegate:self];
    [_audioRecorder prepareToRecord];
    _audioRecorder.meteringEnabled = YES;
    
    
    self.isAudioAvailable = YES;
}

-(void) didStartRecording {
    [_audioRecorder recordForDuration:self.maxDuration];
}

- (void) didStopRecording {
    [_audioRecorder stop];
}

-(float) volumn {
    [_audioRecorder updateMeters];
    return ([_audioRecorder averagePowerForChannel:0] + 120) / 120;
}
    
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag {
    self.isRecordingSucceeded = flag;
    [super didStop];
}

-(void) clear {

    _audioRecorder = nil;
    
    NSError* error = nil;
    [_audioSession setActive:NO error:&error];
    _audioSession = nil;
}

@end
