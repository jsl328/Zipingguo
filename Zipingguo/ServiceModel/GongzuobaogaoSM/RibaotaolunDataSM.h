//
//  RibaotaolunDataSM.h
//  Lvpingguo
//
//  Created by miao on 14-9-22.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
@interface RibaotaolunDataSM : NSObject<IAnnotatable>
@property(nonatomic,retain)NSString*ID;
@property(nonatomic,retain)NSString*content;
@property(nonatomic,retain)NSString*createid;
@property(nonatomic,retain)NSString*createtime;
@property(nonatomic,retain)NSString*dailypaperid;
@property(nonatomic,retain)NSString*isreply;
@property(nonatomic,retain)NSString*topparid;

@end
