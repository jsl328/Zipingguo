//
//  DCServiceMethodConfig.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-5-7.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCServiceMethodConfig.h"
#import "ServiceMethod.h"

@implementation DCServiceMethodConfig {

    NSString* _name;
    
    ServiceMethod* _serviceMethod;
}

@synthesize showWaitBox = _showWaitBox;
@synthesize showErrorMessage = _showErrorMessage;
@synthesize checkNetwork = _checkNetwork;
@synthesize checkPayedNetwork = _checkPayedNetwork;

-(id) initWithServiceMethod:(id) serviceMethod {

    self = [super init];
    
    if (self) {
        
        _serviceMethod = serviceMethod;
    
        _name = _serviceMethod.name;
        _showWaitBox = _serviceMethod.showWaitBox;
        _showErrorMessage = _serviceMethod.showErrorMessage;
        _checkNetwork = _serviceMethod.checkNetwork;
        _checkPayedNetwork = _serviceMethod.checkPayedNetwork;
    }
    
    return self;
}


-(NSString*) name {
    return _name;
}

-(void) setShowWaitBox:(BOOL)showWaitBox {
    _showWaitBox = showWaitBox;
    _serviceMethod.showWaitBox = showWaitBox;
}

-(void) setShowErrorMessage:(BOOL)showErrorMessage {
    _showErrorMessage = showErrorMessage;
    _serviceMethod.showErrorMessage = showErrorMessage;
}

-(void) setCheckNetwork:(BOOL)checkNetwork {
    _checkNetwork = checkNetwork;
    _serviceMethod.checkNetwork = checkNetwork;
}

-(void) setCheckPayedNetwork:(BOOL)checkPayedNetwork {
    _checkPayedNetwork = checkPayedNetwork;
    _serviceMethod.checkPayedNetwork = checkPayedNetwork;
}

@end
