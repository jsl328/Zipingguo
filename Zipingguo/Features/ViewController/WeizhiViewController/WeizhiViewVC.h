//
//  WeizhiViewController.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/14.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "RootViewController.h"

@interface WeizhiViewVC : RootViewController

@property (nonatomic ,strong) void (^passValueFromWeizhi)(NSString* weizhi,CLLocationCoordinate2D coordinate);

@end
