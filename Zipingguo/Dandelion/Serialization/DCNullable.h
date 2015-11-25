//
//  DCNullable.h
//  AmaranthDemo
//
//  Created by Sofia Work on 14-12-2.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCInteger : NSObject

@property (nonatomic) int value;

+(DCInteger*) integerFromInt:(int) value;

@end


@interface DCBoolean : NSObject

@property (nonatomic) BOOL value;

+(DCBoolean*) booleanFromBool:(BOOL) value;

@end
