//
//  DCImageCacheItem.h
//  Nanumanga
//
//  Created by Bob Li on 13-9-12.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCBinaryHeapItem.h"

@interface DCImageCacheItem : NSObject <DCBinaryHeapItem> {
    BOOL _isImageLoaded;
    int _imageSize;
}

@property (nonatomic) int lastAccessTime;
@property (retain, nonatomic) UIImage* image;
@property (nonatomic) NSString* filePath;
@property (nonatomic) int referenceCount;
@property (nonatomic) int binaryHeapIndex;
@property (retain, nonatomic) NSString* imageSource;
@property (nonatomic) int limitSize;
@property (nonatomic) int isResourceFile;

-(BOOL) isImageLoaded;
-(int) imageSize;

-(void) updateAccessTime;

-(void) loadImage;

@end
