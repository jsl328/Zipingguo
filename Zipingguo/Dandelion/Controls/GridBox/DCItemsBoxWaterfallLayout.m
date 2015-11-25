//
//  DCItemsBoxWaterfallLayout.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-15.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCItemsBoxWaterfallLayout.h"
#import "DCCellHeightDataSource.h"

@implementation DCItemsBoxWaterfallLayout
@synthesize horizontalGap;
@synthesize verticalGap;

-(id) initWidthDefaultColumnCount:(int) columnCount {
    self = [super initWidthDefaultColumnCount:columnCount];
    if (self) {
    }
    return self;
}

-(void) populateRectsOfItems:(NSArray*) items toLayoutRects:(NSMutableArray*) layoutRects renderRects:(NSMutableArray*) renderRects; {

    _columnHeights = [[NSMutableArray alloc] init];
    for (int i = 0; i <= _columnCount - 1; i++) {
        [_columnHeights addObject:[NSNumber numberWithFloat:0]];
    }
    
    float sectionPadding = _isSectionedData ? self.sectionPadding.left + self.sectionPadding.right : 0;
    float cellWidth = ((self.size - self.contentPadding.left - self.contentPadding.right - sectionPadding) - (_columnCount - 1) * self.horizontalGap) / _columnCount;
    
    for (id item in items) {

        int columnIndex = [self indexOfcolumnWithMinimumHeight];
        float x = self.contentPadding.left + (_isSectionedData ? self.sectionPadding.left : 0) + (cellWidth + horizontalGap) * columnIndex;
        
        float cellHeight = ((id <DCCellHeightDataSource>)item).cellHeight;
        float top = ((NSNumber*)[_columnHeights objectAtIndex:columnIndex]).floatValue;
        
        
        int gap;
        
        if (top == 0) {
            gap = _isSectionedData ? self.sectionPadding.top : self.contentPadding.top;
        }
        else {
            gap = verticalGap;
        }
        
        
        [layoutRects addObject:[NSValue valueWithCGRect:CGRectMake(x, top, cellWidth, cellHeight + gap)]];
        [renderRects addObject:[NSValue valueWithCGRect:CGRectMake(x, top + gap, cellWidth, cellHeight)]];
        
        [_columnHeights setObject:[NSNumber numberWithFloat:top + cellHeight + gap] atIndexedSubscript:columnIndex];
    }
}

-(int) indexOfcolumnWithMinimumHeight {

    int index = -1;
    float columnHeight = NSIntegerMax;
    
    for (int i = 0; i <= _columnCount - 1; i++) {
        if (columnHeight > ((NSNumber*)[_columnHeights objectAtIndex:i]).floatValue) {
            columnHeight = ((NSNumber*)[_columnHeights objectAtIndex:i]).floatValue;
            index = i;
        }
    }
    
    return index;
}

@end
