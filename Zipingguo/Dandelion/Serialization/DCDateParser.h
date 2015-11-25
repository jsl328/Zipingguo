//
//  DCDateParser.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-10.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCDateParser : NSObject {

    BOOL _errorOccured;
    
    int _position;
}

-(int) errorOccured;

-(NSString*) stringFromDate:(NSDate*) date;
-(NSDate*) dateFromString:(NSString*) dateString;

@end


@interface DCMsDateParser : DCDateParser

@end


@interface DCIsoDateParser : DCDateParser

@end


@interface DCYmdhmsDateParser : DCDateParser

@end
