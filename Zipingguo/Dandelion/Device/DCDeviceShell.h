//
//  DCDeviceShell.h
//  AmaranthDemo
//
//  Created by Bob Li on 14-8-4.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCSelectImageDialog.h"
#import "DCRecorder.h"
#import "DCRecordDialog.h"
#import "DCPlayer.h"

@interface DCDeviceShell : NSObject


+(DCDeviceShell*) defaultShell;

-(NSTimeInterval) durationOfPlayingFile;


-(void) playAudioAtFilePath:(NSString*) filePath;

-(void) stopPlaying;

-(void) recordVoiceUpToDuration:(NSTimeInterval) duration usingCallback:(void (^)(NSString*)) callback;

-(void) takePhotoUsingCallback:(void (^)(NSString*)) callback;

-(void) pickPhotoUsingCallback:(void (^)(NSString*)) callback;

-(void) drawImageUsingCallback:(void (^)(NSString*)) callback;


@end
