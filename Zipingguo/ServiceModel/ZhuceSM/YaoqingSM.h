//
//  YaoqingSM.h
//  Zipingguo
//
//  Created by fuyonghua on 15/11/3.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YaoqingSM : NSObject<IAnnotatable>

@property (nonatomic, assign) int status;

@property (nonatomic, strong) NSString *msg;

@property (nonatomic, strong) NSArray *data;

@end
