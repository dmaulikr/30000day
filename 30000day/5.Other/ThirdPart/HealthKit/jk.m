//
//  jk.m
//  30000天
//
//  Created by wei on 15/11/9.
//  Copyright © 2015年 wei. All rights reserved.
//

#import "jk.h"

@interface jk () {
    
    HKHealthStore *healthStore;
}

@property (nonatomic,strong)UserProfile *userProfile;

@end

@implementation jk


- (id) init {
    
    if (self = [super init]) {
        
        healthStore = [[HKHealthStore alloc] init];
        
        NSSet *readDataTypes = [self dataTypesToRead];
        
        [healthStore requestAuthorizationToShareTypes:nil readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
            if (success) {
                _userProfile = [UserAccountHandler shareUserAccountHandler].userProfile;
                
                [self GetHealthUserDateOfBirth];
                
            } else {
                
                NSLog(@"设备不支持_%@", error);
            }
        }];
        
        NSLog(@"%@",self.sumDay);
    }
    
    return self;
}



- (NSSet *)dataTypesToWrite {
    
    HKQuantityType *stepCountType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    HKQuantityType *activeEnergyBurnType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    
    HKQuantityType *heightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    
    HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    
    HKObjectType *sexType = [HKObjectType quantityTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex];
    
    HKQuantityType *bloodType = [HKQuantityType quantityTypeForIdentifier:HKCharacteristicTypeIdentifierBloodType];
    
    HKQuantityType *jl = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    
    return [NSSet setWithObjects: activeEnergyBurnType, heightType, weightType,sexType,stepCountType,bloodType,jl, nil];
}

//2.2、读取数据的权限
// Returns the types of data that Fit wishes to read from HealthKit.
- (NSSet *)dataTypesToRead {
    
    HKQuantityType *stepCountType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    HKQuantityType *heightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    
    HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    
    HKQuantityType* lo=[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierFlightsClimbed];
    
    HKQuantityType *jl = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    
    return [NSSet setWithObjects: heightType, weightType,stepCountType,lo,jl, nil];
    
}

//3、获取商店共享的数据比如：身高、体重、年龄
//获取步数
- (void)GetHealthUserDateOfBirth {
    
    NSLog(@"%@",self.sumDay);
    
    HKQuantityType *type = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    NSCalendar* calender=[NSCalendar currentCalendar];
    
    NSDate* now=[NSDate date];
    
    NSDateComponents* components=[calender components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    
    NSDate* stardate=[calender dateFromComponents:components];
    
    NSDate* enddate=[calender dateByAddingUnit:NSCalendarUnitDay value:1 toDate:stardate options:0];
    
    NSPredicate* predicate=[HKQuery predicateForSamplesWithStartDate:stardate endDate:enddate options:HKQueryOptionStrictStartDate];
    
    HKStatisticsQuery* squery=[[HKStatisticsQuery alloc]initWithQuantityType:type quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery * _Nonnull query, HKStatistics * _Nullable result, NSError * _Nullable error) {
        HKQuantity* quantiy=result.sumQuantity;
        NSInteger stepCount=[quantiy doubleValueForUnit:[HKUnit countUnit]];
        self.StepCount=[NSString stringWithFormat:@"%ld",(long)stepCount];
        NSLog(@"%ld",(long)stepCount);
        [self Getpalou];
    }];
    
    [healthStore executeQuery:squery];
}

//获取爬楼梯
- (void)Getpalou {
    
    HKQuantityType *type = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierFlightsClimbed];
    
    NSCalendar *calender = [NSCalendar currentCalendar];
    
    NSDate *now = [NSDate date];
    
    NSDateComponents *components=[calender components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    
    NSDate *stardate = [calender dateFromComponents:components];
    
    NSDate *enddate = [calender dateByAddingUnit:NSCalendarUnitDay value:1 toDate:stardate options:0];
    
    //搜索谓词
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:stardate endDate:enddate options:HKQueryOptionStrictStartDate];
    
    //获取某段时间的爬楼梯步数
    HKStatisticsQuery *squery = [[HKStatisticsQuery alloc]initWithQuantityType:type quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery * _Nonnull query, HKStatistics * _Nullable result, NSError * _Nullable error) {
        
        HKQuantity *quantiy = result.sumQuantity;
        
        NSInteger stepCount = [quantiy doubleValueForUnit:[HKUnit countUnit]];
        
        self.FloorCount = [NSString stringWithFormat:@"%ld",(long)stepCount];
        
        NSLog(@"%ld",(long)stepCount);
        
        [self zlpb];
    }];
    
    [healthStore executeQuery:squery];
    
}

