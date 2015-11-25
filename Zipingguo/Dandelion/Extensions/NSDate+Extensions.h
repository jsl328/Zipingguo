//
//  NSDate+Extensions.h
//  Dandelion
//
//  Created by Bob Li on 13-4-18.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extensions)

-(NSDateComponents*) components;

-(NSString*) toString;

- (NSString *)ymd;

///返回 星期几
- (NSString *)weekdayStr;

///返回 周几
- (NSString *)weekdayStr2;
@end
