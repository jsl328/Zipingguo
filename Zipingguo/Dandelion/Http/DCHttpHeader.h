//
//  DCHttpHeader.h
//  DandelionDemo
//
//  Created by Bob Li on 14-1-10.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RXMLElement.h"

@interface DCHttpHeader : NSObject

@property (nonatomic) BOOL isEnabled;

-(void) setHeaderValue:(NSString*) value forName:(NSString*) name;

-(void) parseXml:(RXMLElement*) xml;

-(void) printLog:(NSString*) title;

-(void) applyToRequest:(NSMutableURLRequest*) request;

@end