//获取运动距离
- (void)zlpb {
    
    HKQuantityType *type = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    
    NSCalendar *calender = [NSCalendar currentCalendar];
    
    NSDate *now = [NSDate date];
    
    NSDateComponents *components = [calender components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    
    NSDate *stardate=[calender dateFromComponents:components];
    
    NSDate *enddate=[calender dateByAddingUnit:NSCalendarUnitDay value:1 toDate:stardate options:0];
    
    NSPredicate* predicate=[HKQuery predicateForSamplesWithStartDate:stardate endDate:enddate options:HKQueryOptionStrictStartDate];
    
    //搜索某段时间的运动步数
    HKStatisticsQuery *squery = [[HKStatisticsQuery alloc]initWithQuantityType:type quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery * _Nonnull query, HKStatistics * _Nullable result, NSError * _Nullable error) {
        
        HKQuantity *quantiy = result.sumQuantity;
        
        CGFloat stepCount = [quantiy doubleValueForUnit:[HKUnit meterUnit]];
        
        self.ExerciseDistance = [NSString stringWithFormat:@"%f",stepCount];
        
        NSLog(@"%lf",stepCount);
        
        [self GetHealthUserWeight];
        
    }];
    
    [healthStore executeQuery:squery];
    
}

- (void)GetHealthUserWeight {
    
    HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    
    [self fetchMostRecentDataOfQuantityType:weightType withCompletion:^(HKQuantity *mostRecentQuantity, NSError *error) {
        
        NSLog(@"==读取成功==%@",mostRecentQuantity);
        
        self.Weight = [NSString stringWithFormat:@"%@",mostRecentQuantity];
    }];
    
    [self GetHealthUserHeight];
}

- (void)GetHealthUserHeight {
    
    NSLengthFormatter *lengthFormatter = [[NSLengthFormatter alloc] init];
    
    lengthFormatter.unitStyle = NSFormattingUnitStyleLong;
    
    NSLengthFormatterUnit heightFormatterUnit = NSLengthFormatterUnitInch;
    
    NSString *str3 = [lengthFormatter unitStringFromValue:10 unit:heightFormatterUnit];
    
    HKQuantityType *heightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    
    [self fetchMostRecentDataOfQuantityType:heightType withCompletion:^(HKQuantity *mostRecentQuantity, NSError *error) {
        
        if (error) {
            
            NSLog(@"读取用户的身高错误 ，错误原因:%@",error);
            //            abort();
        } else {
            
            NSLog(@"-读取成功-%@",mostRecentQuantity);
            
            self.Height=[NSString stringWithFormat:@"%@",mostRecentQuantity];
        }
        
        double userHeight = 0.0;
        
        if (mostRecentQuantity) {
            
            HKUnit *heightUnit = [HKUnit inchUnit];
            
            userHeight = [mostRecentQuantity doubleValueForUnit:heightUnit];
            
            userHeight = userHeight*2.5;
            
            NSLog(@"%f",userHeight);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *str4 = [NSNumberFormatter localizedStringFromNumber:@(userHeight) numberStyle:NSNumberFormatterNoStyle];
                
            });
        }
    }];
    
    [self bcdata];
}

- (void)fetchMostRecentDataOfQuantityType:(HKQuantityType *)quantityType withCompletion:(void(^)(HKQuantity *mostRecentQuantity, NSError *error))completion
{
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:quantityType predicate:nil limit:1 sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery *query,NSArray *results,NSError *error) {
        
        HKQuantitySample *quantitySample = results.firstObject;
        
        HKQuantity *quantity = quantitySample.quantity;
        
        //好一个回调
        completion(quantity,error);
    }];
    
    [healthStore executeQuery:query];
}

