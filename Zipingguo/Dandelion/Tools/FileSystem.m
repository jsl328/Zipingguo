//
//  FileSystem.m
//  Mulberry
//
//  Created by Bob Li on 13-7-2.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "FileSystem.h"

@implementation FileSystem

+(void) ensureDirectoryExists: (NSString*) directoryPath {
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    BOOL exists = [fileManager fileExistsAtPath:directoryPath];
    
    if (!exists) {
        [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

@end
