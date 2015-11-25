//
//  ZhoubiaorenmingData.h
//  Lvpingguo
//
//  Created by miao on 14-10-11.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
#import "UserSM.h"
#import "RibumenweekPapers.h"
#import "DailyPapers.h"
@interface ZhoubiaorenmingData : NSObject<IAnnotatable>
@property(nonatomic,retain)UserSM*user;
@property(nonatomic,retain)NSArray*weekPapers;
@property(nonatomic,retain)DailyPapers*dailyPapers;
@end
