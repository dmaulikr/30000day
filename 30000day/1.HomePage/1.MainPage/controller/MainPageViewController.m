//
//  MainPageViewController.m
//  30000day
//
//  Created by GuoJia on 16/1/29.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "MainPageViewController.h"
#import "MDRadialProgressView.h"
#import "BEMSimpleLineGraphView.h"
#import "MDRadialProgressTheme.h"
#import "JHAPISDK.h"
#import "JHOpenidSupplier.h"
#import "UIImageView+WebCache.h"
#import "jk.h"
#import <CoreLocation/CoreLocation.h>

@interface MainPageViewController () < CLLocationManagerDelegate,BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate >

@property (nonatomic,strong)NSMutableArray *dayarr;

@property (nonatomic,strong)NSMutableArray *xarr;

@property (nonatomic,strong)NSString *pm25;

@property (nonatomic,assign)NSInteger yy;

@property (nonatomic,assign)NSInteger progressViewY;

@property (nonatomic,assign)NSInteger chartViewY;

@property (nonatomic,strong)BEMSimpleLineGraphView *myGraph;//屏幕下方的曲线图

@property (nonatomic,assign)NSInteger first;

@property (nonatomic,strong)UILabel *rankingLabel;

@property (nonatomic,strong)UIView *SplitLineView;

@property (strong, nonatomic) MDRadialProgressView *progressView;//屏幕上方的圈圈图

@property (weak, nonatomic) IBOutlet UIView *weatherSupView;

@property (weak, nonatomic) IBOutlet UIImageView *userHeadView;

@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;

@property (weak, nonatomic) IBOutlet UILabel *weatherCityLabel;

@property (weak, nonatomic) IBOutlet UILabel *weatherTemperatureLabel;//温度

@property (weak, nonatomic) IBOutlet UILabel *weatherPM25Label;//空气质量label

@property (retain, nonatomic) CLLocationManager *locationManager;

@property (nonatomic, copy) NSString *cityName;

@end

@implementation MainPageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
     _userInfo = [UserAccountHandler shareUserAccountHandler].userInfo;
    
    [self.weatherSupView.layer setBorderWidth:1.0];
    
    [self.weatherSupView.layer setBorderColor:[UIColor colorWithRed:208.0/255 green:208.0/255 blue:208.0/255 alpha:1.0].CGColor];
    
    //设置聚合SDK的APPID
    [[JHOpenidSupplier shareSupplier] registerJuheAPIByOpenId:jhOpenID];
    
    [self.userHeadView.layer setCornerRadius:6.0];
    
    [self.userHeadView.layer setMasksToBounds:YES];
    
    NSURL *imgurl = [NSURL URLWithString:_userInfo.HeadImg];
    
    if ([[NSString stringWithFormat:@"%@",imgurl] isEqualToString:@""] || imgurl == nil ) {
        
        [self.userHeadView setImage:[UIImage imageNamed:@"lcon.png"]];
        
    } else {
        
        [self.userHeadView sd_setImageWithURL:imgurl];
    }
    
    [self getCurrentUserDays];
    
    [self configMDRadialProgressView];
    
    [self startLocation];
}

//开始定位
- (void)startLocation {
    
    // 判断定位操作是否被允许
    if ([CLLocationManager locationServicesEnabled]) {
        
        self.locationManager = [[CLLocationManager alloc] init] ;
        
        self.locationManager.delegate = self;
        
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        _locationManager.distanceFilter = 100;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)[_locationManager requestWhenInUseAuthorization];
        
        self.first=0;
        
    } else {
        
        //提示用户无法进行定位操作  Product
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"开启定位功能可查看天气噢！"
                                                          delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        
        return;
    }
    
    // 开始定位
    [_locationManager startUpdatingLocation];
}

