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
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "MotionData.h"
#import "SportInformationModel.h"
#import "SportInformationTableManager.h"
#import <BaiduMapApI_Map/BMKGroundOverlay.h>
#import "MTProgressHUD.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>
#import "SportsFunctionTableViewCell.h"
#import "SportsFunctionViewController.h"
#import "SportInformationModel.h"
#import "SportsFunctionManager.h"


@interface SportTrajectoryViewController () <BMKMapViewDelegate,BMKLocationServiceDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,AVSpeechSynthesizerDelegate>

@property (nonatomic,strong) BMKMapView *mapView;                               //地图
@property (nonatomic,strong) BMKLocationService *service;                       //定位
@property (nonatomic,strong) BMKLocationViewDisplayParam *displayParam;
@property (nonatomic,strong) CLLocation *preLocation;                           //记录上一次的位置
@property (nonatomic,strong) NSMutableArray *locationArrayM;                    //位置数组
@property (nonatomic,strong) BMKPolyline *polyLine;                             //轨迹线
@property (nonatomic,assign) CGFloat sumDistance;                               //累计步行距离
@property (nonatomic,assign) CGFloat KMDistance;                                //用于距离提醒
@property (nonatomic,strong) NSTimer *timer;                                    //计时器
@property (nonatomic,assign) NSInteger timerInt;                                //跑步时间
@property (nonatomic,assign) NSInteger lastTimeStepNumber;                      //上次运动步数
@property (nonatomic,assign) NSInteger stepNumber;                              //累计步数
@property (nonatomic,strong) AVSpeechSynthesizer *aVSpeechSynthesizer;          //语音播报
@property (nonatomic,strong) CMPedometer *pedometer;                            //计步器
@property (nonatomic,assign) NSInteger firstEnter;                              //1 表示第一次进入
@property (nonatomic,strong) SportsFunctionManager *sportsFunctionManager;
@property (nonatomic,strong) SportInformationTableManager *sportInformationTableManager;
@property (nonatomic,strong) SportsFunctionModel *sportsFunctionModel;
@property (nonatomic,assign) NSInteger speechDistance;                          //播报距离
@property (nonatomic,assign) BOOL isTap;                                        //是否点击
@property (nonatomic,strong) NSDate *startTime;                                 //开始时间
@property (nonatomic,assign) float mapZoomLevel;                                //地图大小
@property (nonatomic,strong) UIButton *compassButton;                           //罗盘按钮
//@property (nonatomic,strong) NSMutableArray *locationSumArray;                  //最新位置的一个点

@property (nonatomic,strong) UIView *countDownView;                             //倒计时视图
@property (nonatomic,strong) UILabel *countDownLable;
@property (nonatomic,assign) NSInteger countDownNumber;
@property (nonatomic,strong) NSTimer *countDownTimer;

@property (nonatomic,strong) UIView *belowView;                                 //其他视图
@property (nonatomic,strong) UILabel *distanceLable;
@property (nonatomic,strong) UILabel *timeLable;
@property (nonatomic,strong) UILabel *startLable;
@property (nonatomic,strong) UIButton *circleButton;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation SportTrajectoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadOtherObj];          //计步器 音频 通知
    
    [self loadMapView];           //初始化地图 定位
    
    [self loadOtherView];         //初始化其他视图
    
    [self loadCountDownView];     //初始化倒计时

}

//计步器 音频 通知
- (void)loadOtherObj{
    
    self.locationArrayM = [NSMutableArray array];
    //self.locationSumArray = [NSMutableArray array];
    _aVSpeechSynthesizer = [[AVSpeechSynthesizer alloc] init];
    [_aVSpeechSynthesizer setDelegate:self];
    self.firstEnter = 1;
    

    if ([CMPedometer isStepCountingAvailable]) self.pedometer = [[CMPedometer alloc] init]; //检测是否支持计步器
    
    [STNotificationCenter addObserver:self selector:@selector(sportsFunctionFreshen:) name:STSelectSportsFunctionMapSendNotification object:nil]; //dismiss返回刷新

    [STNotificationCenter addObserver:self selector:@selector(sportsFunctionBroadcastFreshen:) name:STSelectSportsFunctionSpeechDistanceSendNotification object:nil];
    
    //获取语音播报间隔时间与地图设置 若新用户则插入默认数据
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
    
    self.speechDistance = [self speechDistanceMate:model.speechDistance.integerValue]; //数据库保存的是tableView下标

}

