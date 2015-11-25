//
//  ResultModelOfGetOptionSM.h
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-20.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
@class OptionSM;
@interface ResultModelOfGetOptionSM : NSObject<IAnnotatable>
@property (nonatomic, assign) int status;
@property (retain, nonatomic) NSArray *data;

@end

@interface OptionSM : NSObject<IAnnotatable>

@property (retain, nonatomic) NSString *_id;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *createid;
@property (retain, nonatomic) NSDate *createtime;
@property (nonatomic) int status;
@property (retain, nonatomic) NSString *companyid;
@property (nonatomic) int isReceive;
@end