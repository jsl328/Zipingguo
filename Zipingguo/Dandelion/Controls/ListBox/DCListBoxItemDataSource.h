//
//  DCListBoxItemDataSource.h
//  DandelionDemo
//
//  Created by Bob Li on 13-12-17.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DCListBoxItemDataSource <NSObject>

@optional

-(int) dragOffset;

-(void) setDragOffset:(int) dragOffset;

-(int) minDragOffset;

-(int) maxDragOffset;

-(BOOL) isDeletable;

-(BOOL) isInsertable;

-(BOOL) isMovable;

@end
