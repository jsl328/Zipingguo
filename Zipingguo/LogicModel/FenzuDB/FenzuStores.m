//
//  FenzuStores.m
//  Lvpingguo
//
//  Created by fuyonghua on 14-11-26.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "FenzuStores.h"
#import "FenzuDB.h"
#import "DB.h"
@implementation FenzuStores

+ (NSMutableArray *)getAllWithGongsiID:(NSString *)gongshi Parid:(NSString *)parid{
    
    NSString *sql = [NSString stringWithFormat:@"select * from FenzuInfoDB Where companyid = '%@' and parid = '%@'",gongshi,parid];
    
    NSMutableArray * array = [[NSMutableArray alloc]initWithArray:[DB select:[FenzuInfoDB class] withSql:sql]];
    return array;
}

+ (void)deleteDataInGongSiTongXunLuFenzuDataBase{
    [DB executeSql:@"delete from FenzuInfoDB"];
}

@end
