//
//  MapViewController.m
//  渠道助手
//
//  Created by bug on 16/3/31.
//  Copyright © 2016年 Kami Mahou. All rights reserved.
//

#import "MapViewController.h"
#import "MapKit/MapKit.h"
#import "CoreLocation/CoreLocation.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件

@interface MapViewController ()<CLLocationManagerDelegate, BMKMapViewDelegate,BMKLocationServiceDelegate,UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate>

@property(nonatomic, strong)CLGeocoder *geocoder;

@property(nonatomic, strong)NSString *str;

@property(nonatomic, strong)UIView *topView;
@property(nonatomic, strong)UIView *floatView;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSDictionary *test;
//经纬度
@property (nonatomic, assign) NSString *lon;
@property (nonatomic, assign) NSString *lat;

@property(nonatomic, strong)UIButton *dateButton;
/** 记录上一次的位置 */
@property (nonatomic, strong) CLLocation *preLocation;
/** 位置数组 */
@property (nonatomic, strong) NSMutableArray *locationArrayM;
/** 轨迹线 */
@property (nonatomic, strong) BMKPolyline *polyLine;
/** 百度地图View */
@property (nonatomic,strong) BMKMapView *mapView;
/** 百度定位地图服务 */
@property (nonatomic, strong) BMKLocationService *bmkLocationService;

@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, strong) UIPickerView *pickerView;

@end

@implementation MapViewController

-(CLGeocoder *)geocoder
{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (NSMutableArray *)locationArrayM
{
    if (!_locationArrayM) {
        _locationArrayM = [[NSMutableArray alloc] init];
    }
    return _locationArrayM;
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 10.0f;
    }
    return _locationManager;
}

