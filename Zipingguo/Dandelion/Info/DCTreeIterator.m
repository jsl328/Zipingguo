//
//  DCTreeInterator.m
//  AmaranthDemo
//
//  Created by Bob Li on 14-8-1.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCTreeIterator.h"
#import "DCTreeIterationStackLevel.h"

@implementation DCTreeIterator {

    id <DCAbstractTree> _tree;

    NSMutableArray* _stackLevels;
}

-(id) initWithTree:(id <DCAbstractTree>) tree {
    self = [super init];
    if (self) {
        _tree = tree;
        _stackLevels = [[NSMutableArray alloc] init];
        [self rewind];
    }
    return self;
}

-(void) rewind {
    [_stackLevels removeAllObjects];
    [self goToBottomLeft];
}

-(id) next {
    
    if (_stackLevels.count == 0) {
        return nil;
    }
    
    
    DCTreeIterationStackLevel* level = [_stackLevels lastObject];
    id node =level.node;
    
    [_stackLevels removeLastObject];
    if (_stackLevels.count == 0) {
        return nil;
    }
    
    
    level = [_stackLevels lastObject];
    
    if (level.subNodeIndex < level.subNodes.count - 1) {
        level.subNodeIndex++;
        [self goToBottomLeft];
    }
    
    return node;
}


-(void) goToBottomLeft {

    id node = nil;
    
    if (_stackLevels.count > 0) {
        DCTreeIterationStackLevel* level = [_stackLevels lastObject];
        node = [level.subNodes objectAtIndex:level.subNodeIndex];
    }
    
    
    while (true) {
    
        DCTreeIterationStackLevel* level = [[DCTreeIterationStackLevel alloc] init];
        level.node = node;
        level.subNodes = node ? [_tree subNodesOfNode:node] : [_tree rootNodes];
        level.subNodeIndex = 0;
        
        [_stackLevels addObject:level];
        
        if (level.subNodes.count == 0) {
            break;
        }
        else {
            node = [level.subNodes objectAtIndex:0];
        }
    }
}

@end
