//
//  DCRelativeLayout.h
//  DandelionDemo
//
//  Created by Bob Li on 13-12-23.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCViewGroup.h"

@interface DCGridLayout : DCViewGroup {

    NSMutableArray* _columnWeights;
    NSMutableArray* _rowWeights;
}

@property (nonatomic) int columnCount;
@property (nonatomic) int rowCount;

-(void) setWeight:(float) weight forColumn:(int) columnIndex;
-(void) setWeight:(float) weight forRow:(int) rowIndex;

@end
