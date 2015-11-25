//
//  SouSuoViewController.m
//  Zipingguo
//
//  Created by lilufeng on 15/10/9.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "SouSuoBaoGaoViewController.h"

@interface SouSuoBaoGaoViewController ()
{

    UIButton *_currentBtn;

}
@end

@implementation SouSuoBaoGaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_mScrollView setContentSize:CGSizeMake(ScreenWidth *3 , 0)];
    _currentBtn = _ribaoBtn;
    _mSearchBar.barTintColor = RGBACOLOR(40, 41, 52, 1);
    _mSearchBar.showsCancelButton = YES;
    [_mSearchBar becomeFirstResponder];
    
}
-(void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    _topView.frame = CGRectMake(0, 0, ScreenWidth, 64);
    _xuanzeView.frame = CGRectMake(0, _topView.height, ScreenWidth, 40);
    _mScrollView.frame = CGRectMake(0, CGRectGetMaxY(_xuanzeView.frame), ScreenWidth , ScreenHeight - CGRectGetMaxY(_xuanzeView.frame));
    _ribaoTableView.frame  = CGRectMake(0, 0, ScreenWidth , _mScrollView.height);
    _zhoubaoTableView.frame  = CGRectMake(ScreenWidth,0, ScreenWidth , _mScrollView.height);
    _yuebaoTableView.frame  = CGRectMake(ScreenWidth * 2,0, ScreenWidth , _mScrollView.height);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 顶部日报 周报 月报button点击
-(void)btnClick:(UIButton *)sender{
    _currentBtn.selected = NO;
    sender.selected = YES;
    _currentBtn = sender;
//    [self reloadTableView];
    
    [UIView animateWithDuration:0.2 animations:^{
//        _lineLabel.frame = CGRectMake(sender.x, _lineLabel.y, _lineLabel.width, _lineLabel.height);
        
        
        _lineLabel.center = CGPointMake(sender.center.x, 39);
        _mScrollView.contentOffset = CGPointMake(ScreenWidth * (sender.tag - 10), 0);
        
    }];
    
    
}
#pragma mark - search bar delegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{

    [self dismissViewControllerAnimated:YES completion:nil];
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{

//    searchBar.showsCancelButton = YES;
    return YES;
}
@end
