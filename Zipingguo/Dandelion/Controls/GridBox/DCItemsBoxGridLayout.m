//
//  DCItemsBoxGridLayout.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-11.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCItemsBoxGridLayout.h"
#import "DCSectionedData.h"


@implementation DCItemsBoxGridLayout
@synthesize itemGap;
@synthesize rowGap;
@synthesize rowHeight;

-(id) initWidthDefaultColumnCount:(int) columnCount {
    self = [super initWidthDefaultColumnCount:columnCount];
    if (self) {
        rowHeight = 200;
    }
    return self;
}

-(void) populateRectsOfItems:(NSArray*) items toLayoutRects:(NSMutableArray*) layoutRects renderRects:(NSMutableArray*) renderRects; {

    int top = 0;
    float sectionPadding = _isSectionedData ? self.sectionPadding.left + self.sectionPadding.right : 0;
    float cellWidth = ((self.size - self.contentPadding.left - self.contentPadding.right - sectionPadding) - (_columnCount - 1) * self.itemGap) / _columnCount;
    
    int columnIndex = 0;
    int gap = _isSectionedData ? self.sectionPadding.top : self.contentPadding.top;
    for (id item in items) {
    
        float x = self.contentPadding.left + (_isSectionedData ? self.sectionPadding.left : 0) + (cellWidth + itemGap) * columnIndex;
        
        [layoutRects addObject:[NSValue valueWithCGRect:CGRectMake(x, top, cellWidth, rowHeight + gap)]];
        [renderRects addObject:[NSValue valueWithCGRect:CGRectMake(x, top + gap, cellWidth, rowHeight)]];
        
        columnIndex++;
        if (columnIndex == _columnCount) {
            columnIndex = 0;
            top += rowHeight + gap;
            gap = rowGap;
        }
    }
}

@end
