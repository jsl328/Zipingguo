//
//  DCGridBoxColumnedLayout.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-15.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCItemsBoxColumnedLayout.h"


@implementation DCItemsBoxGridLayoutColumnSetting
@synthesize columnCount;
@synthesize width;

@end


@implementation DCItemsBoxColumnedLayout

-(id) initWidthDefaultColumnCount:(int) columnCount {
    self = [super init];
    if (self) {
        _columnSettings = [[NSMutableArray alloc] init];
        [self setColumnCount:columnCount forContainerWidth:NSIntegerMax];
    }
    return self;
}

-(void) setColumnCount:(int) columnCount forContainerWidth:(int) width {
    
    DCItemsBoxGridLayoutColumnSetting* columnSetting = [[DCItemsBoxGridLayoutColumnSetting alloc] init];
    columnSetting.columnCount = columnCount;
    columnSetting.width = width;
    
    if (_columnSettings.count == 0) {
        [_columnSettings addObject:columnSetting];
    }
    else {
        [_columnSettings insertObject:columnSetting atIndex:_columnSettings.count - 1];
    }
}

-(void) sizeDidChange {
    
    if (_columnSettings.count == 1) {
        _columnCount = ((DCItemsBoxGridLayoutColumnSetting*)[_columnSettings objectAtIndex:0]).columnCount;
        return;
    }
    
    
    int previousWidth = 0;
    
    for (int i = 0; i <= _columnSettings.count - 1; i++) {
        
        DCItemsBoxGridLayoutColumnSetting* current = [_columnSettings objectAtIndex:i];
        
        if (self.size >= previousWidth && self.size < current.width) {
            _columnCount = current.columnCount;
            break;
        }
        
        previousWidth = current.width;
    }
}

@end
