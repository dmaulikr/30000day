//
//  SportTrajectoryViewController.m
//  30000day
//
//  Created by WeiGe on 16/7/4.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SportTrajectoryViewController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Map/BMKPolyline.h>
#import <BaiduMapAPI_Map/BMKPolylineView.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

@interface SportTrajectoryViewController () <BMKMapViewDelegate,BMKLocationServiceDelegate>

@property (nonatomic,strong) BMKMapView *mapView; //地图

@property (nonnull,strong) BMKLocationService *service; //定位

/** 记录上一次的位置 */
@property (nonatomic, strong) CLLocation *preLocation;
/** 位置数组 */
@property (nonatomic, strong) NSMutableArray *locationArrayM;
/** 轨迹线 */
@property (nonatomic, strong) BMKPolyline *polyLine;

@end

@implementation SportTrajectoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.service = [[BMKLocationService alloc] init];
    
    self.service.delegate = self;
    
    [self.service startUserLocationService];

    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    self.mapView.delegate = self;
    
    self.mapView.zoomLevel = 17;
    
    [self.view addSubview:self.mapView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setBackgroundColor:[UIColor redColor]];
    
    [btn setFrame:CGRectMake(50, 100, 40, 30)];
    
    [btn setTitle:@"关闭" forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(colseView) forControlEvents:UIControlEventTouchUpInside];
    
    [self.mapView addSubview:btn];
    
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {

    self.mapView.showsUserLocation = YES;
    
    [self.mapView updateLocationData:userLocation];
    
    self.mapView.centerCoordinate = userLocation.location.coordinate;
    
    [self.locationArrayM addObject:userLocation.location];
    
    [self drawWalkPolyline];
    
}

- (void)drawWalkPolyline {
    // 轨迹点数组个数
    NSInteger count = self.locationArrayM.count;
    // 动态分配存储空间
    // BMKMapPoint是个结构体：地理坐标点，用直角地理坐标表示 X：横坐标 Y：纵坐标
    BMKMapPoint *tempPoints = new BMKMapPoint[count];
    // 遍历数组
    [self.locationArrayM enumerateObjectsUsingBlock:^(CLLocation *location, NSUInteger idx, BOOL *stop) {
        BMKMapPoint locationPoint = BMKMapPointForCoordinate(location.coordinate);
        tempPoints[idx] = locationPoint;
    }];
    //移除原有的绘图，避免在原来轨迹上重画
    if (self.polyLine) {
        [self.mapView removeOverlay:self.polyLine];
    }
    // 通过points构建BMKPolyline
    self.polyLine = [BMKPolyline polylineWithPoints:tempPoints count:count];
    //添加路线,绘图
    if (self.polyLine) {
        [self.mapView addOverlay:self.polyLine];
    }
    // 清空 tempPoints 临时数组
    delete []tempPoints;
    // 根据polyline设置地图范围
    //    [self mapViewFitPolyLine:self.polyLine];
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKPolyline class]]){
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [[UIColor purpleColor] colorWithAlphaComponent:1];
        polylineView.lineWidth = 5.0;
        return polylineView;
    }
    return nil;
}


- (void)colseView {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
