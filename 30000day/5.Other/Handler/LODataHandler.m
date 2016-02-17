//
//  LODataHandler.m
//  LianjiaOnlineApp
//
//  Created by GuoJia on 15/12/10.
//  Copyright © 2015年 GuoJia. All rights reserved.
//

#import "LODataHandler.h"
#import "LORequest.h"
#import "LOApiRequest.h"
#import "LONetworkAgent.h"
#import "STBaseViewController.h"
#import "FriendListInfo.h"
#import <AddressBook/AddressBook.h>
#import "AddressBookModel.h"
#import "ChineseString.h"
#import "WeatherInformationModel.h"

//定位头文件
#import <CoreLocation/CoreLocation.h>

//聚合头文件
#import "JHAPISDK.h"
#import "JHOpenidSupplier.h"

@interface NSMutableDictionary (Parameter)

- (void)addParameter:(id)param forKey:(NSString *)key;

@end

@implementation NSMutableDictionary (Parameter)

- (void)addParameter:(id)param forKey:(NSString *)key {
    
    if (param) {
        
        [self setObject:param forKey:key];
        
    }
}

@end


@interface LODataHandler () <CLLocationManagerDelegate>

@property (nonatomic ,copy) void (^(addressBookBlock))(NSMutableArray *,NSMutableArray *,NSMutableArray *);//获取电话簿的回调代码块

@property (nonatomic,strong)CLLocationManager *locationManager;

@property (nonatomic,copy) void (^(getLocationBlock))(NSString *);//获取地理位置和城市名称的回调代码块

@property (nonatomic,copy) void (^(getLocationErrorBlock))(NSError *);//获取地理位置和城市名称出错回调代码块

@end


@implementation LODataHandler

- (id)init {
    
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

// 开始一个请求，并将请求 Hash 值插入回 BaseViewController
- (NSString *)startRequest:(LORequest *)request {
    
    NSString *requestHash = [[LONetworkAgent sharedAgent] addRequest:request];
    
    if ([(STBaseViewController *)self.delegate respondsToSelector:@selector(requestRecord)]) {
        
        [[(STBaseViewController *)self.delegate requestRecord] addObject:requestHash];
        
    }
    
    return requestHash;
}

// 试图将错误交回给 BaseViewController 预处理
- (void)preHandleLONetError:(LONetError *)error failureBlock:(void (^)(LONetError *))failure {
    
    if ([(STBaseViewController *)self.delegate respondsToSelector:@selector(handleLONetError:)]) {
        
        [(STBaseViewController *)self.delegate handleLONetError:error];
    }
    
    if (failure) {
        
        failure(error);
        
    }
}

#pragma mark ---- 以下封装的是app所用到的所有接口

//***** 发送验证请求 *****/
- (void)getVerifyWithPhoneNumber:(NSString *)phoneNumber
                               success:(void (^)(NSString *responseObject))success
                               failure:(void (^)(NSString *error))failure {
    
        NSString * url = @"http://116.254.206.7:12580/M/API/SendCode?";
    
        url = [url stringByAppendingString:@"&phoneNumber="];
    
        url = [url stringByAppendingString:phoneNumber];
    
        NSMutableString *mUrl = [[NSMutableString alloc] initWithString:url];
    
        NSError *error;
    
        NSString *jsonStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:mUrl] encoding:NSUTF8StringEncoding error:&error];
    
        if ([jsonStr isEqualToString:@"1"]){
    
            success(jsonStr);
            
        } else {
            
            failure(jsonStr);
        }    
}

//*********** 核对短信验证码是否正确 ********/
- (void)postVerifySMSCodeWithPhoneNumber:(NSString *)phoneNumber
                             smsCode:(NSString *)smsCode
                             success:(void (^)(BOOL))success
                             failure:(void (^)(NSError *))failure {
    
    NSString *urlString = @"http://116.254.206.7:12580/M/API/ValidateSmsCode";
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSString *param = [NSString stringWithFormat:@"phoneNumber=%@&validateCode=%@",phoneNumber,smsCode];
    
    NSData * postData = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    
    [request setURL:url];
    
    [request setHTTPBody:postData];
    
    NSURLResponse * response;
    
    NSError * error;
    
    NSData * backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if ([[[NSString alloc] initWithData:backData encoding:NSUTF8StringEncoding] intValue] == 1) {
        
        success(YES);
        
    } else {
        
        failure(error);
        
    }
}

