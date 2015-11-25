//
//  LDevice.h
//  AmaranthDemo
//
//  Created by Sofia Work on 14-8-12.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LDevice : NSObject

+(void) play:(NSString*) filePath;

+(void) stopPlaying;

+(void) recordVoiceUpToDuration:(NSTimeInterval) duration callback:(void (^)(NSString*)) callback;

+(void) takePhoto:(void (^)(NSString*)) callback;

+(void) pickPhoto:(void (^)(NSString*)) callback;

+(void) drawImage:(void (^)(NSString*)) callback;

@end