- (NSInteger)speechDistanceMate:(NSInteger)index {
    
    NSInteger broadcastKM;
    
    if (index == 0) {
        
        broadcastKM = 0;
        
    } else if (index == 1) {
        
        broadcastKM = 1;
        
    } else if (index == 2) {
        
        broadcastKM = 2;
        
    } else if (index == 3) {
        
        broadcastKM = 5;
        
    } else {
        
        broadcastKM = 10;
        
    }
    
    return broadcastKM;
    
}

- (void)sportsFunctionFreshen:(NSNotification *)sender {
    
    self.sportsFunctionModel.mapType = [sender.object stringValue];
    
    [self.mapView setMapType:[sender.object integerValue]];
    
    [self.tableView reloadData];

}

- (void)sportsFunctionBroadcastFreshen:(NSNotification *)sender {
    
    self.sportsFunctionModel.speechDistance = [sender.object stringValue];
    
    self.speechDistance = [self speechDistanceMate:[sender.object integerValue]];
    
    [self.tableView reloadData];
    
}

//加载倒计时View
- (void)loadCountDownView {
    
    self.countDownNumber = 3;

    UIView *countDownView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [countDownView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:countDownView];
    self.countDownView = countDownView;
    
    UILabel *countDownLable = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 200) / 2, (SCREEN_HEIGHT - 300) / 2, 200, 300)];
    [countDownLable setText:[NSString stringWithFormat:@"%ld",(long)self.countDownNumber]];
    [countDownLable setFont:[UIFont systemFontOfSize:300]];
    [countDownLable setTextAlignment:NSTextAlignmentCenter];
    [countDownLable setTextColor:LOWBLUECOLOR];
    [countDownView addSubview:countDownLable];
    self.countDownLable = countDownLable;
    
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownTiming) userInfo:nil repeats:YES];

}

//计时器
- (void)timing {
    
    self.timerInt += 1;
    
    self.timeLable.text = [NSString stringWithFormat:@"%@",[self TimeformatFromSeconds:self.timerInt]];
    
}

//倒计时
- (void)countDownTiming {

    self.countDownNumber--;
    
    [self.countDownLable setText:[NSString stringWithFormat:@"%ld",(long)self.countDownNumber]];
    
    if (self.countDownNumber == 0) {

        [self.mapView removeOverlay:self.polyLine];
        
        self.polyLine = nil;
        
        self.sumDistance = 0;
        
        self.distanceLable.text = @"- -";
        
        //保存最新的点
        //self.locationSumArray[0] = [self.locationArrayM lastObject];
        
        [self.locationArrayM removeAllObjects];
        
        [self.countDownTimer invalidate];
        
        [self read:@"开始跑步"];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timing) userInfo:nil repeats:YES];
        
        [self startPedometerUpdatesTodayWithHandler:^(NSNumber *stepNumber, NSError *error) {
           
            if ([CMPedometer isStepCountingAvailable]) {
                
                if (!error) {
                    
                    if (self.firstEnter == 1) {
                        
                        self.lastTimeStepNumber = stepNumber.integerValue;
                        
                    }
                    
                    self.stepNumber = stepNumber.integerValue;
                    
                    self.firstEnter ++;
                    
                }
                
            }
            
        }];
        
        [self.countDownView removeFromSuperview];
        
    }

}


- (void)startPedometerUpdatesTodayWithHandler:(QYPedometerHandler)handler {
    
    NSDate *toDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *fromDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:toDate]];
    
    [_pedometer startPedometerUpdatesFromDate:fromDate withHandler:^(CMPedometerData *_Nullable pedometerData,NSError *_Nullable error) {
         
         dispatch_async(dispatch_get_main_queue(), ^{
             
             handler(pedometerData.numberOfSteps,error);

         });
     }];
    
}

