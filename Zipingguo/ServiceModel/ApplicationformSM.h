//
//  ApplicationformSM.h
//  Lvpingguo
//
//  Created by jiangshilin on 14-9-25.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
@interface ApplicationformSM : NSObject<IAnnotatable>

@property (nonatomic,strong)NSString *_id;
@property (nonatomic,strong)NSString *flowid;
@property (nonatomic,strong)NSString *chname;
@property (nonatomic,assign)int sort;
@property (nonatomic,assign)int type;
@property (nonatomic,strong)NSString *strs;
@property (nonatomic,strong)NSString *content;
@end
