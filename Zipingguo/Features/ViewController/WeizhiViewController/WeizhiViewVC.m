//
//  WeizhiViewController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/14.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "WeizhiViewVC.h"
#import "WeizhiModel.h"
#import "WeizhiCellView.h"
// 百度地图相关
// 检索
#import <BaiduMapAPI/BMKPoiSearchOption.h>
// 地理编码
#import <BaiduMapAPI/BMKGeocodeSearch.h>
// 定位
#import <BaiduMapAPI/BMKLocationService.h>
@interface WeizhiViewVC ()<BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate>
{
    // 地图相关
    ///geo搜索服务
    BMKGeoCodeSearch *geoCodeSearch;
    /// 当前坐标
    CLLocationCoordinate2D currentLocation;
    NSUInteger positionX;
    NSUInteger positionY;
    /// 定位管理服务
    BMKLocationService * locationService;
    ///反编译的次数，如果 > 5次，提示反编译失败
    NSInteger loadSearchTimer;
    
    NSMutableArray *dataArray;
    
    CLLocationCoordinate2D coordinate;
}
@end

@implementation WeizhiViewVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    locationService.delegate = self;
    geoCodeSearch.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    locationService.delegate = nil;
    geoCodeSearch.delegate = nil;
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [locationService stopUserLocationService];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"位置";

    dataArray = [[NSMutableArray alloc] init];
    // 实例化地图相关
    [self createBaiDuMap];
    
}

#pragma mark - 数据
- (void)loadDaKaAddress:(NSArray *)addressArray{
    [dataArray removeAllObjects];
    
    // pio信息类
    for (BMKPoiInfo * info in addressArray) {
        //        info.name // pio名称
        //        info.address // pio 地址
        WeizhiModel *model = [[WeizhiModel alloc] init];
        model.name = info.name;
        model.jutidizhi = info.address;
        [dataArray addObject:model];
    }
    [_tableView reloadData];
}

- (void)createBaiDuMap{
    locationService = [[BMKLocationService alloc] init];
    // 打开定位服务
    [locationService startUserLocationService];
    geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
}

#pragma mark - 百度地图delegate
#pragma mark - 百度地图定位delegate
// 将要开始定位
- (void)willStartLocatingUser{
    [locationService startUserLocationService];
}
// 关闭定位
- (void)didStopLocatingUser{
    [locationService stopUserLocationService];
}

// 位置改变
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    /// geo检索信息类
    BMKReverseGeoCodeOption *geoCodeOption = [[BMKReverseGeoCodeOption alloc] init];
    geoCodeOption.reverseGeoPoint = userLocation.location.coordinate;
    coordinate = userLocation.location.coordinate;
    // 根据地理坐标获取地址信息
    BOOL isSuccess = [geoCodeSearch reverseGeoCode:geoCodeOption];
    loadSearchTimer ++;
    if (isSuccess) {
        NSLog(@"反编译成功次数 ： %d",loadSearchTimer);
        [locationService stopUserLocationService];
    }else{
        geoCodeSearch = nil;
        NSLog(@"反编译失败");
        if (loadSearchTimer > 100 ) {
            [locationService stopUserLocationService];
            [SDialog showTipViewWithText:@"获取周围位置失败，请稍后再试" hideAfterSeconds:1];
        }
    }
}
- (void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"定位失败！！！");
}
#pragma mark -BMKGeoCodeSearchDelegate
///返回反地理编码搜索结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    // 获得地址 -- poi地址
    [self loadDaKaAddress:result.poiList];
    if (error == 0) {
        
    }else{
        [locationService startUserLocationService];
    }
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight);
}

#pragma mark - table View delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //自动反选
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WeizhiModel *model = [dataArray objectAtIndex:indexPath.row];
    _passValueFromWeizhi(model.jutidizhi,coordinate);
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - table View DataSource
//重写两个dataSource方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeizhiCellView *cell = [WeizhiCellView cellForTableView:tableView];
    WeizhiModel *model = [dataArray objectAtIndex:indexPath.row];
    cell.model = model;
    
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
