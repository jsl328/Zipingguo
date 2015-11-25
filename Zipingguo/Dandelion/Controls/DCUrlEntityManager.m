//
//  DCUrlImageViewScheduler.m
//  Nanumanga
//
//  Created by Bob Li on 13-9-11.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCUrlEntityManager.h"
#import "DCUrlDownloader.h"
#import "FileSystem.h"
#import "DCImageCache.h"
#import "AppContext.h"
#import "DCImageIO.h"

static DCUrlEntityManager* _instance;

@implementation DCUrlEntityManager

+(DCUrlEntityManager*) defaultManager {
    if (!_instance) {
        _instance = [[DCUrlEntityManager alloc] init];
    }
    return _instance;
}

-(id) init {
    self = [super init];
    if (self) {
        _downloading = [[DCWeakSet alloc] init];
        [[DCUrlDownloader defaultDownloader] addDelegate:self];
    }
    return self;
}

-(void) downloadUrlEntity:(id <DCUrlEntity>) urlEntity fileName:(NSString *)fileName limitSize:(int)limitSize {
    
    if (!fileName || fileName.length == 0) {
        int position = [urlEntity.url rangeOfString:@"." options:NSBackwardsSearch].location;
        if (position == NSNotFound) {
            fileName = @"dat";
        }
        else {
            fileName = [urlEntity.url substringFromIndex:position + 1];
        }
    }
    

    NSString* filePath = [[AppContext storageResolver] pathForDownloadedFileFromUrl:urlEntity.url fileName:fileName];
    BOOL isDownloading = [[DCUrlDownloader defaultDownloader] isDownloadingUrl:urlEntity.url];
    
    if (!isDownloading && [[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [urlEntity setFilePath:filePath];
        return;
    }
    
    
    [urlEntity didScheduleDownload];
    [_downloading addObject:urlEntity];
    
    if (!isDownloading) {
        [[DCUrlDownloader defaultDownloader] downloadUrl:urlEntity.url fileName:fileName limitSize:limitSize];
    }
}


-(void) urlDownloadDidSucceed: (NSString*) url fileName:(NSString *)fileName limitSize:(int)limitSize {
    
    
    NSString* filePath = [[AppContext storageResolver] pathForDownloadedFileFromUrl:url fileName:fileName];

    if (limitSize >= 0) {
        [DCImageIO downsampleImageAtFilePath:filePath toSizeNoMoreThan:limitSize];
    }
    
    
    NSArray* items = [self entitiesMatchingUrl:url];
    
    if (items) {
        for (id <DCUrlEntity> urlEntity in items) {
            [urlEntity setFilePath:filePath];
            [_downloading removeObject:urlEntity];
        }
    }
}

-(void) urlDownloadDidFail: (NSString*) url {

    NSArray* items = [self entitiesMatchingUrl:url];
    
    if (items) {
        for (id <DCUrlEntity> urlEntity in items) {
            [urlEntity setFilePath:nil];
            [_downloading removeObject:urlEntity];
        }
    }
}

-(void) url:(NSString *)url progressDidChange:(float)progress {

    for (id <DCUrlEntity> urlEntity in _downloading.objectEnumerator) {
        if ([urlEntity.url isEqualToString:url]) {
            [urlEntity downloadDidProgressTo:progress];
        }
    }
}


-(void) removeEntity:(id<DCUrlEntity>)entity {
    [_downloading removeObject:entity];
}


-(NSArray*) entitiesMatchingUrl:(NSString*) url {

    NSMutableArray* items = nil;
    
    for (id <DCUrlEntity> urlEntity in _downloading.objectEnumerator) {
        if ([urlEntity.url isEqualToString:url]) {
            
            if (!items) {
                items = [[NSMutableArray alloc] init];
            }
            [items addObject:urlEntity];
        }
    }
    
    return items;
}

@end
