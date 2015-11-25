//
//  UserSM.h
//  Lvpingguo
//
//  Created by miao on 14-9-22.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
@interface UserSM : NSObject<IAnnotatable>
@property(nonatomic,retain)NSString*ID;
@property(nonatomic,retain)NSString*name;
@property(nonatomic,retain)NSString*password;
@property(nonatomic,retain)NSString*email;
@property(nonatomic,retain)NSString*phone;
@property(nonatomic,retain)NSString*wechat;
@property(nonatomic,retain)NSString*qq;
@property(nonatomic,retain)NSString*birthday;
@property(nonatomic,retain)NSString*constellation;
@property(nonatomic,retain)NSString*hobby;
@property(nonatomic,retain)NSString*imgurl;
@property(nonatomic,retain)NSString*fontsize;
@property(nonatomic,retain)NSString*companyid;
@property(nonatomic,retain)NSString*sessionid;
@property(nonatomic,retain)NSString*position;
@property(nonatomic,retain)NSString*deleteflag;
@property(nonatomic,retain)NSString*status;


@end
