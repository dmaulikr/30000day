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

//- (NSString *)postChangePasswordWithPassword:(NSString *)newpassword
//                                 phoneNumber:(NSString *)phonenumber
//                                  verifyCode:(NSString *)verifycode
//                                     success:(void (^)(id responseObject))success
//                                     failure:(void (^)(LONetError *))failure {
//    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
//    [parameters addParameter:phonenumber forKey:@"mobile_phone_no"];
//    [parameters addParameter:newpassword forKey:@"new_password"];
//    [parameters addParameter:verifycode forKey:@"verify_code"];
//    
//    LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodPost
//                                                        url:CHANGE_PASSWORD_PATH
//                                                 parameters:parameters
//                                                    success:^(id responseObject) {
//                                                        
//                                                        success(responseObject);
//                                                        
//                                                    } failure:^(LONetError *error) {
//                                                        failure(error);
//                                                    }];
//    request.needHeaderAuthorization = YES;
//    request.requestSerializerType = LORequestSerializerTypeJSON;
//    return [self startRequest:request];
//
//}

//- (NSString *)getRecordCountIfSuccess:(void (^)(id responseObject))success
//                              failure:(void (^)(LONetError *))failure {
//    LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodPost
//                                                        url:GET_RECORD_COUNT
//                                                 parameters:nil
//                                                    success:^(id responseObject) {
//                                                        
//                                                        success(responseObject);
//                                                        
//                                                    } failure:^(LONetError *error) {
//                                                        failure(error);
//                                                    }];
//    request.needHeaderAuthorization = YES;
//    request.requestSerializerType = LORequestSerializerTypeJSON;
//    return [self startRequest:request];
//}


//**** 获取好友 *****/
- (NSString *)getMyFriendsWithPassword:(NSString *)password
                             loginName:(NSString *)loginName
                               success:(void (^)(id responseObject))success
                               failure:(void (^)(LONetError *))failure {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters addParameter:loginName forKey:@"LoginName"];
    
    [parameters addParameter:password forKey:@"LoginPassword"];
    
        LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodGet
                                                            url:GET_MY_FRIENDS
                                                     parameters:parameters
                                                        success:^(id responseObject) {
                                                            
                                                            NSError *localError = nil;
                                                            
                                                            id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                            
                                                            NSArray  *array = (NSArray *)parsedObject;
                                                            
                                                            NSMutableArray *dataArray = [NSMutableArray array];
                                                            
                                                            for (NSDictionary *dictionary in array) {
                                                                
                                                                FriendListInfo *listInfo = [[FriendListInfo alloc] init];
                                                                
                                                                [listInfo setValuesForKeysWithDictionary:dictionary];
                                                                
                                                                [dataArray addObject:listInfo];
                                                            }
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                success(dataArray);
                                                            });
                                                            
                                                        } failure:^(LONetError *error) {
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                    failure(error);
                                                            });
                                                            
                                                        }];
        request.needHeaderAuthorization = NO;
    
        request.requestSerializerType = LORequestSerializerTypeJSON;
    
        request.responseSerializerType = LOResponseTypeJSON;
    
        return [self startRequest:request];
    
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


@end
