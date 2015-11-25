//
//  DCImageCacheItemComparer.m
//  DandelionDemo
//
//  Created by Bob Li on 14-2-8.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCImageCacheItemComparer.h"
#import "DCImageCacheItem.h"

@implementation DCImageCacheItemComparer

-(int) compare:(id)object1 with:(id)object2 {

    DCImageCacheItem* item1 = object1;
    DCImageCacheItem* item2 = object2;
    
    if (item1.isImageLoaded != item2.isImageLoaded) {
        return (item1.isImageLoaded ? 0 : 1) - (item2.isImageLoaded ? 0 : 1);
    }
    else if (item1.referenceCount == 0 != item2.referenceCount == 0) {
        return item1.referenceCount - item2.referenceCount;
    }
    else {
        return item1.lastAccessTime - item2.lastAccessTime;
    }
}

@end
