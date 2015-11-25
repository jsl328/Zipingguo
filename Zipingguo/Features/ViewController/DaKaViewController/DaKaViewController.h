//
//  DaKaViewController.h
//  Zipingguo
//
//  Created by sunny on 15/9/24.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "ParentsViewController.h"
#import "JZScrollView.h"
#import "UIPlaceHolderTextView.h"


typedef NS_ENUM(NSInteger,DaKaType) {
    DaKaTypeNone = 0,
    DaKaTypeChangGui,
    DaKaTypeWaiChu
};

@interface DaKaViewController : ParentsViewController{
    
    IBOutlet JZScrollView *changGuiScrollView;
    
    IBOutlet UIView *headerBgView;
    // 顶部view
    IBOutlet UIView *headerView;
    // 时间view
    IBOutlet UIView *timeView;
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *riQiLabel;
    IBOutlet UIView *jiLuHeaderView;
    
    // 底部打卡view
    __weak IBOutlet UIView *bottomView;
    IBOutlet UIButton *daKaButton;
    IBOutlet UIImageView *bgImageView;
    
    /// 外出View
    IBOutlet UIView *waiChuView;
    IBOutlet UIPlaceHolderTextView *shuRuTextView;
    
    // 录音view
    IBOutlet UIView *yuYinView;
    IBOutlet UIButton *luYinButton;
    IBOutlet UIButton *luYinCloseButton;
    
    //  toolView
    IBOutlet UIView *toolView;
    IBOutlet UIButton *yuYinBtn;
    IBOutlet UIButton *tuPianBtn;
    IBOutlet UIButton *weiZhiBtn;
    IBOutlet JZScrollView *waiChuBottomScrollView;
    
}

@end
