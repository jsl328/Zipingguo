//
//  DaKaRecordSM.h
//  Zipingguo
//
//  Created by sunny on 15/10/27.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"

@interface DaKaRecordSM : NSObject<IAnnotatable>
@property (nonatomic,copy) NSString *companyID;
@property (nonatomic,copy) NSString *recordID;
@property (nonatomic,copy) NSString *createDate;
@property (nonatomic,copy) NSString *createID;
@property (nonatomic,copy) NSString *nowTime;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *week;
@property (nonatomic,copy) NSNumber *deleteFlag;
@property (nonatomic,copy) NSString *timeStr;
@end
