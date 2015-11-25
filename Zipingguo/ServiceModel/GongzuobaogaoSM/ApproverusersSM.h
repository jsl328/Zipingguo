//
//  ApproverusersSM.h
//  Lvpingguo
//
//  Created by miao on 14-9-22.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
@interface ApproverusersSM : NSObject<IAnnotatable>
@property(nonatomic,retain)NSString*ID;
@property(nonatomic,retain)NSString*name;
@property(nonatomic,retain)NSString*imgurl;
@property(nonatomic,retain)NSString*username;
@property(nonatomic,assign)int type;
@end
