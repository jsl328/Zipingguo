//
//  DCSocketDelegate.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-24.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DCSocketDelegate <NSObject>

-(void) socketDidLoseConnection:(id) socket;

-(void) socket:(id) socket didReceiveData:(NSData*) data;

@end
