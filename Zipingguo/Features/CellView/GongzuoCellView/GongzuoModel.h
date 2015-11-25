//
//  GongzuoModel.h
//  Zipingguo
//
//  Created by fuyonghua on 15/9/10.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeContentVSM.h"
@interface GongzuoModel : NSObject

@property (nonatomic, strong) HomeContentVDataSM *data;

@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *neirong;
@end
