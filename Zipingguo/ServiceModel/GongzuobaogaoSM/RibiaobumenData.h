//
//  RibiaobumenData.h
//  Lvpingguo
//
//  Created by miao on 14-10-11.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
#import"DailyPapers.h"
#import "DailyPaperSM.h"
#import"RibumenweekPapers.h"
#import "Ribaodepartment.h"
#import "RirenmingdailyPapers.h"
@interface RibiaobumenData : NSObject<IAnnotatable>
@property(nonatomic,retain)Ribaodepartment*department;
@property(nonatomic,retain)NSArray*dailyPapers;
@property(nonatomic,retain)RibumenweekPapers*weekPapers;
@property(nonatomic,retain)NSArray * workpapers;

@end