- (UIButton *)dateButton
{
    if (!_dateButton) {
        _dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _dateButton.frame = CGRectMake(50, 35, 150, 30);
        [_dateButton addTarget:self action:@selector(openFloatView) forControlEvents:UIControlEventTouchUpInside];
        
        NSInteger firstRow=[self.pickerView selectedRowInComponent:0];//获取第1个组建的选择行
        NSInteger secondRow=[self.pickerView selectedRowInComponent:1];//获取第2个组建的选择行
        NSInteger thirdRow=[self.pickerView selectedRowInComponent:2];//获取第3个组建的选择行
        NSString *month;
        NSString *day;
        if ([self.dataDic[@"month"][secondRow] intValue] < 10) {
            month = [NSString stringWithFormat:@"0%@",self.dataDic[@"month"][secondRow]];
        }
        else
        {
            month = self.dataDic[@"month"][secondRow];
        }
        if ([self.dataDic[@"day"][thirdRow] intValue] < 10) {
            day = [NSString stringWithFormat:@"0%@",self.dataDic[@"day"][thirdRow]];
        }
        else
        {
            day = self.dataDic[@"day"][thirdRow];
        }
        NSString *str = [NSString stringWithFormat:@"%@-%@-%@",self.dataDic[@"year"][firstRow],month,day];

        [_dateButton setTitle:str forState:UIControlStateNormal];
        [_dateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [_topView addSubview:_dateButton];
    }
    return _dateButton;
}

//- (UIView *)topView
//{
//    if (!_topView) {
//        _topView = [[UIView alloc] init];
//        
//        _topView.frame = CGRectMake(0, 0, 320, 100);
//        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(0, 20, 30, 30);
//        [button addTarget:self action:@selector(goBackView) forControlEvents:UIControlEventTouchUpInside];
//        [button setBackgroundImage:[UIImage imageNamed:@"System_Nav_Back_btn"] forState:UIControlStateNormal];
//        [_topView addSubview:button];
//        
//        UIButton *enquiriesButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        enquiriesButton.frame = CGRectMake(250, 35, 50, 30);
//        [enquiriesButton addTarget:self action:@selector(buttonCilck) forControlEvents:UIControlEventTouchUpInside];
//        [enquiriesButton setTitle:@"查询" forState:UIControlStateNormal];
//        [enquiriesButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [_topView addSubview:enquiriesButton];
//        
//        [self.view addSubview:_topView];
//    }
//    return _topView;
//}

- (UIView *)floatView
{
    if (!_floatView) {
        _floatView = [[UIView alloc] init];
        
        _floatView.frame = self.topView.frame;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(250, 70, 50, 30);
        [button addTarget:self action:@selector(hideFloatView) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [_floatView addSubview:button];
        
        _floatView.hidden = YES;
        
        [self.view addSubview:_floatView];
    }
    return _floatView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 初始化百度位置服务
    [self initBMLocationService];
    
    // 初始化地图窗口
    self.mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    self.mapView.frame = CGRectMake(0, 100, width, height-100);
    //显示地图放大级别
    [self.mapView setZoomLevel:18];
    // 设置MapView的一些属性
    [self setMapViewProperty];

    [self.view addSubview:self.mapView];

    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 20, 320, 50)];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    [self.floatView addSubview:self.pickerView];
    
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    
    //存储年份的数组
    NSMutableArray *yearArray = [[NSMutableArray alloc] initWithCapacity:50];
    for (int i = 0; i < 50; i ++)
    {
        [yearArray addObject:[NSString stringWithFormat:@"%d", 1990 + i]];
    }
    //存储月份的数组
    NSMutableArray *monthArray = [[NSMutableArray alloc] initWithCapacity:12];
    for (int i = 0; i < 12; i ++)
    {
        [monthArray addObject:[NSString stringWithFormat:@"%d", i + 1]];
    }
    //存储天数的数组
    NSMutableArray *dayArray = [[NSMutableArray alloc] initWithCapacity:31];
    for (int i = 0; i < 31; i ++)
    {
        [dayArray addObject:[NSString stringWithFormat:@"%d", i + 1]];
    }
    
    //将年、月、日都存放进字典
    _dataDic = [[NSDictionary alloc] initWithObjectsAndKeys:yearArray, @"year", monthArray, @"month", dayArray, @"day", nil];
    
    //计算今天的日期
    NSDate *date = [NSDate date];
    date = [date dateByAddingTimeInterval:8 * 60 * 60];
    NSString *today = [date description];
    int yearNow = [[today substringToIndex:4] intValue];
    int monthNow = [[today substringWithRange:NSMakeRange(5, 2)] intValue];
    int dayNow = [[today substringWithRange:NSMakeRange(8, 2)] intValue];
    
    //日期指定到今天，让日历默认显示今天的日期
    [self.pickerView selectRow:(yearNow - 1990) inComponent:0 animated:NO];
    [self.pickerView selectRow:(monthNow - 1) inComponent:1 animated:NO];
    [self.pickerView selectRow:(dayNow - 1) inComponent:2 animated:NO];
    
    [self topView];
    [self dateButton];
    [self floatView];
}

