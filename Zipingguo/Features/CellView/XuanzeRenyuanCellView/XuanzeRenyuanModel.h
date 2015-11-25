//
//  XuanzeRenyuanModel.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/16.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XuanzeRenyuanModel : NSObject<NSCoding>

@property (nonatomic, assign) BOOL xuanzhong;

@property (nonatomic, assign) BOOL  endure;

@property (nonatomic, strong) YonghuInfoDB *personsSM;

@property (nonatomic,strong) NSAttributedString *showName;

@end
