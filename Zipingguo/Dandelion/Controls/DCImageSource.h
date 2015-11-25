//
//  DCImageView.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-5-29.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCUrlEntity.h"
#import "DCImageCacheConsumer.h"

@protocol DCImageSourceDelegate <NSObject>

-(void) acceptImage:(UIImage*) image;

@end


@interface DCImageSource : NSObject <DCUrlEntity, DCImageCacheConsumer>

@property (retain, nonatomic) NSString* placeholder;
@property (assign, nonatomic) id <DCImageSourceDelegate> delegate;
@property (nonatomic) int limitSize;

-(void) setUrl:(NSString*) url fileName:(NSString*) fileName;
-(void) setUrl:(NSString*) url fileName:(NSString*) fileName limitSize:(int) limitSize;
-(void) setFilePath:(NSString*) filePath;
-(void) setResourceFileName:(NSString*) fileName;

-(NSString*) url;
-(NSString*) urlFileName;

-(void) ownerWillMoveToWindow:(UIWindow*) window;

@end
