//
//  DCFileQuery1.m
//  AmaranthDemo
//
//  Created by Bob Li on 14-8-1.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCFileQuery.h"
#import "DCGroupResult.h"

@implementation DCFileQuery {
    
    NSMutableArray* _results;
}

@synthesize options;

-(id) init {
    self = [super init];
    if (self) {
        options = [[DCFileQueryOptions alloc] init];
    }
    return self;
}


-(NSArray*) rootNodes {
    return [self rootFolders];
}

-(NSArray*) subNodesOfNode:(id) node {

    NSString* filePath = node;
    
    if ([self isDirectory:filePath]) {
        
        NSMutableArray* subFiles = [[NSMutableArray alloc] init];
        
        for (NSString* subFile in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:nil]) {
            [subFiles addObject:[NSString stringWithFormat:@"%@/%@", filePath, subFile]];
        }
        
        return subFiles;
    }
    else {
        return @[];
    }
}

-(BOOL) isDirectory:(NSString*) filePath {
    
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error: nil];
    NSString* fileType = [attrs objectForKey: NSFileType];
    return [fileType isEqualToString:NSFileTypeDirectory];
}


-(NSArray*) matchedFiles {
    [self findFiles];
    return _results;
}

-(NSArray*) matchedFilesGroupedByFolder {
    
    [self findFiles];
    
    return [_results groupBy:^id(NSString* filePath) {
        
        NSInteger positionOfSlash = [filePath rangeOfString:@"/" options:NSBackwardsSearch].location;
        NSString* folderPath = [filePath substringToIndex:positionOfSlash];
        
        return folderPath;
        
    } keysSortedBy:^NSComparisonResult(DCGroupResult* group1, DCGroupResult* group2) {
        return [group1.key compare:group2.key];
    }];
}

-(NSArray*) matchedFilesGroupedByExtension {
    
    [self findFiles];
    
    return [_results groupBy:^id(NSString* filePath) {
        
        NSInteger positionOfDot = [filePath rangeOfString:@"." options:NSBackwardsSearch].location;
        NSString* extension = positionOfDot == NSNotFound ? @"" : [filePath substringFromIndex:positionOfDot + 1];
        
        return extension;
        
    } keysSortedBy:^NSComparisonResult(DCGroupResult* group1, DCGroupResult* group2) {
        return [group1.key compare:group2.key];
    }];
}


-(void) findFiles {
    
    if (!_results) {
        
        _results = [[NSMutableArray alloc] init];
        
        
        DCTreeIterator* it = [[DCTreeIterator alloc] initWithTree:self];
        
        int count = 0;
        NSString* filePath = nil;
        while ((filePath = [it next]) != nil) {
            
            NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error: nil];

            if ([[attrs objectForKey: NSFileType] isEqualToString:NSFileTypeRegular] && [options fileMatchesSearchCriteria:filePath withAttrs:attrs]) {
                
                [_results addObject:filePath];
            
                count++;
                if (options.maxFileCount >= 0 && count == options.maxFileCount) {
                    break;
                }
            }
        }
        
            
        [_results sortUsingComparator:^NSComparisonResult(NSString* obj1, NSString* obj2) {
            return [obj1 compare:obj2];
        }];
    }
}

-(NSArray*) rootFolders {
    
    NSMutableArray* rootFolders = [[NSMutableArray alloc] init];
    [rootFolders addObjectsFromArray:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSAllDomainsMask, YES)];
    [rootFolders addObjectsFromArray:NSSearchPathForDirectoriesInDomains(NSPicturesDirectory, NSAllDomainsMask, YES)];
    [rootFolders addObjectsFromArray:NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSAllDomainsMask, YES)];
    
    NSMutableArray* existingRootFolders = [[NSMutableArray alloc] init];
    for (NSString* rootFolder in rootFolders) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:rootFolder]) {
            [existingRootFolders addObject:rootFolder];
        }
    }
    
    return existingRootFolders;
}

@end
