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
#import "SportsFunctionViewController.h"
#import "SportsFunctionModel.h"
#import "SportsFunctionTableViewCell.h"
#import "SportsFunctionManager.h"

#define lableHeight 20
#define labelTop 30
#define labelWith 100

@interface SportTrajectoryLookViewController () <BMKMapViewDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic,strong) BMKMapView *mapView;

@property (nonatomic,strong) CLLocationManager *manager;

@property (nonatomic,strong) UIView *belowView;

@property (nonatomic,strong) UIButton *circleButton;

@property (nonatomic,strong) UILabel *startLable;

@property (nonatomic,strong) UIView *topView;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) SportsFunctionModel *sportsFunctionModel;

@property (nonatomic,strong) SportsFunctionManager *sportsFunctionManager;

@property (nonatomic,assign) BOOL isTap;

@end

@implementation SportTrajectoryLookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    [self loadMapView];
    
    [self loadDownView];
    
    [self loadAnnotation];
    
    [self loadInformationView];
    
}

- (void)mapTap {
    
    if (self.isTap) {
        
        //收起
        
        [UIView animateWithDuration:0.5 animations:^{
            
            [self.belowView setFrame:CGRectMake(0, SCREEN_HEIGHT - 144, SCREEN_WIDTH, 144)];
            
        }];
        
        self.isTap = 0;
        
    } else {
        
        //展开
        
        [UIView animateWithDuration:0.5 animations:^{
            
            [self.belowView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 144)];
            
        }];
        
        self.isTap = 1;
        
    }
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

- (void)loadData {

    SportsFunctionManager *sportsFunctionManager = [[SportsFunctionManager alloc] init];
    
    SportsFunctionModel *model = [sportsFunctionManager selectSportsFunction:STUserAccountHandler.userProfile.userId];
    
    if (!model.userId) {
        
        model.userId = STUserAccountHandler.userProfile.userId;
        
        model.speechDistance = @"1";
        
        model.mapType = @"1";
        
        [sportsFunctionManager insertSportsFunction:model];
        
    }
    
    self.sportsFunctionManager = sportsFunctionManager;
    
    self.sportsFunctionModel = model;
    
    //dismiss返回刷新
    [STNotificationCenter addObserver:self selector:@selector(sportsFunctionFreshen:) name:STSelectSportsFunctionMapSendNotification object:nil];

}

- (void)loadMapView {

    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    [self.mapView setMapType:self.sportsFunctionModel.mapType.integerValue];
    
    self.mapView.delegate = self;
    
    self.mapView.zoomLevel = 18;
    
    [self.view addSubview:self.mapView];
    
    UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTap)];
    
    [portraitTap setDelegate:self];
    
    [self.mapView addGestureRecognizer:portraitTap];

}

