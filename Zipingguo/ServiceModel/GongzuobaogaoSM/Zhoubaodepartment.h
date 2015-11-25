//
//  Zhoubaodepartment.h
//  Lvpingguo
//
//  Created by miao on 14-9-22.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
@interface Zhoubaodepartment : NSObject<IAnnotatable>
@property(nonatomic,retain)NSString*ID;
@property(nonatomic,retain)NSString*name;
@property(nonatomic,retain)NSString*isleaf;
@property(nonatomic,retain)NSString*parid;
@property(nonatomic,retain)NSString*memo;
@property(nonatomic,retain)NSString*companyid;
@end
