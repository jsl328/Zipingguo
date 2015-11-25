//
//  LDevice.m
//  AmaranthDemo
//
//  Created by Sofia Work on 14-8-12.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "LDevice.h"
#import "DCDeviceShell.h"

@implementation LDevice

+(void) play:(NSString*) filePath {
    [[DCDeviceShell defaultShell] playAudioAtFilePath:filePath];
}

+(void) stopPlaying {
    [[DCDeviceShell defaultShell] stopPlaying];
}

+(void) recordVoiceUpToDuration:(NSTimeInterval) duration callback:(void (^)(NSString*)) callback {
    [[DCDeviceShell defaultShell] recordVoiceUpToDuration:duration usingCallback:callback];
}

+(void) takePhoto:(void (^)(NSString*)) callback {
    [[DCDeviceShell defaultShell] takePhotoUsingCallback:callback];
}

+(void) pickPhoto:(void (^)(NSString*)) callback {
    [[DCDeviceShell defaultShell] pickPhotoUsingCallback:callback];
}

+(void) drawImage:(void (^)(NSString*)) callback {
    [[DCDeviceShell defaultShell] drawImageUsingCallback:callback];
}

@end
