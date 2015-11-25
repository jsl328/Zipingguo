//
//  DCItemsBoxWaterfallLayout.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-15.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCItemsBoxColumnedLayout.h"

@interface DCItemsBoxWaterfallLayout : DCItemsBoxColumnedLayout {

    NSMutableArray* _columnHeights;
}

@property (nonatomic) float horizontalGap;
@property (nonatomic) float verticalGap;

@end
