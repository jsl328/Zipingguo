//
//  DCServiceMethodConfig.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-5-7.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCServiceMethodConfig : NSObject

@property (nonatomic) BOOL showWaitBox;
@property (nonatomic) BOOL showErrorMessage;
@property (nonatomic) BOOL checkNetwork;
@property (nonatomic) BOOL checkPayedNetwork;

-(id) initWithServiceMethod:(id) serviceMethod;

-(NSString*) name;

@end