//获取当前用户的天龄
- (void)getCurrentUserDays {
    
    NSString *URLString=@"http://116.254.206.7:12580/M/API/GetLatestUserLifeStat?";//不需要传递参数
    
    NSURL *URL = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    NSString *param = [NSString stringWithFormat:@"loginName=%@&loginPassword=%@&howManyDays=%d&userID=%d",_userInfo.LoginName,_userInfo.LoginPassword,7,_userInfo.UserID.intValue];
    
    NSData *postData = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    
    [request setURL:URL];
    
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    
    NSError *error;
    
    NSData *backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (backData) {
        
        NSArray *ar = [NSJSONSerialization JSONObjectWithData:backData options:NSJSONReadingAllowFragments error:&error];
        
        _dayarr = [NSMutableArray array];
        
        _xarr = [NSMutableArray array];
        
        for (int i=0; i<ar.count; i++) {
            
            _dayarr[i] = ar[i][@"TotalLife"];
            
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            
            [formatter setDateFormat:@"yyyy/MM/dd"];
            
            NSDate *da = [formatter dateFromString:ar[i][@"CreateDate"]];
            
            NSDateFormatter *f = [[NSDateFormatter alloc]init];
            
            [f setDateFormat:@"dd"];
            
            NSString *stringday = [NSString stringWithFormat:@"%@",[f stringFromDate:da]];
            
            _xarr[i]=stringday;
    
        }
        
        if (_xarr.count==1) {
            
            [_xarr addObject:_xarr[0]];
            
            [_dayarr addObject:_dayarr[0]];
        }
        
        _xarr = (NSMutableArray *)[[_xarr reverseObjectEnumerator] allObjects];
        
        _dayarr=(NSMutableArray*)[[_dayarr reverseObjectEnumerator] allObjects];
    }
    
}

//配置MDRadialProgressView
- (void)configMDRadialProgressView {
    
    int hasbeen;
    
    int count = 0;
    
    if ([_userInfo.Birthday isEqualToString:@""] || _userInfo.Birthday == nil) {
        
        hasbeen=0;
        
    } else {
        
        hasbeen = [self getDays:_userInfo.Birthday];
    }
    
    NSArray *arr = [_userInfo.Birthday componentsSeparatedByString:@"-"];
    
    NSLog(@"%@",arr);
    
    int year = [arr[0] intValue];
    
    for (int i=year; i<year+80; i++) {
        
        if (i%400==0||(i%4==0 && i%100!=0)) {
            
            count+=366;
            
        } else {
            
            count+=365;
        }
    }
    
    _progressView = [[MDRadialProgressView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height * 0.2, [UIScreen mainScreen].bounds.size.height * 0.2)];
    
    float uday = [[_dayarr lastObject] floatValue];
    
    NSString* userday=[NSString stringWithFormat:@"%.2f",uday];
    
    _progressView.progressTotal = [userday floatValue];  //总数
    
    _progressView.progressCounter = hasbeen;
    
    _progressView.theme.sliceDividerHidden = YES;
    
    _progressView.theme.incompletedColor = [UIColor colorWithRed:232.0/255 green:232.0/255 blue:232.0/255 alpha:1.0];
    
    _progressView.theme.completedColor = BLUECOLOR;
    
    _progressView.theme.thickness = 12.0;
    
    [self.view addSubview:_progressView];
    
    _progressView.translatesAutoresizingMaskIntoConstraints=NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_progressView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [_progressView addConstraint:[NSLayoutConstraint constraintWithItem:_progressView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_progressView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_progressView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.2 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_progressView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:165]];
    
    self.rankingLabel=[[UILabel alloc]init];
    
    [self.rankingLabel setText:@"当前您已经击败9999个用户！"];
    
    [self.rankingLabel setFont:[UIFont systemFontOfSize:18.0]];
    
    [self.view addSubview:self.rankingLabel];
    
    self.rankingLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.rankingLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_progressView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:27]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.rankingLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_progressView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    self.SplitLineView=[[UIView alloc]init];
    
    [self.SplitLineView setBackgroundColor:[UIColor colorWithRed:208.0/255 green:208.0/255 blue:208.0/255 alpha:1.0]];
    
    [self.view addSubview:self.SplitLineView];
    
    self.SplitLineView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.SplitLineView addConstraint:[NSLayoutConstraint constraintWithItem:self.SplitLineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:1]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.SplitLineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:15]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.SplitLineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-15]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.SplitLineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.rankingLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:20]];
    
    [self configBEMSimpleLineGraphView];
}

