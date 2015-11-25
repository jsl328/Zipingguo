//
//  BaoGaoSortResultSM.h
//  Zipingguo
//
//  Created by lilufeng on 15/10/30.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
@interface BaoGaoSortResultSM : NSObject<IAnnotatable>
@property (strong, nonatomic) NSArray *data;

@end



@interface CompanyDeptsSortSM : NSObject<IAnnotatable>
@property (retain, nonatomic) NSString *ID;//公司返回的是id
@property (retain, nonatomic) NSString *userid;//名称返回的是userid

@property (retain, nonatomic) NSString *imgurl;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *notreadcount;

@end

