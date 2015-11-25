//
//  UserinfoByHuanxinSM.h
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-22.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"

@interface UserinfoByHuanxinSM : NSObject<IAnnotatable>
@property (retain, nonatomic) NSString *_id;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *phone;
@property (retain, nonatomic) NSString *imgurl;
@end
