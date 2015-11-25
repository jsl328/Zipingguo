//
//  DCFile.m
//  DandelionDemo
//
//  Created by Bob Li on 13-12-12.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCFile.h"

@implementation DCFile
@synthesize path;

+(DCFile*) fileAtPath:(NSString *)filePath {
    DCFile* file = [[DCFile alloc] init];
    file.path = filePath;
    return file;
}

-(int) length {
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:path error: nil];
    return [[attrs objectForKey: NSFileSize] intValue];
}

@end
