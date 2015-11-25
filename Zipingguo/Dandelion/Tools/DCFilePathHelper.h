//
//  DCFilePathHelper.h
//  DandelionDemo
//
//  Created by Bob Li on 13-12-25.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCFilePathHelper : NSObject

+(NSString*) folderPathForFilePath:(NSString*) filePath;

+(NSString*) filePathCombinedFromPath:(NSString*) path1 withPath:(NSString*) path2;

+(NSString*) fileNameForFilePath:(NSString*) filePath;

@end
