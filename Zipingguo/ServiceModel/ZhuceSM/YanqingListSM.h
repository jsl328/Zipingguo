//
//  YanqingListSM.h
//  Zipingguo
//
//  Created by fuyonghua on 15/11/5.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YaoqingListDataSM;

@interface YanqingListSM : NSObject<IAnnotatable>
@property (nonatomic, assign) int status;

@property (nonatomic, strong) NSString *msg;

@property (nonatomic, strong) NSArray *data;

@end

@interface YaoqingListDataSM : NSObject<IAnnotatable>


@property (nonatomic, strong) NSString *phone;

@property (nonatomic, strong) NSArray *name;

@end