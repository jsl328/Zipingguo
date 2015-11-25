//
//  DCWeakArray.h
//  DandelionDemo
//
//  Created by Bob Li on 13-12-17.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCWeakSet : NSObject {
    NSMapTable* _mapTable;
}

-(void) addObject:(id) object;
-(void) removeObject:(id) object;

-(BOOL) containsObject:(id) object;
-(NSInteger) count;

-(void) removeAllObjects;

-(NSEnumerator*) objectEnumerator;

@end