//加载地图
- (void)loadMapView {

    self.service = [[BMKLocationService alloc] init];
    self.service.distanceFilter = 5;
    self.service.desiredAccuracy = kCLLocationAccuracyBest;
    self.service.delegate = self;
    self.service.allowsBackgroundLocationUpdates = YES;
    self.service.pausesLocationUpdatesAutomatically = NO;
    [self.service startUserLocationService];
    
    
    self.mapZoomLevel = 17;
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.mapView setMapType:self.sportsFunctionModel.mapType.integerValue];
    
    if ([self.sportsFunctionModel.compass integerValue] == 2) {
        
        [self.mapView setUserTrackingMode:BMKUserTrackingModeFollowWithHeading];
        
    } else {
    
        [self.mapView setUserTrackingMode:BMKUserTrackingModeFollow];
        
    }
    
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    self.mapView.zoomLevel = self.mapZoomLevel;
    
    UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTap)];
    [portraitTap setDelegate:self];
    [self.mapView addGestureRecognizer:portraitTap];
    
    // 定位图层自定义样式参数
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
    displayParam.isRotateAngleValid = YES;//跟随态旋转角度是否生效
    displayParam.isAccuracyCircleShow = NO;//精度圈是否显示
    displayParam.locationViewOffsetX = 0;//定位偏移量(经度)
    displayParam.locationViewOffsetY = 0;//定位偏移量（纬度）
    [self.mapView updateLocationViewWithParam:displayParam];
    [self.view addSubview:self.mapView];
    
    self.displayParam = displayParam;

}

