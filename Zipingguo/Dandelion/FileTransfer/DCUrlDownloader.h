//
//  DownloadShceduler.h
//  Dandelion
//
//  Created by Bob Li on 13-8-23.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCTaskPoolDelegate.h"


@protocol DCUrlDownloaderDelegate <NSObject>

@optional

-(void) urlDownloadDidStart: (NSString*) url;

-(void) url:(NSString*) url progressDidChange:(float) progress;

-(void) urlDownloadDidSucceed: (NSString*) url fileName:(NSString*) fileName limitSize:(int) limitSize;

-(void) urlDownloadDidFail: (NSString*) url;

@end



@interface DCUrlDownloader : NSObject <DCTaskPoolDelegate>
@property (nonatomic) BOOL enableAppDelegate;

+(DCUrlDownloader*) defaultDownloader;

-(void) addDelegate:(id <DCUrlDownloaderDelegate>) delegate;

-(void) removeDelegate:(id <DCUrlDownloaderDelegate>) delegate;

-(void) downloadUrl:(NSString*) url fileName:(NSString*) fileName limitSize:(int) limitSize;
-(void) downloadUrl:(NSString*) url fileName:(NSString*) fileName limitSize:(int) limitSize  completeCallback:(void (^)(NSString*)) completeCallback failCallback:(void (^)(void)) failCallback;

-(BOOL) isDownloadingUrl:(NSString*) url;

@end
