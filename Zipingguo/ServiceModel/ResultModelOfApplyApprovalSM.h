//
//  ResultModelOfApplyApprovalSM.h
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-4.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
@interface ResultModelOfApplyApprovalSM : NSObject<IAnnotatable>

@property (assign, nonatomic) int status;
@property (retain, nonatomic) NSArray *data;
@end