- (void)getLocation:(NSInteger)count andArr:(NSArray *)locationArr
{
    NSDictionary *dict = locationArr[count];
    count++;
    
    //说明：调用下面的方法开始编码，不管编码是成功还是失败都会调用block中的方法
    [self.geocoder geocodeAddressString:dict[@"address"] completionHandler:^(NSArray *placemarks, NSError *error) {
        //如果有错误信息，或者是数组中获取的地名元素数量为0，那么说明没有找到
        if (error || placemarks.count == 0)
        {
            NSLog(@"失败");
        }
        else   //编码成功，找到了具体的位置信息
        {
            //取出获取的地理信息数组中的第一个显示在界面上
            CLPlacemark *firstPlacemark=[placemarks firstObject];
            //                //纬度
            //                CLLocationDegrees latitude=firstPlacemark.location.coordinate.latitude;
            //                //经度
            //                CLLocationDegrees longitude = firstPlacemark.location.coordinate.longitude;
            
            //                CLLocationCoordinate2D test = CLLocationCoordinate2DMake(latitude, longitude);
            //                //转换 google地图、soso地图、aliyun地图、mapabc地图和amap地图所用坐标至百度坐标
            //                NSDictionary* testdic = BMKConvertBaiduCoorFrom(test,BMK_COORDTYPE_COMMON);
            //                //转换GPS坐标至百度坐标
            //                testdic = BMKConvertBaiduCoorFrom(test,BMK_COORDTYPE_GPS);
            //                NSLog(@"x=%@,y=%@",[testdic objectForKey:@"x"],[testdic objectForKey:@"y"]);
            
            [self.locationArrayM addObject:firstPlacemark.location];
            
            if (dict == locationArr.lastObject)
            {
                self.mapView.centerCoordinate = firstPlacemark.location.coordinate;

                [self drawWalkPolyline];
            }
            else
            {
                [self getLocation:count andArr:locationArr];
            }
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.bmkLocationService.delegate = self;
    self.mapView.delegate = self;
    //获取坐标
    [self.locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  设置 百度MapView的一些属性
 */
- (void)setMapViewProperty
{
    // 显示定位图层
    self.mapView.showsUserLocation = YES;
    // 设置定位模式
    self.mapView.userTrackingMode = BMKUserTrackingModeNone;
    // 允许旋转地图
    self.mapView.rotateEnabled = YES;
    // 显示比例尺
//    self.bmkMapView.showMapScaleBar = YES;
//    self.bmkMapView.mapScaleBarPosition = CGPointMake(self.view.frame.size.width - 50, self.view.frame.size.height - 50);
    // 定位图层自定义样式参数
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
    displayParam.isRotateAngleValid = NO;//跟随态旋转角度是否生效
    displayParam.isAccuracyCircleShow = NO;//精度圈是否显示
    displayParam.locationViewOffsetX = 0;//定位偏移量(经度)
    displayParam.locationViewOffsetY = 0;//定位偏移量（纬度）
    displayParam.locationViewImgName = @"walk";
    [self.mapView updateLocationViewWithParam:displayParam];
}
/**
 *  初始化百度位置服务
 */
- (void)initBMLocationService
{
    // 初始化位置百度位置服务
    self.bmkLocationService = [[BMKLocationService alloc] init];
    // 设置距离过滤，表示每移动10更新一次位置
    self.bmkLocationService.distanceFilter = 10;
    // 设置定位精度
    self.bmkLocationService.desiredAccuracy = kCLLocationAccuracyBest;
    // 打开定位服务
    [self.bmkLocationService startUserLocationService];
    // 设置当前地图的显示范围，直接显示到用户位置
    BMKCoordinateRegion adjustRegion = [self.mapView regionThatFits:BMKCoordinateRegionMake(self.bmkLocationService.userLocation.location.coordinate, BMKCoordinateSpanMake(0.02f,0.02f))];
    [self.mapView setRegion:adjustRegion animated:YES];
}

/**
 *  定位失败会调用该方法
 *
 *  @param error 错误信息
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"did failed locate,error is %@",[error localizedDescription]);
}
/**
 *  用户位置更新后，会调用此函数
 *  @param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //更新自己的位置
    self.mapView.centerCoordinate = userLocation.location.coordinate;

    // 如果此时位置更新的水平精准度大于10米，直接返回该方法
//    [self recordTrackingWithUserLocation:userLocation];

    // 可以用来简单判断GPS的信号强度
    if (userLocation.location.horizontalAccuracy > kCLLocationAccuracyNearestTenMeters) {
        return;
    }
}

/**
 *  用户方向更新后，会调用此函数
 *  @param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    // 动态更新我的位置数据
    [self.mapView updateLocationData:userLocation];
}

/**
 *  开始记录轨迹
 *
 *  @param userLocation 实时更新的位置信息
 */
- (void)recordTrackingWithUserLocation:(BMKUserLocation *)userLocation
{
    if (self.preLocation) {
        // 计算本次定位数据与上次定位数据之间的距离
        CGFloat distance = [userLocation.location distanceFromLocation:self.preLocation];
//        self.statusView.distanceWithPreLoc.text = [NSString stringWithFormat:@"%.3f",distance];
        NSLog(@"与上一位置点的距离为:%f",distance);
        // (5米门限值，存储数组画线) 如果距离少于 5 米，则忽略本次数据直接返回方法
        if (distance < 5) {
            return;
            
        }
    }
    // 2. 将符合的位置点存储到数组中（第一直接来到这里）
    [self.locationArrayM addObject:userLocation.location];
    self.preLocation = userLocation.location;
    // 3. 绘图
    [self drawWalkPolyline];
}

/**
 *  绘制轨迹路线
 */
- (void)drawWalkPolyline
{
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

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]){
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [[UIColor purpleColor] colorWithAlphaComponent:1];
        polylineView.lineWidth = 5.0;
        return polylineView;
    }
    return nil;
}

//- (void)buttonCilck
//{
//    [[[ServiceDataCentre alloc] init] createService:[NSString stringWithFormat:@"http://wap.gs.10086.cn/ecu_web/xundian/queryTrace.xundian?traceDate=%@",self.dateButton.titleLabel.text] mathFunction:^(BOOL isSuccess, NSDictionary * res, NSString * msg) {
//        if (isSuccess) {
//            NSArray *locationArr = res[@"msg"];
//            if (locationArr.count == 0) {
//                return;
//            }
//            [self getLocation:0 andArr:locationArr];
//        }
//        else
//        {
//            return;
//        }
//    }];
//}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return _dataDic.count; //设置选择器的列数，即显示年、月、日三列
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *keyArray = [_dataDic allKeys];
    NSArray *contentArray = [_dataDic objectForKey:keyArray[component]];
    //显示每月的天数跟年份和月份都有关系，所以需要判断条件
    if (component == 2)
    {
        int month = [pickerView selectedRowInComponent:1] + 1;
        int year = [pickerView selectedRowInComponent:0] + 1990;
        switch (month)
        {
                //每个月的天数不一样
            case 4: case 6: case 9: case 11:
            {
                contentArray = [contentArray subarrayWithRange:NSMakeRange(0, 30)];//4、6、9、11月的天数是30天
                return contentArray.count;
            }
            case 2:
            {
                if ( [self isLeapYear:year])
                {
                    //如果是闰年，二月有 29 天
                    contentArray = [contentArray subarrayWithRange:NSMakeRange(0, 29)];
                }
                else
                {
                    //不是闰年，二月只有 28 天
                    contentArray = [contentArray subarrayWithRange:NSMakeRange(0, 28)];
                }
                
                return contentArray.count;
            }
            default:
                return contentArray.count;  //1、3、5、7、8、10、12 月的天数都是31天
        }
    }
    
    return contentArray.count;  //返回每列的行数
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 100; //设置每列的宽度
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50; //设置每行的高度
}

//设置所在列每行的显示标题，与设置所在列的行数一样，天数的标题设置仍旧需要非一番功夫
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *keyArray = [_dataDic allKeys];
    NSArray *contentArray = [_dataDic objectForKey:keyArray[component]];
    
    if (component == 2)
    {
        int month = [pickerView selectedRowInComponent:1] + 1;
        int year = [pickerView selectedRowInComponent:0] +1990;
        switch (month)
        {
            case 4: case 6: case 9: case 11:
            {
                contentArray = [contentArray subarrayWithRange:NSMakeRange(0, 30)];
                return contentArray[row];
            }
            case 2:
            {
                if ( [self isLeapYear:year])
                {
                    //闰年
                    contentArray = [contentArray subarrayWithRange:NSMakeRange(0, 29)];
                }
                else
                {
                    contentArray = [contentArray subarrayWithRange:NSMakeRange(0, 28)];
                }
                
                return contentArray[row];
            }
            default:
                return contentArray[row];
        }
    }
    return contentArray[row];
}

//当选择的行数改变时触发的方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //第一列的被选择行变化，即年份改变，则刷新月份和天数
    if (component == 0)
    {
        [pickerView reloadAllComponents]; //刷新月份与日期
        //下面是将月份和天数都定位到第一行
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
    //第二列的被选择行变化，即月份发生变化，刷新天这列的内容
    if (component == 1)
    {
        [pickerView reloadAllComponents];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }//需要这些条件的原因是年份和月份的变化，都会引起每月的天数的变化，他们之间是有联系的，要掌握好他们之间的对应关系
    [self value];
}
- (void)value
{
    NSInteger row=[self.pickerView selectedRowInComponent:0];//获取第一个组建的选择行

    NSLog(@"%@",self.dataDic[@"year"][row]);
}

//判断是否闰年
- (BOOL)isLeapYear:(int)year
{
    if ((year % 400 == 0) || ((year % 4 == 0) && (year % 100 != 0)))
    {
        return YES; //是闰年返回 YES
    }
    
    return NO; //不是闰年，返回 NO
}

//返回上一级
- (void)goBackView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)openFloatView
{
    self.floatView.hidden = NO;
}

