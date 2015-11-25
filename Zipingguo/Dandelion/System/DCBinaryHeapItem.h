//
//  DCBinaryHeapItem.h
//  DandelionDemo
//
//  Created by Bob Li on 14-2-7.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DCBinaryHeapItem <NSObject>

-(int) binaryHeapIndex;
-(void) setBinaryHeapIndex:(int) index;

@end
