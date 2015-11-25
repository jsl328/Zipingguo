//
//  Ribaodepartment.h
//  Lvpingguo
//
//  Created by miao on 14-10-11.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
@interface Ribaodepartment : NSObject<IAnnotatable>
@property(nonatomic,retain)NSString*ID;
@property(nonatomic,retain)NSString*name;
@property(nonatomic,assign)int isleaf;
@property(nonatomic,retain)NSString*parid;
@property(nonatomic,retain)NSString*memo;
@property(nonatomic,retain)NSString*companyid;
@end
