//
//  DCViewTree.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-4-1.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCViewTree : NSObject

+(void) forViewsOfClass:(Class) viewClass containedIn:(UIView*) view visit:(void (^)(id)) callback;

+(void) forViewsOfClass:(Class) viewClass surroundedBy:(UIView*) view visit:(void (^)(id)) callback;

+(id) protocolOfType:(Protocol*) protocol forObject:(id) object;

@end
