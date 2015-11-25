//
//  DCItemsBoxFlowLayout.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-16.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCItemsBoxFlowLayout.h"
#import "DCCellWidthDataSource.h"

@implementation DCItemsBoxFlowLayout
@synthesize itemGap;
@synthesize rowGap;
@synthesize rowHeight;

-(id) init {
    self = [super init];
    if (self) {
        rowHeight = 200;
    }
    return self;
}

-(void) populateRectsOfItems:(NSArray*) items toLayoutRects:(NSMutableArray*) layoutRects renderRects:(NSMutableArray*) renderRects; {
    
    int top = 0;
    
    float right = self.size - self.contentPadding.right - (_isSectionedData ? self.sectionPadding.right : 0);
    float x = self.contentPadding.left + (_isSectionedData ? self.sectionPadding.left : 0);
    int gap = _isSectionedData ? self.sectionPadding.top : self.contentPadding.top;
    
    for (id item in items) {
        
        float cellWidth = ((id <DCCellWidthDataSource>)item).cellWidth;
        
        if (x + cellWidth + itemGap > right) {
            x = self.contentPadding.left + (_isSectionedData ? self.sectionPadding.left : 0);
            top += rowHeight + gap;
            gap = rowGap;
        }
        
        [layoutRects addObject:[NSValue valueWithCGRect:CGRectMake(x, top, cellWidth, rowHeight + gap)]];
        [renderRects addObject:[NSValue valueWithCGRect:CGRectMake(x, top + gap, cellWidth, rowHeight)]];
        
        x += cellWidth + itemGap;
    }
}

@end
