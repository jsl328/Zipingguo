//
//  DCDataSource.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-5-29.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCUrlEntity.h"

@protocol DCFileSourceDelegate <NSObject>

-(void) acceptFile:(NSString*) filePath;

@end


@interface DCFileSource : NSObject <DCUrlEntity>

@property (assign, nonatomic) id <DCFileSourceDelegate> delegate;

-(void) setUrl:(NSString*) url fileName:(NSString*) fileName;
-(void) setUrl:(NSString*) url fileName:(NSString*) fileName limitSize:(int) limitSize;
-(void) setFilePath:(NSString*) filePath;
-(void) setResourceFileName:(NSString*) fileName;


-(void) ownerWillMoveToWindow:(UIWindow*) newWindow;

-(NSString*) url;
-(NSString*) urlFileName;

@end
