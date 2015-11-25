//
//  FileSystem.h
//  Mulberry
//
//  Created by Bob Li on 13-7-2.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileSystem : NSObject

+(void) ensureDirectoryExists: (NSString*) directoryPath;

@end
