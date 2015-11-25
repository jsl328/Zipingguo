//
//  ChuangjianrilibeiwangSM.h
//  Zipingguo
//
//  Created by miao on 15/10/28.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
@class BeishuData;
@interface ChuangjianrilibeiwangSM : NSObject<IAnnotatable>
@property(nonatomic,copy)NSString *msg;
@property(nonatomic,assign)int status;
@property(nonatomic,retain)BeishuData*data;
@end
@interface BeishuData : NSObject<IAnnotatable>
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *userid;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *createtime;

@end