//
//  GongsiModel.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/29.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DengluSM.h"
@interface GongsiModel : NSObject

@property (nonatomic, strong) NSString *selIcon;

@property (nonatomic, strong) NSString *icon;

@property (nonatomic, strong) DengluData2 *data2;

@property (nonatomic,assign) BOOL isSelect;

@property (nonatomic, assign) BOOL Isjiechu;

@end
