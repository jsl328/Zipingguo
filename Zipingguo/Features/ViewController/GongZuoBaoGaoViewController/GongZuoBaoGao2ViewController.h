//
//  GongZuoBaoGao2ViewController.h
//  Zipingguo
//
//  Created by lilufeng on 15/10/9.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "ParentsViewController.h"

@interface GongZuoBaoGao2ViewController : ParentsViewController<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
//@property (weak, nonatomic) IBOutlet UITableView *tijiaowoTableView;


@property (weak, nonatomic) IBOutlet UIView *xuanzeView;

@property (weak, nonatomic) IBOutlet UIButton *ribaoBtn;
@property (weak, nonatomic) IBOutlet UIButton *zhoubaoBtn;
@property (weak, nonatomic) IBOutlet UIButton *yuebaoBtn;

- (IBAction)btnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@end
