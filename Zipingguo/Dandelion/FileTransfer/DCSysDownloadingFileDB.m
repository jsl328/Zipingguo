//
//  DCSysDownloadingFileDB.m
//  DandelionDemo
//
//  Created by Bob Li on 14-1-6.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCSysDownloadingFileDB.h"
#import "DB.h"

@implementation DCSysDownloadingFileDB
@synthesize url;
@synthesize path;

-(void) deleteFromDB {
    [DB executeSql:[NSString stringWithFormat:@"DELETE FROM DCSysDownloadingFileDB WHERE url='%@'", url]];
}

@end
