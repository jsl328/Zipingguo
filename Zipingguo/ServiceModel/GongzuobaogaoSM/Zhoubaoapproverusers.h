//
//  Zhoubaoapproverusers.h
//  Lvpingguo
//
//  Created by miao on 14-9-22.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
@interface Zhoubaoapproverusers : NSObject<IAnnotatable>
@property(nonatomic,retain)NSString*ID;
@property(nonatomic,retain)NSString*workpaperid ;
@property(nonatomic,retain)NSString*userid;
@property(nonatomic,retain)NSString*username;
@property(nonatomic,assign)int type;
@property(nonatomic,assign)int isread;
@property (nonatomic,retain) NSString *createtime;
@end
