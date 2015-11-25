//
//  DCDataRequestTask.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-7-18.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCDownloadTask.h"

@interface DCDataRequestTask : DCDownloadTask

-(NSData*) returnedData;

@end