//登陆保存健康数据
-(void)bcdata{
    // (截取最后4个 拼上新数据)  注册那边也要拼上    mstableview 那边  先查询上次的数据  保存基数与运动量  修改的时候先那基数去减 再减总天数 再拼上基数与运动量   （显示保存本地  点击获取行数与字符串 数组的count等于总行数 每次点击替换  保存之后再保存本地）
    //先查询上次数据  判断是不是今天的数据 如果是今天的数据就拿今天的运动量-上次的运动量=总运动量  不是则取本次数据  然后拼上 上次的基数以及SubFators与SubResults
    NSDate *  senddate=[NSDate date];//当前时间
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString* locationString=[dateformatter stringFromDate:senddate];
    NSLog(@"%@",locationString);
    
    CGFloat result=0;//每天最终总的加减量
    NSString* subResults=[[NSString alloc]init];//每个因素天龄的加减量
    NSString* subFators=[[NSString alloc]init]; //加减因素
    NSInteger bs=[self.StepCount integerValue];//步数
    NSInteger lt=[self.FloorCount integerValue];//楼梯
    CGFloat jl=[self.ExerciseDistance floatValue];//运动距离
    
    //查询上次保存健康因素 去掉旧pm2.5 步数 爬楼 运动距离 保留AvearageLife基数 拼接新数据
    NSString * URLString = @"http://116.254.206.7:12580/M/API/GetLatestUserLifeStatDetails?";
    NSURL * URL = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSString * postString = [NSString stringWithFormat:@"howManyDays=%d&userID=%@&loginname=%@&loginpassword=%@",1,_userProfile.UserID,_userProfile.LoginName,_userProfile.LoginPassword];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"post"];
    [request setURL:URL];
    [request setHTTPBody:postData];
    
    NSURLResponse * response;
    NSError * error;
    NSData * backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        NSLog(@"error : %@",[error localizedDescription]);
    }else{
        NSArray* backDataArr=[NSJSONSerialization JSONObjectWithData:backData options:NSJSONReadingAllowFragments error:&error];
        NSDictionary* backDataDic=backDataArr[0];
        if (backDataDic!=nil) {
            NSLog(@"%@",backDataDic);
            CGFloat sumDay=[backDataDic[@"TotalLife"] floatValue];
            NSInteger tag=[backDataDic[@"Tag"] integerValue];//1表示当天 0表示昨天
            NSMutableArray *SubFatorsArr =[NSMutableArray arrayWithArray:[backDataDic[@"SubFators"] componentsSeparatedByString:@","]];
            NSMutableArray *SubSubResults =[NSMutableArray arrayWithArray:[backDataDic[@"SubResults"] componentsSeparatedByString:@","]];
            NSString* SubResultsString=backDataDic[@"SubResultsString"];
            NSString* AvearageLife=[SubSubResults lastObject];
            
            NSString* newSubFators=[[NSString alloc]init];
            NSString* newSubResults=[[NSString alloc]init];
            //上次总运动量pm25的总加减
            CGFloat SumMotion=0;
            if (SubSubResults.count>=5) {
                CGFloat pm25=[SubSubResults[SubSubResults.count-5] floatValue];
                CGFloat StepCount=[SubSubResults[SubSubResults.count-4] floatValue];
                CGFloat FloorCount=[SubSubResults[SubSubResults.count-3] floatValue];
                CGFloat ExerciseDistance=[SubSubResults[SubSubResults.count-2] floatValue];
                SumMotion=pm25+StepCount+FloorCount+ExerciseDistance;
            }
            
            
            if (SubFatorsArr.count>5) {
                for (int i=0; i<5; i++) {
                    [SubFatorsArr removeLastObject];
                    [SubSubResults removeLastObject];
                }
                for (int i=0; i<SubFatorsArr.count; i++) {
                    if (i==0) {
                        newSubFators=[newSubFators stringByAppendingString:SubFatorsArr[i]];
                        newSubResults=[newSubResults stringByAppendingString:SubSubResults[i]];
                    }else{
                        newSubFators=[newSubFators stringByAppendingString:[NSString stringWithFormat:@",%@",SubFatorsArr[i]]];
                        newSubResults=[newSubResults stringByAppendingString:[NSString stringWithFormat:@",%@",SubSubResults[i]]];
                    }
                }
                subFators=newSubFators;
                subResults=newSubResults;
                subFators=[subFators stringByAppendingString:@","];
                subResults=[subResults stringByAppendingString:@","];
            }
            NSLog(@"%@",subFators);
            NSLog(@"%@",newSubResults);
            
            subFators=[subFators stringByAppendingString:@"pm25"];
            subResults=[subResults stringByAppendingString:[NSString stringWithFormat:@"%.2lf",result]];
            
            if (bs<=2000){
                result=result+0.00;
                subResults=[subResults stringByAppendingString:@",0.00"];
            }if (bs>=3000) {
                result=result+0.02;
                subResults=[subResults stringByAppendingString:@",0.02"];
            }else if (bs>=5000) {
                result=result+0.05;
                subResults=[subResults stringByAppendingString:@",0.05"];
            }else if (bs>=7000) {
                result=result+0.8;
                subResults=[subResults stringByAppendingString:@",0.08"];
            }
            
            subFators=[subFators stringByAppendingString:@",StepCount"];
            
            if(lt>=20){
                result=result+0.03;
                subResults=[subResults stringByAppendingString:@",0.03"];
            }else{
                result=result+0.00;
                subResults=[subResults stringByAppendingString:@",0.00"];
            }
            subFators=[subFators stringByAppendingString:@",FloorCount"];
            
            if(jl>=5000){
                result=result+0.08;
                subResults=[subResults stringByAppendingString:@",0.08"];
            }else if(jl>=3000){
                result=result+0.03;
                subResults=[subResults stringByAppendingString:@",0.03"];
            }if(jl<=2000){
                result=result+0.00;
                subResults=[subResults stringByAppendingString:@",0.00"];
            }
            subFators=[subFators stringByAppendingString:@",ExerciseDistance"];
            //if 今天
            if (tag) {
                result=result-SumMotion;
            }
            //else 昨天
            
            subFators=[subFators stringByAppendingString:@",AvearageLife"];
            subResults=[subResults stringByAppendingString:[NSString stringWithFormat:@",%@",AvearageLife]];
            sumDay=sumDay+result;
            
            
            NSString *URLString=@"http://116.254.206.7:12580/M/API/WriteUserLifeForEachDay?";
            NSURL * URL = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
            
            NSString *param=[NSString stringWithFormat:@"loginName=%@&loginPassword=%@&sumDay=%@&result=%@&date=%@&subFators=%@&subResults=%@&SubResultsString=%@",_userProfile.LoginName,_userProfile.LoginPassword,[NSString stringWithFormat:@"%.2lf",sumDay],[NSString stringWithFormat:@"%.2f",result] ,locationString,subFators,subResults,SubResultsString];
            
            NSLog(@"%@",param);
            
            NSData * postData = [param dataUsingEncoding:NSUTF8StringEncoding];
            [request setHTTPMethod:@"post"];
            [request setURL:URL];
            [request setHTTPBody:postData];
            
            NSURLResponse * response;
            NSError * error;
            NSData * backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            if (error) {
                //访问服务器失败进此方法
                NSLog(@"error : %@",[error localizedDescription]);
            }else{
                //成功访问服务器
                NSLog(@"response : %@",response);
                NSLog(@"backData : %@",[[NSString alloc]initWithData:backData encoding:NSUTF8StringEncoding]);
                NSLog(@"error:%@",error);
            }
        }
    }
}

