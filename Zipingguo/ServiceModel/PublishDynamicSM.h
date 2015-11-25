//
//  PublishDynamicSM.h
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-24.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
@interface PublishDynamicSM : NSObject<IAnnotatable>
@property (retain, nonatomic) NSString *groupid;
@property (retain, nonatomic) NSString *content;
@property (retain, nonatomic) NSString *address;
@property (retain, nonatomic) NSString *createid;
@property (retain, nonatomic) NSArray *spendtimes;
@property (retain, nonatomic) NSArray *imgstrs;
@property (retain, nonatomic) NSArray *atusers;
@property (retain, nonatomic) NSArray *sounds;
@property (nonatomic) NSUInteger positionx;
@property (nonatomic) NSUInteger positiony;
@property (retain, nonatomic) NSString *companyid;
@end
