//
//  ResultModelOfNoticeDetailSM.h
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-2.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
#import "ResultModelOfIListOfNoticeSM.h"
@interface ResultModelOfNoticeDetailSM : NSObject<IAnnotatable>
@property (nonatomic, assign) int status;
@property (retain, nonatomic) NoticeSM *data;

@end
