//
//  ResultModelShangchuanXiangpianSM.h
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-23.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
@class ModelUrlSM;
@interface ResultModelShangchuanWenjianSM : NSObject<IAnnotatable>

@property (nonatomic) int result;
@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *msg;
@property (retain, nonatomic) ModelUrlSM *data;
@end

@interface ModelUrlSM : NSObject<IAnnotatable>

@property (retain, nonatomic) NSString *url;

@end