//配置下面的曲线图
- (void)configBEMSimpleLineGraphView {
    
    _myGraph = [[BEMSimpleLineGraphView alloc]init];
    
    self.myGraph.delegate = self;
    
    self.myGraph.dataSource = self;
    
    [self.view addSubview:self.myGraph];
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    size_t num_locations = 2;
    
    CGFloat locations[2] = { 0.0, 1.0 };
    
    CGFloat components[8] = {
        
        1.0, 1.0, 1.0, 1.0,
        
        1.0, 1.0, 1.0, 0.0
    };
    
    NSLog(@"%@",self.xarr);
    
    // Apply the gradient to the bottom portion of the graph
    self.myGraph.gradientBottom = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    
    self.myGraph.formatStringForValues = @"%.2f";
    
    _myGraph.backgroundColor = [UIColor grayColor];
    
    _myGraph.enableTouchReport = YES;
    
    _myGraph.enablePopUpReport = YES;
    
    _myGraph.enableYAxisLabel = YES;
    
    _myGraph.autoScaleYAxis = YES;
    
    _myGraph.enableReferenceXAxisLines = YES;
    
    _myGraph.enableReferenceYAxisLines = YES;
    
    _myGraph.enableReferenceAxisFrame = YES;
    
    _myGraph.alwaysDisplayDots = YES;
    
    self.myGraph.animationGraphStyle = BEMLineAnimationDraw;
    
    self.myGraph.lineDashPatternForReferenceYAxisLines = @[@(2),@(2)];
    
    //232 232 232 colorWithRed:232.0/255 green:232.0/255 blue:232.0/255 alpha:1.0   0 255 255
    _myGraph.colorTop = [UIColor whiteColor];
    
    _myGraph.colorBottom = [UIColor colorWithRed:232.0/255 green:232.0/255 blue:232.0/255 alpha:1.0];
    
    _myGraph.colorLine = BLUECOLOR;
    
    _myGraph.colorPoint = BLUECOLOR;
    
    _myGraph.colorXaxisLabel = [UIColor blackColor];
    
    _myGraph.colorYaxisLabel = [UIColor blackColor];
    
    _myGraph.colorBackgroundYaxis = [UIColor whiteColor];
    
    _myGraph.colorBackgroundXaxis=[UIColor whiteColor];
    
    _myGraph.colorReferenceLines = [UIColor blackColor];
    
    self.myGraph.translatesAutoresizingMaskIntoConstraints=NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.myGraph attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.myGraph attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-15]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.myGraph attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.SplitLineView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:20]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.myGraph attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-54]];
    
    NSLog(@"%lf",self.myGraph.bounds.size.height);
    
}

- (int)getDays:(NSString *)theDate {
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *d=[date dateFromString:theDate];
    
    NSLog(@"%@",d);
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    //获取当前系统时间
    NSDate *adate = [NSDate date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: adate];
    
    NSDate *localeDate = [adate  dateByAddingTimeInterval: interval];
    
    NSTimeInterval now=[localeDate timeIntervalSince1970]*1;
    
    NSString *timeString = @"";
    
    NSLog(@"mainViewCtr:%@", localeDate);
    
    NSTimeInterval cha = now-late;
    
    timeString = [NSString stringWithFormat:@"%f", cha/86400];
    
    timeString = [timeString substringToIndex:timeString.length-7];
    
    int iDays = [timeString intValue];
    
    return iDays;
}

#pragma ---
#pragma mark --- CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    
    //如果调用已经一次，不再执行
    CLLocation *currentLocation = [locations lastObject];
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error){
        
        if (array.count > 0){
            
            CLPlacemark *placemark = [array objectAtIndex:0];
            
            //将获得的所有信息显示到label上
            NSString *city = placemark.locality;
            
            NSLog(@"%@",city);
            
            if (!city) {
                
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
                
            }
            
            self.cityName = city;
            
        } else if (error == nil && [array count] == 0) {
            
            NSLog(@"No results were returned.");
            
        } else if (error != nil) {
            
            NSLog(@"An error occurred = %@", error);
        }
        
        if (self.first == 0){
            
            [self getWeatherInfo];
            
        }
        
        self.first++;
    }];
    
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
    
}

