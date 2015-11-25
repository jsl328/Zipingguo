//
//  ResultModelOfPersonDetailSM.h
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-3.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
#import "DeptPersonsSM.h"
#import "DengluSM.h"
@interface ResultModelOfPersonDetailSM : NSObject<IAnnotatable>
@property (retain, nonatomic) DeptPersonsSM *data;

@property (nonatomic) int status;
@property (retain, nonatomic) NSString *msg;
@end
