//
//  DCBinaryHeap.m
//  DandelionDemo
//
//  Created by Bob Li on 14-2-7.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCBinaryHeap.h"

static NSNumber* _nilValue;

@implementation DCBinaryHeap

+(void) initialize {
    _nilValue = [NSNumber numberWithInt:0];
}

-(id) initWithComparer:(id <DCComparer>) comparer {
    self = [super init];
    if (self) {
        _comparer = comparer;
        [self clear];
    }
    return self;
}

-(void) clear {
    
    _capacity = 0;
    _size = 0;
    
    _items = [[NSMutableArray alloc] init];
    
    [self ensureCapacity:20];
}

-(void) ensureCapacity:(int) newCapacity {

    if (_capacity < newCapacity) {

        int length = _capacity + newCapacity + (newCapacity >> 1);
        for (int i = _capacity; i <= length - 1; i++) {
            [_items addObject:_nilValue];
        }

        _capacity = length;
    }
}

-(void) filterUp:(id <DCBinaryHeapItem>) item {

    int index = [item binaryHeapIndex];
    id <DCBinaryHeapItem> current = item;
    
    while (index > 1) {
        
        int parentIndex = index >> 1;
        id <DCBinaryHeapItem> parent = [_items objectAtIndex:parentIndex];
        if ([_comparer compare:current with:parent] < 0) {

            [_items setObject:parent atIndexedSubscript:index];
            [parent setBinaryHeapIndex:index];
            
            [_items setObject:current atIndexedSubscript:parentIndex];
            [current setBinaryHeapIndex:parentIndex];

            index = parentIndex;
        }
        else {
            break;
        }
    }
}

-(void) filterDown:(id <DCBinaryHeapItem>) item {

    int index = [item binaryHeapIndex];
    id <DCBinaryHeapItem> current = item;
    
    while (true) {
    
        int leftChildIndex = index << 1;
        int rightChildIndex = leftChildIndex + 1;
        
        if (leftChildIndex > _size) {
            break;
        }
        
        
        int swapIndex = rightChildIndex > _size || [_comparer compare:[_items objectAtIndex:leftChildIndex] with:[_items objectAtIndex:rightChildIndex]] < 0 ? leftChildIndex : rightChildIndex;
        
        if ([_comparer compare:current with:[_items objectAtIndex:swapIndex]] <= 0) {
            break;
        }
        
        
        id <DCBinaryHeapItem> swapItem = [_items objectAtIndex:swapIndex];
        
        [_items setObject:swapItem atIndexedSubscript:index];
        [swapItem setBinaryHeapIndex:index];
        
        [_items setObject:current atIndexedSubscript:swapIndex];
        [current setBinaryHeapIndex:swapIndex];
        
        index = swapIndex;
    }
}

-(void) addItem:(id <DCBinaryHeapItem>) item {

    _size++;
    [self ensureCapacity:_size + 1];
    [_items setObject:item atIndexedSubscript:_size];
    [item setBinaryHeapIndex:_size];
    
    [self filterUp:item];
}

-(void) updateItem:(id <DCBinaryHeapItem>) item {

    int index = [item binaryHeapIndex];
    if (index > 1 && [_comparer compare:item with:[_items objectAtIndex:index >> 1]] < 0) {
        [self filterUp:item];
    }
    else {
        [self filterDown:item];
    }
}

-(void) removeItem:(id <DCBinaryHeapItem>) item {

    int index = [item binaryHeapIndex];
    [item setBinaryHeapIndex:0];
    [_items setObject:_nilValue atIndexedSubscript:index];
    
    _size--;
    
    if (_size > 0) {
        id <DCBinaryHeapItem> lastItem = [_items objectAtIndex:_size + 1];
        [_items setObject:_nilValue atIndexedSubscript:_size + 1];
        [_items setObject:lastItem atIndexedSubscript:index];
        [lastItem setBinaryHeapIndex:index];
        [self filterDown:lastItem];
    }
}

-(void) removeAllItems {
    [self clear];
}


-(id <DCBinaryHeapItem>) pollItem {

    if (_size == 0) {
        return nil;
    }
    else {
        id <DCBinaryHeapItem> firstItem = [_items objectAtIndex:1];
        [self removeItem:firstItem];
        return firstItem;
    }
}

@end
