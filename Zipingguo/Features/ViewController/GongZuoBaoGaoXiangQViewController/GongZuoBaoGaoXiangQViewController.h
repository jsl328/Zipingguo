//
//  GongZuoBaoGaoXiangQViewController.h
//  Zipingguo
//
//  Created by lilufeng on 15/10/10.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "ParentsViewController.h"
#import "UIPlaceHolderTextView.h"


@interface GongZuoBaoGaoXiangQViewController : ParentsViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIView *huiFuView;
- (IBAction)aiTeClick:(UIButton *)sender;
//@property (weak, nonatomic) IBOutlet UITextField *huiFuTextField;
- (IBAction)faSongClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *faSongBtn;

@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *huifuTextView;

@property (copy, nonatomic) NSString * baogaoId;
@property (nonatomic) int leixing;//1-日报 2-周报 3-月报

@property (nonatomic, assign) BOOL isRead;//是否已读未读

@end

