//
//  ResultModelOfUserinfoByHxnameSM.h
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-22.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserinfoByHuanxinSM.h"
#import "IAnnotatable.h"
@interface ResultModelOfUserinfoByHxnameSM : NSObject<IAnnotatable>
@property (retain, nonatomic) NSArray *data;
@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSString *msg;
@end
