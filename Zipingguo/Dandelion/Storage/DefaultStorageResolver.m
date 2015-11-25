//
//  DefaultStorageLocationResolver.m
//  Dandelion
//
//  Created by Bob Li on 13-8-23.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DefaultStorageResolver.h"

@implementation DefaultStorageResolver

-(NSString*) workingRootDirectory {
    
    if (!_documentDirectory) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
        _documentDirectory = [paths objectAtIndex:0];
    }
    
    return _documentDirectory;
}

-(NSString*) directoryForPickedFile {
    return @"Picked";
}

-(NSString*) directoryForDownloadedFile {
    return @"Downloaded";
}

-(NSString*) directoryForAppFile {
    return @"AppFiles";
}

@end
