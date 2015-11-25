//
//  DCOnSelectedIndexChangedDelegate.h
//  Nanumanga
//
//  Created by Bob Li on 13-10-18.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DCOnSelectedIndexChangedDelegate <NSObject>

-(void) sender: (id) sender selectedIndexDidChangeTo:(int) index;

@end
