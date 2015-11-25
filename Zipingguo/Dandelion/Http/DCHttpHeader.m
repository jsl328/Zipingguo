//
//  DCHttpHeader.m
//  DandelionDemo
//
//  Created by Bob Li on 14-1-10.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCHttpHeader.h"

@implementation DCHttpHeader {

    NSMutableDictionary* _items;
}

@synthesize isEnabled;

-(id) init {
    self = [super init];
    if (self) {
        _items = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void) setHeaderValue:(NSString*) value forName:(NSString*) name {
    [_items setObject:value forKey:name];
}

-(void) parseXml:(RXMLElement*) xml {
    
    [_items removeAllObjects];
    
    isEnabled = [xml attribute:@"IsEnabled"] ? [[xml attribute:@"IsEnabled"] isEqualToString:@"true"] : YES;
    
    [xml iterate:@"HeaderItem" usingBlock: ^(RXMLElement *e) {
        
        NSString* name = [e attribute:@"Name"] ? [e attribute:@"Name"] : nil;
        NSString* value = [e attribute:@"Value"] ? [e attribute:@"Value"] : @"";
        
        if (name) {
            [_items setObject:value forKey:name];
        }
    }];
}

-(void) printLog:(NSString*) title {
    
    if (!isEnabled) {
        return;
    }
    
    NSMutableString* s = [[NSMutableString alloc] init];
    [s appendFormat:@"%@:\r\n", title];
    
    for (NSString* name in _items.keyEnumerator) {
        [s appendFormat:@"name:%@ value:%@\r\n", name, [_items objectForKey:name]];
    }
         
    NSLog(@"%@", s);
}

-(void) applyToRequest:(NSMutableURLRequest*) request {
    
    if (!isEnabled) {
        return;
    }
    
    for (NSString* name in _items.keyEnumerator) {
        [request setValue:[_items objectForKey:name] forHTTPHeaderField:name];
    }
}

@end
