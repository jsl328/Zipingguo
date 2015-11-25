//
//  DCImageCacheItem.m
//  Nanumanga
//
//  Created by Bob Li on 13-9-12.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCImageCacheItem.h"
#import "DCGifDecoder.h"
#import "DCImageIO.h"

static int _accessTime;

@implementation DCImageCacheItem
@synthesize lastAccessTime;
@synthesize image;
@synthesize filePath;
@synthesize referenceCount;
@synthesize binaryHeapIndex;
@synthesize imageSource;
@synthesize limitSize;
@synthesize isResourceFile;

+(void) initialize {
    _accessTime = 0;
}

-(id) init {
    self = [super init];
    if (self) {
        _isImageLoaded = NO;
        _imageSize = 0;
    }
    return self;
}

-(BOOL) isImageLoaded {
    return _isImageLoaded;
}

-(int) imageSize {
    return _imageSize;
}

-(void) updateAccessTime {
    _accessTime++;
    lastAccessTime = _accessTime;
}

-(void) loadImage {
    
    image = nil;
    
    if ([filePath endsWithString:@"gif"]) {
        
        PRGifDecoder* decoder = [[PRGifDecoder alloc] init];
        decoder.decodeFirstFrame = YES;
        [decoder readFromFile:filePath];
    
        if ([decoder getFrameCount] == 1) {
            image = [decoder getFrame:0];
        }
    }
    else {
        image = [UIImage imageWithContentsOfFile:filePath];
    }
    
    if (limitSize >= 0) {
        image = [DCImageIO downsampledImageFromImage:image withSizeNoMoreThan:limitSize];
    }
    
    _isImageLoaded = YES;
    _imageSize = image ? (image.scale * image.size.width) * (image.scale * image.size.height) * 4 : 0;
}

@end
