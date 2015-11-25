//
//  ApplyDetail2SM.h
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-4.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
@interface ApplyDetailsSM : NSObject<IAnnotatable>

@property (retain, nonatomic) NSString *_id;
@property (retain, nonatomic) NSString *applyid;
@property (assign, nonatomic) int sort;
@property (retain, nonatomic) NSString *chname;
@property (assign, nonatomic) int type;
@property (retain, nonatomic) NSString *content;
@end
