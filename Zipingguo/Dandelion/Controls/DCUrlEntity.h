//
//  DCUrlEntity.h
//  DandelionDemo
//
//  Created by Bob Li on 14-2-7.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DCUrlEntity <NSObject>

-(NSString*) url;

-(void) setFilePath:(NSString*) filePath;

@optional

-(void) didScheduleDownload;

-(void) downloadDidProgressTo:(float) progress;

@end
