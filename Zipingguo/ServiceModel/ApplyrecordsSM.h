//
//  ApplyrecordsSM.h
//  Lvpingguo
//
//  Created by jiangshilin on 14-10-11.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
@interface ApplyrecordsSM : NSObject<IAnnotatable>
@property (retain, nonatomic) NSString *_id;
@property (retain, nonatomic) NSString *applyid;
@property (retain, nonatomic) NSString *dealid;
@property (retain, nonatomic) NSString *dealtime;
@property (assign, nonatomic) int status;
@property (strong, nonatomic) NSString *passid;
@property (retain, nonatomic) NSString *content;
@property (retain, nonatomic) NSString *dealname;
@property (strong, nonatomic) NSString *passname;

@end
