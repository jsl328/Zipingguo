//
//  DCViewTree.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-4-1.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCViewTree.h"

@implementation DCViewTree

+(void) forViewsOfClass:(Class) viewClass containedIn:(UIView*) view visit:(void (^)(id)) callback {
    
    for (UIView* subview in view.subviews) {
        if ([[view class] isSubclassOfClass:viewClass]) {
            callback(view);
        }
    }
}

+(void) forViewsOfClass:(Class) viewClass surroundedBy:(UIView*) view visit:(void (^)(id)) callback {

    if ([[view class] isSubclassOfClass:viewClass]) {
        callback(view);
    }
    
    for (UIView* subview in view.subviews) {
        [DCViewTree forViewsOfClass:viewClass surroundedBy:subview visit:callback];
    }
}

+(id) protocolOfType:(Protocol*) protocol forObject:(id) object {
    
    if (![[object class] isSubclassOfClass:[UIView class]]) {
        return nil;
    }
    
    
    UIView* current = object;
    while (current) {
        
        if ([current conformsToProtocol:protocol]) {
            return current;
        }
        
        current = current.superview;
    }
    
    return [[AppContext controller] conformsToProtocol:protocol] ? [AppContext controller] : nil;
}

@end
