//
//  HPResultSM.h
//  Lvpingguo
//
//  Created by HeHe丶 on 15/3/4.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
@interface HPResultSM : NSObject<IAnnotatable>

@property (nonatomic) int status;
@property (retain, nonatomic) NSString *msg;
@property (nonatomic) int data;

@end

