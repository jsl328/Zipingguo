//
//  FirstLoginPerfectInfoSM.h
//  Zipingguo
//
//  Created by fuyonghua on 15/11/2.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
@interface FirstLoginPerfectInfoSM : NSObject<IAnnotatable>

@property (nonatomic, strong) NSString *userid;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *deptid;

@property (nonatomic, strong) NSString *position;

@property (nonatomic, strong) NSString *imgurl;

@property (nonatomic, strong) NSString *jobnumber;

@property (nonatomic, strong) NSString *email;

@end
