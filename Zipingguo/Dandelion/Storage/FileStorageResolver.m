//
//  FileStorageLocationResolver.m
//  Dandelion
//
//  Created by Bob Li on 13-8-23.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "FileStorageResolver.h"
#import "FileSystem.h"
#import "DCFilePathHelper.h"

@implementation FileStorageResolver

-(NSString*) workingRootDirectory {
    return nil;
}

-(NSString*) pathForResourceFile: (NSString*) fileName {
    return [DCFilePathHelper filePathCombinedFromPath:[[NSBundle mainBundle] resourcePath] withPath:fileName];
}

-(NSString*) pathForPickedFile: (NSString*) fileName {
    return [self pathForFile:fileName directory:[self directoryForPickedFile]];
}

-(NSString*) newPathForDownloadedFile:(NSString*) fileName {
    return [self pathForFile:fileName directory:[self directoryForDownloadedFile]];
}

-(NSString*) pathForDownloadedFileFromUrl:(NSString*) url fileName:(NSString*) fileName {
    
    NSString* downloadedFileName;
    
    
    if (!fileName || fileName.length == 0) {
        NSInteger urlDotPosition = [url rangeOfString:@"." options:NSBackwardsSearch].location;
        if (urlDotPosition >= 0 && urlDotPosition <= url.length - 1) {
            fileName = [url substringFromIndex:urlDotPosition + 1];
        }
    }
    
    NSInteger dotPosition = [fileName rangeOfString:@"." options:NSBackwardsSearch].location;
    if (dotPosition >= 0 && dotPosition <= fileName.length - 1) {
        downloadedFileName = fileName;
    }
    else {
        downloadedFileName = [NSString stringWithFormat:@"%@.%@", DCMD5ForString(url), fileName];
    }
    
    return [self pathForFile:downloadedFileName directory:[self directoryForDownloadedFile]];
}

-(NSString*) pathForAppFile:(NSString *)fileName {
    return [self pathForFile:fileName directory:[self directoryForAppFile]];
}

-(NSString*) pathForFolderUnderDownloadFolder:(NSString*) folderPath {
    return [self pathForFolder:folderPath directory:[self directoryForDownloadedFile]];
}

-(NSString*) pathForFolderUnderAppFolder:(NSString*) folderPath {
    return [self pathForFolder:folderPath directory:[self directoryForAppFile]];
}


-(NSString*) pathForFolder:(NSString*) folderPath directory: (NSString*) directory {
    NSString* path = [DCFilePathHelper filePathCombinedFromPath:[self workingRootDirectory] withPath:[DCFilePathHelper filePathCombinedFromPath:directory withPath:folderPath]];
    [FileSystem ensureDirectoryExists:path];
    return path;
}

-(NSString*) pathForFile: (NSString*) fileName directory: (NSString*) directory {
    
    NSString* filePath;
    NSInteger dotPosition = [fileName rangeOfString:@"."].location;
    
    if (dotPosition >= 0 && dotPosition <= fileName.length - 1) {
        filePath = [DCFilePathHelper filePathCombinedFromPath:directory withPath:fileName];
    }
    else {
        filePath = [DCFilePathHelper filePathCombinedFromPath:directory withPath:[self fileNameWithExtension:fileName]];
    }
    
    filePath = [DCFilePathHelper filePathCombinedFromPath:[self workingRootDirectory] withPath:filePath];
    [FileSystem ensureDirectoryExists:[DCFilePathHelper folderPathForFilePath:filePath]];
    return filePath;
}

-(NSString*) fileNameWithExtension: (NSString*) extension {
    return [NSString stringWithFormat:@"%@.%@", DCUUIDMake(), extension];
}


-(void) removeAllDownloads {
    
    NSString* downloadFolderPath = [[AppContext storageResolver] pathForFolderUnderDownloadFolder:nil];
    [[NSFileManager defaultManager] removeItemAtPath:downloadFolderPath error:nil];
}

-(void) removeDownloadsForUrls:(NSArray*) urls {
    
    NSArray* filesToRemove = [urls map:^id(NSString* item) {
        return [[AppContext storageResolver] pathForDownloadedFileFromUrl:item fileName:nil];
    }];
    
    
    NSString* downloadFolderPath = [[AppContext storageResolver] pathForFolderUnderDownloadFolder:nil];
    
    for (NSString* fileName in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:downloadFolderPath error:nil]) {
        
        NSString* filePath = [DCFilePathHelper filePathCombinedFromPath:downloadFolderPath withPath:fileName];
        
        if ([filesToRemove containsObject:filePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
    }
}


// abstract methods

-(NSString*) directoryForPickedFile {
    return nil;
}

-(NSString*) directoryForDownloadedFile {
    return nil;
}

-(NSString*) directoryForAppFile {
    return nil;
}

//

@end
