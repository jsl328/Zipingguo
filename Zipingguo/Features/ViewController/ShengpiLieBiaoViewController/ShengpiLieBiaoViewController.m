//
//  ShengpiLieBiaoViewController.m
//  Zipingguo
//
//  Created by jiangshilin on 15/10/16.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ShengpiLieBiaoViewController.h"
#import "ShengpiDetailViewController.h"
@interface ShengpiLieBiaoViewController ()
{
    NSMutableArray *dataArray;
    NSMutableArray *wotijiaoArray;
    
    int startPage;
    int CountPage;
    int beishu;
    
    BOOL _isNotice;//系统通知yes 提到我的no
    BOOL _shengPiLoaded;//系统通知是否加载过，省流量
    BOOL _shengQingLoaded;//提到我的是否加载过，省流量
    
    BOOL _isLoadMore;//是否加载更多数据，yes-上拉加载，no-下拉刷新；
}
@end

@implementation ShengpiLieBiaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    startPage=0;
    CountPage=10;
    beishu=0;
    
    _isNotice = YES;
    _shengPiLoaded = NO;
    _shengQingLoaded = NO;
    _isLoadMore = NO;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    _mTableView.tableFooterView = footerView;
    
    dataArray =[[NSMutableArray alloc]init];
    wotijiaoArray =[[NSMutableArray alloc]init];
    _mTableView.separatorStyle =UITableViewCellSeparatorStyleSingleLine;
    _mTableView.separatorColor =Fenge_Color;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fabiaoShengpiFanhui) name:@"fabiaoShengpiFanhui" object:nil];
 
    [self addSegmentedControlWithLeftTitle:@"审批" RightTitle:@"申请" selector:@selector(segmentedControlValueChanged:)];
    [self addItemWithTitle:nil imageName:@"快捷操作+icon" selector:@selector(xinjianClick:) location:NO];
    
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    [self loadData];
    
    //下拉刷新
    MJYaMiRefreshHeader *header = [MJYaMiRefreshHeader headerWithRefreshingBlock:^{
        _isLoadMore = NO;
        [self loadData];
    }];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    _mTableView.header = header;
    
    //上拉加载
    MJYaMiFooter *footer = [MJYaMiFooter footerWithRefreshingBlock:^{
        _isLoadMore = YES;
        [self loadData];
    }];
    _mTableView.footer = footer;
}
- (void)ShengpiFanhui{
    _isLoadMore = NO;
    _isNotice = YES;
    self.seg.selectedSegmentIndex = 0;
    [self loadData];
}

- (void)fabiaoShengpiFanhui{
    _isLoadMore = NO;
    _isNotice = NO;
    self.seg.selectedSegmentIndex = 1;
    [self loadData];
}

-(void)segmentedControlValueChanged:(UISegmentedControl *)seg
{
    if (seg.selectedSegmentIndex == 0) {
        //审批
        _isNotice = YES;
        if (!_shengQingLoaded) {
            [self shengPiList];
        }
    }else{
        //申请
        _isNotice = NO;
        if (!_shengPiLoaded) {
            [self shengQingList];
        }
    }
    [_mTableView reloadData];
}

-(void)loadData
{
    if(_isNotice){//系统通知
        [self shengPiList];//默认加载系统通知
    }else{
        [self shengQingList];//加载提交我的
    }
}

-(void)shengPiList
{
    int start= _isLoadMore ? (int)[dataArray count] :0;
    if (start == 0) {
        [LDialog showWaitBox:@"数据加载中"];
    }
    [ServiceShell getApplyApprovalWithStart:start Count:CountPage Dealid:[AppStore getYongHuID] usingCallback:^(DCServiceContext *ser, ResultModelOfApplyApprovalSM *results) {
        [LDialog closeWaitBox];
        if (ser.isSucceeded && results.status == 0) {
            [_mTableView.header endRefreshing];//停止刷新
            if (results.data.count<CountPage) {
                //没有更多数据
                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                [_mTableView.footer endRefreshingWithNoMoreData];
                
            }else{
                [_mTableView.footer endRefreshing];//停止加载
            }
            _shengQingLoaded =YES;
            if (!_isLoadMore) {//下拉刷新清除数据
                [dataArray removeAllObjects];
            }
            [self dataModel:results.data ToViewModel:dataArray];
        }
    }];
}

