//
//  DCImageCacheConsumer.h
//  DandelionDemo
//
//  Created by Bob Li on 14-2-8.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCImageCacheItem.h"

@protocol DCImageCacheConsumer <NSObject>

-(void) relinquishCachedImage;
-(void) setCachedImage:(UIImage*) image isImageLoaded:(BOOL) isImageLoaded;

-(NSString*) filePathForCachedImage;
-(NSString*) resourceNameForCachedImage;

@end
