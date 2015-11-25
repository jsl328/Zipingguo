//
//  XInjianribaoSM.h
//  Lvpingguo
//
//  Created by miao on 14-9-22.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
#import "DataSM.h"
@interface XInjianribaoSM : NSObject<IAnnotatable>
@property(nonatomic,assign)int status;
@property(nonatomic,retain)NSString*msg;
@property(nonatomic,retain)DataSM*data;
@end
