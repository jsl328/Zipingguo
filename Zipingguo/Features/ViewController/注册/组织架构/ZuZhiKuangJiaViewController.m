//
//  ZuZhiKuangJiaViewController.m
//  Zipingguo
//
//  Created by 韩飞 on 15/11/11.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "ZuZhiKuangJiaViewController.h"
#import "IQKeyboardManager.h"
#import "ZuZhiJieGouModel.h"
#import "ZuZhiJieGouTableViewCell.h"
#import "YaoqingViewController.h"
#import "EditZuZhiViewController.h"
#import "RenWuToolView.h"
#import "XuanZeCengJiViewController.h"

@interface ZuZhiKuangJiaViewController ()<UITableViewDataSource,UITableViewDelegate,ZuZhiJieGouTableViewCellDelegate,UITextFieldDelegate>
{
    __weak IBOutlet UITableView *myTableView;
    NSMutableArray *items;
    NSMutableArray *dataArray;
    FXBlurView *blurView;
    RenWuToolView *toolView;
    NSString *newCengJiName;
    XuanZeCengJiViewController *selectCengJiVC;
}
@end

@implementation ZuZhiKuangJiaViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IOSDEVICE) {
        [self setAutomaticallyAdjustsScrollViewInsets:YES];
        [self setExtendedLayoutIncludesOpaqueBars:YES];
    }
    
    self.backbtn.hidden = YES;
    
    [self setNavRightButton];
    
    [myTableView setSeparatorColor:Fenge_Color];
    if ([myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    items = [[NSMutableArray alloc] init];
    dataArray = [[NSMutableArray alloc] init];
    NSArray *array = @[@"人事部",@"财务部",@"行政部",@"销售部",@"业务部"];
    for (int  i = 0;i<array.count;i++){
        ZuZhiJieGouModel *model = [[ZuZhiJieGouModel alloc] init];
        model.name = array[i];
        model.tag = i+1;
        [items addObject:model];
    }
    [self getDataArrayAndRefreshTableView];
    [self setViewBlur];
}
// 设置模糊背景
- (void)setViewBlur{
    if (!blurView) {
        blurView = [[FXBlurView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
//        [blurView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissBgView)]];
        [blurView setDynamic:YES];
        blurView.blurRadius = 8;
        blurView.tintColor = [UIColor clearColor];
        [ShareApp.window addSubview:blurView];
        blurView.hidden = YES;
        toolView = [[RenWuToolView alloc] init];
        toolView.renWuTF.delegate = self;
        toolView.renWuTF.placeholder = @"请输入层级名称";
        [blurView addSubview:toolView];
        toolView.frame = CGRectMake(0, self.view.height, ScreenWidth, toolView.height);
        toolView.backgroundColor = [UIColor redColor];
        [toolView.toolButton addTarget:self action:@selector(toolButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        selectCengJiVC = [[XuanZeCengJiViewController alloc] init];
        __block XuanZeCengJiViewController *blvc = selectCengJiVC;
        selectCengJiVC.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        selectCengJiVC.view.hidden = YES;
        __block ZuZhiKuangJiaViewController *blSelf = self;
        __block RenWuToolView *blToolView = toolView;
        selectCengJiVC.quXiaoBlock = ^(){
            blvc.view.hidden = YES;
            blSelf.blurView.hidden = NO;
            [blToolView.renWuTF becomeFirstResponder];
        };
        selectCengJiVC.finishBlock = ^(NSString *preName){
            blvc.view.hidden = YES;
            [blSelf disMissBgView];
            [blSelf addNewCengJiWithPrename:preName];
        };
        [ShareApp.window addSubview:selectCengJiVC.view];
    }
}

- (void)addNewCengJiWithPrename:(NSString *)preName{
    if (!preName) {
        ZuZhiJieGouModel *sm = [[ZuZhiJieGouModel alloc] init];
        sm.name = [newCengJiName copy];
        sm.cengJi = 0;
        [items addObject:sm];
    }else{
        for (ZuZhiJieGouModel *model in dataArray) {
            if ([model.name isEqualToString:preName]) {
                ZuZhiJieGouModel *sm = [[ZuZhiJieGouModel alloc] init];
                sm.name = [newCengJiName copy];
                sm.cengJi = model.cengJi+1;
                sm.preModel = model;
                [model.children addObject:sm];
            }
        }
    }
    [self getDataArrayAndRefreshTableView];
}

- (void)toolButtonClick:(UIButton *)btn{
    if ([toolView.renWuTF.text length]){
        selectCengJiVC.view.hidden = NO;
        selectCengJiVC.dataArray = dataArray;
        [selectCengJiVC reloadData];
        newCengJiName = toolView.renWuTF.text;
    }else{
        blurView.hidden = YES;
    }
    [toolView.renWuTF resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self toolButtonClick:nil];
    return NO;
}
- (void)getDataArrayAndRefreshTableView{
    [dataArray removeAllObjects];
    for (ZuZhiJieGouModel *mo in items) {
        
        [dataArray addObjectsFromArray:[self getObjectWithModel:mo]];
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
    ZuZhiJieGouTableViewCell *cell = [ZuZhiJieGouTableViewCell cellWithtableView:myTableView withCellName:@"cell1"];
    ZuZhiJieGouModel *model = dataArray[indexPath.row];
    cell.delegate = self;
    [cell bindDataWith:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)zheDieButtonClick:(ZuZhiJieGouModel *)model isClose:(BOOL)close{
    if (close) {
        model.children = [model.tempChildren copy];
        model.tempChildren = nil;
    }else{
        model.tempChildren = [model.children copy];
        model.children = nil;
    }
    [self getDataArrayAndRefreshTableView];
}

- (void)editButtonClick{
    EditZuZhiViewController *vc = [[EditZuZhiViewController alloc] init];
    vc.items = items;
    vc.editFinish = ^(){
        [self getDataArrayAndRefreshTableView];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)addNewButton:(UIButton *)sender {
    blurView.hidden = NO;
    [toolView.renWuTF becomeFirstResponder];
    
}

- (void)nextButtonClick{
    NSMutableArray *deptArray = [@[] mutableCopy];
     for (ZuZhiJieGouModel *model in dataArray) {
         if (model.isDelete) {
             break;
         }
        FirstCreateDeptSM *deptSM = [[FirstCreateDeptSM alloc] init];
        deptSM.companyid = [AppStore getGongsiID];
        deptSM.name = model.name;
        if (model.preModel) {
            deptSM.parid = model.preModel.name;
        }else
            deptSM.parid = @"0";
        [deptArray addObject:deptSM];
    }
    [LDialog showWaitBox:@"创建组织架构中"];
    [ZhuceServiceShell getFirstCreateDeptWithFirstCreateDeptSM:deptArray UsingCallback:^(DCServiceContext *context, ResultMode *sm) {
        [LDialog closeWaitBox];
        if (!context.isSucceeded) {
            return ;
        }
        if (sm.status == 0) {
            YaoqingViewController *yaoqingVC = [[YaoqingViewController alloc] init];
            yaoqingVC.isDenglu = self.isDenglu;
            [self.navigationController pushViewController:yaoqingVC animated:YES];
        }
    }];
}
- (void)setNavRightButton{
    // 下一步按钮
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setFrame:CGRectMake(0,0,50,18)];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    if (!self.isDenglu) {
        [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }else{
        [nextButton setTitleColor:DCColorFromRGB(4, 175, 245) forState:UIControlStateNormal];
    }
    nextButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
    
    // 编辑按钮
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton setFrame:CGRectMake(0,0,40,18)];
    if (!self.isDenglu) {
        [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }else{
        [editButton setTitleColor:DCColorFromRGB(4, 175, 245) forState:UIControlStateNormal];
    }
    editButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [editButton addTarget:self action:@selector(editButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    /*
    // 空白按钮
    UIButton *spaceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    spaceButton.userInteractionEnabled = NO;
    [spaceButton setFrame:CGRectMake(0,0,0,18)];
    [spaceButton setTitleColor:DCColorFromRGB(4, 175, 245) forState:UIControlStateNormal];
    spaceButton.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithCustomView:spaceButton];
    NSArray *itemArray = @[nextItem,spaceItem,editItem];
    self.navigationItem.rightBarButtonItems = itemArray;
    */
    self.navigationItem.rightBarButtonItem = nextItem;
    self.navigationItem.leftBarButtonItem = editItem;
}
- (void)textFieldDidChange:(NSNotification *)noti
{
    if ([toolView.renWuTF.text length]) {
        [toolView.toolButton setImage:[UIImage imageNamed:@"快捷任务-创建"] forState:UIControlStateNormal];
    }else{
        
        [toolView.toolButton setImage:[UIImage imageNamed:@"快捷任务-取消"] forState:UIControlStateNormal];
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([toolView.renWuTF.text length]) {
        [toolView.toolButton setImage:[UIImage imageNamed:@"快捷任务-创建"] forState:UIControlStateNormal];
    }else{
        
        [toolView.toolButton setImage:[UIImage imageNamed:@"快捷任务-取消"] forState:UIControlStateNormal];
    }
}
// 点击模糊的背景消失
- (void)disMissBgView {
    blurView.hidden = YES;
    toolView.renWuTF.text = nil;
    [toolView.renWuTF resignFirstResponder];
}

// 显示
- (void)keyboardWasShown:(NSNotification *)noti{
    NSDictionary* info = [noti userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    float d = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:d animations:^{
        toolView.frame = CGRectMake(0, ScreenHeight-kbSize.height-toolView.height, self.view.width, toolView.height);
    }completion:^(BOOL finished) {
        NSLog(@"%@",NSStringFromCGRect(toolView.frame));
    }];
}
// 隐藏
- (void)keyboardWillBeHidden:(NSNotification *)noti{
    NSDictionary* info = [noti userInfo];
    float d = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:d animations:^{
        toolView.frame = CGRectMake(0, self.view.height, ScreenWidth, toolView.height);
    } completion:^(BOOL finished) {
        NSLog(@"%@",NSStringFromCGRect(toolView.frame));
    }];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChange:)
                                                 name:UITextFieldTextDidChangeNotification object:toolView.renWuTF];
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


- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if ([myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
