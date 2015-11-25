//
//  DCViewQuery.h
//  AmaranthDemo
//
//  Created by Sofia Work on 14-8-12.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCTreeIterator.h"

@interface DCViewQuery : NSObject <DCAbstractTree>

@property (nonatomic) BOOL includeController;

-(id) firstViewThatConfirmsToProtocol:(Protocol*) p selector:(SEL) selector inView:(UIView*) view;

-(id) firstViewThatConfirmsToProtocol:(Protocol*) p selector:(SEL) selector;

@end
