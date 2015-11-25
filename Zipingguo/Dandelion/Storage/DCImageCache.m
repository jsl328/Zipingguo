//
//  ResourceImageLoader.m
//  Nanumanga
//
//  Created by Bob Li on 13-9-10.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCImageCache.h"
#import "DCImageCacheItem.h"
#import "DCActionTask.h"
#import "DCImageCacheItemComparer.h"

static DCImageCache* _defaultCache;

@implementation DCImageCache {
    
    NSMapTable* _consumerCacheItemMap;
    
    NSMutableDictionary* _cacheItems;
    
    DCBinaryHeap* _sortedItems;
    
    int _usedSize;
}

@synthesize maximumCacheSize;


-(id) init {
    self = [super init];
    if (self) {
        _consumerCacheItemMap = [NSMapTable strongToStrongObjectsMapTable];
        _cacheItems = [[NSMutableDictionary alloc] init];
        _sortedItems = [[DCBinaryHeap alloc] initWithComparer:[[DCImageCacheItemComparer alloc] init]];
        maximumCacheSize = 12 * 1024 * 1024;
        _usedSize = 0;
    }
    return self;
}

+(DCImageCache*) defaultCache {
    if (!_defaultCache) {
        _defaultCache = [[DCImageCache alloc] init];
    }
    return _defaultCache;
}

-(int) count {
    return (int)_cacheItems.count;
}

-(int) usedSize {
    return _usedSize;
}


-(void) decreaseCacheSizeToNoMoreThan:(int) size {
    
    while (_usedSize > size) {

        DCImageCacheItem* item = [_sortedItems pollItem];
        if (!item) {
            break;
        }
        else {
            [self removeCacheItem:item];
        }
    }
}

-(void) removeCacheItem:(DCImageCacheItem*) item {

    _usedSize -= item.imageSize;
    [_cacheItems removeObjectForKey:item.filePath];
    
    
    NSMutableArray* matchedItems;
    
    for (id <DCImageCacheConsumer> consumer in _consumerCacheItemMap.keyEnumerator) {
        if ([[consumer filePathForCachedImage] isEqualToString:item.filePath]) {
            if (!matchedItems) {
                matchedItems = [[NSMutableArray alloc] init];
            }
            [matchedItems addObject:consumer];
        }
    }
    
    if (matchedItems) {
        for (id <DCImageCacheConsumer> consumer in matchedItems) {
            [consumer relinquishCachedImage];
            [_consumerCacheItemMap removeObjectForKey:consumer];
        }
    }
}


-(void) mapConsumer:(id <DCImageCacheConsumer>) consumer withCacheItem:(DCImageCacheItem*) item {

    DCImageCacheItem* previousItem = [_consumerCacheItemMap objectForKey:consumer];
    if (previousItem == item) {
        return;
    }
    
    
    [_consumerCacheItemMap setObject:item forKey:consumer];
    
    if (previousItem) {
        previousItem.referenceCount--;
        [_sortedItems updateItem:previousItem];
    }
        
    item.referenceCount++;
    if (item.binaryHeapIndex == 0) {
        [_sortedItems addItem:item];
    }
    else {
        [_sortedItems updateItem:item];
    }
}

-(void) removeConsumer:(id <DCImageCacheConsumer>) consumer {

    DCImageCacheItem* previousItem = [_consumerCacheItemMap objectForKey:consumer];
    
    if (previousItem) {
        
        [consumer relinquishCachedImage];
    
        [_consumerCacheItemMap removeObjectForKey:consumer];

        previousItem.referenceCount--;
        [_sortedItems updateItem:previousItem];
    }
}

-(void) removeAllItems {
    
    for (id <DCImageCacheConsumer> consumer in _consumerCacheItemMap.keyEnumerator) {
        [consumer relinquishCachedImage];
    }
    
    [_consumerCacheItemMap removeAllObjects];
    [_cacheItems removeAllObjects];
    [_sortedItems removeAllItems];
    
    _usedSize = 0;
}

