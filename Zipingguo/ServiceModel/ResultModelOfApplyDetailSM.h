//
//  ResultModelOfApplyDetailSM.h
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-4.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
#import "ApplyDetailSM.h"
@interface ResultModelOfApplyDetailSM : NSObject<IAnnotatable>
@property (retain, nonatomic) ApplyDetailSM *data;
@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSString *msg;
@end
