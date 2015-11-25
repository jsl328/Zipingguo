//
//  TidaoWodeModel.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/13.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResultModelOfatMeNoticeSM.h"
@interface TidaoWodeModel : NSObject

@property (nonatomic, strong) AtMeNoticeSM *atMeNoticeSM;

@property (nonatomic, strong) NSString *mingzi;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *leixing;

@property (nonatomic, strong) NSString *shijian;

@property (nonatomic, strong) NSString *touxiang;

@property (nonatomic, strong) NSString *neirong;

@end
