//
//  DCFileDownloadTask.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-7-18.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCFileDownloadTask.h"
#import "DCSysDownloadingFileDB.h"

static NSObject* _lock;

@implementation DCFileDownloadTask {

    NSOutputStream* _stream;
}

@synthesize fileName;
@synthesize limitSize;
@synthesize targetFilePath;


+(void) load {
    _lock = [[NSObject alloc] init];
}

-(id) init {
    self = [super init];
    if (self) {
        self.httpMethod = @"GET";
        self.feature = DCTaskFeatureStreamDownload;
    }
    return self;
}

-(void) execute {

    if (![[NSFileManager defaultManager] fileExistsAtPath:targetFilePath]) {
        [self logDownloadFileSession];
        _stream = [NSOutputStream outputStreamToFileAtPath:targetFilePath append:NO];
        [_stream open];
        [super execute];
    }
}

// abstract methods

-(void) writeData:(NSData*) data {
     [_stream write:[data bytes] maxLength:data.length];
}

-(void) onDownloadComplete {
    
    [_stream close];
    [self removeDownloadFileSession];
}

//


-(void) logDownloadFileSession {
    
    @synchronized (_lock) {
        DCSysDownloadingFileDB* fileDB = [[DCSysDownloadingFileDB alloc] init];
        fileDB.url = self.url;
        fileDB.path = targetFilePath;
        [fileDB save];
    }
}

-(void) removeDownloadFileSession {
    
    @synchronized (_lock) {
        DCSysDownloadingFileDB* fileDB = [[DCSysDownloadingFileDB alloc] init];
        fileDB.url = self.url;
        [fileDB deleteFromDB];
    }
}

@end
