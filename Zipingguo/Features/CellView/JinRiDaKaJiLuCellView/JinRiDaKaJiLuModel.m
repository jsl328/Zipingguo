//
//  JinRiDaKaJiLuModel.m
//  Zipingguo
//
//  Created by sunny on 15/10/16.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "JinRiDaKaJiLuModel.h"

@implementation JinRiDaKaJiLuModel
- (void)setVMWithSM:(SingleDaySM *)sm{
    self.time = [[[sm.attdtime componentsSeparatedByString:@" "] objectAtIndex:1] substringToIndex:5];
    self.addressName = sm.attdaddr;
}
@end
