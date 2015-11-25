//
//  DCDraggableView.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-4-16.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCHandleDirection.h"

@interface DCDraggableView : UIView <DCHandleDirection> {
    
    float _x;
    float _y;
}

@property (nonatomic) BOOL isDraggingEnabled;

@end
