//
//  FujianModel.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/15.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResultModelOfIListOfNoticeSM.h"
@interface FujianModel : NSObject
@property (nonatomic, strong) NoticeAnnexsSM *noticeAnnexsSM;

@property (nonatomic,assign) BOOL isBaogao;//是否是工作报告
@end
