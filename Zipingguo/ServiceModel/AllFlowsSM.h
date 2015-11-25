//
//  AllFlowsSM.h
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-4.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
@interface AllFlowsSM : NSObject<IAnnotatable>
@property (retain, nonatomic) NSString *leixingID;
@property (retain, nonatomic) NSString *im;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *infodescription;
@property (retain, nonatomic) NSString *defaultuserid;
@property (retain, nonatomic) NSString *defaultusername;
@property (retain, nonatomic) NSString *deleteflag;
@property (retain, nonatomic) NSString *companyid;
@end