- (void)loadDownView {
    
    UIView *belowView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 144, SCREEN_WIDTH, 144)];
    
    [belowView setBackgroundColor:[UIColor whiteColor]];
    
    [self.mapView addSubview:belowView];
    
    self.belowView = belowView;
    
    
    UIButton *circleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [circleButton setFrame:CGRectMake(SCREEN_WIDTH / 2 - 40, 10, 80, 80)];
    
    [circleButton setBackgroundColor:[UIColor redColor]];
    
    circleButton.layer.masksToBounds = YES;
    
    circleButton.layer.cornerRadius = circleButton.frame.size.width / 2;
    
    [circleButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    
    [belowView addSubview:circleButton];
    
    self.circleButton = circleButton;
    
    
    UILabel *startLable = [[UILabel alloc] initWithFrame:CGRectMake(circleButton.bounds.size.width / 2 - 20, circleButton.bounds.size.height / 2 - 10, 40, 20)];
    
    [startLable setTextAlignment:NSTextAlignmentCenter];
    
    [startLable setTextColor:[UIColor whiteColor]];
    
    [startLable setText:@"关闭"];
    
    [circleButton addSubview:startLable];
    
    self.startLable = startLable;
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 99, SCREEN_WIDTH, 0.5)];
    
    [lineView setBackgroundColor:VIEWBORDERLINECOLOR];
    
    [belowView addSubview:lineView];
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 44)];
    
    [tableView setDelegate:self];
    
    [tableView setDataSource:self];
    
    [tableView setScrollEnabled:NO];
    
    [belowView addSubview:tableView];
    
    self.tableView = tableView;

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SportsFunctionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SportsFunctionTableViewCell"];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SportsFunctionTableViewCell" owner:nil options:nil]lastObject];
        
    }
        
    [cell.SFImageView setImage:[UIImage imageNamed:@"map_image"]];
    
    [cell.SFLable setText:@"地图设置"];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SportsFunctionViewController *controller = [[SportsFunctionViewController alloc] init];

    NSArray *array = @[@"空白地图",@"标准地图",@"卫星地图"];
    
    controller.type = 1;
    
    controller.dataArray = array;
    
    controller.selectIndex = self.sportsFunctionModel.mapType.integerValue;
    
    [self presentViewController:controller animated:YES completion:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (void)sportsFunctionFreshen:(NSNotification *)sender {
    
    self.sportsFunctionModel.mapType = [sender.object stringValue];
    
    [self.mapView setMapType:[sender.object integerValue]];
    
}

//加载轨迹以及大头针
- (void)loadAnnotation {

    NSArray *XArray = [self.sportInformationModel.x componentsSeparatedByString:@","];
    
    NSArray *YArray = [self.sportInformationModel.y componentsSeparatedByString:@","];
    
    
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
    
    annotation.title = @"开始";
    
    CLLocationCoordinate2D coor;
    
    coor.latitude = coors[0].latitude;
    
    coor.longitude = coors[0].longitude;
    
    annotation.coordinate = coor;
    
    [_mapView addAnnotation:annotation];
    
    
    BMKPointAnnotation* annotationEnd = [[BMKPointAnnotation alloc]init];
    
    annotationEnd.title = @"结束";
    
    CLLocationCoordinate2D coorEnd;
    
    coorEnd.latitude = coors[XArray.count - 1].latitude;
    
    coorEnd.longitude = coors[XArray.count - 1].longitude;
    
    annotationEnd.coordinate = coorEnd;
    
    [_mapView addAnnotation:annotationEnd];

}

- (void)loadInformationView {

    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130)];
    
    [topView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.3]];
    
    [self.mapView addSubview:topView];
    
    self.topView = topView;
    
    
    CGFloat lableX = (SCREEN_WIDTH / 3 - labelWith) / 2;
    
    UILabel *timeLable = [self lableWithFrame:CGRectMake(lableX, labelTop, labelWith, lableHeight) text:self.sportInformationModel.time.stringValue == nil ? @"00:00:00" : [self TimeformatFromSeconds:self.sportInformationModel.time.integerValue]];
    
    [topView addSubview:timeLable];
    
    UILabel *timeTieleLable = [self lableTitleWithFrame:CGRectMake(lableX, labelTop + lableHeight + 5, labelWith, lableHeight) text:@"时长"];
    
    [topView addSubview:timeTieleLable];
    
    
    CGFloat calorieLableX = lableX + (SCREEN_WIDTH / 3);
    
    UILabel *calorieLable = [self lableWithFrame:CGRectMake(calorieLableX, labelTop, labelWith, lableHeight) text:[NSString stringWithFormat:@"%.1f",self.sportInformationModel.calorie.floatValue]];
    
    [topView addSubview:calorieLable];
    
    UILabel *calorieTitleLable = [self lableTitleWithFrame:CGRectMake(calorieLableX, labelTop + lableHeight + 5, labelWith, lableHeight) text:@"卡路里"];
    
    [topView addSubview:calorieTitleLable];
    
    
    CGFloat stepNumberLableX = lableX + (SCREEN_WIDTH / 3) * 2;
    
    UILabel *stepNumberLable = [self lableWithFrame:CGRectMake(stepNumberLableX, labelTop, labelWith, lableHeight) text:self.sportInformationModel.stepNumber.stringValue];
    
    [topView addSubview:stepNumberLable];
    
    UILabel *stepNumberTitleLable = [self lableTitleWithFrame:CGRectMake(stepNumberLableX, labelTop + lableHeight + 5, labelWith, lableHeight) text:@"步数"];
    
    [topView addSubview:stepNumberTitleLable];
    
   
    UILabel *distanceLable = [[UILabel alloc] initWithFrame:CGRectMake(10, lableHeight * 2 + 20 + labelTop, 85, 30)];
    
    [distanceLable setTextAlignment:NSTextAlignmentRight];
    
    [distanceLable setTextColor:[UIColor whiteColor]];
    
    [distanceLable setText:self.sportInformationModel.distance.stringValue == nil || [self.sportInformationModel.distance.stringValue isEqualToString:@"0"] ? @"0.00" : self.sportInformationModel.distance.stringValue];
    
    //[distanceLable setBackgroundColor:[UIColor whiteColor]];
    
    [distanceLable setFont:[UIFont fontWithName:@"Arial-BoldMT" size:32.0]];
    
    [topView addSubview:distanceLable];
    
    UILabel *distanceTitleLable = [self lableTitleWithFrame:CGRectMake(100, lableHeight * 2 + 20 + labelTop + 30 - lableHeight, 40, lableHeight) text:@"公里"];
    
    [topView addSubview:distanceTitleLable];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 3 , labelTop, 1, lableHeight * 2 + 5)];
    
    [lineView setBackgroundColor:[UIColor whiteColor]];
    
    [topView addSubview:lineView];
    
    
    UIView *lineViewOne = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 3 * 2, labelTop, 1, lableHeight * 2 + 5)];
    
    [lineViewOne setBackgroundColor:[UIColor whiteColor]];
    
    [topView addSubview:lineViewOne];

}

- (UILabel *)lableWithFrame:(CGRect)rect text:(NSString *)textString {

    UILabel *lable = [[UILabel alloc] initWithFrame:rect];
    
    [lable setTextColor:[UIColor whiteColor]];
    
    [lable setTextAlignment:NSTextAlignmentCenter];
    
    [lable setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16.0]];
    
    [lable setText:textString];
    
    //[lable setBackgroundColor:[UIColor whiteColor]];
    
    return lable;

}

- (UILabel *)lableTitleWithFrame:(CGRect)rect text:(NSString *)textString {
    
    UILabel *lable = [[UILabel alloc] initWithFrame:rect];
    
    [lable setFont:[UIFont fontWithName:@"AmericanTypewriter" size:13.0]];
    
    [lable setTextColor:[UIColor whiteColor]];
    
    [lable setTextAlignment:NSTextAlignmentCenter];
    
    [lable setText:textString];
    
    //[lable setBackgroundColor:[UIColor whiteColor]];
    
    return lable;
    
}

//秒转时分秒
- (NSString*)TimeformatFromSeconds:(NSInteger)seconds {
    
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    return format_time;
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        
        newAnnotationView.enabled3D = YES;
        
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        
        newAnnotationView.annotation = annotation;
        
        if ([annotation.title isEqualToString:@"开始"]) {
         
            newAnnotationView.image = [UIImage imageNamed:@"run_blue"];
            
        } else {
        
            newAnnotationView.image = [UIImage imageNamed:@"destination"];
        
        }
        
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
