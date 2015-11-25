//
//  RegCorpCheckCodeSM.h
//  Zipingguo
//
//  Created by fuyonghua on 15/11/3.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RegCorpCheckCodeDataSM;
@interface RegCorpCheckCodeSM : NSObject<IAnnotatable>

@property (nonatomic, assign) int status;

@property (nonatomic, strong) NSString *msg;

@property (nonatomic, strong) RegCorpCheckCodeDataSM *data;

@end

@interface RegCorpCheckCodeDataSM : NSObject<IAnnotatable>

@property (nonatomic, strong) NSString *userid;

@property (nonatomic, strong) NSString *companyid;

@end