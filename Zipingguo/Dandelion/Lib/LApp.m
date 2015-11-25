//
//  LApp.m
//  AmaranthDemo
//
//  Created by Sofia Work on 14-8-14.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "LApp.h"
#import "DCUrlDownloader.h"

@implementation LApp

+(void) removeAllDownloads {
    [AppContext removeAllDownloads];
}

+(void) removeDownloadsForUrls:(NSArray*) urls {
    [AppContext removeDownloadsForUrls:urls];
}

+(NSString*) localFilePathForUrl:(NSString *)url {
    return [[AppContext storageResolver] pathForDownloadedFileFromUrl:url fileName:nil];
}

+(void) setDownloadEventsEnabled:(BOOL) enabled {
    [DCUrlDownloader defaultDownloader].enableAppDelegate = enabled;
}

@end
