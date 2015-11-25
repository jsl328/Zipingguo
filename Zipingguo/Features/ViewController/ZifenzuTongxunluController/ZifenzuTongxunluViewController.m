//
//  ZifenzuTongxunluViewController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/9/12.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ZifenzuTongxunluViewController.h"
#import "TongxunluModel.h"
#import "TongxunluViewCell.h"
#import "LianXiRenXiangQingViewController.h"
@interface ZifenzuTongxunluViewController ()<TongxunluModelDelegate>
{
    //原始数据源
    NSMutableArray *_dataArray;
    //用于存放搜索结果
    NSMutableArray *_resultArray;
    //搜索条(普通视图控件)
    UISearchBar  *_searchBar;
    //搜索控制器(用于开启搜索模式，并呈现搜索结果)
    UISearchDisplayController *_displayController;
}
@end

@implementation ZifenzuTongxunluViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IOSDEVICE) {
        [self setAutomaticallyAdjustsScrollViewInsets:YES];
        [self setExtendedLayoutIncludesOpaqueBars:YES];
    }
    
    self.navigationItem.title = self.Title;
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self loadData];
    
}

#pragma mark 布局

- (void)initUI{
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    _tableView.tableHeaderView = _searchBar;
    _searchBar.placeholder = @"请输入搜索关键词";
    //创建搜索控制器
    _displayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    //为搜索控制器中tableView设置数据源和代理
    _displayController.searchResultsDelegate = self;
    _displayController.searchResultsDataSource = self;
}

#pragma mark 填充数据

- (void)loadData{
    _dataArray = [[NSMutableArray alloc] init];
    _resultArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *yonghuArray = [YonghuStores getAllWithGongsiID:[AppStore getGongsiID] Deptid:_ID];
    
    for (YonghuInfoDB *infodb in yonghuArray) {
        TongxunluModel *model = [[TongxunluModel alloc] init];
        model.personsSM = infodb;
        [_dataArray addObject:model];
    }
    
    [_tableView reloadData];
    
    /*
    [ServiceShell getDeptPersonsWithID:_ID usingCallback:^(DCServiceContext *serviceContext, ResultModelOfDeptPersonsSM *deptpersonsSM) {
        for (DeptPersonsSM *personsSM in deptpersonsSM.data) {
            
            TongxunluModel *model = [[TongxunluModel alloc] init];
            model.personsSM = personsSM;
            [_dataArray addObject:model];
        }
        [_tableView reloadData];
    }];
    */
    
}

#pragma mark - table View delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     //自动反选
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TongxunluModel *model;
    if (tableView != _tableView) {
        model = [_resultArray objectAtIndex:indexPath.row];
        
    }else{
        
        model = [_dataArray objectAtIndex:indexPath.row];
    }
    NSLog(@"第%d分区,第%d行被选中",indexPath.section,indexPath.row);
    LianXiRenXiangQingViewController *lianXiRenVC = [[LianXiRenXiangQingViewController alloc] init];
    lianXiRenVC.ID = model.personsSM.userid;
    [self.navigationController pushViewController:lianXiRenVC animated:YES];
}

#pragma mark - table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //可以通过传递过来的tableView参数来判断，到底是通过哪个tableView调用的此方法
    return 1;
    
}

//重写两个dataSource方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView!=_tableView) {
        //收集搜索结果,收集完成后 返回搜索结果的数目
        //搜索之前，先清除旧的搜索结果
        [_resultArray removeAllObjects];
        //根据用户在搜索框中输入的关键字，从_dataArray中筛选包含关键字的字符串,放入_resultArray中
        //_searchBar.text 能够拿到用户在搜索框中输入的文字
        for (TongxunluModel *model in _dataArray) {
            NSRange range = [model.personsSM.name rangeOfString:_searchBar.text];
            if (range.location!=NSNotFound) {
                //str符合搜索结果
                [_resultArray addObject:model];
            }
        }
        return [_resultArray count];
    }else{
        return [_dataArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TongxunluViewCell *tongxunluCell = [TongxunluViewCell cellForTableView:tableView];
    TongxunluModel *model;
    
    if (tableView != _tableView) {
        model = [_resultArray objectAtIndex:indexPath.row];
        tongxunluCell.model = model;
    }else{
       model = [_dataArray objectAtIndex:indexPath.row];
        tongxunluCell.model = model;
    }
    model.delegate = self;
    return tongxunluCell;
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (IOSDEVICE) {
        _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }else{
        _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavHeight);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AllDelegate
-(void)callNumber:(TongxunluModel *)model
{
    NSLog(@"打电话");
    NSString *telUrl = [NSString stringWithFormat:@"tel:%@",model.personsSM.phone];
    NSURL *url = [[NSURL alloc] initWithString:telUrl];
    [[UIApplication sharedApplication] openURL:url];
}

-(void)chatMessage:(TongxunluModel *)model
{
    NSLog(@"发起聊天");
//    NSMutableArray *_xuanzhongArray = [[NSMutableArray alloc] init];
//    [_xuanzhongArray addObject:model];
    ChatViewController *chatView =[[ChatViewController alloc]initWithChatter:[model.personsSM.userid substringToIndex:20] isGroup:NO];
    chatView.name = model.personsSM.name;
    chatView.Renyuanid = model.personsSM.userid;
    chatView.phonto = model.personsSM.imgurl;
    [self.navigationController pushViewController:chatView animated:YES];
}

-(void)smsMessage:(TongxunluModel *)model
{
    NSLog(@"发送短信消息");
    NSString *telUrl = [NSString stringWithFormat:@"sms://%@",model.personsSM.phone];
    NSURL *url = [[NSURL alloc] initWithString:telUrl];
    [[UIApplication sharedApplication] openURL:url];
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
    
    if (indexPath.row == _dataArray.count - 1) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }else{
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
    
}

@end
