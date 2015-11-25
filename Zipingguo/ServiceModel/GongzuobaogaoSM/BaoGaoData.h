//
//  ZhoubiaoData.h
//  Lvpingguo
//
//  Created by miao on 14-10-10.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import"WorkPaper.h"
#import "CreateuserSM.h"
#import "Zhoubaoapproverusers.h"
#import "Zhoubaoccusers.h"
#import "DailyCommentsSM.h"
#import "IAnnotatable.h"
#import "RirenmingdailyPapers.h"
#import "ResultModelOfIListOfNoticeSM.h"

@interface BaoGaoData : NSObject<IAnnotatable>
@property(nonatomic,retain) WorkPaper *workpaper;
@property(nonatomic,retain) CreateuserSM *createuser;
@property(nonatomic,retain) NSArray *approverusers;
@property(nonatomic,retain) NSArray *ccusers;
@property(nonatomic,retain) NSArray *workpaperComments;
//@property(nonatomic,retain) RirenmingdailyPapers*workpaper;
@property(nonatomic,retain) NSArray * workpaperAnnexs;

@end
