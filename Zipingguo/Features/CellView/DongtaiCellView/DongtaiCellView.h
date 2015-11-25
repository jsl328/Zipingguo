//
//  DongtaiCellView.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/21.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DongtaiModel.h"
#import "WeizhiView.h"
#import "TupianView.h"
#import "YuyinView.h"
#import "ZanPingShanView.h"
#import "ZanView.h"
#import "DongtaiPinglunCellVM.h"
@interface DongtaiCellView : UITableViewCell<YuyinViewDelegate,TupianViewDelegate,ZanPingShanViewDelegate,ListBoxDelegate>
{
    DongtaiModel *_model;
    __weak IBOutlet UIImageView *touxiang;
    __weak IBOutlet UILabel *name;
    __weak IBOutlet UILabel *time;
    __weak IBOutlet UIButton *guanzhuBtn;
    __weak IBOutlet UIButton *quxiaoGuanzhuBtn;
    __weak IBOutlet UILabel *neirong;
    __weak IBOutlet UIView *xinxiView;
    
    __weak IBOutlet ListBox *listBox;
    YuyinView *yuyinView;
    WeizhiView *weizhiView;
    TupianView *tupianView;
    ZanPingShanView *zanpingShanView;
    ZanView *zanpingView;
    
    NSMutableArray *photos;
    NSMutableArray *tupianUrlArray;
    NSMutableArray *tupianArray;
    NSMutableArray *tpArray;
    __weak IBOutlet UIImageView *fengeXian;
    CGSize size1;
    CGSize size;
    
    NSMutableArray *dataArray;
    
    float viewHeight;
    
    NSMutableArray *yuyinViewArray;
    
}
+ (id)cellForTableView:(UITableView *)tableView;

@property (nonatomic, strong) DongtaiModel *model;

@end
