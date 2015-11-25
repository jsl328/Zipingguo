//
//  XuanzeBumenViewController.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/18.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "RootViewController.h"

@interface XuanzeBumenViewController : RootViewController

@property (nonatomic ,strong) void (^passValueFromXuanze)(NSString* bumen,NSString *deptid);

@property (nonatomic, strong) NSString *titleText;

@end
