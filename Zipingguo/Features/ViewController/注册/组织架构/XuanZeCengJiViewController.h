//
//  XuanZeCengJiViewController.h
//  Zipingguo
//
//  Created by 韩飞 on 15/11/12.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "WaiweiParentsViewController.h"

@interface XuanZeCengJiViewController : WaiweiParentsViewController
@property (nonatomic,strong) NSMutableArray *dataArray;;
@property (nonatomic,strong) void(^quXiaoBlock)();
@property (nonatomic,strong) void(^finishBlock)(NSString *preName);
- (void)reloadData;
@property (nonatomic ,strong) void (^passValueFromXuanze)(NSString* bumen,NSString *deptid);
- (void)loadCengJiJieGouData;
@end
