//
//  TongzhiViewController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/13.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "TongzhiViewController.h"
#import "XitongTongzhiCellView.h"
#import "XitongTongzhiModel.h"
#import "TidaoWodeModel.h"
#import "TidaoWodeCellView.h"
#import "TongzhiXiangViewController.h"
#import "DongtaiXiangqingViewController.h"
#import "GongZuoBaoGaoXiangQViewController.h"
#import "RenWuDetailViewController.h"
#import "ZiXunPingLunViewController.h"
@interface TongzhiViewController ()<UISearchBarDelegate>
{
    //原始数据源
    NSMutableArray *_dataArray;
    
    NSMutableArray *_tidaoDataArray;
    
    //用于存放搜索结果
    NSMutableArray *_resultArray;
    //搜索条(普通视图控件)
    UISearchBar  *_searchBar;
    //搜索控制器(用于开启搜索模式，并呈现搜索结果)
    UISearchDisplayController *_displayController;
    
    BOOL _isNotice;//系统通知yes 提到我的no
    BOOL _tongzhiLoaded;//系统通知是否加载过，省流量
    BOOL _tidaoWodeLoaded;//提到我的是否加载过，省流量
    
    BOOL _isLoadMore;//是否加载更多数据，yes-上拉加载，no-下拉刷新；
    
}
@end

@implementation TongzhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IOSDEVICE) {
        [self setExtendedLayoutIncludesOpaqueBars:YES];
    }
    
    _isNotice = YES;
    _tongzhiLoaded = NO;
    _tidaoWodeLoaded = NO;
    _isLoadMore = NO;
    
    _dataArray = [@[] mutableCopy];
    _resultArray = [@[] mutableCopy];
    _tidaoDataArray = [@[] mutableCopy];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    _tableView.tableHeaderView = _searchBar;
    _searchBar.placeholder = @"请输入关键词";
    _searchBar.delegate = self;
    //创建搜索控制器
    _displayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    //为搜索控制器中tableView设置数据源和代理
    _displayController.searchResultsDelegate = self;
    _displayController.searchResultsDataSource = self;
    
    [self addSegmentedControlWithLeftTitle:@"系统通知" RightTitle:@"提到我的" selector:@selector(segmentedControlValueChanged:)];
    
    [self loadData];
    // Do any additional setup after loading the view from its nib.
    
    //下拉刷新
    MJYaMiRefreshHeader *header = [MJYaMiRefreshHeader headerWithRefreshingBlock:^{
        _isLoadMore = NO;
        [self loadData];
    }];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    _tableView.header = header;
    
    //上拉加载
    MJYaMiFooter *footer = [MJYaMiFooter footerWithRefreshingBlock:^{
        _isLoadMore = YES;
        [self loadData];
    }];
    _tableView.footer = footer;
    
}

- (void)segmentedControlValueChanged:(UISegmentedControl *)seg{
    if (seg.selectedSegmentIndex == 0) {//系统通知
        _isNotice = YES;
        _tableView.tableHeaderView = _searchBar;
        if (!_tidaoWodeLoaded) {
            [self xitongTongzhi];
        }
        
    }else{//提到我的
        _isNotice = NO;
        _tableView.tableHeaderView = nil;
        if (!_tongzhiLoaded) {
            [self tidaoWode];
        }
    }
    [_tableView reloadData];
}

#pragma mark - 加载数据
-(void)loadData{
    
    if(_isNotice){//系统通知
        [self xitongTongzhi];//默认加载系统通知
        
    }else{
        
        [self tidaoWode];//加载提交我的
    }
    
}

