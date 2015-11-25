//
//  DCWeakArray.m
//  DandelionDemo
//
//  Created by Bob Li on 13-12-17.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCWeakSet.h"

@implementation DCWeakSet

-(id) init {
    self = [super init];
    if (self) {
        _mapTable = [NSMapTable weakToWeakObjectsMapTable];
    }
    return self;
}


-(void) addObject:(id) object {
    [_mapTable setObject:object forKey:object];
}

-(void) removeObject:(id) object {
    [_mapTable removeObjectForKey:object];
}

-(BOOL) containsObject:(id) object {
    return [_mapTable objectForKey:object] != nil;
}

-(NSInteger) count {
    return _mapTable.count;
}

-(void) removeAllObjects {
    [_mapTable removeAllObjects];
}

-(NSEnumerator*) objectEnumerator {
    return _mapTable.keyEnumerator;
}

@end
