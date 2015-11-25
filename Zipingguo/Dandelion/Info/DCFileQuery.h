//
//  DCFileQuery1.h
//  AmaranthDemo
//
//  Created by Bob Li on 14-8-1.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCFileQueryOptions.h"
#import "DCTreeIterator.h"

@interface DCFileQuery : NSObject <DCAbstractTree>
@property (retain, nonatomic) DCFileQueryOptions* options;

-(NSArray*) matchedFiles;

-(NSArray*) matchedFilesGroupedByFolder;

-(NSArray*) matchedFilesGroupedByExtension;

@end
