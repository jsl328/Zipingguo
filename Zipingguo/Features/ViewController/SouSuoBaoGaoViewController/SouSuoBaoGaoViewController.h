//
//  SouSuoViewController.h
//  Zipingguo
//
//  Created by lilufeng on 15/10/9.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SouSuoBaoGaoViewController : UIViewController<UISearchBarDelegate>



@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UISearchBar *mSearchBar;

@property (weak, nonatomic) IBOutlet UIView *xuanzeView;

@property (weak, nonatomic) IBOutlet UIButton *ribaoBtn;
@property (weak, nonatomic) IBOutlet UIButton *zhoubaoBtn;
@property (weak, nonatomic) IBOutlet UIButton *yuebaoBtn;

- (IBAction)btnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UITableView *ribaoTableView;

@property (weak, nonatomic) IBOutlet UITableView *zhoubaoTableView;
@property (weak, nonatomic) IBOutlet UITableView *yuebaoTableView;

@end
