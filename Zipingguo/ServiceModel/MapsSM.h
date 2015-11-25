//
//  MapsSM.h
//  Lvpingguo
//
//  Created by jiangshilin on 14-9-25.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
@interface MapsSM : NSObject<IAnnotatable>

@property (assign, nonatomic) NSString* chname;
@property (assign, nonatomic) int sort;
@property (assign, nonatomic) int type;
@property (assign, nonatomic) NSString* content;

@end
