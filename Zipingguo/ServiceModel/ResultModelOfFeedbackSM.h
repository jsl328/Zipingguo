//
//  ResultModelOfFeedbackSM.h
//  Lvpingguo
//
//  Created by fuyonghua on 14-10-20.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
@class FeedbackSM;
@interface ResultModelOfFeedbackSM : NSObject<IAnnotatable>
@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) FeedbackSM *entity;
@end

@interface FeedbackSM : NSObject<IAnnotatable>
@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *createtime;
@end