/*-(void)bcdata{
    CGFloat sumDay=[self returnSumDay];
    if (sumDay<=0) return;
 
    UserInfo* user=[TKAddressBook shareControl].userInfo;
    NSDate *  senddate=[NSDate date];//当前时间
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString* locationString=[dateformatter stringFromDate:senddate];
 
    CGFloat result=[_sumDay floatValue];//每天最终总的加减量
    NSString* subResults=[[NSString alloc]init];//每个因素天龄的加减量
    NSString* subFators=[[NSString alloc]init];//加减因素
    subFators=@"pm25";
    subResults=[subResults stringByAppendingString:[NSString stringWithFormat:@"+%.2lf",result]];
    NSInteger bs=[self.StepCount integerValue];
    NSInteger lt=[self.FloorCount integerValue];
    CGFloat jl=[self.ExerciseDistance floatValue];
    
    if (bs>=7000) {
        result=result+0.1;
        subResults=[subResults stringByAppendingString:@",+0.08"];
    }else if (bs>=5000) {
        result=result+0.05;
        subResults=[subResults stringByAppendingString:@",+0.05"];
    }else if (bs>=3000) {
        result=result+0.02;
        subResults=[subResults stringByAppendingString:@",+0.02"];
    } if (bs<=2000){
        result=result+0.00;
        subResults=[subResults stringByAppendingString:@",+0.00"];
    }
    
    subFators=[subFators stringByAppendingString:[NSString stringWithFormat:@",StepCount%ld",(long)bs]];
    
    if(lt>=20){
        result=result+0.03;
        subResults=[subResults stringByAppendingString:@",+0.03"];
    }else{
        result=result+0.00;
        subResults=[subResults stringByAppendingString:@",+0.00"];
    }
    subFators=[subFators stringByAppendingString:[NSString stringWithFormat:@",FloorCount%ld",(long)lt]];
    
    if(jl>=5000){
        result=result+0.08;
        subResults=[subResults stringByAppendingString:@",+0.08"];
    }else if(jl>=3000){
        result=result+0.03;
        subResults=[subResults stringByAppendingString:@",+0.03"];
    }if(jl<=2000){
        result=result+0.00;
        subResults=[subResults stringByAppendingString:@",+0.00"];
    }
    subFators=[subFators stringByAppendingString:[NSString stringWithFormat:@",ExerciseDistance%f",jl]];
    sumDay=sumDay+result;
    
    NSString *URLString=@"http://116.254.206.7:12580/M/API/WriteUserLifeForEachDay?";
    NSURL * URL = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    NSString *param=[NSString stringWithFormat:@"loginName=%@&loginPassword=%@&sumDay=%@&result=%@&date=%@&subFators=%@&subResults=%@",user.LoginName,user.LoginPassword,[NSString stringWithFormat:@"%.2lf",sumDay],[NSString stringWithFormat:@"%.2f",result] ,locationString,subFators,subResults];
    
    NSData * postData = [param dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"post"];
    [request setURL:URL];
    [request setHTTPBody:postData];
    
    NSURLResponse * response;
    NSError * error;
    NSData * backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error) {
        NSLog(@"error : %@",[error localizedDescription]);
    }else{
        NSLog(@"response : %@",response);
        NSLog(@"backData : %@",[[NSString alloc]initWithData:backData encoding:NSUTF8StringEncoding]);
        NSLog(@"error:%@",error);
    }
}*/

//-(CGFloat)returnSumDay{
//    CGFloat sumDay=0.0;
//    NSString * URLString = @"http://116.254.206.7:12580/M/API/GetLatestUserLifeStatDetails?";
//    NSURL * URL = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    
//    NSString * postString = [NSString stringWithFormat:@"howManyDays=%d&userID=%@&loginname=%@&loginpassword=%@",2,_user.UserID,_user.LoginName,_user.LoginPassword];
//    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
//    [request setHTTPMethod:@"post"];
//    [request setURL:URL];
//    [request setHTTPBody:postData];
//    
//    NSURLResponse * response;
//    NSError * error;
//    NSData * backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    if (error) {
//        NSLog(@"error : %@",[error localizedDescription]);
//    }else{
//        NSArray* backDataArr=[NSJSONSerialization JSONObjectWithData:backData options:NSJSONReadingAllowFragments error:&error];
//        if (backDataArr!=nil) {
//            NSDictionary* backDataDic=backDataArr[1];
//            sumDay=[backDataDic[@"TotalLife"] floatValue];
//        }
//    }
//    
//    return sumDay;
//}
@end
