//
//  NSArray+Extensions.h
//  Dandelion
//
//  Created by Bob Li on 13-4-12.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Extensions)

-(NSArray*) map: (id (^)(id)) mapFunction;
-(id) findFirst: (BOOL (^)(id)) condition;
-(NSArray*) find: (BOOL (^)(id)) condition;
-(BOOL) any: (BOOL (^)(id)) condition;
-(int) count: (BOOL (^)(id)) condition;

-(NSArray*) groupBy:(id (^)(id)) keyMapFunction keysSortedBy:(NSComparator) keyComparer;

@end
