//
//  DCUploadTask.h
//  DandelionDemo
//
//  Created by Bob Li on 13-12-12.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCTask.h"

@interface DCUploadTask : DCTask <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (retain, nonatomic) NSString* url;
@property (retain, nonatomic) NSString* filePath;
@property (retain, nonatomic) NSData* responseData;
@property (retain, nonatomic) NSError* error;
@property (retain, nonatomic) NSString* httpMethod;
@property (nonatomic) int statusCode;


@end
