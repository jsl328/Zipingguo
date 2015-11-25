//
//  ZiXunZanSM.h
//  Zipingguo
//
//  Created by sunny on 15/11/2.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"

@interface ZiXunZanSM : NSObject <IAnnotatable>
@property(nonatomic,assign) int Status;
@property(nonatomic,copy) NSString *Msg;
@end
