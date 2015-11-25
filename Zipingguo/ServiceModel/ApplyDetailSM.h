//
//  ApplyDetailSM.h
//  Lvpingguo
//
//  Created by jiangshilin on 14-9-23.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApplyApprovalSM.h"
#import "IAnnotatable.h"
@interface ApplyDetailSM : NSObject<IAnnotatable>
@property (retain, nonatomic) ApplyApprovalSM *apply;
@property (retain, nonatomic) NSArray *applyexts;
@property (retain, nonatomic) NSArray *applyccs;
@property (retain, nonatomic) NSArray *applyrecords;
@end
