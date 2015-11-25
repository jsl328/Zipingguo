//
//  DCComparer.h
//  DandelionDemo
//
//  Created by Bob Li on 14-2-7.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DCComparer <NSObject>

-(int) compare:(id) object1 with:(id) object2;

@end
