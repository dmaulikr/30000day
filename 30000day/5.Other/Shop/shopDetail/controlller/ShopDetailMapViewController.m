//
//  ShopDetailMapViewController.m
//  30000day
//
//  Created by GuoJia on 16/4/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ShopDetailMapViewController.h"

@interface ShopDetailMapViewController ()

@end

@implementation ShopDetailMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.detailModel.productName;
    
    //初始化百度地图
    _mapView = [[BMKMapView alloc] init];
    
    _mapView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake([self.detailModel.latitude doubleValue],[self.detailModel.longitude doubleValue])];
    
    _mapView.showsUserLocation = NO;
    
    _mapView.delegate = self;
    
    _mapView.zoomLevel = 15;//地图等级
    
    [self.view addSubview:_mapView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self;// 此处记得不用的时候需要置nil，否则影响内存的释放
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; //不用时，置nil
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}

#pragma mark -
#pragma mark implement BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation {
    
    BMKPinAnnotationView *pinAnnotationView = (BMKPinAnnotationView *)[view dequeueReusableAnnotationViewWithIdentifier:@"BMKPinAnnotationView"];
    
    if (!pinAnnotationView) {
        
        pinAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"BMKPinAnnotationView"];
    }
    
    pinAnnotationView.pinColor = BMKPinAnnotationColorPurple;
    
    pinAnnotationView.animatesDrop = NO;
    
    pinAnnotationView.canShowCallout = YES;
    
    [pinAnnotationView setSelected:YES animated:YES];
    
    return pinAnnotationView;
}

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    //百度地图显示等级
    _mapView.zoomLevel = 15;
    
    //起始的大头针
    BMKPointAnnotation *item = [[BMKPointAnnotation alloc] init];
    
    item.coordinate = CLLocationCoordinate2DMake([self.detailModel.latitude doubleValue],[self.detailModel.longitude doubleValue]);
    
    item.title = self.detailModel.productName;
    
    item.subtitle = self.detailModel.address;
    
    [_mapView addAnnotation:item];
    
    [_mapView showAnnotations:@[item] animated:NO];
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
