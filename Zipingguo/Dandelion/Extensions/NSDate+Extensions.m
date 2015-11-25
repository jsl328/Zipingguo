//
//  NSDate+Extensions.m
//  Dandelion
//
//  Created by Bob Li on 13-4-18.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "NSDate+Extensions.h"

@implementation NSDate (Extensions)

-(NSDateComponents*) components {
    
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday fromDate:self];
}

-(NSString*) toString {
    
    NSDateComponents* components = [self components];
    
    return [NSString stringWithFormat:@"%d-%02d-%02d %02d:%02d:%02d", components.year, components.month, components.day, components.hour, components.minute, components.second];
}

- (NSString *)ymd{
    NSDateComponents* components = [self components];
    
    return [NSString stringWithFormat:@"%d-%02d-%02d", components.year, components.month, components.day];
}

- (NSString *)weekdayStr{
    NSDateComponents* components = [self components];
    NSArray * weekdayArr = @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    return weekdayArr[components.weekday - 1];
}
- (NSString *)weekdayStr2{
    NSDateComponents* components = [self components];
    NSArray * weekdayArr = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    return weekdayArr[components.weekday - 1];
}


@end
