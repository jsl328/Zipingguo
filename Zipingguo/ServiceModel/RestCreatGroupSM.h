//
//  RestCreatGroupSM.h
//  Lvpingguo
//
//  Created by jiangshilin on 15-1-22.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"

@interface GroupID : NSObject<IAnnotatable>

@property (nonatomic,strong)NSString *groupid;

@end

@interface RestCreatGroupSM : NSObject<IAnnotatable>

@property (nonatomic,strong) GroupID *data;

@end
