//
//  DCItemsBoxInterleavingStackLayout.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-25.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCItemsBoxStackLayout.h"
#import "DCCellWidthDataSource.h"
#import "DCCellHeightDataSource.h"
#import "DCItemsBoxCellHorizontalGravityDataSource.h"

@implementation DCItemsBoxStackLayout
@synthesize rowGap;
@synthesize cellWidth = _cellWidth;
@synthesize cellHeight = _cellHeight;
@synthesize cellHorizontalGravity = _cellHorizontalGravity;

-(id) init {
    self = [super init];
    if (self) {
        _cellHeight = 200;
        _cellHorizontalGravity = DCHorizontalGravityStretch;
    }
    return self;
}

-(void) populateRectsOfItems:(NSArray*) items toLayoutRects:(NSMutableArray*) layoutRects renderRects:(NSMutableArray*) renderRects; {
    
    int top = 0;
    
    
    float layoutSize = self.size - self.contentPadding.left - self.contentPadding.right - (_isSectionedData ? self.sectionPadding.left + self.sectionPadding.right : 0);
    
    float layoutLeft = self.contentPadding.left + (_isSectionedData ? self.sectionPadding.left : 0);
    float layoutRight = self.size - self.contentPadding.right - (_isSectionedData ? self.sectionPadding.right : 0);
    int gap = _isSectionedData ? self.sectionPadding.top : self.contentPadding.top;
    
    for (id item in items) {
        
        float desiredCellWidth = [item conformsToProtocol:@protocol(DCCellWidthDataSource)] ? ((id <DCCellWidthDataSource>)item).cellWidth : _cellWidth;
        float desiredCellHeight = [item conformsToProtocol:@protocol(DCCellHeightDataSource)] ? ((id <DCCellHeightDataSource>)item).cellHeight : _cellHeight;
        DCHorizontalGravity cellHorizontalGravity = [item conformsToProtocol:@protocol(DCItemsBoxCellHorizontalGravityDataSource)] ? ((id <DCItemsBoxCellHorizontalGravityDataSource>)item).horizontalGravity : _cellHorizontalGravity;

        float cellWidth = cellHorizontalGravity == DCHorizontalGravityStretch ? layoutSize : desiredCellWidth;
        float cellHeight = desiredCellHeight;
        
        
        float cellLeft;
        
        if (cellHorizontalGravity == DCHorizontalGravityLeft) {
            cellLeft = layoutLeft;
        }
        else if (cellHorizontalGravity == DCHorizontalGravityCenter) {
            cellLeft = layoutLeft + (layoutSize - cellWidth) / 2;
        }
        else if (cellHorizontalGravity == DCHorizontalGravityRight) {
            cellLeft = layoutRight - cellWidth;
        }
        else {
            cellLeft = layoutLeft;
        }
        
        
        [layoutRects addObject:[NSValue valueWithCGRect:CGRectMake(cellLeft, top, cellWidth, cellHeight + gap)]];
        [renderRects addObject:[NSValue valueWithCGRect:CGRectMake(cellLeft, top + gap, cellWidth, cellHeight)]];
        
        
        top += cellHeight + gap;
        gap = rowGap;
    }
}

@end
