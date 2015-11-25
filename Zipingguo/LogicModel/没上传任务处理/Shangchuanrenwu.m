//
//  Shangchuanrenwu.m
//  Zipingguo
//
//  Created by miao on 15/11/17.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "Shangchuanrenwu.h"

@implementation Shangchuanrenwu

+(void)meichangchuanrenwuDB
{
    
    NSLog(@"___%@",[[NSBundle mainBundle] description]);
    NSArray*myrewuDBArr=[RenwuStores getmeishangchuanrenwu];
    for (RenwuDB * db in myrewuDBArr) {
        ChuangjianRenwuSM * sm = [[ChuangjianRenwuSM alloc] init];
        [sm setSMWithDB:db]  ;
        
    }

}

@end
