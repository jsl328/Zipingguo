//
//  ZiXunXiangQingViewController.h
//  Zipingguo
//
//  Created by sunny on 15/10/12.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "ParentsViewController.h"
#import "ZiXunCellModel.h"

typedef void(^actionClick)(NSString *actionName);
@interface ZiXunXiangQingViewController : ParentsViewController
{
    IBOutlet UIScrollView *bgScrollView;
    IBOutlet UIView *topView;
    IBOutlet UILabel *titleNameLabel;
    IBOutlet UILabel *detailLabel;
    IBOutlet UIImageView *lineImageView;
    
    IBOutlet UIWebView *contentWebView;
    
    IBOutlet UIView *midView;
    IBOutlet UILabel *tipLabel;
    
    IBOutlet UIView *bottomView;
    IBOutlet UIButton *shouCangBtn;
    IBOutlet UIButton *fenXiangBtn;
    IBOutlet UIButton *pingLunBtn;
    IBOutlet UIButton *dianZanBtn;
}

/// 上个页面是从第几个tableView跳转过来的 --- 回调刷新对应界面
//@property (nonatomic,assign) int currentIndex;
@property (nonatomic,strong) ZiXunCellModel *ziXunCellModel;
@property (nonatomic,copy) NSString *ziXunID;
@property (nonatomic,copy) NSString *fenXiangImage;

@property (nonatomic,strong) actionClick actionCallback;
@end
