//
//  CalendarHomeViewController.h
//  Calendar
//
//  Created by 张凡 on 14-6-23.
//  Copyright (c) 2014年 张凡. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "CalendarViewController.h"


@interface CalendarHomeViewController : CalendarViewController

@property (nonatomic, strong) NSString *calendartitle;//设置导航栏标题


- (void)setAirPlaneToDay:(int)day ToDateforString:(NSString *)todate;//飞机初始化方法



@end
