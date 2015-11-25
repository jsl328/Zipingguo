//
//  ZiXunShouCangSM.h
//  Zipingguo
//
//  Created by sunny on 15/11/2.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"

@class ZiXunShouCangSubSM;

@interface ZiXunShouCangSM : NSObject <IAnnotatable>
@property (nonatomic,assign) int status;
@property (nonatomic,retain) NSString * msg;
@property (nonatomic,retain) ZiXunShouCangSubSM * data;
@end

@interface ZiXunShouCangSubSM : NSObject<IAnnotatable>

@property (nonatomic,retain) NSString * ziXunID;
@property (nonatomic,retain) NSString * infoid;
@property (nonatomic,retain) NSString * userid;
@property (nonatomic,retain) NSString * createtime;


@end