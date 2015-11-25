//
//  WaiChuDaKaCell.h
//  Zipingguo
//
//  Created by sunny on 15/10/26.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaiChuDaKaJiLuModel.h"
#import "YuyinView.h"
#import "TupianView.h"

typedef void(^BoFangYuYin)(YuyinView *yuYinView);

typedef void(^ChaKanPhotos)(int,NSArray *);

@interface WaiChuDaKaJiLuCell : UITableViewCell{
    IBOutlet UILabel *diZhiLabel;
    IBOutlet UILabel *contentLabel;
}

+ (WaiChuDaKaJiLuCell *)cellForTableView:(UITableView *)tableView;

@property (nonatomic,strong)WaiChuDaKaJiLuModel *model;
@property (nonatomic,assign) float cellHeight;

@property (nonatomic,strong) BoFangYuYin boFangYuYinClick;
@property (nonatomic,strong) ChaKanPhotos chaKanPhotos;
@end
