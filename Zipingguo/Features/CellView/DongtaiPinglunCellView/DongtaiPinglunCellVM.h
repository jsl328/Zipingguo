//
//  DongtaiPinglunCellVM.h
//  Lvpingguo
//
//  Created by fuyonghua on 14-8-6.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//
 
#import <Foundation/Foundation.h>
#import "DCCellHeightDataSource.h"
#import "ResultModelOfIListOfDynamicSM.h"

@interface DongtaiPinglunCellVM : NSObject<DCCellHeightDataSource>

@property (nonatomic) float cellHeight;
@property (nonatomic, strong) DycommentsSM *model;

@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) BOOL last;
@property (nonatomic, assign) BOOL isIcon;

@end
