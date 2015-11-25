//
//  MemoContentSM.h
//  Lvpingguo
//
//  Created by fuyonghua on 14-10-13.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"

@interface groupID : NSObject<IAnnotatable>
@property (nonatomic,strong )NSString *groupid;
@end

@interface MemoContentSM : NSObject<IAnnotatable>

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *createtime;
@property (nonatomic, strong) NSString *flowname;
//jsl...
@property (nonatomic, strong) groupID *data;
@end
