//
//  DCDateParser.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-10.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCDateParser.h"

@implementation DCDateParser

-(int) errorOccured {
    return _errorOccured;
}

-(NSString*) stringFromDate:(NSDate *)date {
    return nil;
}

-(NSDate*) dateFromString:(NSString*) dateString {
    return nil;
}

-(int) nextIntInString:(NSString*) s {
    
    int n = 0;
    
    while (_position <= s.length - 1) {
        
        char c = [s characterAtIndex:_position];
        
        if (c >= '0' && c <= '9') {
            n = n * 10 + ((int)c - 48);
            _position++;
        }
        else {
            break;
        }
    }
    
    return n;
}

-(long) nextLongInString:(NSString*) s {
    
    long n = 0;
    
    while (_position <= s.length - 1) {
        
        char c = [s characterAtIndex:_position];
        
        if (c >= '0' && c <= '9') {
            n = n * 10 + ((int)c - 48);
            _position++;
        }
        else {
            break;
        }
    }
    
    return n;
}

-(float) nextFloatInString:(NSString*) s {
    
    int n = 0;
    float decimal = 0;
    int decimalDigits = 1;
    BOOL hasDot = NO;
    
    while (_position <= s.length - 1) {
        
        char c = [s characterAtIndex:_position];
        
        
        if (c == '.') {
            hasDot = YES;
            _position++;
        }
        else if (c >= '0' && c <= '9') {
            
            if (!hasDot) {
                n = n * 10 + ((int)c - 48);
            }
            else {
                decimalDigits *= 10;
                decimal += (float)((int)c - 48) / decimalDigits;
            }
            
            _position++;
        }
        else {
            break;
        }
    }
    
    return n + decimal;
}

@end


@implementation DCMsDateParser

-(NSString*) stringFromDate:(NSDate *)date {
    
    NSCalendar* calender = [NSCalendar currentCalendar];
    NSDateComponents* dc = [calender components:NSTimeZoneCalendarUnit fromDate:date];
    
    int timeZoneSign = dc.timeZone.secondsFromGMT > 0 ? 1 : -1;
    int timeZoneHour = floor((float)ABS(dc.timeZone.secondsFromGMT) / 3600);
    int timeZoneMinute = (ABS(dc.timeZone.secondsFromGMT) - timeZoneHour * 3600) / 60;
    
    return [NSString stringWithFormat:@"/Date(%ld%@%02d%02d)/", (long)[date timeIntervalSince1970] - dc.timeZone.secondsFromGMT, timeZoneSign == 1 ? @"+" : @"-", timeZoneHour, timeZoneMinute];
}

-(NSDate*) dateFromString:(NSString*) dateString {
    
    //"/Date(1237951967000)/"

    _position = 6;
    long time = [self nextLongInString:dateString];
    
    char c = [dateString characterAtIndex:_position];
    if (c == '+' || c == '-') {
        
        int timeZoneSign = c == '+' ? 1 : -1;
        
        _position++;
        int timeZone = [self nextIntInString:dateString];
        int hour = floor(timeZone / 100);
        int minute = timeZone - hour * 100;
        
        time += timeZoneSign * (hour * 3600 + minute * 60);
    }
    
    return [[NSDate alloc] initWithTimeIntervalSince1970:time];
}

@end


@implementation DCIsoDateParser

-(NSString*) stringFromDate:(NSDate *)date {

    NSCalendar* calender = [NSCalendar currentCalendar];
    NSDateComponents* dc = [calender components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSTimeZoneCalendarUnit fromDate:date];

    int timeZoneSign = dc.timeZone.secondsFromGMT > 0 ? 1 : -1;
    int timeZoneHour = floor((float)ABS(dc.timeZone.secondsFromGMT) / 3600);
    int timeZoneMinute = (ABS(dc.timeZone.secondsFromGMT) - timeZoneHour * 3600) / 60;
    
    return [NSString stringWithFormat:@"%d-%02d-%02dT%02d:%02d:%02d%@%02d:%02d", dc.year, dc.month, dc.day, dc.hour, dc.minute, dc.second, timeZoneSign == 1 ? @"+" : @"-", timeZoneHour, timeZoneMinute];
}

-(NSDate*) dateFromString:(NSString*) dateString {
    
    //2014-04-25T23:41:14+00:00
    //2014-04-25T23:41:14Z
    
    int timeZoneSign = 1;
    int timeZoneHour = 0;
    int timeZoneMinute = 0;
    
    _position = 0;
    int year = [self nextIntInString:dateString];
    
    _position++;
    int month = [self nextIntInString:dateString];
    
    _position++;
    int day = [self nextIntInString:dateString];
    
    _position++;
    int hour = [self nextIntInString:dateString];
    
    _position++;
    int minute = [self nextIntInString:dateString];
    
    _position++;
    float second = [self nextFloatInString:dateString];
    
    char c = [dateString characterAtIndex:_position];
    if (c == '+' || c == '-') {
        
        timeZoneSign = c == '+' ? 1 : -1;
        
        _position++;
        timeZoneHour = [self nextIntInString:dateString];
        
        _position++;
        timeZoneMinute = [self nextIntInString:dateString];
    }
    
    NSCalendar* calender = [NSCalendar currentCalendar];
    NSDateComponents* dc = [[NSDateComponents alloc] init];
    dc.year = year;
    dc.month = month;
    dc.day = day;
    dc.hour = hour;
    dc.minute = minute;
    dc.second = second;
    [dc setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:timeZoneSign * (timeZoneHour * 3600 + timeZoneMinute * 60)]];
    [dc setCalendar:calender];
    return dc.date;
}

@end


@implementation DCYmdhmsDateParser

-(NSString*) stringFromDate:(NSDate *)date {

    NSCalendar* calender = [NSCalendar currentCalendar];
    NSDateComponents* dc = [calender components:NSTimeZoneCalendarUnit fromDate:date];

    int timeZoneSign = dc.timeZone.secondsFromGMT > 0 ? 1 : -1;
    int timeZoneHour = floor((float)ABS(dc.timeZone.secondsFromGMT) / 3600);
    int timeZoneMinute = (ABS(dc.timeZone.secondsFromGMT) - timeZoneHour * 3600) / 60;
    
    dc.year = 0;
    dc.month = 0;
    dc.day = 0;
    dc.hour = -timeZoneSign * timeZoneHour;
    dc.minute = -timeZoneSign * timeZoneMinute;
    dc.second = 0;
    
    NSDate* utcDate = [calender dateByAddingComponents:dc toDate:date options:0];
    dc = [calender components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:utcDate];

    return [NSString stringWithFormat:@"%d-%02d-%02d %02d:%02d:%02d", dc.year, dc.month, dc.day, dc.hour, dc.minute, dc.second];
}

-(NSDate*) dateFromString:(NSString *)dateString {
    
    //2014-06-29 16:25:41

    NSCalendar* calender = [NSCalendar currentCalendar];
    NSDateComponents* dc = [[NSDateComponents alloc] init];
    [dc setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    _position = 0;
    dc.year = [self nextIntInString:dateString];
    
    _position++;
    dc.month = [self nextIntInString:dateString];
    
    _position++;
    dc.day = [self nextIntInString:dateString];
    
    _position++;
    dc.hour = [self nextIntInString:dateString];
    
    _position++;
    dc.minute = [self nextIntInString:dateString];
    
    _position++;
    dc.second = [self nextIntInString:dateString];
    
    return [calender dateFromComponents:dc];
    
}

@end
