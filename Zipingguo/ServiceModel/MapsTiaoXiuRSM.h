//
//  MapsTiaoXiuRSM.h
//  Lvpingguo
//
//  Created by jiangshilin on 14-10-25.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
#import "MapsTiaoxiuSM.h"
@interface MapsTiaoXiuRSM : NSObject<IAnnotatable>
@property (retain, nonatomic) NSString *createid;
@property (retain, nonatomic) NSString *createname;
@property (retain, nonatomic) NSString *flowid;
@property (retain, nonatomic) NSString *flowname;
@property (retain, nonatomic) NSString *companyid;
@property (retain, nonatomic) NSString *dealid;
@property (retain, nonatomic) NSArray *ccs;
@property (retain, nonatomic) MapsTiaoxiuSM *maps;
@end
