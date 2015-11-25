//
//  DCTreeInterator.h
//  AmaranthDemo
//
//  Created by Bob Li on 14-8-1.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DCAbstractTree <NSObject>

-(NSArray*) rootNodes;

-(NSArray*) subNodesOfNode:(id) node;

@end


@interface DCTreeIterator : NSObject

-(id) initWithTree:(id <DCAbstractTree>) tree;

-(void) rewind;

-(id) next;

@end
