//
//  EditZuZhiViewController.m
//  Zipingguo
//
//  Created by 韩飞 on 15/11/11.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "EditZuZhiViewController.h"
#import "ZuZhiJieGouModel.h"
#import "ZuZhiJieGouTableViewCell.h"

@interface EditZuZhiViewController ()<UITableViewDataSource,UITableViewDelegate,ZuZhiJieGouTableViewCellDelegate>
{
    __weak IBOutlet UITableView *myTableView;
    NSMutableArray *dataArray;
    ZuZhiJieGouModel *deleteModel;
}
@end

@implementation EditZuZhiViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;// 默认不显示工具条、[super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;// 默认不显示工具条
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        dataArray = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (IOSDEVICE) {
        [self setAutomaticallyAdjustsScrollViewInsets:YES];
        [self setExtendedLayoutIncludesOpaqueBars:YES];
    }
    [myTableView setSeparatorColor:Fenge_Color];
    if ([myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self setFinishButton];
    [self getDataArrayAndRefreshTableView];
    [myTableView reloadData];

}
- (void)backClick{
    if (self.editFinish) {
        self.editFinish();
    }
}
- (void)getDataArrayAndRefreshTableView{
    [dataArray removeAllObjects];
    for (ZuZhiJieGouModel *mo in _items) {
        [dataArray addObjectsFromArray:[self getObjectWithModel:mo]];
    }
}
- (NSArray *)getObjectWithModel:(ZuZhiJieGouModel *)model{
    NSMutableArray *marray = [[NSMutableArray alloc] init];
    model.canDelete = !model.tag;
    model.isEditing = YES;
    [marray addObject:model];
    if (model.children.count!=0) {
        for (ZuZhiJieGouModel *mo in model.children) {
            [marray addObjectsFromArray:[self getObjectWithModel:mo]];
        }
    }
    return marray;
}
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
    ZuZhiJieGouTableViewCell *cell = [ZuZhiJieGouTableViewCell cellWithtableView:myTableView withCellName:@"cell2"];
    ZuZhiJieGouModel *model = dataArray[indexPath.row];
    cell.delegate = self;
    [cell bindDataWith:model];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)deleteButtonClick:(ZuZhiJieGouModel *)model{
    model.isDelete = YES;
    [dataArray removeObject:model];
    [myTableView reloadData];
}
- (void)finishButtonClick{
    [self getDataArrayAndRefreshTableView];
    for (ZuZhiJieGouModel *model in dataArray) {
        if (model.isDelete) {
            [model.preModel.children removeObject:model];
        }
    }
    if (self.editFinish) {
        self.editFinish();
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setFinishButton{
    // 空白按钮
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [finishButton setFrame:CGRectMake(0,0,40,18)];
    [finishButton setTitleColor:DCColorFromRGB(4, 175, 245) forState:UIControlStateNormal];
    finishButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [finishButton addTarget:self action:@selector(finishButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithCustomView:finishButton];
    self.navigationItem.rightBarButtonItem = finishItem;
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
