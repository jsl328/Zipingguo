//
//  CalendarViewController.h
//  Calendar
//
//  Created by 张凡 on 14-8-21.
//  Copyright (c) 2014年 张凡. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "CalendarLogic.h"
#import "ParentsViewController.h"
//回掉代码块
typedef void (^CalendarBlock)(CalendarDayModel *model);

@interface CalendarViewController : ParentsViewController


@property(nonatomic ,strong) UICollectionView* collectionView;//网格视图

@property(nonatomic ,strong) NSMutableArray *calendarMonth;//每个月份的中的daymodel容器数组
@property(nonatomic ,strong) NSMutableArray*calendarMonthhongdian;
@property(nonatomic ,strong) CalendarLogic *Logic;

@property (nonatomic, copy) CalendarBlock calendarblock;//回调
@property (nonatomic, assign) NSUInteger day;//天
@property (nonatomic, assign) NSUInteger month;//月
@property (nonatomic, assign) NSUInteger year;//年
@property(nonatomic,assign)BOOL isguangdong;
@end
