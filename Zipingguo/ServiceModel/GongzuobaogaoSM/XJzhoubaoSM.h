//
//  XJzhoubaoSM.h
//  Lvpingguo
//
//  Created by miao on 14-10-8.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
@interface XJzhoubaoSM : NSObject<IAnnotatable>
@property (retain, nonatomic) NSString *summary;
@property (retain, nonatomic) NSString *plan;
@property (retain, nonatomic) NSString *createid;
@property (retain, nonatomic) NSString *createtime;
@property (retain, nonatomic) NSArray *dailyUsers;
@property(nonatomic,retain)NSArray*approveruserids;
@property(nonatomic,retain)NSArray*ccuserids;

@end
