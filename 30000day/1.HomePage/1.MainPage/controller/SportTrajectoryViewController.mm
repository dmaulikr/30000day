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
#import "MotionData.h"
#import "SportInformationModel.h"
#import "SportInformationTableManager.h"
#import <BaiduMapApI_Map/BMKGroundOverlay.h>
#import "MTProgressHUD.h"

@interface SportTrajectoryViewController () <BMKMapViewDelegate,BMKLocationServiceDelegate>

@property (nonatomic,strong) BMKMapView *mapView; //地图

@property (nonatomic,strong) BMKLocationService *service; //定位

@property (nonatomic,strong) CLLocation *preLocation;  //记录上一次的位置

@property (nonatomic,strong) NSMutableArray *locationArrayM; //位置数组

@property (nonatomic,strong) BMKPolyline *polyLine; //轨迹线

@property (nonatomic,assign) CGFloat sumDistance;  // 累计步行距离

@property (nonatomic,strong) NSTimer *timer; //计时器

@property (nonatomic,assign) NSInteger timerInt; //跑步时间

@property (nonatomic,assign) NSInteger lastTimeStepNumber; //上次运动步数

@property (nonatomic,strong) MotionData *motionData;


@property (nonatomic,strong) UIView *belowView;

@property (nonatomic,strong) UILabel *distanceLable;

@property (nonatomic,strong) UILabel *timeLable;

@property (nonatomic,strong) UILabel *startLable;

@property (nonatomic,strong) UIButton *circleButton;

@end

@implementation SportTrajectoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationArrayM = [NSMutableArray array];
    
    [self getLastTimeStepCount];
    
    [self loadMapView];
    
    [self loadOtherView];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timing) userInfo:nil repeats:YES];

}

//获取上次运动步数
- (void)getLastTimeStepCount {
    
    MotionData *mdata = [[MotionData alloc]init];
    
    self.motionData = mdata;
    
    [mdata getHealtHequipmentWhetherSupport:^(BOOL scs) {
        
        if (scs) {
            
            [mdata getHealthUserDateOfBirthCount:^(NSString *birthString) {
                
                self.lastTimeStepNumber = birthString.integerValue;
                
            } failure:^(NSError *error) {
                
                
            }];
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];
}

//加载地图
- (void)loadMapView {

    self.service = [[BMKLocationService alloc] init];
    
    self.service.distanceFilter = 5;
    
    self.service.desiredAccuracy = kCLLocationAccuracyBest;
    
    self.service.delegate = self;
    
    [self.service startUserLocationService];
    
    
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    self.mapView.showsUserLocation = YES;
    
    self.mapView.delegate = self;
    
    self.mapView.zoomLevel = 17;
    
    
    // 定位图层自定义样式参数
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
    
    displayParam.isRotateAngleValid = NO;//跟随态旋转角度是否生效
    
    displayParam.isAccuracyCircleShow = NO;//精度圈是否显示
    
    displayParam.locationViewOffsetX = 0;//定位偏移量(经度)
    
    displayParam.locationViewOffsetY = 0;//定位偏移量（纬度）
    
    [self.mapView updateLocationViewWithParam:displayParam];
    
    [self.view addSubview:self.mapView];


}

//加载其他视图
- (void)loadOtherView {
    
    UIView *belowView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 100, SCREEN_WIDTH, SCREEN_HEIGHT - 100)];
    
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

}

