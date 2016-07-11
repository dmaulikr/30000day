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

@property (nonatomic,strong) CLLocationManager *manager;

@property (nonatomic,strong) UIView *belowView;

@property (nonatomic,strong) UIButton *circleButton;

@property (nonatomic,strong) UILabel *startLable;

@end

@implementation SportTrajectoryLookViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];

    self.mapView.delegate = self;

    self.mapView.zoomLevel = 18;
    
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
    
    [_mapView addAnnotation:annotation];
    
    
    BMKPointAnnotation* annotationEnd = [[BMKPointAnnotation alloc]init];
    
    CLLocationCoordinate2D coorEnd;
    
    coorEnd.latitude = coors[XArray.count].latitude;
    
    coorEnd.longitude = coors[XArray.count].longitude;
    
    annotationEnd.coordinate = coorEnd;
    
    [_mapView addAnnotation:annotationEnd];
    
    
    
    UIButton *circleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [circleButton setFrame:CGRectMake(SCREEN_WIDTH / 2 - 40, SCREEN_HEIGHT - 90, 80, 80)];
    
    [circleButton setBackgroundColor:[UIColor redColor]];
    
    circleButton.layer.masksToBounds = YES;
    
    circleButton.layer.cornerRadius = circleButton.frame.size.width / 2;
    
    [circleButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.mapView addSubview:circleButton];
    
    self.circleButton = circleButton;
    
    
    UILabel *startLable = [[UILabel alloc] initWithFrame:CGRectMake(circleButton.bounds.size.width / 2 - 20, circleButton.bounds.size.height / 2 - 10, 40, 20)];
    
    [startLable setTextAlignment:NSTextAlignmentCenter];
    
    [startLable setTextColor:[UIColor whiteColor]];
    
    [startLable setText:@"关闭"];
    
    [circleButton addSubview:startLable];
    
    self.startLable = startLable;
    
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        
        newAnnotationView.enabled3D = YES;
        
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        
        newAnnotationView.annotation = annotation;
        
        newAnnotationView.image = [UIImage imageNamed:@"run_blue"];   //把大头针换成别的图片
        
        newAnnotationView.size = CGSizeMake(23, 23);
        
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
