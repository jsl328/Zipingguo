//
//  DCFileDownloadTask.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-7-18.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCDownloadTask.h"

@interface DCFileDownloadTask : DCDownloadTask

@property (retain, nonatomic) NSString* fileName;
@property (nonatomic) int limitSize;
@property (retain, nonatomic) NSString* targetFilePath;

@end
