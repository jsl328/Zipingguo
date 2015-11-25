//
//  DCViewQuery.m
//  AmaranthDemo
//
//  Created by Sofia Work on 14-8-12.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCViewQuery.h"
#import "AppContext.h"

@implementation DCViewQuery {

    UIView* _rootView;
}

@synthesize includeController;


-(NSArray*) rootNodes {
    return @[_rootView];
}

-(NSArray*) subNodesOfNode:(id) node {
    return ((UIView*)node).subviews;
}


-(id) firstViewThatConfirmsToProtocol:(Protocol*) p selector:(SEL) selector inView:(UIView*) view {

    _rootView = view;
    
    UIView* foundView = nil;
    
    DCTreeIterator* it = [[DCTreeIterator alloc] initWithTree:self];
    UIView* current;
    while ((current = [it next]) != nil) {
        if ([current conformsToProtocol:p] && (!selector || [current respondsToSelector:selector])) {
            foundView = current;
            break;
        }
    }
    
    
    _rootView = nil;
    
    if (!includeController) {
        return foundView;
    }
    else if (foundView) {
        return foundView;
    }
    else {
        id controller = [AppContext controller];
        return [controller conformsToProtocol:p] && (!selector || [controller respondsToSelector:selector]) ? controller : nil;
    }
}

-(id) firstViewThatConfirmsToProtocol:(Protocol*) p selector:(SEL) selector {
    return [self firstViewThatConfirmsToProtocol:p selector:selector inView:[AppContext controller].view];
}

@end
