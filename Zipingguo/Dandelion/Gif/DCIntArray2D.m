//
//  DCIntArray2D.m
//  DandelionDemo
//
//  Created by Bob Li on 13-12-6.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCIntArray2D.h"

@implementation DCIntArray2D

-(id) initWithRowCount:(int) rowCount columnCount:(int) columnCount {
    self = [super init];
    if (self) {
        _rowCount = rowCount;
        _columnCount = columnCount;
        _rows = [[NSMutableArray alloc] init];
        for (int i = 1;i <= rowCount; i++) {
            
            int* columns = malloc(sizeof(int) * columnCount);
            for (int j = 0; j <= columnCount - 1; j++) {
                columns[j] = 0;
            }
            
            [_rows addObject:[NSValue valueWithPointer:columns]];
        }
    }
    return self;
}

-(int*) columnsAtRow:(int) row {
    return ((NSValue*)[_rows objectAtIndex:row]).pointerValue;
}

-(void) setInt:(int) value atRow:(int) row column:(int) column {
    [self columnsAtRow:row][column] = value;
}

-(int) intAtRow:(int)row column:(int)column {
    return [self columnsAtRow:row][column];
}

-(void) free {
    for (int i = 0;i <= _rowCount - 1; i++) {
        int* columns = ((NSValue*)[_rows objectAtIndex:0]).pointerValue;
        free(columns);
    }
}

@end
