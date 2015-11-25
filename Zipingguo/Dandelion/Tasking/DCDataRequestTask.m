//
//  DCDataRequestTask.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-7-18.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCDataRequestTask.h"

@implementation DCDataRequestTask {
    
    NSMutableData* _returnedData;
}

-(id) init {
    self = [super init];
    if (self) {
        self.feature = DCTaskFeatureDataRequest;
    }
    return self;
}


-(NSData*) returnedData {
    return _returnedData;
}

-(void) execute {
    _returnedData = [[NSMutableData alloc] init];
    [super execute];
}


// abstract methods

-(void) writeData:(NSData*) data {
    [_returnedData appendData:data];
}

-(void) onDownloadComplete {
}

//

@end
