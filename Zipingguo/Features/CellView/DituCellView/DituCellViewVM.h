//
//  DituCellViewVM.h
//  CeshiOA
//
//  Created by jiangshilin on 14-8-8.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCCellHeightDataSource.h"
@interface DituCellViewVM : NSObject<DCCellHeightDataSource>
@property (nonatomic, assign) float cellHeight;
@property (nonatomic, strong) NSString *dizhiXinxi;
@property (nonatomic, strong) NSString *jutiXinxi;
@end
