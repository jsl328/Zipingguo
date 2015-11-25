//
//  GuanyuWomenViewController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/9/12.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "GuanyuWomenViewController.h"
#import "GuanyuWomenHeaderView.h"
#import "WodexinxiViewCell.h"
@interface GuanyuWomenViewController ()
{
    NSMutableArray *dataArray;
}
@end

@implementation GuanyuWomenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于我们";
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    _tableView.scrollEnabled = NO;
    dataArray = [[NSMutableArray alloc] initWithObjects:@"意见反馈",@"版本更新", nil];
}

- (void)initUI{
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    
    GuanyuWomenHeaderView *guanyuwomenHeader = [[GuanyuWomenHeaderView alloc] init];
    guanyuwomenHeader.banben.text = [NSString stringWithFormat:@"版本：%@beta",appVersion];
    guanyuwomenHeader.icon.image = [UIImage imageNamed:@"雅米logo"];
    
    guanyuwomenHeader.frame = CGRectMake(0, 0, ScreenWidth, 190);
   
    _tableView.tableHeaderView = guanyuwomenHeader;
    
    
}

#pragma mark - tabelviewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        YijianFankuiViewController *yijianVC = [[YijianFankuiViewController alloc] init];
        [self.navigationController pushViewController:yijianVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WodexinxiViewCell *cell = [WodexinxiViewCell cellForTableView:tableView];
    cell.name.textColor = RGBACOLOR(53, 55, 68, 1);
    cell.name.text = [dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, 190+100);
    NSLog(@"%f",ScreenHeight);
    _wangzhi.frame = CGRectMake(0, ScreenHeight-16-21-64, ScreenWidth, 21);
    _name.frame = CGRectMake(0, _wangzhi.frame.origin.y-21, ScreenWidth, 21);
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
