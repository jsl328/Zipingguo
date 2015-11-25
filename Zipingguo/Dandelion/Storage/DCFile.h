//
//  DCFile.h
//  DandelionDemo
//
//  Created by Bob Li on 13-12-12.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCFile : NSObject

@property (retain, nonatomic) NSString* path;

+(DCFile*) fileAtPath:(NSString*) filePath;

-(int) length;

@end