//***** 普通登录 *****/
- (NSString *)postSignInWithPassword:(NSString *)password
                           loginName:(NSString *)loginName
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(LONetError *))failure {
    
     NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters addParameter:loginName forKey:@"LoginName"];
    
    [parameters addParameter:password forKey:@"LoginPassword"];
    
    LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodPost
                                                        url:LOGIN_WITH_PASSWORD
                                                 parameters:parameters
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            UserProfile *userProfile = [[UserProfile alloc] init];
                                                            
                                                            [userProfile setValuesForKeysWithDictionary:recvDic];
                                                            
                                                            //保存用户上次登录的账号,同时也会更新用户信息
                                                            [[UserAccountHandler shareUserAccountHandler] saveUserAccountWithModel:userProfile];
                                                            
                                                            success(responseObject);
                                                            
                                                        } else {
                                                            
                                                            LONetError *error = [LONetError errorWithAFHTTPRequestOperation:nil NSError:localError];
                                                            
                                                             failure(error);
                                                        }
                                                        
                                                    } failure:^(LONetError *error) {
                                                        
                                                        failure(error);
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = LORequestSerializerTypeJSON;
    
    return [self startRequest:request];
}

//********** 用户注册 ************/
- (void)postRegesiterWithPassword:(NSString *)password
                            phoneNumber:(NSString *)phoneNumber
                               nickName:(NSString *)nickName
                              loginName:(NSString *)loginName
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *))failure {
    
    NSString *URLString = @"http://116.254.206.7:12580/M/API/Register?";
    
    NSURL * URL = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    
    NSString *param=[NSString stringWithFormat:@"LoginName=%@&LoginPassword=%@&NickName=%@&PhoneNumber=%@",loginName,password,nickName,phoneNumber];
    
    NSData * postData = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    
    [request setURL:URL];
    
    [request setHTTPBody:postData];
    
    NSURLResponse * response;
    
    NSError * error;
    
    NSData * backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            failure(error);
        });
        
    } else {
        
        NSLog(@"response : %@",response);
        
        NSLog(@"backData : %@",[[NSString alloc] initWithData:backData encoding:NSUTF8StringEncoding]);
    }
    
    if ([[[NSString alloc] initWithData:backData encoding:NSUTF8StringEncoding] intValue] == 1) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            success(backData);
        });
        
    } else {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            failure(error);
        });
    }

}

//**** 获取好友 *****/
- (void)getMyFriendsWithPassword:(NSString *)password
                             loginName:(NSString *)loginName
                               success:(void (^)(NSMutableArray * dataArray))success
                               failure:(void (^)(NSError *))failure {

    NSString * url = @"http://116.254.206.7:12580/M/API/GetMyFriends?";
    
    url = [url stringByAppendingString:@"LoginName="];
    
    url = [url stringByAppendingString:loginName];
    
    url = [url stringByAppendingString:@"&LoginPassword="];
    
    url = [url stringByAppendingString:password];
    
    NSMutableString *mUrl = [[NSMutableString alloc] initWithString:url];
    
    NSError *error;
    
    NSString *jsonStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:mUrl] encoding:NSUTF8StringEncoding error:&error];
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    
    NSDictionary * dict = [jsonParser objectWithString:jsonStr error:nil];
    
    if (dict != nil) {
        
        NSMutableArray *array = [NSMutableArray array];
        
        for (NSDictionary *dic in dict) {
            
            FriendListInfo *ff = [[FriendListInfo alloc] init];
            
            [ff setValuesForKeysWithDictionary:dic];
            
            [array addObject:ff];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
          success(array);
        });
    } else {
        
        failure([[NSError alloc] init]);
    }
    
}

//***** 更新个人信息 *****/
- (void)postUpdateProfileWithUserID:(NSString *)userID
                                 Password:(NSString *)password
                                loginName:(NSString *)loginName
                                 NickName:(NSString *)nickName
                                   Gender:(NSString *)gender
                                 Birthday:(NSString *)birthday
                                  success:(void (^)(BOOL))success
                                  failure:(void (^)(NSError *))failure {
    
        NSString *URLString= @"http://116.254.206.7:12580/M/API/UpdateProfile?";
    
        NSURL * URL = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    
        NSString *param=[NSString stringWithFormat:@"UserID=%@&LoginName=%@&LoginPassword=%@&NickName=%@&Gender=%d&Birthday=%@",userID,loginName,password,nickName,[gender intValue],birthday];
    
        NSData * postData = [param dataUsingEncoding:NSUTF8StringEncoding];
    
        [request setHTTPMethod:@"post"];
    
        [request setURL:URL];
    
        [request setHTTPBody:postData];
    
        NSURLResponse * response;
    
        NSError * error;
    
        NSData * backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
        if (error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                failure(error);
                
            });
            
        } else {
            
            if ([[[NSString alloc] initWithData:backData encoding:NSUTF8StringEncoding] intValue]==1) {
                
               
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                     success(YES);
                    
                });
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    failure(error);
                    
                });
            }
        }
}


