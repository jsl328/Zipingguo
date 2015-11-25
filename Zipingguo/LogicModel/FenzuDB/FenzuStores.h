//
//  FenzuStores.h
//  Lvpingguo
//
//  Created by fuyonghua on 14-11-26.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface FenzuStores : NSObject

//根据公司id,parid来查
+ (NSMutableArray *)getAllWithGongsiID:(NSString *)gongshi Parid:(NSString *)parid;

//全部删除
+ (void)deleteDataInGongSiTongXunLuFenzuDataBase;

@end
