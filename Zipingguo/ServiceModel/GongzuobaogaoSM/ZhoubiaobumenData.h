//
//  ZhoubiaobumenData.h
//  Lvpingguo
//
//  Created by miao on 14-10-11.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
#import "Zhoubaodepartment.h"
#import "RibumenweekPapers.h"
#import "DailyPapers.h"
@interface ZhoubiaobumenData : NSObject<IAnnotatable>
@property(nonatomic,retain)Zhoubaodepartment*department;
@property(nonatomic,retain)NSArray*weekPapers;
@property(nonatomic,retain)DailyPapers*dailyPapers;

@end
