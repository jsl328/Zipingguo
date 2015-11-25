//
//  NSDate+Compare.h
//  Zipingguo
//
//  Created by sunny on 15/10/14.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDateFormatter+Category.h"
@interface NSDate (Compare)
/**
 *  传入时间段和当前时间 获取当前时间是否在时间段内
 *
 *  @param fromHour 起始时间
 *  @param toHour   终止时间
 *  @param date     当前时间
 *
 *  @return 返回YES是在时间段内，否则不在此时间段内
 */
+ (BOOL)isBetweenFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour withNowData:(NSDate *)date;
- (NSString *)formatted;
@end
