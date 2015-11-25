//
//  DownloadTask.h
//  Mulberry
//
//  Created by Bob Li on 13-7-9.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCTask.h"
#import "DCHttpHeader.h"

@interface DCDownloadTask : DCTask <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (retain, nonatomic) NSString* url;
@property (nonatomic) int responseContentLength;
@property (nonatomic) NSData* body;
@property (retain, nonatomic) NSString* contentType;
@property (nonatomic) NSString* httpMethod;
@property (nonatomic) int useCookie;
@property (retain, nonatomic) DCHttpHeader* globalHeader;
@property (retain, nonatomic) DCHttpHeader* requestHeader;
@property (retain, nonatomic) NSString* requestEncodingName;


// abstract methods

-(void) writeData:(NSData*) data;

-(void) onDownloadComplete;

//


-(NSError*) error;

-(int) statusCode;

@end
