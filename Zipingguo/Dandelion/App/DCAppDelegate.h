//
//  AppEventDelegate.h
//  AmaranthDemo
//
//  Created by Sofia Work on 14-8-12.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 DCAppDelegate notifies the app that a global event occurs, such as file downloads, file uploads, audio/video playback, etc.
 The view tree is traversed in the following order to find which view implements this protocol.
 First, the top most view is visited, and back up.
 Then, the top controller is visited.
 If none is found, then nil is returned.
 */

@protocol DCAppDelegate <NSObject>

@optional

//
// The following 3 events pertain to playing audio files.
//

/*
 Occurs when app stops playing a file.
 Typically you use the filePath to iterate through items of ListBox to find the VM that represents the filePath. Then set certain flags to the VM and call [ListBox bindItem:VM] to update the cell.
 Also occurs when a file stops aplying due to that [LDevice play:] is called on another file while the previous file is still playing.
 */
-(void) appDidStopPlayingAudioFile:(NSString*) filePath;

/*
 Occurs when app starts playing a file.
 */
-(void) appDidStartPlayingAudioFile:(NSString*) filePath;

/*
 Occurs periodically as the file is playing.
 Typically you use time and totalTime to update VM of a ListBox, and call [ListBox bindItem:VM] to update the cell. An animation on the cell can be used to indicate that the file is playing.
 */
-(void) appDidPlayAudioFile:(NSString*) filePath toTime:(NSTimeInterval) time outOfTotalTime:(NSTimeInterval) totalTime;


//
// The following events pertain to downloading files.
//

-(void) appDidStartDownloadingUrl: (NSString*) url;

-(void) appDidDownloadUrl:(NSString*) url toPercent:(float) percent;

-(void) appDidDownloadUrl: (NSString*) url filePath:(NSString*) filePath limitSize:(int) limitSize;

-(void) appDidFailToDownloadUrl: (NSString*) url;



-(void) appDidReceiveErrorMessage:(NSString*) errorMessage;

@end
