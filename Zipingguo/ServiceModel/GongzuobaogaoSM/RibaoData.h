//
//  RibaoData.h
//  Lvpingguo
//
//  Created by miao on 14-10-9.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
#import "DailyCommentsSM.h"
#import "DailyPaperSM.h"
#import "RibaoCreateuser.h"
#import "ApproverusersSM.h"
#import "CcusersSM.h"
#import"CreateuserSM.h"
@interface RibaoData : NSObject<IAnnotatable>
@property(nonatomic,retain)DailyPaperSM*dailyPaper;
@property(nonatomic,retain) NSArray*dailyComments;
@property(nonatomic,retain)CreateuserSM*createuser;
@property(nonatomic,retain)NSArray*approverusers;
@property(nonatomic,retain)NSArray*ccusers;

@end
