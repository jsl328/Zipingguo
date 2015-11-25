//
//  DCSectionedData.h
//  DandelionDemo
//
//  Created by Bob Li on 13-12-17.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DCSectionedData <NSObject>

-(NSArray*) items;

@optional

-(id) header;
-(id) footer;

-(int) headerHeight;
-(int) footerHeight;

@end
