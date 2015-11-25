//
//  DCBinaryHeap.h
//  DandelionDemo
//
//  Created by Bob Li on 14-2-7.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCBinaryHeapItem.h"
#import "DCComparer.h"

@interface DCBinaryHeap : NSObject {
    
    NSMutableArray* _items;
    
    int _capacity;

    int _size;
    
    id <DCComparer> _comparer;
}

-(id) initWithComparer:(id <DCComparer>) comparer;

-(void) addItem:(id <DCBinaryHeapItem>) item;
-(void) updateItem:(id <DCBinaryHeapItem>) item;
-(void) removeItem:(id <DCBinaryHeapItem>) item;
-(void) removeAllItems;

-(id <DCBinaryHeapItem>) pollItem;

@end
