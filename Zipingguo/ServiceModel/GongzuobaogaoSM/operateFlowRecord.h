//
//  operateFlowRecord.h
//  Lvpingguo
//
//  Created by jiangshilin on 14-9-24.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
@interface operateFlowRecord : NSObject<IAnnotatable>

@property (nonatomic,weak)NSString *status;
@property (nonatomic,weak)NSString *msg;

@end
