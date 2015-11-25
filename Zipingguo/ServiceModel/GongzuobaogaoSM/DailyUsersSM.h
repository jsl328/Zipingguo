//
//  DailyUsersSM.h
//  Lvpingguo
//
//  Created by linku on 14-9-25.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
@interface DailyUsersSM : NSObject<IAnnotatable>

@property (retain, nonatomic) NSString *userid;
@property (retain, nonatomic) NSString *username;
@property (nonatomic) int type;
@end
