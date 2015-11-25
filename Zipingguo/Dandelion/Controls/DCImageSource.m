//
//  DCImageView.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-5-29.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCImageSource.h"
#import "DCImageCache.h"
#import "DCUrlEntityManager.h"


NSMutableDictionary* _placeholders;

@implementation DCImageSource {
    
    NSString* _url;
    NSString* _urlFileName;
    NSString* _filePath;
    NSString* _resourceFileName;
    
    BOOL _isDownloading;
}

@synthesize placeholder = _placeholder;
@synthesize delegate;
@synthesize limitSize = _limitSize;

- (id)init
{
    self = [super init];
    if (self) {
        _limitSize = -1;
    }
    return self;
}

+(void) load {
    _placeholders = [[NSMutableDictionary alloc] init];
}

-(UIImage*) placeholderImage {
    return _placeholder ? [_placeholders objectForKey:_placeholder] : nil;
}

-(void) setPlaceholder:(NSString *)placeholder {
    
    _placeholder = placeholder;
    
    if (![_placeholders objectForKey:placeholder]) {
        [_placeholders setObject:[UIImage imageNamed:placeholder] forKey:placeholder];
    }
        
    if (!_filePath && !_resourceFileName) {
        [delegate acceptImage:[self placeholderImage]];
    }
}


-(void) didScheduleDownload {
    [delegate acceptImage:[self placeholderImage]];
    _isDownloading = YES;
}

-(void) downloadDidProgressTo:(float) progress {
}

-(void) setUrl:(NSString *)url fileName:(NSString *)fileName {
    [self setUrl:url fileName:fileName limitSize:-1];
}

-(void) setUrl:(NSString*) url fileName:(NSString*) fileName limitSize:(int)limitSize {
    
    if ([_url isEqualToString:url]) {
        return;
    }
    
    
    _resourceFileName = nil;
    _filePath = nil;
    _url = url;
    _urlFileName = fileName;
    
    if (url.length > 0) {
        [[DCUrlEntityManager defaultManager] downloadUrlEntity:self fileName:fileName limitSize:limitSize];
    }
    else {
        [[DCImageCache defaultCache] removeConsumer:self];
    }
}

-(void) setFilePath:(NSString*) filePath {
    
    if (!_isDownloading && [_filePath isEqualToString:filePath]) {
        return;
    }
    
    _resourceFileName = nil;
    _filePath = filePath;
    _isDownloading = NO;
    
    if (!_filePath) {
        [[DCImageCache defaultCache] removeConsumer:self];
    }
    else {
        [[DCImageCache defaultCache] requestImageFromPath:filePath limitSize:_limitSize byConsumer:self];
    }
}

-(void) setResourceFileName:(NSString*) fileName {
    _url = nil;
    _urlFileName = nil;
    _resourceFileName = fileName;
    _filePath = nil;
    [[DCImageCache defaultCache] requestImageFromResourceFile:fileName limitSize:_limitSize byConsumer:self];
}

-(NSString*) url {
    return _url;
}

-(NSString*) urlFileName {
    return _urlFileName;
}


-(void) ownerWillMoveToWindow:(UIWindow *)newWindow {

    if (!newWindow) {
        [[DCUrlEntityManager defaultManager] removeEntity:self];
        [[DCImageCache defaultCache] removeConsumer:self];
    }
    else if (_filePath.length > 0) {
        [[DCImageCache defaultCache] requestImageFromPath:_filePath limitSize:_limitSize byConsumer:self];
    }
    else if (_resourceFileName.length > 0) {
        [[DCImageCache defaultCache] requestImageFromResourceFile:_resourceFileName limitSize:_limitSize byConsumer:self];
    }
}


-(void) relinquishCachedImage {
    [delegate acceptImage:[self placeholderImage]];
}

-(void) setCachedImage:(UIImage*) image isImageLoaded:(BOOL) isImageLoaded {
    [delegate acceptImage:image == nil ? [self placeholderImage] : image];
}

-(NSString*) filePathForCachedImage {
    return _filePath;
}

-(NSString*) resourceNameForCachedImage {
    return _resourceFileName;
}

@end
