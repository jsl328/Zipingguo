//
//  DCFileQueryOptions.h
//  AmaranthDemo
//
//  Created by Bob Li on 14-8-1.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCFileQueryOptions : NSObject
@property (nonatomic) int maxFileCount;

-(void) addFileExtension:(NSString*) extension;

-(void) setFileShouldBeLargerThan:(int) fromLength andSmallerThan:(int) toLength;

-(void) setFileShouldBeSmallerThan:(int) length;

-(void) setFileShouldBeLargerThan:(int) length;


-(BOOL) fileMatchesSearchCriteria:(NSString*) filePath withAttrs:(NSDictionary*) attrs;

@end