-(void) removeItemsForFiles:(NSArray*) filePaths {
    

    NSMutableArray* fullPaths = [[NSMutableArray alloc] init];
    
    for (NSString* filePath in filePaths) {
        
        NSString* fullPath;
        
        if ([filePath rangeOfString:@"/"].location != NSNotFound) {
            fullPath = filePath;
        }
        else {
            fullPath = [[AppContext storageResolver] pathForResourceFile:filePath];
        }
        
        [fullPaths addObject:fullPath];
    }
    
    
    NSMutableArray* cacheItemsToRemove = [[NSMutableArray alloc] init];
    
    for (DCImageCacheItem* item in _cacheItems.objectEnumerator) {
        if ([fullPaths containsObject:item.filePath]) {
            [cacheItemsToRemove addObject:item];
        }
    }
    
    
    for (DCImageCacheItem* item in cacheItemsToRemove) {
        [self removeCacheItem:item];
    }
}


-(void) evictNonReferencedItems {
    
    for (NSString* key in [_cacheItems.keyEnumerator allObjects]) {
        DCImageCacheItem* item = [_cacheItems objectForKey:key];
        if (item.referenceCount == 0) {
            [_cacheItems removeObjectForKey:key];
            [_sortedItems removeItem:item];
            _usedSize -= item.imageSize;
        }
    }
}


-(void) requestImageFromResourceFile:(NSString*) fileName limitSize:(int)limitSize byConsumer:(id<DCImageCacheConsumer>)consumer {
    [self requestImageFromPath:[[AppContext storageResolver] pathForResourceFile:fileName] limitSize:limitSize byConsumer:consumer withImageSource:fileName isResourceFile:YES];
}

-(void) requestImageFromPath:(NSString*) path limitSize:(int)limitSize byConsumer:(id<DCImageCacheConsumer>)consumer {
    [self requestImageFromPath:path limitSize:limitSize byConsumer:consumer withImageSource:path isResourceFile:NO];
}

-(void) requestImageFromPath:(NSString*) path limitSize:(int)limitSize byConsumer:(id <DCImageCacheConsumer>) consumer withImageSource:(NSString*) imageSource isResourceFile:(BOOL) isResourceFile {
    
    
    NSString* key = [NSString stringWithFormat:@"%@,%d", path, limitSize];
    
    DCImageCacheItem* item = [_cacheItems objectForKey:key];
    if (item) {
        
        if (item.isImageLoaded) {
            [item updateAccessTime];
        }
        
        [self mapConsumer:consumer withCacheItem:item];
        [consumer setCachedImage:item.image isImageLoaded:YES];
        return;
    }
    
    
    item = [[DCImageCacheItem alloc] init];
    item.filePath = path;
    item.limitSize = limitSize;
    item.imageSource = imageSource;
    item.isResourceFile = isResourceFile;
    
    [_cacheItems setObject:item forKey:key];
    [self mapConsumer:consumer withCacheItem:item];
    [consumer setCachedImage:item.image isImageLoaded:NO];
    
    
    DCActionTask* task = [[DCActionTask alloc] init];
    task.action = ^{
        [item loadImage];
    };
    task.feature = DCTaskFeatureLoadImage;
    [task addCompleteCallback:^{
        
        [self decreaseCacheSizeToNoMoreThan:maximumCacheSize - item.imageSize];
        
        
        _usedSize += item.imageSize;
        [item updateAccessTime];
        
        for (id <DCImageCacheConsumer> consumer in _consumerCacheItemMap.keyEnumerator) {
            NSString* imageSource = item.isResourceFile ? [consumer resourceNameForCachedImage] : [consumer filePathForCachedImage];
            if ([imageSource isEqualToString:item.imageSource]) {
                [consumer setCachedImage:item.image isImageLoaded:YES];
            }
        }
    }];
    
    [[DCTaskPool obtainConcurrent] addTask:task];
}

@end