- (void)getWeatherInfo {
    
    if (_cityName!=nil) {
        
        NSDictionary *param = @{ @"cityname" : _cityName};
        
        JHAPISDK *jhapi = [JHAPISDK shareJHAPISDK];
        
        [jhapi executeWorkWithAPI:jhPath
                            APIID:jhAppID
                       Parameters:param
                           Method:jhMethod
                          Success:^(id responseObject) {
                              
                              NSLog(@"%@", responseObject);
                              
                              if ([[responseObject valueForKey:@"result"] isKindOfClass:[NSNull class]]) return;
                              
                              NSString *cityName =[[[[responseObject valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"realtime"] valueForKey:@"city_name"];
                              
                              NSString *img =[[[[[responseObject valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"realtime"] valueForKey:@"weather"] valueForKey:@"img"];
                              
                              if (![img isKindOfClass:[NSNull class]]) {
                                  
                                  if ([img intValue] < 10) {
                                      
                                      img = [NSString stringWithFormat:@"0%@",img];
                                  }
                              }
                              
                              NSLog(@"img:%@",img);
                              
                              NSString *maxTem = [[[[[responseObject valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"weather"][0] valueForKey:@"info"] valueForKey:@"day"][2];
                              
                              NSString *minTem = [[[[[responseObject valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"weather"][0] valueForKey:@"info"] valueForKey:@"night"][2];
                              
                              NSString *pm25 = [[[[[responseObject valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"pm25"] valueForKey:@"pm25"] valueForKey:@"curPm"];
                              
                              NSString *pm25Index = [[[[[responseObject valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"pm25"] valueForKey:@"pm25"] valueForKey:@"quality"];
                              
                              _pm25 = [[NSString alloc] init];
                              
                              _pm25 = pm25Index;
                              
                              [self.weatherCityLabel setText:cityName];
                              
                              [self.weatherTemperatureLabel setText:[NSString stringWithFormat:@"%@ ~ %@ ℃",maxTem,minTem]];
                              
                              [self.weatherPM25Label setText:pm25Index];
                              
                              UIImage *weatherImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",img]];
                              
                              [self.weatherImageView setImage:weatherImage];
                              
                              [self calculateMoreAge];//将pm2.5数据计算加至天龄
                
                          }
         
                          Failure:^(NSError *error) {
                              
                              NSLog(@"error:%@",error);
                              
                          }];
    }
}

//将pm2.5数据计算加至天龄
- (void)calculateMoreAge {
    
    NSString *sumDay=@"0";//总加减天数
    
    if ([self.pm25 isEqualToString:@"优"]) {
        
        sumDay=@"+0.05";
        
    } else if ([self.pm25 isEqualToString:@"良"]) {
        
        sumDay=@"+0.03";
        
    } else if ([self.pm25 isEqualToString:@"轻度污染"]) {
        
        sumDay=@"+0.00";
        
    } else if ([self.pm25 isEqualToString:@"中度污染"]) {
        
        sumDay=@"-0.02";
        
    } else if ([self.pm25 isEqualToString:@"重度污染"]) {
        
        sumDay=@"-0.05";
        
    } else if ([self.pm25 isEqualToString:@"严重污染"]) {
        
        sumDay=@"-0.10";
        
    }
    
    jk *j = [[jk alloc] init];
    
    j.sumDay=sumDay;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showAlertView{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"本模块暂未开放，敬请期待" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
    [alert show];
    
}

#pragma ---
#pragma mark ----BEMSimpleLineGraphDataSource/BEMSimpleLineGraphDelegate

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    
    return self.xarr.count;
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index //y点值  曲线值
{
    return [[self.dayarr objectAtIndex:index] floatValue];
}

- (NSString*)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    return [NSString stringWithFormat:@"%@",self.xarr[index]];
}

- (NSInteger)numberOfYAxisLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    if (self.dayarr.count<=7) {
        return 4;
    }else{
        return 1;
    }
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
