//
//  BaiDuDiTuViewController.m
//  CeshiOA
//
//  Created by jiangshilin on 14-8-8.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "BaiDuDiTuViewController.h"
#import "DCNavigationController.h"
@interface BaiDuDiTuViewController ()
{
    BMKLocationService * locationSer;
    ///反编译的次数，如果 > 5次，提示反编译失败
    int loadSearchTime;
}
@end

@implementation BaiDuDiTuViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [maker viewWillDisappear];
//    [(MLNavigationController *)self.navigationController addGestureRecognizer];
    maker.delegate=nil;
    locationSer.delegate = nil;
    search.delegate = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [maker viewWillAppear];
    maker.delegate = self;
    locationSer.delegate = self;
    search.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [(MLNavigationController *)self.navigationController removeGestureRecognizer];
}

- (void)dealloc{
    _listBox.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"获取地址位置";
    [_listBox setSeparatorColor:[UIColor clearColor]];
    maker = [[BMKMapView alloc] init];
    //C OC C++
    maker.delegate = self;
    maker.zoomEnabled =YES;
    maker.scrollEnabled =YES;
    maker.zoomLevel =18;
    maker.showsUserLocation = NO;
    maker.userTrackingMode = BMKUserTrackingModeNone;
    //maker.showMapScaleBar =YES;
    
    [self.view addSubview:maker];
    
    locationSer =[[BMKLocationService alloc]init];
    [locationSer startUserLocationService];
    search=[[BMKGeoCodeSearch alloc]init];
    
}

#pragma mark -BMKMapViewDelegate

//移动完成回调
-(void)mapViewDidFinishLoading:(BMKMapView *)mapView
{
    NSLog(@"已经移动完毕!");
    
}


-(void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinat{
    
    NSLog(@"长按");
    
    NSLog(@"%f %f",coordinat.latitude,coordinat.longitude);
    //    [locationSer startUserLocationService];
    NSString* showmeg = [NSString stringWithFormat:@"您长按了地图(long pressed).\r\n当前经度:%f,当前纬度:%f,\r\nZoomLevel=%d;RotateAngle=%d;OverlookAngle=%d", coordinate.longitude,coordinate.latitude,
                         (int)maker.zoomLevel,maker.rotation,maker.overlooking];
    NSLog(@"%@",showmeg);
}

-(void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"双击空白处");
}

-(void)updateLocationData:(BMKUserLocation*)userLocation
{
    NSLog(@"userLocation=%@",userLocation);
}

-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        
        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        
        return newAnnotationView;
    }
    return nil;
}

#pragma mark -BMKLocationServiceDelegate

-(void)willStartLocatingUser{
    
    NSLog(@"定位将要开启!");
    
    [locationSer startUserLocationService];
}
-(void)didStopLocatingUser{
    
    NSLog(@"停止定位!");
    [locationSer stopUserLocationService];
    [maker setShowsUserLocation:NO];
}

//位置改变
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //获取用户坐标以后需要更新地图
    [maker updateLocationData:userLocation];
    // 添加一个PointAnnotation
    if (!annotation1) {
        annotation1 = [[BMKPointAnnotation alloc]init];
        annotation1.title = @"当前位置";
        annotation1.coordinate = userLocation.location.coordinate;
        [maker addAnnotation:annotation1];
    }else{
        annotation1.coordinate = userLocation.location.coordinate;
    }
    
    NSLog(@"!latitude!!!  %f",userLocation.location.coordinate.latitude);//经度
    NSLog(@"!longtitude!!!  %f",userLocation.location.coordinate.longitude);//纬度
    positionX  = userLocation.location.coordinate.latitude;
    positionY = userLocation.location.coordinate.longitude;
    coordinate = userLocation.location.coordinate;
    maker.centerCoordinate = userLocation.location.coordinate;
    
    BMKReverseGeoCodeOption *coore = [[BMKReverseGeoCodeOption alloc] init];
    coore.reverseGeoPoint= coordinate;
    
    BOOL isSecc=[search reverseGeoCode:coore];
    loadSearchTime ++;
    
    if (isSecc) {
        NSLog(@"反编译成功 %d",loadSearchTime);
        
        [locationSer stopUserLocationService];
    }else{
        search = nil;
        NSLog(@"反编译失败");
        if (loadSearchTime > 100) {
            [locationSer stopUserLocationService];
            [LDialog showMessage:@"获取周围位置失败，请稍后再试" ok:^{
                [AppContext pop];
            }];
        }
    }
}


-(void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"定位失败!");
}

#pragma mark -BMKGeoCodeSearchDelegate

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    //poi地址
    [self listBoxtData:result.poiList];
    
    if (error==0) {
        //副标题
        annotation1.subtitle = [NSString stringWithFormat:@"%@",result.address];
    }else{
        [locationSer startUserLocationService];
    }
}

- (void)listBoxtData:(NSArray *)xinxiArray{

    _listBox.delegate = self;
    dataArray =  [[NSMutableArray alloc] init];
    for (BMKPoiInfo *info in xinxiArray) {
        DituCellViewVM *model = [[DituCellViewVM alloc] init];
        
        CGSize nameSize  = [info.name sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(self.view.frame.size.width-70,MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        CGSize addressSize  = [info.address sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(self.view.frame.size.width-70,MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        model.cellHeight = nameSize.height+addressSize.height+25;
        model.dizhiXinxi = info.name;
        model.jutiXinxi = info.address;
        //NSLog(@"%@",model.jutiXinxi);
        [dataArray addObject:model];
        
    }
    _listBox.items = dataArray;
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    if (annotation1 !=nil) {
        
        [maker removeAnnotation:annotation1];
    }
    
    [locationSer stopUserLocationService];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    float makerHeight = 200.0;
    float pandingY;
    if (IOSDEVICE) {
        pandingY = 20;
    }
    maker.frame = CGRectMake(0, 0, width, makerHeight);
    _listBox.frame = CGRectMake(0, makerHeight, width, height-makerHeight);
}

- (void)listBox:(ListBox *)listBox didSelectItem:(id)data{

}

@end
