//
//  DCUploadTaskCF.h
//  AmaranthDemo
//
//  Created by Sofia Work on 14-11-20.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import "DCTask.h"

@interface DCUploadTaskCF : DCTask <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (retain, nonatomic) NSString* url;
@property (retain, nonatomic) NSString* filePath;
@property (retain, nonatomic) NSData* responseData;
@property (retain, nonatomic) NSError* error;
@property (retain, nonatomic) NSString* httpMethod;
@property (nonatomic) int statusCode;


@end