//加载其他视图
- (void)loadOtherView {
    
    UIView *belowView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 188, SCREEN_WIDTH, 188)];
    [belowView setBackgroundColor:[UIColor whiteColor]];
    [self.mapView addSubview:belowView];
    self.belowView = belowView;
    
    UILabel *distanceLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 30)];
    [distanceLable setTextAlignment:NSTextAlignmentCenter];
    [distanceLable setText:@"- -"];
    [distanceLable setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20.0]];
    [belowView addSubview:distanceLable];
    self.distanceLable = distanceLable;
    
    UILabel *distanceLablelable1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 100, 20)];
    [distanceLablelable1 setTextAlignment:NSTextAlignmentCenter];
    [distanceLablelable1 setFont:[UIFont systemFontOfSize:15.0]];
    [distanceLablelable1 setTextColor:VIEWBORDERLINECOLOR];
    [distanceLablelable1 setText:@"距离(公里)"];
    [belowView addSubview:distanceLablelable1];
    
    UILabel *timeLable = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 120, 20, 100, 30)];
    [timeLable setTextAlignment:NSTextAlignmentCenter];
    [timeLable setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20.0]];
    [timeLable setText:@"00:00:00"];
    [belowView addSubview:timeLable];
    self.timeLable =  timeLable;
    
    UILabel *timeLable1 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 120, 60, 100, 20)];
    [timeLable1 setTextAlignment:NSTextAlignmentCenter];
    [timeLable1 setFont:[UIFont systemFontOfSize:15.0]];
    [timeLable1 setTextColor:VIEWBORDERLINECOLOR];
    [timeLable1 setText:@"时长"];
    [belowView addSubview:timeLable1];
    
    UIButton *circleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [circleButton setTag:0];
    [circleButton setFrame:CGRectMake(SCREEN_WIDTH / 2 - 40, 10, 80, 80)];
    [circleButton setBackgroundColor:LOWBLUECOLOR];
    circleButton.layer.masksToBounds = YES;
    circleButton.layer.cornerRadius = circleButton.frame.size.width / 2;
    [circleButton addTarget:self action:@selector(startClick:) forControlEvents:UIControlEventTouchUpInside];
    [belowView addSubview:circleButton];
    self.circleButton = circleButton;
    
    UILabel *startLable = [[UILabel alloc] initWithFrame:CGRectMake(circleButton.bounds.size.width / 2 - 20, circleButton.bounds.size.height / 2 - 10, 40, 20)];
    [startLable setTextAlignment:NSTextAlignmentCenter];
    [startLable setTextColor:[UIColor whiteColor]];
    [startLable setText:@"结束"];
    [circleButton addSubview:startLable];
    self.startLable = startLable;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 99, SCREEN_WIDTH, 0.5)];
    [lineView setBackgroundColor:VIEWBORDERLINECOLOR];
    [belowView addSubview:lineView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 90)];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setScrollEnabled:NO];
    [belowView addSubview:tableView];
    
    
    UIView *tianAgeView = [[UIView alloc] initWithFrame:CGRectMake(10, 20, 200, 24)];
    [tianAgeView setBackgroundColor:[UIColor blackColor]];
    [tianAgeView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
    [tianAgeView.layer setMasksToBounds:YES];
    [tianAgeView.layer setCornerRadius:12.0];
    [self.mapView addSubview:tianAgeView];
    
    
    UIView *logView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 24)];
    [logView setBackgroundColor:LOWBLUECOLOR];
    [logView.layer setMasksToBounds:YES];
    [logView.layer setCornerRadius:12.0];
    [tianAgeView addSubview:logView];


    UILabel *logLable = [[UILabel alloc] initWithFrame:CGRectMake(6, 0, 64, 24)];
    [logLable setText:@"30000天"];
    [logLable setFont:[UIFont systemFontOfSize:13.0]];
    [logLable setTextColor:[UIColor whiteColor]];
    [logView addSubview:logLable];
    
    
    
    NSDateFormatter *formatter = [Common dateFormatterWithFormatterString:@"yyyy-MM-dd"];
    NSDate *birthdayDate = [formatter dateFromString:STUserAccountHandler.userProfile.birthday];
    NSString *todayString = [formatter stringFromDate:[NSDate date]];
    NSDate *newToday = [formatter dateFromString:todayString];
    NSTimeInterval interval = [newToday timeIntervalSinceDate:birthdayDate];
    int dayNumber = 0;
    
    if ([Common isObjectNull:STUserAccountHandler.userProfile.birthday]) {//表示没设置生日
        dayNumber = 0;
    } else {//有设置了生日
        dayNumber = interval/86400.0f;
    }
    
    UILabel *tianAgeLable = [[UILabel alloc] initWithFrame:CGRectMake(75, 0, 100, 24)];
    [tianAgeLable setTextColor:[UIColor whiteColor]];
    [tianAgeLable setFont:[UIFont systemFontOfSize:14.0]];
    [tianAgeLable setText:[NSString stringWithFormat:@"我的第%d天",dayNumber]];
    [tianAgeView addSubview:tianAgeLable];
    
    
    UIView *timeLogview = [[UIView alloc] initWithFrame:CGRectMake(10, 50, 200, 24)];
    [timeLogview setBackgroundColor:[UIColor blackColor]];
    [timeLogview setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
    [timeLogview.layer setMasksToBounds:YES];
    [timeLogview.layer setCornerRadius:12.0];
    [self.mapView addSubview:timeLogview];
    
    
    self.startTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 hh:mm"];
    NSString *stringDate = [dateFormatter stringFromDate:self.startTime];
    
    UILabel *logTimeLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 170, 24)];
    [logTimeLable setTextColor:[UIColor whiteColor]];
    [logTimeLable setFont:[UIFont systemFontOfSize:14.0]];
    [logTimeLable setText:stringDate];
    [timeLogview addSubview:logTimeLable];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(170, 2, 20, 20)];
    [imageView setImage:[UIImage imageNamed:@"runWhite"]];
    [timeLogview addSubview:imageView];
    
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:[UIImage imageNamed:@"addMap"] forState:UIControlStateNormal];
    [addButton setFrame:CGRectMake(SCREEN_WIDTH - 40, SCREEN_HEIGHT - 360, 30, 30)];
    [addButton addTarget:self action:@selector(addMapClick) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:addButton];
    
    UIButton *reductionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [reductionButton setImage:[UIImage imageNamed:@"reductionMap"] forState:UIControlStateNormal];
    [reductionButton setFrame:CGRectMake(SCREEN_WIDTH - 40, SCREEN_HEIGHT - 320, 30, 30)];
    [reductionButton addTarget:self action:@selector(reductionMapClick) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:reductionButton];
    
    UIImage *image;
    if (self.sportsFunctionModel.compass.integerValue == 2) {
        
        image = [UIImage imageNamed:@"compassSelect"];
        
    } else {
    
        image = [UIImage imageNamed:@"compassNoSelect"];
    
    }
    
    UIButton *compassButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [compassButton setBackgroundColor:[UIColor whiteColor]];
    [compassButton setImage:image forState:UIControlStateNormal];
    [compassButton setFrame:CGRectMake(SCREEN_WIDTH - 40, SCREEN_HEIGHT - 270, 30, 30)];
    [compassButton addTarget:self action:@selector(compassButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:compassButton];
    self.compassButton = compassButton;
    
    
    UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [locationButton setBackgroundColor:[UIColor whiteColor]];
    [locationButton setImage:[UIImage imageNamed:@"locationImage"] forState:UIControlStateNormal];
    [locationButton setFrame:CGRectMake(SCREEN_WIDTH - 40, SCREEN_HEIGHT - 230, 30, 30)];
    [locationButton addTarget:self action:@selector(locationButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:locationButton];
    
    
    self.tableView = tableView;

}

- (void)addMapClick {
    
    if (self.mapZoomLevel == 21) {
        
        return;
        
    }
    
    self.mapZoomLevel ++;
    
    self.mapView.zoomLevel = self.mapZoomLevel;

}

- (void)reductionMapClick {
    
    if (self.mapZoomLevel == 3) {
        
        return;
        
    }

    self.mapZoomLevel --;
    
    self.mapView.zoomLevel = self.mapZoomLevel;

}

- (void)compassButtonClick:(UIButton *)sender {
    
//    if (sender.tag) {
//        
//        CLLocation *locationArray = [self.locationSumArray lastObject];
//        
//        CLLocation *location = [[CLLocation alloc] initWithLatitude:locationArray.coordinate.latitude longitude:locationArray.coordinate.longitude];
//        
//        [self.mapView setCenterCoordinate:location.coordinate animated:YES];
//        
//        if ([self.sportsFunctionModel.compass integerValue] == 1) {
//
//            [sender setImage:[UIImage imageNamed:@"compassNoSelect"] forState:UIControlStateNormal];
//            
//        } else {
//            
//            [sender setImage:[UIImage imageNamed:@"compassSelect"] forState:UIControlStateNormal];
//            
//        }
//        
//        sender.tag = 0;
//
//        
//    } else {
    
    
    if (STUserAccountHandler.userProfile.userId == nil) {
        
        return;
        
    }

    if ([self.sportsFunctionModel.compass integerValue] == 1) {
        
        self.sportsFunctionModel.compass = [NSNumber numberWithInteger:2];
        
        [sender setImage:[UIImage imageNamed:@"compassSelect"] forState:UIControlStateNormal];
        
        [self.mapView setUserTrackingMode:BMKUserTrackingModeFollowWithHeading];
        
    } else {
    
        self.sportsFunctionModel.compass = [NSNumber numberWithInteger:1];
        
        [sender setImage:[UIImage imageNamed:@"compassNoSelect"] forState:UIControlStateNormal];
        
        [self.mapView setUserTrackingMode:BMKUserTrackingModeFollow];
    
    }
    
    [self.sportsFunctionManager updateSportsFunction:STUserAccountHandler.userProfile.userId compass:self.sportsFunctionModel.compass];
    
    [self.mapView updateLocationViewWithParam:self.displayParam];
        
    
    
}

- (void)locationButtonClick {

//        CLLocation *locationArray = [self.locationSumArray lastObject];
//
//        CLLocation *location = [[CLLocation alloc] initWithLatitude:locationArray.coordinate.latitude longitude:locationArray.coordinate.longitude];
//
//        [self.mapView setCenterCoordinate:location.coordinate animated:YES];
    
    if (STUserAccountHandler.userProfile.userId == nil) {
        
        return;
        
    }
    
    [self.mapView setUserTrackingMode:BMKUserTrackingModeFollow];
    
    self.sportsFunctionModel.compass = [NSNumber numberWithInteger:1];
    
    [self.sportsFunctionManager updateSportsFunction:STUserAccountHandler.userProfile.userId compass:self.sportsFunctionModel.compass];
    
    [self.mapView updateLocationViewWithParam:self.displayParam];
    
    [self.compassButton setImage:[UIImage imageNamed:@"compassNoSelect"] forState:UIControlStateNormal];
    
}

//- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
//    
//    self.compassButton.tag = 1;
//    
//    [self.compassButton setImage:[UIImage imageNamed:@"locationImage"] forState:UIControlStateNormal];
//    
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SportsFunctionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SportsFunctionTableViewCell"];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SportsFunctionTableViewCell" owner:nil options:nil]lastObject];
        
    }
    
    if (indexPath.row == 0) {
        
        [cell.SFImageView setImage:[UIImage imageNamed:@"broadcast_image"]];
        
        [cell.SFLable setText:@"播报距离："];
        
        NSArray *array = @[@"关闭",@"每1公里",@"每2公里",@"每5公里",@"每10公里"];
        
        [cell.dataLabel setText:array[self.self.sportsFunctionModel.speechDistance.integerValue]];
        
        return cell;
        
    } else {
    
        [cell.SFImageView setImage:[UIImage imageNamed:@"map_image"]];
        
        [cell.SFLable setText:@"地图设置："];
        
        NSArray *array = @[@"空白地图",@"标准地图",@"卫星地图"];
        
        [cell.dataLabel setText:array[self.self.sportsFunctionModel.mapType.integerValue]];
        
        return cell;
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    SportsFunctionViewController *controller = [[SportsFunctionViewController alloc] init];
    
    if (indexPath.row == 0) {
        
        NSArray *array = @[@"关闭",@"每1公里",@"每2公里",@"每5公里",@"每10公里"];
        
        controller.type = 0;
        
        controller.dataArray = array;
        
        controller.selectIndex = self.sportsFunctionModel.speechDistance.integerValue;
        
    } else {
    
        NSArray *array = @[@"空白地图",@"标准地图",@"卫星地图"];
        
        controller.type = 1;
        
        controller.dataArray = array;
        
        controller.selectIndex = self.sportsFunctionModel.mapType.integerValue;
        
    }
    
    [self presentViewController:controller animated:YES completion:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

//定位代理
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    
    //跟新坐标
    CGFloat size = self.mapView.zoomLevel;
    [self.mapView updateLocationData:userLocation];
    self.mapView.centerCoordinate = userLocation.location.coordinate;
    self.mapView.zoomLevel = size;
    
    //计算本次定位数据与上次定位数据之间的距离   并保存距离
    CGFloat distanceFloat = [userLocation.location distanceFromLocation:self.preLocation];
    self.sumDistance += distanceFloat;
    self.KMDistance += distanceFloat;
    
    //距离跟新到lable
    CGFloat distance = self.sumDistance / 1000.0;
    NSString *num = [NSString stringWithFormat:@"%lf",distance];
    NSRange range = [num rangeOfString:@"."];
    num = [num substringToIndex:range.location + 3];
    self.distanceLable.text = [NSString stringWithFormat:@"%@",num];
    
    //将符合的位置点存储到数组中
    [self.locationArrayM addObject:userLocation.location];
    
    //保存最新的点
    //self.locationSumArray[0] = userLocation.location;
    
    //语音播报
    CGFloat KM = self.KMDistance / 1000.0;
    if (KM >= self.speechDistance && self.speechDistance != 0) {
        NSString *readString = [NSString stringWithFormat:@"您已经运动了%@公里 用时%@ 加油",num,[self TimeformatFromSeconds:self.timerInt]];
        [self read:readString];
        self.KMDistance = 0;
    }
    
    //记录本次坐标点 用于下次对比
    self.preLocation = userLocation.location;
    
    //画轨迹
    [self drawWalkPolyline];
}


// 用户方向更新后，会调用此函数
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
    
    [self.mapView updateLocationData:userLocation];
    
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

//点击结束
- (void)startClick:(UIButton *)sender {
    
    if (!sender.tag) {  //结束
        
        [self read:@"运动已结束"];
        
        NSString *alertTitleString = @"是否保存?";
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitleString message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if ([Common isObjectNull:STUserAccountHandler.userProfile.userId]) {
                
                [self showToast:@"保存失败，请重新登陆"];
                
                [self over];
                
            } else {
                
                [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
                
                _sportInformationTableManager = [[SportInformationTableManager alloc] init];
                
                SportInformationModel *sportModel = [[SportInformationModel alloc] init];
                
                NSInteger lastMaxID = [Common readAppIntegerDataForKey:LAST_MAX_ID];
                if (!lastMaxID) lastMaxID = 1;
                else lastMaxID ++;
                [Common saveAppIntegerDataForKey:LAST_MAX_ID withObject:lastMaxID];
                sportModel.lastMaxID = [NSNumber numberWithInteger:lastMaxID];
                
                sportModel.sportNo = [[NSNumber numberWithInteger:lastMaxID] stringValue];
                
                sportModel.userId = STUserAccountHandler.userProfile.userId;
                
                NSInteger step = self.stepNumber - self.lastTimeStepNumber;
                sportModel.steps = [NSNumber numberWithInteger:step];
            
                CGFloat distance = self.sumDistance / 1000.0;
                CGFloat calorie = 66.2 * distance * 1.036;      //跑步卡路里（kcal）＝体重（kg）×距离（公里）×1.036
                sportModel.calorie = [[NSNumber numberWithFloat:calorie] stringValue];
                
                NSString *num = [NSString stringWithFormat:@"%.2f",distance];
                
                if (distance == 0) {
                    
                    num = @"0.00";
                    
                }
                
                sportModel.distance = num;
                
                sportModel.period = [NSString stringWithFormat:@"%ld",(long)self.timerInt];
                NSString *x = @"";
                NSString *y = @"";
                for (int i = 0; i < self.locationArrayM.count; i++) {
                    CLLocation *location = self.locationArrayM[i];
                    NSString *locationStringX = [NSString stringWithFormat:@"%f,",location.coordinate.latitude];
                    NSString *locationStringY = [NSString stringWithFormat:@"%f,",location.coordinate.longitude];
                    x = [x stringByAppendingString:locationStringX];
                    y = [y stringByAppendingString:locationStringY];
                }
                if (![Common isObjectNull:x] && ![Common isObjectNull:y]) {
                    x = [x substringToIndex:x.length - 1];
                    y = [y substringToIndex:y.length - 1];
                }
                sportModel.xcoordinate = x;
                sportModel.ycoordinate = y;
                
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy年MM月dd日 hh:mm"];
                NSString *stringDate = [dateFormatter stringFromDate:self.startTime];
                sportModel.startTime = stringDate;
        
                
                [STDataHandler sendCommitSportHistoryWithSportInformationModel:sportModel success:^(BOOL success) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                       
                        if (success) {
                            
                            sportModel.isSave = [NSNumber numberWithBool:YES];
                            
                            [_sportInformationTableManager insertSportInformation:sportModel];
                            
                        } else {
                        
                            sportModel.isSave = [NSNumber numberWithBool:NO];
                            
                            [_sportInformationTableManager insertSportInformation:sportModel];
                        
                        }
                        
                        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                        
                        [STNotificationCenter postNotificationName:STDidSuccessSportInformationSendNotification object:nil]; //发送通知刷新历史记录
                        
                    });
                    
                    
                } failure:^(NSError *error) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                       
                        sportModel.isSave = [NSNumber numberWithBool:NO];
                        
                        [_sportInformationTableManager insertSportInformation:sportModel];
                        
                        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                        
                        [STNotificationCenter postNotificationName:STDidSuccessSportInformationSendNotification object:nil]; //发送通知刷新历史记录
                        
                    });
                    
                }];
                
                [self over];
            }
            
        }];
        
        UIAlertAction *CancelAlertAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self over];
            
        }];
        
        [alert addAction:alertAction];
        [alert addAction:CancelAlertAction];
        [self presentViewController:alert animated:YES completion:nil];
    
    } else {  //关闭页面
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}

