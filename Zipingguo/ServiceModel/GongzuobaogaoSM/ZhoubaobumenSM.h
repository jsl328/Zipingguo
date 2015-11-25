//
//  ZhoubaobumenSM.h
//  Lvpingguo
//
//  Created by miao on 14-9-22.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
#import"ZhoubiaobumenData.h"
@interface ZhoubaobumenSM : NSObject<IAnnotatable>
@property(nonatomic,retain)NSArray*data;
@end

@interface BumenSM : NSObject<IAnnotatable>
@property(nonatomic,retain)NSArray*data;
@end