//******* 保存默认健康因素  ************/
- (void)postUpdateHealthDataWithPassword:(NSString *)password
                               loginName:(NSString *)loginName
                                cityName:(NSString *)cityName
                                 success:(void (^)(BOOL))success
                                 failure:(void (^)(NSError *))failure {
    
    if ([cityName isEqualToString:@""] || cityName == nil) {
        
        cityName = @"北京";
        
    } else {
        
        cityName = [cityName substringToIndex:cityName.length - 1];//去掉市
    }
    
    NSString *ProvinceLifeExpectancyMan = [[NSBundle mainBundle] pathForResource:@"ProvinceLifeExpectancyMan" ofType:@"plist"];
    
    NSDictionary* citydic = [[NSDictionary alloc] initWithContentsOfFile:ProvinceLifeExpectancyMan];
    
    NSInteger yeardate = [citydic[cityName] integerValue];
    
    NSInteger AvearageLife = [self AverageLifeToDay:yeardate];//默认基数
    
    NSMutableArray *UserDayArr = [[NSMutableArray alloc] initWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",
                                  @"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",
                                  @"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    
    UserDayArr[0] = [NSString stringWithFormat:@"+%ld",(long)AvearageLife];
    
    NSArray *Elements = [NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",
                         @"5",@"6",@"7",@"8",@"9",
                         @"10",@"11",@"12",@"13",@"14",
                         @"15",@"16",@"17",@"18",@"19",
                         @"20",@"21",@"22",@"23",@"24",@"25",@"26",nil];
    
    //用户选项
    NSString *SubResultsString = [NSString stringWithFormat:@"%@,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,",cityName];
    
    //因素
    NSString *ElementsStr = [[NSString alloc] init];
    
    NSString *UserAlternative = [[NSString alloc] init];
    
    for (int i = 0; i< Elements.count; i++) {
        
        if (i == 0) {
            
            ElementsStr = [ElementsStr stringByAppendingString:[NSString stringWithFormat:@"%@",Elements[i]]];
            
            UserAlternative = [UserAlternative stringByAppendingString:[NSString stringWithFormat:@"%@",UserDayArr[i]]];
            
        } else {
            
            ElementsStr = [ElementsStr stringByAppendingString:[NSString stringWithFormat:@",%@",Elements[i]]];
            
            UserAlternative = [UserAlternative stringByAppendingString:[NSString stringWithFormat:@",%@",UserDayArr[i]]];
        }
    }
    
    ElementsStr = [ElementsStr stringByAppendingString:@",pm25,StepCount,FloorCount,ExerciseDistance,AvearageLife"];
    
    //用户选择因素
    UserAlternative = [UserAlternative stringByAppendingString:[NSString stringWithFormat:@",0,0,0,0,%ld",(long)AvearageLife]];
    
    //AvearageLife 为初始的默认平均寿命基数
    NSDate *senddate = [NSDate date];//当前时间
    
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *locationString = [dateformatter stringFromDate:senddate];//系统当前时间
    
    NSString *resultstring = [NSString stringWithFormat:@"%ld",(long)AvearageLife];
    
    NSString *URLString = @"http://116.254.206.7:12580/M/API/WriteUserLifeForEachDay?";
    
    NSURL *URL = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    NSString *param = [NSString stringWithFormat:@"loginName=%@&loginPassword=%@&sumDay=%ld&result=%@&date=%@&subFators=%@&subResults=%@&SubResultsString=%@",loginName,password,(long)AvearageLife,resultstring,locationString,ElementsStr,UserAlternative,SubResultsString];
    
    NSData *postData = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"post"];
    
    [request setURL:URL];
    
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    
    NSError *error;
    
    NSData *backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            failure(error);
        });
        
    } else {
        
        NSLog(@"response : %@",response);
        
        NSLog(@"backData : %@",[[NSString alloc]initWithData:backData encoding:NSUTF8StringEncoding]);
        
        if ([[[NSString alloc] initWithData:backData encoding:NSUTF8StringEncoding] intValue] == 1) {
            
            [Common saveAppDataForKey:loginName withObject:KEY_SIGNIN_USER_NAME];
            
            [Common saveAppDataForKey:password withObject:KEY_SIGNIN_USER_PASSWORD];
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                 success(YES);
                
            });
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSError *error = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"出现了未知因素"}];
                
                failure(error);
            });
        }
    }
}

