//
//  DCFileQueryOptions.m
//  AmaranthDemo
//
//  Created by Bob Li on 14-8-1.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCFileQueryOptions.h"

@implementation DCFileQueryOptions {

    NSMutableArray* _fileExtensions;
    
    int _fromLength;
    int _toLength;
    
    int _maxCountOfFiles;
}

@synthesize maxFileCount;

-(id)init {
    self = [super init];
    if (self) {
        _fileExtensions = [[NSMutableArray alloc] init];
        _fromLength = -1;
        _toLength = -1;
        _maxCountOfFiles = -1;
    }
    return self;
}


-(void) addFileExtension:(NSString*) extension {
    [_fileExtensions addObject:extension];
}

-(void) setFileShouldBeLargerThan:(int) fromLength andSmallerThan:(int) toLength {
    _fromLength = fromLength;
    _toLength = toLength;
}

-(void) setFileShouldBeSmallerThan:(int) length {
    [self setFileShouldBeLargerThan:0 andSmallerThan:length];
}

-(void) setFileShouldBeLargerThan:(int) length {
    [self setFileShouldBeLargerThan:length andSmallerThan:NSIntegerMax];
}

-(void) setMaxCountOfFiles:(int) count {
    _maxCountOfFiles = count;
}


-(BOOL) fileMatchesSearchCriteria:(NSString*) filePath withAttrs:(NSDictionary*) attrs {
    
    BOOL matches = YES;
    
    
    if (_fileExtensions.count > 0) {
        matches = [_fileExtensions any:^BOOL(NSString* extension) {
            return [filePath endsWithString:extension];
        }];
    }
    
    if (!matches) {
        return NO;
    }
    
    
    if (_fromLength >= 0) {
        int length = [[attrs objectForKey: NSFileSize] intValue];
        matches = length >= _fromLength && length <= _toLength;
    }
    
    if (!matches) {
        return NO;
    }
    
    
    return YES;
}

@end