//计时器
- (void)timing {

    self.timerInt += 1;
    
    self.timeLable.text = [NSString stringWithFormat:@"%@",[self TimeformatFromSeconds:self.timerInt]];
    
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

//定位代理
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    
    [self.mapView updateLocationData:userLocation];
    
    self.mapView.centerCoordinate = userLocation.location.coordinate;
    
    // 计算本次定位数据与上次定位数据之间的距离
    //CGFloat distanceFloat = [userLocation.location distanceFromLocation:self.preLocation];
    
    // (5米门限值，存储数组划线) 如果距离少于 5 米，则忽略本次数据直接返回该方法
//    if (distanceFloat < 5) {
//        NSLog(@"与前一更新点距离小于5m，直接返回该方法");
//        return;
//    }
    
    // 累加步行距离
    CGFloat distance = self.sumDistance / 1000.0;
    
    NSString *num = [NSString stringWithFormat:@"%lf",distance];
    
    NSRange range = [num rangeOfString:@"."];
    
    num = [num substringToIndex:range.location + 3];
    
    self.distanceLable.text = [NSString stringWithFormat:@"%@",num];
    
    self.sumDistance += 5;
    
    //将符合的位置点存储到数组中
    [self.locationArrayM addObject:userLocation.location];
    
    self.preLocation = userLocation.location;
    
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
        
        NSString *alertTitleString = @"是否保存?";
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitleString message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if ([Common isObjectNull:STUserAccountHandler.userProfile.userId]) {
                
                [self showToast:@"保存失败，请重新登陆"];
                
                [self over];
                
            } else {
                
                [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
                [self.motionData getHealtHequipmentWhetherSupport:^(BOOL scs) {
                    
                    if (scs) {
                        
                        [self.motionData getHealthUserDateOfBirthCount:^(NSString *birthString) {
                            
                            SportInformationTableManager *SFTable = [[SportInformationTableManager alloc] init];
                            
                            SportInformationModel *sportModel = [[SportInformationModel alloc] init];
                            
                            
                            NSInteger lastMaxID = [Common readAppIntegerDataForKey:LAST_MAX_ID];
                            
                            if (!lastMaxID) {
                                
                                lastMaxID = 1;
                                
                            } else {
                                
                                lastMaxID ++;
                                
                            }
                            
                            [Common saveAppIntegerDataForKey:LAST_MAX_ID withObject:lastMaxID];
                            
                            
                            NSNumber *lastMaxIDNumber = [[NSNumber alloc] initWithInteger:lastMaxID];
                            
                            sportModel.lastMaxID = lastMaxIDNumber;
                            
                            sportModel.userId = STUserAccountHandler.userProfile.userId;
                            
                            
                            NSInteger step = birthString.integerValue - self.lastTimeStepNumber; //上次步数-当前步数=本次运动步数
                            
                            NSNumber *stepNumber = [[NSNumber alloc] initWithInteger:step];
                            
                            sportModel.stepNumber = stepNumber;
                            
                            
                            CGFloat distance = self.sumDistance / 1000.0;
                            
                            CGFloat calorie = 66.2 * distance * 1.036;  //跑步卡路里（kcal）＝体重（kg）×距离（公里）×1.036
                            
                            NSNumber *calorieNumber = [[NSNumber alloc] initWithFloat:calorie];
                            
                            sportModel.calorie = calorieNumber;
                            
                            
                            NSString *num = [NSString stringWithFormat:@"%lf",distance];
                            
                            NSRange range = [num rangeOfString:@"."];
                            
                            num = [num substringToIndex:range.location + 3];
                            
                            NSNumber *distanceNumber = [NSNumber numberWithFloat:num.floatValue];
                            
                            sportModel.distance = distanceNumber;
                            
                            
                            NSNumber *timeNumber = [[NSNumber alloc] initWithInteger:self.timerInt];
                            
                            sportModel.time = timeNumber;
                            
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
                            
                            sportModel.x = x;
                            
                            sportModel.y = y;
                            
                            
                            [SFTable insertSportInformation:sportModel];
                            
                            
                            [self over];
                            
                            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                            
                            
                        } failure:^(NSError *error) {
                            
                            
                        }];
                        
                    }
                    
                } failure:^(NSError *error) {
                    
                    
                }];
            
            }
            
        }];
        
        UIAlertAction *CancelAlertAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self over];
            
        }];
        
        [alert addAction:alertAction];
        
        [alert addAction:CancelAlertAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    
    } else {  //关闭页面
        
        [self colseView];
        
    }
    
}

//结束  清空数据关闭定位
- (void)over {

    [self.service stopUserLocationService];
    
    [self.timer invalidate];
    
    [self.locationArrayM removeAllObjects];
    
    self.preLocation = nil;
    
    self.polyLine = nil;
    
    self.sumDistance = 0;
    
    self.timerInt = 0;
    
    self.circleButton.tag = 1;
    
    self.startLable.text = @"关闭";
    
    [self.circleButton setBackgroundColor:[UIColor redColor]];
    
}


- (void)colseView {
    
    //发送通知刷新历史记录
    [STNotificationCenter postNotificationName:STDidSuccessSportInformationSendNotification object:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
