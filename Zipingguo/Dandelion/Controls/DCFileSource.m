//
//  DCDataSource.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-5-29.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCFileSource.h"
#import "DCUrlEntityManager.h"
#import "AppContext.h"

@implementation DCFileSource {
    
    NSString* _url;
    NSString* _urlFileName;
    NSString* _filePath;
    NSString* _resourceFileName;
    
    BOOL _isDownloading;
}

@synthesize delegate;


-(void) didScheduleDownload {
    [delegate acceptFile:nil];
    _isDownloading = YES;
}

-(void) downloadDidProgressTo:(float) progress {
}

-(void) setUrl:(NSString*) url fileName:(NSString*) fileName {
    [self setUrl:url fileName:fileName limitSize:-1];
}

-(void) setUrl:(NSString*) url fileName:(NSString*) fileName limitSize:(int) limitSize {

    
    if ([_url isEqualToString:url]) {
        return;
    }
    
    
    _resourceFileName = nil;
    _url = url;
    _urlFileName = fileName;
    
    if (url.length > 0) {
        [[DCUrlEntityManager defaultManager] downloadUrlEntity:self fileName:fileName limitSize:limitSize];
    }
    else {
        [delegate acceptFile:nil];
        _filePath = nil;
    }
}

-(void) setFilePath:(NSString*) filePath {
    
    if (!_isDownloading && [_filePath isEqualToString:filePath]) {
        return;
    }
    
    _resourceFileName = nil;
    _filePath = filePath;
    
    [delegate acceptFile:filePath];
}

-(void) setResourceFileName:(NSString*) fileName {
    
    _url = nil;
    _urlFileName = nil;
    _resourceFileName = fileName;
    
    [delegate acceptFile:[[AppContext storageResolver] pathForResourceFile:fileName]];
}

-(void) ownerWillMoveToWindow:(UIWindow *)newWindow {
    
    if (!newWindow) {
        [[DCUrlEntityManager defaultManager] removeEntity:self];
    }
}

-(NSString*) url {
    return _url;
}

-(NSString*) urlFileName {
    return _urlFileName;
}

@end
