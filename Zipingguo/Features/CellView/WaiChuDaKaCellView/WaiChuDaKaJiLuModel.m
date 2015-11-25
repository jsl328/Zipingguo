//
//  WaiChuDaKaModel.m
//  Zipingguo
//
//  Created by sunny on 15/10/26.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "WaiChuDaKaJiLuModel.h"

@implementation WaiChuDaKaJiLuModel


@end

@implementation YuyinModel

- (void)setYuYinModelWithSM:(DaKaImageSoundSM *)sm{
    self.attdid = sm.attdid;
    self.attdresid = sm.attdresid;
    self.resname = sm.resname;
    self.resurl = sm.resurl;
    self.restype = sm.restype;
    self.spendtime = sm.spendtime;
    self.sortnum = sm.sortnum;
}

@end
@implementation TupianModel
- (void)setTuPianModelWithSM:(DaKaImageSoundSM *)sm{
    self.attdid = sm.attdid;
    self.attdresid = sm.attdresid;
    self.resname = sm.resname;
    self.resurl = sm.resurl;
    self.restype = sm.restype;
    self.sortnum = sm.sortnum;
    self.bigImgUrl = sm.bigImgUrl;
}
@end