//语音播报
- (void)read:(NSString *)string {
    
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionDuckOthers error:nil];
    
    AVSpeechUtterance * aVSpeechUtterance = [[AVSpeechUtterance alloc] initWithString:string];
    
    aVSpeechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate;
    
    aVSpeechUtterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    
    [self.aVSpeechSynthesizer speakUtterance:aVSpeechUtterance];
    
}

- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didFinishSpeechUtterance:(nonnull AVSpeechUtterance *)utterance {
    
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    
}

//秒转时分秒
- (NSString*)TimeformatFromSeconds:(NSInteger)seconds {
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02d",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02d",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02d",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    return format_time;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

- (void)mapTap {
    
    if (self.isTap) {
        
        [UIView animateWithDuration:0.3 animations:^{ //收起
            
            [self.belowView setFrame:CGRectMake(0, SCREEN_HEIGHT - 188, SCREEN_WIDTH, 188)];
            
        }];
        
        self.isTap = 0;
        
    } else {
        
        [UIView animateWithDuration:0.3 animations:^{ //展开
            
            [self.belowView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 188)];
            
        }];
        
        self.isTap = 1;
        
    }
    
}

//结束  清空数据关闭定位
- (void)over {

    [self.service stopUserLocationService];
    
    [self.timer invalidate];
    
    [self.locationArrayM removeAllObjects];
    
    self.polyLine = nil;
    
    self.sumDistance = 0;
    
    self.timerInt = 0;
    
    self.circleButton.tag = 1;
    
    self.startLable.text = @"关闭";
    
    [self.circleButton setBackgroundColor:[UIColor redColor]];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
