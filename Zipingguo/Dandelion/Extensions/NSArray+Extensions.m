//
//  NSArray+Extensions.m
//  Dandelion
//
//  Created by Bob Li on 13-4-12.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "NSArray+Extensions.h"
#import "DCGroupResult.h"

@implementation NSArray (Extensions)

-(NSArray*) map: (id (^)(id)) mapFunction {

    NSMutableArray* list = [[NSMutableArray alloc] init];
    for (id item in self) {
        [list addObject:mapFunction(item)];
    }
    
    return list;
}

-(id) findFirst: (BOOL (^)(id)) condition {

    for (id item in self) {
        if (condition(item)) {
            return item;
        }
    }
    
    return nil;
}

-(NSArray*) find: (BOOL (^)(id)) condition {

    NSMutableArray* items = [[NSMutableArray alloc] init];
    
    for (id item in self) {
        if (condition(item)) {
            [items addObject:item];
        }
    }
    
    return items;
}

-(BOOL) any: (BOOL (^)(id)) condition {
    
    for (id item in self) {
        if (condition(item)) {
            return YES;
        }
    }
    
    return NO;
}

-(int) count: (BOOL (^)(id)) condition {

    int count = 0;

    for (id item in self) {
        if (condition(item)) {
            count++;
        }
    }
    
    return count;
}


-(NSArray*) groupBy:(id (^)(id)) keyMapFunction keysSortedBy:(NSComparator) keyComparer {

    NSMutableDictionary* groups = [[NSMutableDictionary alloc] init];
    
    for (id item in self) {
    
        id key = keyMapFunction(item);
        
        NSMutableArray* items = [groups objectForKey:key];
        if (!items) {
            items = [[NSMutableArray alloc] init];
            [groups setObject:items forKey:key];
        }
    
        [items addObject:item];
    }


    NSMutableArray* groupList = [[NSMutableArray alloc] init];
    for (id key in [groups keyEnumerator]) {
        DCGroupResult* group = [[DCGroupResult alloc] init];
        group.key = key;
        group.items = [groups objectForKey:key];
        [groupList addObject:group];
    }
    
    if (keyComparer) {
        [groupList sortUsingComparator:keyComparer];
    }
    
    return groupList;
}

@end
