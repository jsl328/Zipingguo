//
//  DCIntArray2D.h
//  DandelionDemo
//
//  Created by Bob Li on 13-12-6.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCIntArray2D : NSObject {

    int _rowCount;
    int _columnCount;
    
    NSMutableArray* _rows;
}

-(id) initWithRowCount:(int) rowCount columnCount:(int) columnCount;

-(int*) columnsAtRow:(int) row;

-(void) setInt:(int) value atRow:(int) row column:(int) column;
-(int) intAtRow:(int) row column:(int) column;

-(void) free;

@end
