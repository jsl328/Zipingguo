//
//  ResultModelOfGetCodeSM.h
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-16.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
@interface ResultModelOfGetCodeSM : NSObject<IAnnotatable>
@property (nonatomic) int status;
@property (retain, nonatomic) NSString *msg;
@property (retain, nonatomic) NSString *data;
@end