////定位代理经纬度回调
//-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
//{
//    [self.locationManager stopUpdatingLocation];
//    
//    NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f",newLocation.coordinate.latitude,newLocation.coordinate.longitude]);
//    _lon = [NSString stringWithFormat:@"%3.5f",newLocation.coordinate.latitude];
//    _lat = [NSString stringWithFormat:@"%3.5f",newLocation.coordinate.longitude];
//    
//    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
//    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
//        for (CLPlacemark * placemark in placemarks) {
//            
//            self.test = [placemark addressDictionary];
//            //  Country(国家)  City(城市)  State(省)
//            NSLog(@"%@", self.test[@"FormattedAddressLines"]);
//            [self uploadLocation];
//        }
//    }];
//}
//
//- (void)uploadLocation
//{
//    NSArray *numUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"number"];
//    NSString *str = [NSString stringWithFormat:@"http://wap.gs.10086.cn/ecu_web/xundian/getPosition.xundian?user_number=%@&address=%@&longitude=%@&latitude=%@", numUser, self.test[@"FormattedAddressLines"], _lon, _lat];
//    NSString *urlStringUTF8 = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    [[[ServiceDataCentre alloc] init] createService:urlStringUTF8 mathFunction:^(BOOL isSuccess, NSDictionary * res, NSString * msg) {
//        if (isSuccess) {
//            
//        }
//        else
//        {
//            return;
//        }
//    }];
//}

- (void)hideFloatView
{
    self.floatView.hidden = YES;
    NSInteger firstRow=[self.pickerView selectedRowInComponent:0];//获取第1个组建的选择行
    NSInteger secondRow=[self.pickerView selectedRowInComponent:1];//获取第2个组建的选择行
    NSInteger thirdRow=[self.pickerView selectedRowInComponent:2];//获取第3个组建的选择行
    NSString *month;
    NSString *day;
    if ([self.dataDic[@"month"][secondRow] intValue] < 10) {
        month = [NSString stringWithFormat:@"0%@",self.dataDic[@"month"][secondRow]];
    }
    if ([self.dataDic[@"day"][thirdRow] intValue] < 10) {
        day = [NSString stringWithFormat:@"0%@",self.dataDic[@"day"][thirdRow]];
    }
    
    NSString *str = [NSString stringWithFormat:@"%@-%@-%@",self.dataDic[@"year"][firstRow],month,day];
    [self.dateButton setTitle:str forState:UIControlStateNormal];
}

@end
