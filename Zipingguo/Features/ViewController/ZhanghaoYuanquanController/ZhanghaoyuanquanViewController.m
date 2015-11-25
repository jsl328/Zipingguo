//
//  ZhanghaoyuanquanViewController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/9/11.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ZhanghaoyuanquanViewController.h"
#import "WodexinxiViewCell.h"
#import "ChongzhiMimaViewController.h"
@interface ZhanghaoyuanquanViewController ()
{
    NSMutableArray *dataArray;
}
@end

@implementation ZhanghaoyuanquanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"账号安全";
    // Do any additional setup after loading the view from its nib.
    dataArray = [[NSMutableArray alloc] initWithObjects:@"重置密码",@"重置手机号码", nil];
}

#pragma mark - tabelviewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChongzhiMimaViewController *chongzhi = [[ChongzhiMimaViewController alloc] init];
    if (indexPath.row == 0) {
        chongzhi.isXiugaiMima = YES;
    }else{
        chongzhi.isXiugaiMima = NO;
    }
    [self.navigationController pushViewController:chongzhi animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"子类必须重写此方法");
    return dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WodexinxiViewCell *cell = [WodexinxiViewCell cellForTableView:tableView];
    cell.name.textColor = RGBACOLOR(53, 55, 68, 1);
    cell.name.text= [dataArray objectAtIndex:indexPath.row];
    cell.neirong.hidden = YES;
    return cell;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, self.view.height);
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
