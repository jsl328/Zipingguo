//
//  XuanZeCengJiViewController.m
//  Zipingguo
//
//  Created by 韩飞 on 15/11/12.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "XuanZeCengJiViewController.h"
#import "ZuZhiJieGouModel.h"
#import "ZuZhiJieGouTableViewCell.h"

@interface XuanZeCengJiViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *selectName;
    __weak IBOutlet UITableView *myTableView;
    NSMutableArray *tempArray;
}
@end

@implementation XuanZeCengJiViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [myTableView setSeparatorColor:Fenge_Color];
    if ([myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    for (ZuZhiJieGouModel *model in _dataArray) {
        model.isShowIcon = NO;
    }
    [myTableView reloadData];
    
}
- (void)loadCengJiJieGouData{
    tempArray = [[NSMutableArray alloc] init];
    [ServiceShell getCompanyDeptsListWithCompanyid:[AppStore getGongsiID] usingCallback:^(DCServiceContext *serviceContext, ResultModelOfCompanyDeptsSM *companyDeptsSM){
        for (CompanyDeptsSM *deptsSM in companyDeptsSM.data) {
            ZuZhiJieGouModel *model = [[ZuZhiJieGouModel alloc] init];
            model.name = deptsSM.name;
            model.jieGouID = deptsSM._id;
            model.parentID = deptsSM.parid;
            [tempArray addObject:model];
        }
        [self sortItemsWithArray:tempArray];
    }];
}
- (void)sortItemsWithArray:(NSMutableArray *)array{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (int i= (int)array.count-1;i>=0 ;i--){
        ZuZhiJieGouModel*mm = array[i];
        if ([mm.parentID isEqualToString:@"0"]) {
            mm.cengJi = 0;
            [items addObject:mm];
        }
    }
    for (ZuZhiJieGouModel *model in items) {
        [self getSonItemWithModel:model];
    }
    [self getDataArrayAndRefreshTableViewWithItems:items];
}
- (void)getSonItemWithModel:(ZuZhiJieGouModel *)model{
    for (int i= (int)tempArray.count-1;i>=0 ;i--){
        ZuZhiJieGouModel*mm = tempArray[i];
        if ([mm.parentID isEqualToString:model.jieGouID]) {
            mm.cengJi = model.cengJi + 1;
            mm.preModel = model;
            [model.children addObject:mm];
            [self getSonItemWithModel:mm];
        }
    }
}
- (void)getDataArrayAndRefreshTableViewWithItems:(NSMutableArray *)items{
    [_dataArray removeAllObjects];
    for (ZuZhiJieGouModel *mo in items) {
        [_dataArray addObjectsFromArray:[self getObjectWithModel:mo]];
    }
    [myTableView reloadData];
}
- (NSArray *)getObjectWithModel:(ZuZhiJieGouModel *)model{
    NSMutableArray *marray = [[NSMutableArray alloc] init];
    model.odlName = model.name;
    model.isEditing = NO;
    model.canDelete = !model.tag;
    [marray addObject:model];
    if (model.children.count!=0) {
        for (ZuZhiJieGouModel *mo in model.children) {
            [marray addObjectsFromArray:[self getObjectWithModel:mo]];
        }
    }
    return marray;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZuZhiJieGouTableViewCell *cell = [ZuZhiJieGouTableViewCell cellWithtableView:myTableView withCellName:@"cell3"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ZuZhiJieGouModel *model = self.dataArray[indexPath.row];
    [cell bindSelectCengJiData:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZuZhiJieGouModel *model = self.dataArray[indexPath.row];
    for (ZuZhiJieGouModel *m in self.dataArray) {
        if (m!=model) {
            m.isShowIcon = NO;
        }else{
            m.isShowIcon = !m.isShowIcon;
            if (m.isShowIcon) {
                selectName = model.name;
            }else{
                selectName = nil;
            }
        }
    }
    [myTableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (IBAction)finishButtonClick:(id)sender {
    ZuZhiJieGouModel *model;
    for (ZuZhiJieGouModel *m in self.dataArray) {
        if (m.isShowIcon) {
            model = m;
        }
    }
    if (self.finishBlock) {
        self.finishBlock(selectName);
    }
    if (self.passValueFromXuanze) {
        self.passValueFromXuanze(model.name,model.jieGouID);
    }
}
- (IBAction)fanHuiButtonClick:(UIButton *)sender {
    if (self.quXiaoBlock) {
        self.quXiaoBlock();
    }
}
- (void)reloadData{
    [myTableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if ([myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTableView setLayoutMargins:UIEdgeInsetsZero];
    }
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
