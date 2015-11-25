//
//  DCClearUnfinishedDownloadsTask.m
//  DandelionDemo
//
//  Created by Bob Li on 14-1-6.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCClearUnfinishedDownloadsTask.h"
#import "DB.h"
#import "DCSysDownloadingFileDB.h"

@implementation DCClearUnfinishedDownloadsTask

-(id) init {
    self = [super init];
    if (self) {
        self.feature = DCTaskFeatureLocalShortTask;
    }
    return self;
}

-(void) execute {
    
    NSError* error;
    
    for (DCSysDownloadingFileDB* file in [DB select:[DCSysDownloadingFileDB class] withSql:@"SELECT * FROM DCSysDownloadingFileDB"]) {
        [[NSFileManager defaultManager] removeItemAtPath:file.path error:&error];
    }

    [DB executeSql:@"DELETE FROM DCSysDownloadingFileDB"];
    
    if (error) {
        @throw [NSException exceptionWithName:@"Exception" reason:@"" userInfo:error.userInfo];
    }
}

@end
