//
//  CurrentDevice.h
//  ZiRobot
//
//  Created by 阿布都沙拉木吾斯曼 on 15/4/29.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentDevice : NSObject

+ (BOOL)GetDeviceType;

+ (NSString *)GetDeviceName;
@end
