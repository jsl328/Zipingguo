//
//  DCRecorder.h
//  AmaranthDemo
//
//  Created by Bob Li on 14-7-24.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCRecorder : NSObject

@property (nonatomic) NSTimeInterval maxDuration;
@property (nonatomic) BOOL isAudioAvailable;
@property (nonatomic) BOOL isRecordingSucceeded;

-(void) startRecordingWithExpireCallback:(void (^)(void)) expireCallback completeCallback:(void (^)(void)) completeCallback;

-(void) stopRecording;

-(void) didStop;


// abstract methods

-(void) didStartRecording;

-(void) didStopRecording;

-(void) initRecordingToFileAtPath:(NSString*) filePath;

-(float) volumn;

-(void) clear;

//

@end
