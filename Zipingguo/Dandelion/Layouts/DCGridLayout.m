//
//  DCRelativeLayout.m
//  DandelionDemo
//
//  Created by Bob Li on 13-12-23.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCGridLayout.h"
#import "DCLayoutCore.h"

@implementation DCGridLayout
@synthesize columnCount = _columnCount;
@synthesize rowCount = _rowCount;

-(id) init {
    self = [super init];
    if (self) {
        [self initializeGridLayout];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializeGridLayout];
    }
    return self;
}

-(void) initializeGridLayout {
    self.layoutParams = DCLayoutParamsMake(DCLayoutMatchParent, DCLayoutWrapContent);
    self.columnCount = 3;
}

-(DCLayoutParams*) newLayoutParams {
    return DCLayoutParamsMake(DCLayoutMatchParent, DCLayoutWrapContent);
}

-(void) setColumnCount:(int)columnCount {
    
    _columnCount = columnCount;
    
    _columnWeights = [[NSMutableArray alloc] init];
    for (int i = 0; i <= columnCount - 1; i++) {
        [_columnWeights addObject:[NSNumber numberWithFloat:1.0 / columnCount]];
    }
}

-(void) setRowCount:(int)rowCount {

    _rowCount = rowCount;
    
    _rowWeights = [[NSMutableArray alloc] init];
    for (int i = 0; i <= rowCount - 1; i++) {
        [_rowWeights addObject:[NSNumber numberWithFloat:1.0 / rowCount]];
    }
}

-(void) setWeight:(float) weight forColumn:(int) columnIndex {
    [_columnWeights setObject:[NSNumber numberWithFloat:weight] atIndexedSubscript:columnIndex];
}

-(void) setWeight:(float) weight forRow:(int) rowIndex {
    [_rowWeights setObject:[NSNumber numberWithFloat:weight] atIndexedSubscript:rowIndex];
}

-(void) measureWithWidthSpec:(DCMeasureSpec) widthSpec heightSpec:(DCMeasureSpec) heightSpec {

    float availableWidth = widthSpec.size - self.padding.left - self.padding.right -(_columnCount - 1) * self.gap;
    float availableHeight = heightSpec.size - self.padding.left - self.padding.right -(_columnCount - 1) * self.gap;
    
    float contentHeight = self.padding.top + self.padding.bottom;
    float rowHeight = 0;
    int columnIndex = 0;
    int rowIndex = 0;
    
    for (UIView* view in self.subviews) {
        
        DCLayoutParams* params = [self layoutParamsForView:view];

        DCMeasureSpec subviewWidthSpec = [DCLayoutCore measureSpecForSize:params.width withParentSpec:DCMeasureSpecMakeAtMost(availableWidth * [[_columnWeights objectAtIndex:columnIndex] floatValue])];
        
        
        DCMeasureSpec viewHeightSpec;
        if (_rowCount > 0) {
            viewHeightSpec = DCMeasureSpecMakeAtMost((heightSpec.size - self.padding.top - self.padding.bottom - self.gap * (_rowCount - 1)) * [[_rowWeights objectAtIndex:rowIndex] floatValue]);
        }
        else {
            viewHeightSpec = heightSpec.mode == DCMeasureSpecUnspecified ? DCMeasureSpecMakeUnspecified() : DCMeasureSpecMakeAtMost(heightSpec.size);
        }
        
        DCMeasureSpec subviewHeightSpec = [DCLayoutCore measureSpecForSize:params.height withParentSpec:viewHeightSpec];
        
        
        
        [self measure:view widthSpec:subviewWidthSpec heightSpec:subviewHeightSpec];
        
        if (rowHeight < [self layoutSizeForView:view].height) {
            rowHeight = [self layoutSizeForView:view].height;
        }
        
        if (columnIndex == _columnCount - 1) {
            contentHeight += (_rowCount == 0 ? rowHeight : availableHeight * [[_rowWeights objectAtIndex:rowIndex] floatValue]) + self.gap;
            rowHeight = 0;
        }
        
        
        columnIndex++;
        if (columnIndex == _columnCount) {
            columnIndex = 0;
            rowIndex++;
        } 
    }
    
    if (self.subviews.count % _columnCount == 0) {
        contentHeight -= self.gap;
    }
    
    [self setMeasuredSizeWithContentWidth:widthSpec.size widthSpec:widthSpec contentHeight:contentHeight heightSpec:heightSpec];
}

-(void) onLayout {
    
    float availableWidth = self.measuredSize.width - self.padding.left - self.padding.right - (_columnCount - 1) * self.gap;
    float availableHeight = _rowCount == 0 ? 0 : self.measuredSize.height - self.padding.top - self.padding.bottom - (_rowCount - 1) * self.gap;
    
    float top = self.padding.top;
    
    
    for (int row = 0; row <= ceil((float)self.subviews.count / _columnCount) - 1; row++) {
        
        float rowHeight = 0;
        int startIndex = row * _columnCount;
        
        int bound = self.subviews.count - 1;
        int endIndex = MIN(startIndex + _columnCount - 1, bound);
        
        for (int i = startIndex; i <= endIndex; i++) {
        
            UIView* view = [self.subviews objectAtIndex:i];
            CGSize size = [self layoutSizeForView:view];
            
            if (rowHeight < size.height) {
                rowHeight = size.height;
            }
        }
        
        
        int left = self.padding.left;
        
        for (int i = startIndex; i <= endIndex; i++) {
            
            UIView* view = [self.subviews objectAtIndex:i];
            CGSize size = [self layoutSizeForView:view];
            
            int cellWidth = availableWidth * [[_columnWeights objectAtIndex:(i % _columnCount)] floatValue] + self.gap;
            
            [self layout:view withRect:[DCLayoutCore rectOfRect:CGRectMake(left, top, size.width, size.height) inSize:CGSizeMake(cellWidth, _rowCount == 0 ? rowHeight : availableHeight * [[_rowWeights objectAtIndex:row] floatValue]) withView:view inViewGroup:self]];
            
            left += cellWidth;
        }
            
        top += (_rowCount == 0 ? rowHeight : availableHeight * [[_rowWeights objectAtIndex:row] floatValue]) + self.gap;
    }
}

@end
