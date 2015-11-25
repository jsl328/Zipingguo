//
//  DCTabControlDelegate.h
//  Nanumanga
//
//  Created by Bob Li on 13-9-17.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCTabControl.h"

@class DCTabControl;

@protocol DCTabControlDelegate <NSObject>

-(void) tabControl:(DCTabControl*) tabControl didSelectPage:(int) pageIndex;

@end
