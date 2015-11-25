//
//  LApp.h
//  AmaranthDemo
//
//  Created by Sofia Work on 14-8-14.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LApp : NSObject

+(void) removeAllDownloads;

+(void) removeDownloadsForUrls:(NSArray*) urls;

+(NSString*) localFilePathForUrl:(NSString*) url;

+(void) setDownloadEventsEnabled:(BOOL) enabled;

@end
