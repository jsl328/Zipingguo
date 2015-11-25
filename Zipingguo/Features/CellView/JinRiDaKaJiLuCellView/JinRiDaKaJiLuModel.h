//
//  JinRiDaKaJiLuModel.h
//  Zipingguo
//
//  Created by sunny on 15/10/16.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DaKaJiLuSM.h"

@interface JinRiDaKaJiLuModel : NSObject
@property (nonatomic,copy) NSString *time;
@property (nonatomic,copy) NSString *addressName;
- (void)setVMWithSM:(SingleDaySM *)sm;
@end
