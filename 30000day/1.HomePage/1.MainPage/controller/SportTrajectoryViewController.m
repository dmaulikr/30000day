//
//  SportTrajectoryViewController.m
//  30000day
//
//  Created by WeiGe on 16/7/4.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SportTrajectoryViewController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>

@interface SportTrajectoryViewController () <BMKMapViewDelegate>

@property (nonatomic,strong) BMKMapView *mapView;

@end

@implementation SportTrajectoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mapView = [[BMKMapView alloc] initWithFrame:self.view.frame];
    
    self.mapView.delegate = self;
    
    self.mapView.mapType = BMKMapTypeSatellite;//卫星地图
    
    self.mapView.trafficEnabled = YES;
    
    self.mapView.showMapPoi = NO;
    
    self.mapView.zoomLevel = 21;
    
    self.mapView.rotateEnabled = NO;
    
    self.mapView.scrollEnabled = NO;
    
    [self.view addSubview:self.mapView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