-(void)shengQingList
{
    int start= _isLoadMore ? (int)[wotijiaoArray count] :0;
    if (start == 0) {
        [LDialog showWaitBox:@"数据加载中"];
    }
    [ServiceShell getApplyListWithStart:start Count:CountPage Dealid:[AppStore getYongHuID] usingCallback:^(DCServiceContext *sc, ResultModelOfApplyApprovalSM *results) {
        [LDialog closeWaitBox];
        
        if (sc.isSucceeded && results.status == 0) {
            [_mTableView.header endRefreshing];//停止刷新
            if (results.data.count< CountPage) {//没有更多数据
                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                [_mTableView.footer endRefreshingWithNoMoreData];
            }else{
                [_mTableView.footer endRefreshing];//停止加载
            }
            _shengPiLoaded = YES;
            if (!_isLoadMore) {//下拉刷新清除数据
                [wotijiaoArray removeAllObjects];
            }
            [self dataModel:results.data ToViewModel:wotijiaoArray];
        }
    }];
}

-(void)dataModel:(NSArray *)data ToViewModel:(NSMutableArray *)distinsArray
{
    for (ApplyApprovalSM *sm in data) {
        
        ShengPiCellVM *vm=[[ShengPiCellVM alloc]init];
        vm.Leixing=sm.status;
        vm.type =sm.type;
        //创建人的id号码
        vm.createid = sm.createid;
        if (_isNotice) {
            vm.extendType =2;
        }else{
            vm.extendType =3;
        }
        //抄送与否?
        vm.shengpiNeiXing=[NSString stringWithFormat:@"%@",sm.flowname];
        vm.shengqingRen=sm.createname;
        vm.dealid = sm.dealid;
        vm.dealName = sm.dealname;
        vm._ID=sm._id;
        vm.jutushijian =sm.time;
        
        [distinsArray addObject:vm];
    }
    [_mTableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _isNotice?dataArray.count:wotijiaoArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self sizeTodRact];
    return 65.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShengPiCellView *cell = [ShengPiCellView cellForTableView:tableView];
    cell.model = _isNotice ?dataArray[indexPath.row]:wotijiaoArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //自动反选
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_isNotice) {
        if (indexPath.row <dataArray.count) {
            ShengpiDetailViewController *detail =[[ShengpiDetailViewController alloc]init];
            detail.vm  = dataArray[indexPath.row];
            detail.row =indexPath.row;
            detail.passValueFromShenpi = ^(int start){
                [self ShengpiFanhui];
            };
            [self.navigationController pushViewController:detail animated:YES];
        }
    }else{
        if (indexPath.row <wotijiaoArray.count) {
            ShengpiDetailViewController *detail =[[ShengpiDetailViewController alloc]init];
            detail.vm  = wotijiaoArray[indexPath.row];
            detail.row = indexPath.row;
            detail.passValueFromShanchu = ^(NSInteger row){
                [wotijiaoArray removeObjectAtIndex:row];
                NSArray *ab =[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]];
                [tableView deleteRowsAtIndexPaths:ab withRowAnimation:UITableViewRowAnimationRight];
                [tableView reloadData];
            };
            [self.navigationController pushViewController:detail animated:YES];
        }
    }
}

//新建审批
-(void)xinjianClick:(UIButton *)button
{
    FaqiShengQingViewController *faqiVC =[[FaqiShengQingViewController alloc]init];
    faqiVC.delagate =self;
    [self.navigationController pushViewController:faqiVC animated:YES];
}
-(void)shuaxinFanhui
{
    
}

-(void)sizeTodRact
{
    _mTableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    if ([_mTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_mTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_mTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_mTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
@end
