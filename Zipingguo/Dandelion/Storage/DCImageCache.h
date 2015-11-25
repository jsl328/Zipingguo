//
//  ResourceImageLoader.h
//  Nanumanga
//
//  Created by Bob Li on 13-9-10.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCTaskPool.h"
#import "DCImageCacheItem.h"
#import "DCBinaryHeap.h"
#import "DCImageCacheConsumer.h"

@interface DCImageCache : NSObject

@property (nonatomic) int maximumCacheSize;

+(DCImageCache*) defaultCache;

-(int) count;

-(int) usedSize;


-(void) requestImageFromResourceFile:(NSString*) fileName limitSize:(int) limitSize byConsumer:(id <DCImageCacheConsumer>) consumer;
-(void) requestImageFromPath:(NSString*) path limitSize:(int) limitSize byConsumer:(id <DCImageCacheConsumer>) consumer;

-(void) removeConsumer:(id <DCImageCacheConsumer>) consumer;

-(void) removeAllItems;
-(void) removeItemsForFiles:(NSArray*) filePaths;

-(void) evictNonReferencedItems;

@end
