//
//  UIView+Extensions.m
//  Dandelion
//
//  Created by Bob Li on 13-4-19.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "UIView+Extensions.h"
#import "DCViewTree.h"

@implementation UIView (Extensions)

-(void) removeAllSubviews {
    
    NSMutableArray* subviews = [[NSMutableArray alloc] init];

    for (UIView* view in self.subviews) {
        [subviews addObject:view];
    }
    
    for (UIView* view in subviews) {
        [view removeFromSuperview];
    }
}

-(void) forSubviewsOfClass:(Class) viewClass visit:(void (^)(id)) callback {
    [DCViewTree forViewsOfClass:viewClass containedIn:self visit:callback];
}

-(void) forDescendentViewsOfClass:(Class) viewClass visit:(void (^)(id)) callback {
    [DCViewTree forViewsOfClass:viewClass surroundedBy:self visit:callback];

}

-(id) viewThatListensProtocol:(Protocol*) protocol {
    return [DCViewTree protocolOfType:protocol forObject:self];
}

@end
