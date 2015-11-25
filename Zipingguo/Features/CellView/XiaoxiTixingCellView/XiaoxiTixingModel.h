//
//  XiaoxiTixingModel.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/17.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResultModelOfGetOptionSM.h"

@protocol XiaoxiTixingModelDelegate <NSObject>

- (void)shezhiShifouJieshouxinXiaoxi:(NSString *)msgoptionid switch:(BOOL)isOn isLiaotian:(BOOL)liaotian;

@end

@interface XiaoxiTixingModel : NSObject
@property (nonatomic, strong) id <XiaoxiTixingModelDelegate> delegate;
@property (nonatomic, strong) OptionSM *optionSM;

@end
