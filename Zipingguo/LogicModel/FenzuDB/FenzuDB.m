//
//  FenzuDB.m
//  Lvpingguo
//
//  Created by fuyonghua on 14-11-26.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "FenzuDB.h"

@implementation FenzuDB

+ (void)saveToDB:(CompanyDeptsSM *)sm{
    FenzuInfoDB *infoDB = [[FenzuInfoDB alloc] init];
    [infoDB saveToFenzuDB:sm];
}

@end

@implementation FenzuInfoDB

- (void)saveToFenzuDB:(CompanyDeptsSM *)sm{
    self.companyid = sm.companyid;
    self._id = sm._id;
    self.code = sm.code;
    self.name = sm.name;
    self.isleaf = sm.isleaf;
    self.parid = sm.parid;
    self.memo = sm.memo;
    self.sort = sm.sort;
    self.deleteflag = sm.deleteflag;
    self.path = sm.path;
    self.sortstr = sm.sortstr;
    self.subdepts = sm.subdepts;
    self.users = sm.users;
    
    [self save];
}

@end