//私有API,计算平均寿命的天数
- (NSInteger)AverageLifeToDay:(NSInteger)today {
    
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    [gregorian setFirstWeekday:2];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *fromDate;
    
    NSDate *toDate;
    
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:[self day:today]];
    
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:[NSDate date]];
    
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    
    NSLog(@"%ld",(long)dayComponents.day);
    
    return dayComponents.day;
}

//私有API,现在时间减去平均寿命
- (NSDate *)day:(NSInteger)today {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    
    NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date]];
    
    components.year = components.year - today;
    
    NSString *newdate = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)components.year,(long)components.month,(long)components.day];
    
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    
    [date setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *returndate = [date dateFromString:newdate];
    
    return returndate;
}

//************获取通讯录好友************/
- (void)sendAddressBooklistRequestCompletionHandler:(void(^)(NSMutableArray *,NSMutableArray *,NSMutableArray *))handler {
    
    //保存回调代码块
    self.addressBookBlock = handler;
    
    dispatch_async(dispatch_queue_create("AddressBookModel", DISPATCH_QUEUE_SERIAL), ^{
        
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        
        NSMutableArray *addressBookArray = [NSMutableArray array];
        
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
                
                CFErrorRef *error1 = NULL;
                
                ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error1);
                
                [self copyAddressBook:addressBook addressBookArray:addressBookArray];
            });
            
        } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
            
            CFErrorRef *error = NULL;
            
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
            
            [self copyAddressBook:addressBook addressBookArray:addressBookArray];
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                //[hud turnToError:@"没有获取通讯录权限"];
            });
        }
        
    });
}

//私有Api
- (void)copyAddressBook:(ABAddressBookRef)addressBook addressBookArray:(NSMutableArray *)addressBookArray {

    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    for ( int i = 0; i < numberOfPeople; i++) {
        
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        
        NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        
        NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        
        //读取电话多值
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        for (int k = 0; k < ABMultiValueGetCount(phone); k++ ) {
            
            //获取电话Label
            NSString * personPhoneLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k));
            
            if ([personPhoneLabel isEqualToString:@"住宅"] || [personPhoneLabel isEqualToString:@"手机"]) {
                //获取該Label下的电话值
                NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
                
                NSString *name;
                
                AddressBookModel *bookModel = [[AddressBookModel alloc] init];
                
                if (firstName!= nil && lastName != nil) {
                    
                    name = [lastName stringByAppendingString:firstName];
                }
                
                if (firstName!= nil && lastName == nil) {
                    
                    name = firstName;
                }
                
                if (firstName == nil && lastName != nil) {
                    
                    name = lastName;
                }
                
                bookModel.name = name;
                
                bookModel.mobilePhone = personPhone;
                
                [addressBookArray addObject:bookModel];
                
                break;
            }
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSMutableArray *array =  [ChineseString LetterSortArray:addressBookArray];
        
        NSMutableArray *sortArray = [ChineseString SortArray:addressBookArray];
        
        NSMutableArray *indexArray = [ChineseString IndexArray:addressBookArray];
        
        self.addressBookBlock(array,sortArray,indexArray);
    
    });
}


//***************开始定位操作********************/
- (void)startFindLocationSucess:(void (^)(NSString *))sucess
                        failure:(void (^)(NSError *))failure {
    
    
    self.getLocationBlock = sucess;
    
    self.getLocationErrorBlock = failure;
    
    // 判断定位操作是否被允许
    if ([CLLocationManager locationServicesEnabled]) {
        
        self.locationManager = [[CLLocationManager alloc] init] ;
        
        self.locationManager.delegate = self;
        
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        _locationManager.distanceFilter = 100;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            
            [_locationManager requestWhenInUseAuthorization];
            
        }
        
    } else {
        
        //提示用户无法进行定位操作  Product
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"开启定位功能可查看天气噢！"
                                                          delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        
        return;
    }

    //开始定位
    [_locationManager startUpdatingLocation];
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
            
            if (!city) {
                
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                if (![Common isObjectNull:city]) {
                    
                    self.getLocationBlock(city);//回调
                    
                    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
                    [manager stopUpdatingLocation];
                }
            });
            
        } else if (error == nil && [array count] == 0) {
            
           NSError *newError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"出现了未知因素"}];
            
            self.getLocationErrorBlock(newError);
            
        } else if (error != nil) {
        
            self.getLocationErrorBlock(error);
        }

    }];
    
}


