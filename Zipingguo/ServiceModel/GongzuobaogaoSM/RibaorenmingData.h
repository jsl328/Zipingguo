//
//  RibaorenmingData.h
//  Lvpingguo
//
//  Created by miao on 14-10-11.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
#import "RibumenweekPapers.h"
#import "RirenmingdailyPapers.h"
#import "UserSM.h"
@interface RibaorenmingData : NSObject<IAnnotatable>
@property(nonatomic,retain)UserSM*user;
@property(nonatomic,retain)NSArray*dailyPapers;
@property(nonatomic,retain)RibumenweekPapers*weekPapers;
@property(nonatomic,retain)NSArray * workpapers;
@property(nonatomic,retain)UserSM*user0;
@end