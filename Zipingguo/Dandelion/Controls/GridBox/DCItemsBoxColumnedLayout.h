//
//  DCGridBoxColumnedLayout.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-15.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCItemsBoxLayout.h"

@interface DCItemsBoxGridLayoutColumnSetting : NSObject

@property (nonatomic) int columnCount;
@property (nonatomic) float width;

@end


@interface DCItemsBoxColumnedLayout : DCItemsBoxLayout {

    NSMutableArray* _columnSettings;
    
    int _columnCount;
}

-(id) initWidthDefaultColumnCount:(int) columnCount;

-(void) setColumnCount:(int) columnCount forContainerWidth:(int) width;

@end
