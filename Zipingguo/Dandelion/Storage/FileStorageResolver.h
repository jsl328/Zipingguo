//
//  FileStorageLocationResolver.h
//  Dandelion
//
//  Created by Bob Li on 13-8-23.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileStorageResolver : NSObject

-(NSString*) workingRootDirectory;

-(NSString*) pathForResourceFile: (NSString*) fileName;
-(NSString*) pathForPickedFile: (NSString*) fileName;
-(NSString*) newPathForDownloadedFile:(NSString*) fileName;
-(NSString*) pathForDownloadedFileFromUrl:(NSString*) url fileName:(NSString*) fileName;

-(NSString*) pathForAppFile:(NSString*) fileName;
-(NSString*) pathForFolderUnderDownloadFolder:(NSString*) folderPath;
-(NSString*) pathForFolderUnderAppFolder:(NSString*) folderPath;


-(void) removeAllDownloads;
-(void) removeDownloadsForUrls:(NSArray*) urls;


// abstract methods;

-(NSString*) directoryForPickedFile;
-(NSString*) directoryForDownloadedFile;
-(NSString*) directoryForAppFile;

//

@end
