//
//  RenWuSheZhiViewController.m
//  Zipingguo
//
//  Created by 韩飞 on 15/10/12.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "RenWuSheZhiViewController.h"
#import "RenWuSheZhiTableViewCell.h"
#import "RenWuSheZhiModel.h"
#import "RenWuServiceShell.h"
@interface RenWuSheZhiViewController ()
{
    NSMutableArray *dataArray;
    NSString *name;
}
@end

@implementation RenWuSheZhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self addItemWithTitle:@"确定" imageName:@"" selector:@selector(queDingButtonClick) location:NO];

    self.title = self.vcTitle;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    sheZhiTableView.tableFooterView = footerView;
    
    dataArray = [[NSMutableArray alloc] initWithCapacity:6];
    if ([self.vcTitle isEqualToString:@"提醒"]) {
        NSArray *array = @[@"不提醒",@"准时提醒",@"提前5分钟",@"提前30分钟",@"提前1小时",@"提前2小时"];
        for (int i=0; i<array.count; i++) {
            RenWuSheZhiModel *model = [[RenWuSheZhiModel alloc] init];
            model.cellState = [self.valueName isEqualToString:array[i]];
            model.cellName = array[i];
            [dataArray addObject:model];
        }
    }else{
        NSArray *array = @[@"普通",@"重要"];
        for (int i=0; i<array.count; i++) {
            RenWuSheZhiModel *model = [[RenWuSheZhiModel alloc] init];
            model.cellState = [self.valueName isEqualToString:array[i]];
            model.cellName = array[i];
            [dataArray addObject:model];
        }
    }
    [sheZhiTableView setSeparatorColor:Fenge_Color];
    if ([sheZhiTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [sheZhiTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([sheZhiTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [sheZhiTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    sheZhiTableView.backgroundColor = RGBACOLOR(248, 248, 248, 1);
    name = self.valueName;
}
- (void)queDingButtonClick
{
    if (self.subTitle) {
        self.subTitle(name);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - UITableViewDelegate
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    UIEdgeInsets edgeInset = UIEdgeInsetsZero;
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:edgeInset];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:edgeInset];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"cell";
    RenWuSheZhiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[RenWuSheZhiTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    [cell bindData:dataArray[indexPath.row]];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (RenWuSheZhiModel *model in dataArray) {
        model.cellState = NO;
    }
    RenWuSheZhiModel *model = dataArray[indexPath.row];
    model.cellState = YES;
    name = model.cellName;
    [sheZhiTableView reloadData];
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

@end