- (void)xitongTongzhi{
    
    NSInteger start;
    start = _isLoadMore ? [_dataArray count] : 0;
    if (start == 0) {
        [LDialog showWaitBox:@"数据加载中"];
    }
    [ServiceShell getNoticeWithCompanyid:[AppStore getGongsiID] Userid:[AppStore getYongHuID] Start:(int)start Count:10 usingCallback:^(DCServiceContext *serviceContext, ResultModelOfIListOfNoticeSM *noticeSM) {
        [LDialog closeWaitBox];
        if (serviceContext.isSucceeded) {
            
            [_tableView.header endRefreshing];//停止刷新
            if (noticeSM.data.count<10) {//没有更多数据
                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                [_tableView.footer endRefreshingWithNoMoreData];
            }else{
                [_tableView.footer endRefreshing];//停止加载
                
            }
            _tidaoWodeLoaded = YES;
            if (!_isLoadMore) {//下拉刷新清除数据
                [_dataArray removeAllObjects];
            }
            [self dataModel:noticeSM.data isTongzhi:YES];
            
        }
        
    }];
    
    
}



- (void)tidaoWode{
    
    NSInteger start;
    start = _isLoadMore ? [_tidaoDataArray count] : 0;
    if (start == 0) {
        [LDialog showWaitBox:@"数据加载中"];
    }
    [ServiceShell getNoticeWithUserid:[AppStore getYongHuID] Start:(int)start Count:10 usingCallback:^(DCServiceContext *serviceContext, ResultModelOfatMeNoticeSM *noticeSM) {
        [LDialog closeWaitBox];
        if (serviceContext.isSucceeded) {
            [_tableView.header endRefreshing];//停止刷新
            if (noticeSM.data.count< 10) {//没有更多数据
                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                [_tableView.footer endRefreshingWithNoMoreData];
            }else{
                [_tableView.footer endRefreshing];//停止加载
                
            }
            _tongzhiLoaded = YES;
            if (!_isLoadMore) {//下拉刷新清除数据
                [_tidaoDataArray removeAllObjects];
            }
            [self dataModel:noticeSM.data isTongzhi:NO];
            
        }
        
    }];
}

-(void)dataModel:(NSArray *)dataArray isTongzhi:(BOOL)tongzhi{
    
    if (tongzhi) {
        for (int i = 0; i < dataArray.count;  i ++) {
            XitongTongzhiModel *model = [[XitongTongzhiModel alloc] init];
            NoticeSM *sm = dataArray[i];
            model.isRead = sm.isRead;
            model.noticeSM = dataArray[i];
            [_dataArray addObject:model];
        }
    }else{
        
        for (int i = 0; i < dataArray.count;  i ++) {
            TidaoWodeModel *model = [[TidaoWodeModel alloc] init];
            model.atMeNoticeSM = dataArray[i];
            [_tidaoDataArray addObject:model];
        }
        
    }
    [_tableView reloadData];
}

