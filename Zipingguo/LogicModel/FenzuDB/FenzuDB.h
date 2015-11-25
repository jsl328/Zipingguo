//
//  FenzuDB.h
//  Lvpingguo
//
//  Created by fuyonghua on 14-11-26.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "EntityBase.h"
@class FenzuInfoDB;
@interface FenzuDB : NSObject

+ (void)saveToDB:(id)sm;

@property (nonatomic, strong) FenzuInfoDB *infoDB;

@end

@interface FenzuInfoDB : EntityBase

- (void)saveToFenzuDB:(id)sm;

@property (retain, nonatomic) NSString *companyid;
@property (retain, nonatomic) NSString * _id;
@property (retain, nonatomic) NSString *code;
@property (retain, nonatomic) NSString *name;
@property (nonatomic) int isleaf;
@property (retain, nonatomic) NSString *parid;
@property (retain, nonatomic) NSString *memo;
@property (nonatomic,assign) int sort;
@property (nonatomic) int deleteflag;
@property (retain, nonatomic) NSString *path;
@property (retain, nonatomic) NSString *sortstr;
@property (retain, nonatomic) NSString *subdepts;
@property (retain, nonatomic) NSString *users;

@end