//*****************获取天气情况(代码块返回的是天气模型)***********/
- (void)getWeatherInformation:(NSString *)cityName
                       sucess:(void (^)(WeatherInformationModel *))sucess
                      failure:(void (^)(NSError *))failure {
    
    if (cityName != nil) {
        
        NSDictionary *param = @{ @"cityname" : cityName};
        
        JHAPISDK *jhapi = [JHAPISDK shareJHAPISDK];
        
        [jhapi executeWorkWithAPI:jhPath
                            APIID:jhAppID
                       Parameters:param
                           Method:jhMethod
                          Success:^(id responseObject) {
                              
                              if ([[responseObject valueForKey:@"result"] isKindOfClass:[NSNull class]]) return;
                              
                              NSString *getCityName = [[[[responseObject valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"realtime"] valueForKey:@"city_name"];
                              
                              NSString *img = [[[[[responseObject valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"realtime"] valueForKey:@"weather"] valueForKey:@"img"];
                              
                              if (![img isKindOfClass:[NSNull class]]) {
                                  
                                  if ([img intValue] < 10) {
                                      
                                      img = [NSString stringWithFormat:@"0%@",img];
                                  }
                              }
                              
                              NSString *maxTem = [[[[[responseObject valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"weather"][0] valueForKey:@"info"] valueForKey:@"day"][2];
                              
                              NSString *minTem = [[[[[responseObject valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"weather"][0] valueForKey:@"info"] valueForKey:@"night"][2];
                              
//                              NSString *pm25 = [[[[[responseObject valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"pm25"] valueForKey:@"pm25"] valueForKey:@"curPm"];
                              
                              NSString *pm25Index = [[[[[responseObject valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"pm25"] valueForKey:@"pm25"] valueForKey:@"quality"];
                              
                              WeatherInformationModel *informationModel = [[WeatherInformationModel alloc] init];
                              
                              informationModel.cityName = getCityName;
                              
                              informationModel.temperatureString = [NSString stringWithFormat:@"%@ ~ %@ ℃",maxTem,minTem];
                              
                              informationModel.pm25Quality = pm25Index;
                              
                              informationModel.weatherShowImageString = [NSString stringWithFormat:@"%@.png",img];

                              dispatch_async(dispatch_get_main_queue(), ^{
                                 
                                  sucess(informationModel);
                                  
                              });
                          }
         
                          Failure:^(NSError *error) {
                              
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  
                                  failure(error);
                                  
                              });
                              
                          }];
    }
}

//**********获取用户的天龄**********************/
- (void)getUserLifeStateUserID:(NSString *)userID
                      Password:(NSString *)password
                     loginName:(NSString *)loginName
                       success:(void (^)(NSMutableArray *,NSMutableArray*))success
                       failure:(void (^)(NSError *))failure {
    
    NSString *URLString = @"http://116.254.206.7:12580/M/API/GetLatestUserLifeStat?";
    
    NSURL *URL = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    NSString *param = [NSString stringWithFormat:@"loginName=%@&loginPassword=%@&howManyDays=%d&userID=%d",loginName,password,7,userID.intValue];
    
    NSData *postData = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    
    [request setURL:URL];
    
    [request setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
       
        NSError *localError = nil;
        
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&localError];
        
        if (localError != nil) {
            
            failure(localError);
        }
        
        NSMutableArray *allDayArray = [NSMutableArray array];
        
        NSMutableArray *dayNumberArray = [NSMutableArray array];
        
        for (int i = 0; i< array.count; i++) {
            
            [allDayArray addObject:array[i][@"TotalLife"]];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            [formatter setDateFormat:@"yyyy/MM/dd"];
            
            NSDate *da = [formatter dateFromString:array[i][@"CreateDate"]];
            
            NSDateFormatter *f = [[NSDateFormatter alloc] init];
            
            [f setDateFormat:@"dd"];
            
            NSString *stringday = [NSString stringWithFormat:@"%@",[f stringFromDate:da]];
            
            [dayNumberArray addObject:stringday];
            
        }
        
        if (dayNumberArray.count == 1) {
            
            [dayNumberArray addObject:dayNumberArray[0]];
            
            [allDayArray addObject:allDayArray[0]];
        }
        
        dayNumberArray = (NSMutableArray *)[[dayNumberArray reverseObjectEnumerator] allObjects];//倒序
        
        allDayArray = (NSMutableArray*)[[allDayArray reverseObjectEnumerator] allObjects];//倒序
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            success(allDayArray,dayNumberArray);
            
        });
        
    }];
    
}




@end
