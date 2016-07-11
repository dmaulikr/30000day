//
//  SportTrajectoryLookViewController.m
//  30000day
//
//  Created by WeiGe on 16/7/9.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SportTrajectoryLookViewController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKPolyline.h>
#import <BaiduMapAPI_Map/BMKPolylineView.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h> //引入计算工具所有的头文件
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import <BaiduMapAPI_Map/BMKPinAnnotationView.h>

@interface SportTrajectoryLookViewController () <BMKMapViewDelegate>

@property (nonatomic,strong) BMKMapView *mapView;

@property (nonatomic,strong) UIButton *closeButton;

@property (nonatomic,strong) CLLocationManager *manager;

@end

@implementation SportTrajectoryLookViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];

    self.mapView.delegate = self;

    self.mapView.zoomLevel = 14;
    
    [self.view addSubview:self.mapView];
    
    
    NSArray *XArray = [self.x componentsSeparatedByString:@","];
    
    NSArray *YArray = [self.y componentsSeparatedByString:@","];
    
    
    CLLocationCoordinate2D coors[XArray.count];
    
    for (int i = 0; i < XArray.count; i++) {
        
        coors[i].latitude = [XArray[i] floatValue];
        coors[i].longitude = [YArray[i] floatValue];
        
    }
    
    BMKPolyline* polyline = [BMKPolyline polylineWithCoordinates:coors count:XArray.count];
    
    [_mapView addOverlay:polyline];

    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coors[0].latitude longitude:coors[0].longitude];
    
    self.mapView.centerCoordinate = location.coordinate;
    
    
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    
    CLLocationCoordinate2D coor;
    
    coor.latitude = coors[0].latitude;
    
    coor.longitude = coors[0].longitude;
    
    annotation.coordinate = coor;
    
    annotation.title = @"起点";
    
    [_mapView addAnnotation:annotation];

    

    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [closeButton setFrame:CGRectMake(10, 30, 20, 20)];
    
    [closeButton setImage:[UIImage imageNamed:@"close_btn"] forState:UIControlStateNormal];
    
    [closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.mapView addSubview:closeButton];
    
    self.closeButton = closeButton;
    
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        
        return newAnnotationView;
    }
    
    return nil;
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    
    if ([overlay isKindOfClass:[BMKPolyline class]]){
        
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        
        polylineView.strokeColor = LOWBLUECOLOR;
        
        polylineView.lineWidth = 5.0;
        
        return polylineView;
    }
    
    return nil;
}


- (void)closeClick {

    [self dismissViewControllerAnimated:YES completion:nil];
    
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

@end