#pragma mark - table View delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
} 

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isNotice) {
        XitongTongzhiModel *model = _dataArray[indexPath.row];
        [_dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [ServiceShell getMarkNoticeDelWithUserid:[AppStore getYongHuID] Noticeid:model.noticeSM._id usingCallback:^(DCServiceContext *context, ResultMode *sm) {
            if (!context.isSucceeded) {
                return ;
            }
        }];
    }else{
        TidaoWodeModel * model = _tidaoDataArray[indexPath.row];
        [_tidaoDataArray removeObjectAtIndex:indexPath.row];
//        [_tableView reloadData];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [ServiceShell getAtMeNoticeDelWithcommantatID:model.atMeNoticeSM._id usingCallback:^(DCServiceContext *serviceContext, ResultMode *model) {
            if (!serviceContext.isSucceeded) {
                return ;
            }
        }];
        
    }
    
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 64;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //自动反选
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_isNotice || tableView != _tableView) {
        XitongTongzhiModel *model;
        if (tableView != _tableView) {
            model = [_resultArray objectAtIndex:indexPath.row];
        }else{
            model = [_dataArray objectAtIndex:indexPath.row];
        }
        TongzhiXiangViewController *tongzhiXiangqing = [[TongzhiXiangViewController alloc] init];
        tongzhiXiangqing.isRead = model.isRead;
        if (model.noticeSM.isRead == 0) {
            model.isRead = 1;
            [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        tongzhiXiangqing.passValueFromTongzhixiangqing = ^(NSUInteger row){
            if (tableView != _tableView) {
                [_resultArray removeObjectAtIndex:row];
            }else{
                [_dataArray removeObjectAtIndex:row];
            }
            [_tableView reloadData];
        };
        
        tongzhiXiangqing.tongzhiID = model.noticeSM._id;
        [self.navigationController pushViewController:tongzhiXiangqing animated:YES];
    }else{
        TidaoWodeModel *tidaoWodeModel = [_tidaoDataArray objectAtIndex:indexPath.row];
        
        if (tidaoWodeModel.atMeNoticeSM.moduletype == 1) {
            DongtaiXiangqingViewController *dongtaiXiangqing = [[DongtaiXiangqingViewController alloc] init];
            dongtaiXiangqing.tongzhi = YES;
            dongtaiXiangqing.dongtaiId = tidaoWodeModel.atMeNoticeSM.baseid;
            [self.navigationController pushViewController:dongtaiXiangqing animated:YES];
            
        }else if (tidaoWodeModel.atMeNoticeSM.moduletype == 2){
            RenWuDetailViewController *xiangqing = [[RenWuDetailViewController alloc] init];
            xiangqing.tongzhiRili = YES;
            xiangqing.renWuID = tidaoWodeModel.atMeNoticeSM.baseid;
            [self.navigationController pushViewController:xiangqing animated:YES];
            
        }else if (tidaoWodeModel.atMeNoticeSM.moduletype == 6){
            GongZuoBaoGaoXiangQViewController *xiangqing = [[GongZuoBaoGaoXiangQViewController alloc] init];
            xiangqing.leixing = tidaoWodeModel.atMeNoticeSM.papertype;
            xiangqing.baogaoId = tidaoWodeModel.atMeNoticeSM.baseid;
            [self.navigationController pushViewController:xiangqing animated:YES];
        }else if (tidaoWodeModel.atMeNoticeSM.moduletype == 5){
            ZiXunPingLunViewController*xiangqing=[[ZiXunPingLunViewController alloc]init];
            xiangqing.ziXunID = tidaoWodeModel.atMeNoticeSM.baseid;
            [self.navigationController pushViewController:xiangqing animated:YES];
        }
        
        
    }
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
        for (XitongTongzhiModel *model in _dataArray) {
            NSRange range = [model.noticeSM.title rangeOfString:_searchBar.text];
            if (range.location!=NSNotFound) {
                //str符合搜索结果
                [_resultArray addObject:model];
            }
        }
        return [_resultArray count];
    }else{
        if (_isNotice) {
            return [_dataArray count];
        }else  if(!_isNotice){
            return [_tidaoDataArray count];
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView!=_tableView) {
        XitongTongzhiCellView *xitongtongzhiCell = [XitongTongzhiCellView cellForTableView:tableView];
        XitongTongzhiModel *model = [_resultArray objectAtIndex:indexPath.row];
        xitongtongzhiCell.model = model;
        return xitongtongzhiCell;
    }
    if (_isNotice) {
        XitongTongzhiCellView *xitongtongzhiCell = [XitongTongzhiCellView cellForTableView:tableView];
        XitongTongzhiModel *model = [_dataArray objectAtIndex:indexPath.row];
        xitongtongzhiCell.model = model;
        return xitongtongzhiCell;
    }else if(!_isNotice){
        TidaoWodeCellView *tidaowodeCell = [TidaoWodeCellView cellForTableView:tableView];
        TidaoWodeModel *model = [_tidaoDataArray objectAtIndex:indexPath.row];
        tidaowodeCell.model = model;
        return tidaowodeCell;
    }
    
    return nil;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, self.view.height);
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
