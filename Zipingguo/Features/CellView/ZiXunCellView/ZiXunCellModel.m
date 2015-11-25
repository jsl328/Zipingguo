//
//  ZiXunCellModel.m
//  Zipingguo
//
//  Created by sunny on 15/10/12.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "ZiXunCellModel.h"

@implementation ZiXunCellModel

@synthesize iconImage,titleName,time,commentCount,ziXunID,createid;

- (void)setModelWithSM:(ZiXunListSubSM *)sm{
    iconImage = sm.imgurl;
    titleName = sm.title;
    time = sm.time;
    commentCount = sm.readamount;
    ziXunID = sm.ziXunID;
    createid = sm.createid;
}
@end
