//
//  DCSysDownloadingFileDB.h
//  DandelionDemo
//
//  Created by Bob Li on 14-1-6.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EntityBase.h"

@interface DCSysDownloadingFileDB : EntityBase

@property (retain, nonatomic) NSString* url;
@property (retain, nonatomic) NSString* path;

-(void) deleteFromDB;

@end
