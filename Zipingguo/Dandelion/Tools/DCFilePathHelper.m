//
//  DCFilePathHelper.m
//  DandelionDemo
//
//  Created by Bob Li on 13-12-25.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCFilePathHelper.h"

@implementation DCFilePathHelper

+(NSString*) folderPathForFilePath:(NSString *)filePath {
    
    NSRange rangeOfLastSlash = [filePath rangeOfString:@"/" options:NSBackwardsSearch];
    NSString* directoryPath = [filePath substringWithRange:NSMakeRange(0, rangeOfLastSlash.location)];
    
    return directoryPath;
}

+(NSString*) filePathCombinedFromPath:(NSString*) path1 withPath:(NSString*) path2 {
    
    if ([path1 startsWithString:@"/"]) {
        path1 = [path1 substringFromIndex:1];
    }
    
    if ([path1 endsWithString:@"/"]) {
        path1 = [path1 substringToIndex:path1.length - 1];
    }
    
    if (!path2 || path2.length == 0) {
        return path1;
    }
    
    
    if ([path2 startsWithString:@"/"]) {
        path2 = [path2 substringFromIndex:1];
    }
    
    if ([path2 endsWithString:@"/"]) {
        path2 = [path2 substringToIndex:path2.length - 1];
    }
    
    
    return [NSString stringWithFormat:@"%@/%@", path1, path2];
}

+(NSString*) fileNameForFilePath:(NSString*) filePath {

    NSRange rangeOfLastSlash = [filePath rangeOfString:@"/" options:NSBackwardsSearch];
    NSRange rangeOfLastDot = [filePath rangeOfString:@"." options:NSBackwardsSearch];
    return [filePath substringWithRange:NSMakeRange(rangeOfLastSlash.location + 1, rangeOfLastDot.location - rangeOfLastSlash.location - 1)];
}

@end
