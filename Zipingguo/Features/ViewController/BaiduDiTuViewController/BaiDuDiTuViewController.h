//
//  BaiDuDiTuViewController.h
//  CeshiOA
//
//  Created by jiangshilin on 14-8-8.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>
#import <BaiduMapAPI/BMKMapView.h>

#import <BaiduMapAPI/BMKPoiSearchOption.h>
#import "ListBox.h"
#import "DituCellViewVM.h"
#import <BaiduMapAPI/BMKGeocodeSearch.h>
#import <BaiduMapAPI/BMKLocationService.h>

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol BaidudituDelegate <NSObject>

@optional

- (void)chuanzhiDizhiTiaozhuanFangfa:(NSString *)dizhi Jingdu:(NSUInteger)jingdu Weidu:(NSUInteger)weidu;

- (void)qiandaoFangfa:(NSString *)dizhi;

- (void)qiantuiFangfaQiandaoDizhi:(NSString *)qiandaoDizhi qiantuiDizhi:(NSString *)qiantuiDizhi;

@end
@interface BaiDuDiTuViewController : UIViewController<BMKMapViewDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate,ListBoxDelegate>
{
    BMKMapView *maker;
    
    BMKGeoCodeSearch *search;
    
    BMKPointAnnotation *annotation1;
    
    CLLocationCoordinate2D coordinate;
    
    NSMutableArray *dataArray;
    
    NSUInteger positionX;
    
    NSUInteger positionY;
}
@property (nonatomic) BOOL isQiandao;
@property (nonatomic) BOOL isQiantui;
@property (nonatomic) BOOL isDongtai;
@property (nonatomic) BOOL isWaichu;
@property (nonatomic, strong) NSString *qiandaoDizhi;
@property (nonatomic, assign) id <BaidudituDelegate> delegate;
@property (strong, nonatomic) IBOutlet ListBox *listBox;

@end
