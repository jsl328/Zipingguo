//
//  DCPageBoxCell.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-5-27.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCContentPresenter.h"

@interface DCPageBoxCell : NSObject

@property (retain, nonatomic) DCContentPresenter* view;
@property (retain, nonatomic) Class dataClass;
@property (nonatomic) BOOL isInUse;
@property (assign, nonatomic) id data;


-(void) claimWithData:(id) data;

-(void) recycle;

@end
