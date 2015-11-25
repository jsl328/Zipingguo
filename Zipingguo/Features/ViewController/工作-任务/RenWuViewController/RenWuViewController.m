//
//  RenWuViewController.m
//  Zipingguo
//
//  Created by 韩飞 on 15/10/9.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "RenWuViewController.h"
#import "RenWuHeaderView.h"
#import "RenWuTableViewCell.h"
#import "RenWuModel.h"
#import "XinJianRenWuViewController.h"
#import "RenWuDetailViewController.h"
#import "FXBlurView.h"
#import "RenWuToolView.h"
#import "RenWuServiceShell.h"
#import "IQKeyboardManager.h"

@interface RenWuViewController ()
{
    FXBlurView *blurView;
    RenWuToolView *toolView;

    NSMutableArray *woDeArray;
    NSMutableArray *fenPeiArray;
    NSInteger currenIndex;
    RenWuHeaderView *daiBanHeader1;
    RenWuHeaderView *daiBanHeader2;
    NSInteger selectIndex;
    BOOL _isLoadMore;//是否加载更多数据，yes-上拉加载，no-下拉刷新；
    
    BOOL showWaitBox;
    
    NSInteger start;
    NSInteger count;
}
@end

@implementation RenWuViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self addSegmentedControlWithLeftTitle:@"我的任务" RightTitle:@"我分配的" selector:@selector(SegmentedControlClicl:)];
    [self addItemWithTitle:@"" imageName:@"RW+icon" selector:@selector(xinJianRenWuClick) location:NO];
    count = 10;
    showWaitBox = YES;
    
    //我的任务下拉刷新
    MJYaMiRefreshHeader *myTableViewheader = [MJYaMiRefreshHeader headerWithRefreshingBlock:^{
        _isLoadMore = NO;
        showWaitBox = YES;
        [self loadYiWeiWanChengTaskListWithType:0];
    }];
    //我分配的下拉刷新
    MJYaMiRefreshHeader *fenpeiTableViewheader = [MJYaMiRefreshHeader headerWithRefreshingBlock:^{
        _isLoadMore = NO;
        showWaitBox = YES;
        [self loadYiWeiWanChengTaskListWithType:1];
    }];
    
    // 隐藏时间
    myTableViewheader.lastUpdatedTimeLabel.hidden = YES;
    fenpeiTableViewheader.lastUpdatedTimeLabel.hidden = YES;
    myTableView.header = myTableViewheader;
    fenPeiTableView.header = fenpeiTableViewheader;
    
    //我的任务上拉加载
    MJYaMiFooter *myTableViewfooter = [MJYaMiFooter footerWithRefreshingBlock:^{
        _isLoadMore = YES;
       [self loadYiWeiWanChengTaskListWithType:0];
    }];
    //我分配的上拉加载
    MJYaMiFooter *feipeiTableViewfooter = [MJYaMiFooter footerWithRefreshingBlock:^{
        _isLoadMore = YES;
       [self loadYiWeiWanChengTaskListWithType:1];
    }];
    myTableView.footer = myTableViewfooter;
    fenPeiTableView.footer = feipeiTableViewfooter;
    
    
    [myTableView setSeparatorColor:[UIColor clearColor]];
    [fenPeiTableView setSeparatorColor:[UIColor clearColor]];
    
    woDeArray = [NSMutableArray alloc].init;
    fenPeiArray = [NSMutableArray alloc].init;
    currenIndex = 0;
    selectIndex = -1;
    [self setViewBlur];
    [self loadYiWeiWanChengTaskListWithType:0];
}
// 设置模糊背景
- (void)setViewBlur{
    if (!blurView) {
        blurView = [[FXBlurView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        [blurView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissBgView)]];
        [blurView setDynamic:YES];
        blurView.blurRadius = 8;
        blurView.tintColor = [UIColor clearColor];
        [ShareApp.window addSubview:blurView];
        blurView.hidden = YES;
        toolView = [[RenWuToolView alloc] init];
        toolView.renWuTF.delegate = self;
        [blurView addSubview:toolView];
        toolView.frame = CGRectMake(0, self.view.height, ScreenWidth, toolView.height);
        toolView.backgroundColor = [UIColor whiteColor];
        [toolView.toolButton addTarget:self action:@selector(toolButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark 加载已未完成的任务

- (void)loadYiWeiWanChengTaskListWithType:(NSInteger)type{
    
    if (type == 0) {
        start = _isLoadMore ? [[woDeArray lastObject] count] : 0;
    }else if (type == 1){
        start = _isLoadMore ? [[fenPeiArray lastObject] count] : 0;
    }
    if (start == 0 && showWaitBox) {
        [LDialog showWaitBox:@"数据加载中"];
    }
    [RenWuServiceShell getMyRenWuListWithcreateid:[AppStore getYongHuID] start:(int)start count:(int)count type:type usingCallback:^(DCServiceContext *context, WoderenwuSM *sm) {
        [LDialog closeWaitBox];
        if (context.isSucceeded) {
            
            if (type == 0) {
                [myTableView.header endRefreshing];//停止刷新
                if (sm.data1.count < count) {//没有更多数据
                    // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                    [myTableView.footer endRefreshingWithNoMoreData];
                }else{
                    [myTableView.footer endRefreshing];//停止加载
                    
                }
                
                if (!_isLoadMore) {//下拉刷新清除数据
                    [woDeArray removeAllObjects];
                }
            }else if(type == 1){
                [fenPeiTableView.header endRefreshing];//停止刷新
                if (sm.data1.count< count) {//没有更多数据
                    // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                    [fenPeiTableView.footer endRefreshingWithNoMoreData];
                }else{
                    [fenPeiTableView.footer endRefreshing];//停止加载
                    
                }
                if (!_isLoadMore) {//下拉刷新清除数据
                    [fenPeiArray removeAllObjects];
                }
                
               
            }
             [self dataModelWithData1:sm.data Data2:sm.data1 isType:type isStart:start];
        }else{
            
        }
    }];
}

-(void)dataModelWithData1:(NSArray *)dataArray1 Data2:(NSArray *)dataArray2 isType:(NSInteger)type isStart:(NSInteger)start1{
    
    if (start1 == 0) {
        NSMutableArray *wArray = [@[] mutableCopy];
        for (RenwuData *data in dataArray1) {
            RenWuModel *model = [[RenWuModel alloc] init];
            if (type == 0) {
                model.isMyRenWu = YES;
            }
            [model bindData:data];
            [wArray addObject:model];
        }
        if (currenIndex == 0) {
            [woDeArray addObject:wArray];
        }else{
            [fenPeiArray addObject:wArray];
        }
    }
    
    NSMutableArray *YArray = [@[] mutableCopy];
    for (RenwuData *data in dataArray2) {
        RenWuModel *model = [[RenWuModel alloc] init];
        if (type == 0) {
            model.isMyRenWu = YES;
        }
        [model bindData:data];
        [YArray addObject:model];
    }
    
    NSMutableArray *tempArray = currenIndex==0?woDeArray:fenPeiArray;
    if (_isLoadMore) {
        [[tempArray lastObject] addObjectsFromArray:YArray];

    }else
        [tempArray addObject:YArray];
    UITableView *tableView = currenIndex==0?myTableView:fenPeiTableView;
    [tableView reloadData];
}

#pragma mark 切换seg
- (void)SegmentedControlClicl:(UISegmentedControl *)seg{
    currenIndex = seg.selectedSegmentIndex;
    if (seg.selectedSegmentIndex==0) {//我的任务
        myTableView.hidden = NO;
        fenPeiTableView.hidden = YES;
        if ([[woDeArray lastObject] count] > 10) {
            showWaitBox = NO;
            _isLoadMore = NO;
            count = [[woDeArray lastObject] count];
        }else{
            showWaitBox = NO;
            _isLoadMore = NO;
            count = 10;
        }
        [self loadYiWeiWanChengTaskListWithType:0];
    }else if (seg.selectedSegmentIndex==1){//我分配的任务
        myTableView.hidden = YES;
        fenPeiTableView.hidden = NO;
        if ([[fenPeiArray lastObject] count] > 10) {
            showWaitBox = NO;
            _isLoadMore = NO;
            count = [[fenPeiArray lastObject] count];
        }else{
            showWaitBox = NO;
            _isLoadMore = NO;
            count = 10;
        }
        [self loadYiWeiWanChengTaskListWithType:1];
    }
    
}

#pragma mark 新建任务
- (void)xinJianRenWuClick{
    NSLog(@"新建");
    XinJianRenWuViewController *vc = [[XinJianRenWuViewController alloc] init];
    vc.passValueFromXinjian = ^(ChuangjianRenwuSM *sm){
        myTableView.hidden = YES;
        fenPeiTableView.hidden = NO;
        self.seg.selectedSegmentIndex = 1;
        currenIndex = 1;
        
        if ([[fenPeiArray lastObject] count] > 10) {
            showWaitBox = NO;
            _isLoadMore = NO;
            count = [[fenPeiArray lastObject] count];
        }else{
            showWaitBox = NO;
            _isLoadMore = NO;
        }
        [self loadYiWeiWanChengTaskListWithType:1];
            
            
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - uitableview

#pragma mark - uitableview
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section==0?@"标记为已完成":@"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (indexPath.section==0)
    return  UITableViewCellEditingStyleDelete;  //返回此值时,Cell会做出响应显示Delete按键,点击Delete后会调用下面的函数,别给传递UITableViewCellEditingStyleDelete参数
    //    return UITableViewCellEditingStyleNone;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *tempArray = currenIndex==0?woDeArray:fenPeiArray;
    RenWuModel *model = tempArray[indexPath.section][indexPath.row];
    selectIndex = indexPath.row;
    if (indexPath.section == 0) {
        [RenWuServiceShell markTaskStateWithID:model.renWuID isFinish:YES usingCallback:^(DCServiceContext *context, ResultMode *sm) {
            if (context.isSucceeded && sm.status == 0) {
                [self showHint:@"该任务已成功标记为已完成" finishCallBack:^{
                    [self finishTask];
                }];
            }else{
                [self showHint:@"修改完成失败"];
            }
            
        }];
    }else{
        [RenWuServiceShell shanChuRenWuWithID:model.renWuID usingCallback:^(DCServiceContext *context, ResultMode *sm){
            if (context.isSucceeded && sm.status == 0) {
                
                [self showHint:@"该任务已成功删除" finishCallBack:^{
                    [[tempArray objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }];
                
            }else{
                [self showHint:@"删除失败"];
            }
        }];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //自动反选
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectIndex = indexPath.row;
    NSMutableArray *tempArray = currenIndex==0?woDeArray:fenPeiArray;
    RenWuModel *model = tempArray[indexPath.section][indexPath.row];
    RenWuDetailViewController *vc = [[RenWuDetailViewController alloc] init];
    vc.isFinish = model.isFinish;
    vc.isMyRenWu = model.isMyRenWu;
    vc.renWuID = model.renWuID;
    
    if (!model.isFinish && !model.isMyRenWu) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DelRenwu:) name:@"indexPath" object:nil];
    }
    
    //更新任务
    vc.updataRenWu = ^(NSString *renWuID){
        if (fenPeiTableView.hidden) {
            currenIndex = 0;
            if ([[woDeArray lastObject] count] > 10) {
                showWaitBox = NO;
                _isLoadMore = NO;
                count = [[woDeArray lastObject] count];
            }else{
                showWaitBox = NO;
                _isLoadMore = NO;
                count = 10;
            }
            [self loadYiWeiWanChengTaskListWithType:0];
        }else if (myTableView.hidden){
            currenIndex = 1;
            if ([[fenPeiArray lastObject] count] > 10) {
                showWaitBox = NO;
                _isLoadMore = NO;
                count = [[fenPeiArray lastObject] count];
            }else{
                showWaitBox = NO;
                _isLoadMore = NO;
                count = 10;
            }
            [self loadYiWeiWanChengTaskListWithType:1];
        }
    };
    //未完成改成已完成
    vc.finishRenWu = ^(NSString *renWuID){
        [self finishTask];
    };
    
    //删除任务
    vc.deleteRenWu = ^(NSString *renWuID){
        [[tempArray objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    };
    vc.indexPath = indexPath;
    [self.navigationController pushViewController:vc animated:YES];
}
// 标记为已完成
- (void)finishTask{
    NSMutableArray *tempArray = currenIndex==0?woDeArray:fenPeiArray;
    RenWuModel *model = tempArray[0][selectIndex];
    model.isFinish = YES;
    NSMutableArray *marray;
    if (tempArray.count==1) {
        marray = [@[model] mutableCopy];
        [tempArray addObject:marray];
    }else{
        NSMutableArray *array = tempArray[1];
        [array addObject:model];
    }
    [tempArray[0]removeObjectAtIndex:selectIndex];
    UITableView *tableView = currenIndex==0?myTableView:fenPeiTableView;
    [tableView reloadData];
}
// 标记为未完成
- (void)noFinishTash{
    NSMutableArray *tempArray = currenIndex==0?woDeArray:fenPeiArray;
    RenWuModel *model = tempArray[1][selectIndex];
    model.isFinish = NO;
    NSMutableArray *marray;
    if (tempArray.count==1) {
        marray = [@[model] mutableCopy];
        [tempArray insertObject:marray atIndex:0];
    }else{
        NSMutableArray *array = tempArray[0];
        [array addObject:model];
    }
    [tempArray[1]removeObjectAtIndex:selectIndex];
    UITableView *tableView = currenIndex==0?myTableView:fenPeiTableView;
    [tableView reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName;
    if (currenIndex==0)
        cellName = @"我的任务";
    else
        cellName = @"分配任务";
    
    RenWuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell)
    {
        cell = [[RenWuTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    NSMutableArray *tempArray = currenIndex==0?woDeArray:fenPeiArray;
    RenWuModel *model = tempArray[indexPath.section][indexPath.row];
    [cell bindDataWithModel:model];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *tempArray = currenIndex==0?woDeArray:fenPeiArray;
    return [tempArray[section] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSMutableArray *tempArray = currenIndex==0?woDeArray:fenPeiArray;
    return tempArray.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    RenWuHeaderView *view = [[RenWuHeaderView alloc] init];
    view.section = section;
    if (section==0) {
        view.addRenWu = ^(){
            [toolView.renWuTF becomeFirstResponder];
        };
    }
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *tempArray = currenIndex==0?woDeArray:fenPeiArray;
    RenWuModel *m = tempArray[indexPath.section][indexPath.row];
    if (m.type==1)
        return 64;
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0)
        return 50;
    return 30;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self toolButtonClick:nil];
    return NO;
}
- (void)toolButtonClick:(UIButton *)sender {
    if ([toolView.renWuTF.text length]) {
        
        ChuangjianRenwuSM *param = [[ChuangjianRenwuSM alloc] init];
        param.title = toolView.renWuTF.text;
        param.type = 2;
        param.createid = [AppStore getYongHuID];
        param.companyid = [AppStore getGongsiID];
        [RenWuServiceShell xinjianrenwuWithCreateid:param usingCallback:^(DCServiceContext*context,TaskBaseSM*sm){
            if (context.isSucceeded) {
                [SDialog showTipViewWithText:sm.msg hideAfterSeconds:1 finishCallBack:^{
                    RenWuModel *model = [[RenWuModel alloc] init];
                    model.renWuName = toolView.renWuTF.text;
                    model.isZhongYao = NO;
                    model.isFinish = NO;
                    model.isMyRenWu = currenIndex == 0 ? YES : NO;
                    model.type = 2;
                    model.renWuID = sm.data._id;
                    [toolView.renWuTF resignFirstResponder];
                    NSMutableArray *tArray;
                    tArray = woDeArray[0];
                    if (tArray.count == 0) {
                        [tArray addObject:model];
                    }else
                        [tArray insertObject:model atIndex:1];
                    if (fenPeiArray.count != 0) {
                        tArray = fenPeiArray[0];
                        if (tArray.count == 0) {
                            [tArray addObject:model];
                        }else
                            [tArray insertObject:model atIndex:1];
                    }
                    
                    if (fenPeiTableView.hidden) {
                        [myTableView reloadData];
                    }else if (myTableView.hidden){
                        [fenPeiTableView reloadData];
                    }
                }];
            }else{
                [SDialog showTipViewWithText:sm.msg hideAfterSeconds:1 finishCallBack:^{
                    
                }];
            }
        }];

    }else{
        [toolView.renWuTF resignFirstResponder];
    }
}

- (void)textFieldDidChange:(NSNotification *)noti
{
    if ([toolView.renWuTF.text length]) {
        [toolView.toolButton setImage:[UIImage imageNamed:@"快捷任务-创建"] forState:UIControlStateNormal];
    }else{
        
        [toolView.toolButton setImage:[UIImage imageNamed:@"快捷任务-取消"] forState:UIControlStateNormal];
    }
}

// 点击模糊的背景消失
- (void)disMissBgView {
    [toolView.renWuTF resignFirstResponder];
}

// 显示
- (void)keyboardWasShown:(NSNotification *)noti{
    blurView.hidden = NO;
    NSDictionary* info = [noti userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    float d = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:d animations:^{
        toolView.frame = CGRectMake(0, self.view.height-kbSize.height-toolView.height+64, self.view.width, toolView.height);
    }completion:^(BOOL finished) {
        
    }];
}
// 隐藏
- (void)keyboardWillBeHidden:(NSNotification *)noti{
    blurView.hidden = YES;
    NSDictionary* info = [noti userInfo];
    float d = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:d animations:^{
        toolView.frame = CGRectMake(0, self.view.height, ScreenWidth, toolView.height);
    } completion:^(BOOL finished) {
        toolView.renWuTF.text = nil;
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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
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

- (void)DelRenwu:(NSNotification *)not{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"indexPath" object:nil];
    UITableView *tableView = currenIndex==0?myTableView:fenPeiTableView;
    NSDictionary *dict = [not userInfo];
    NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
    NSMutableArray *tempArray = currenIndex==0?woDeArray:fenPeiArray;
    [[tempArray objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

@end
