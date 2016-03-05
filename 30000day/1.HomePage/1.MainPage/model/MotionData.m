//
//  jk.m
//  30000天
//
//  Created by wei on 15/11/9.
//  Copyright © 2015年 wei. All rights reserved.
//

#import "MotionData.h"

@interface MotionData ()
{
    HKHealthStore *healthStore;
}
@end
@implementation MotionData


- (id) init {
    if (self = [super init]) {
        healthStore = [[HKHealthStore alloc] init];
        NSSet *readDataTypes = [self dataTypesToRead];
        [healthStore requestAuthorizationToShareTypes:nil readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
            if (success) {
                NSLog(@"设备支持");
            }else{
                NSLog(@"设备不支持 :%@", error);
            }
        }];
        
    }
    
    return self;
}

//2、读取数据的权限
// Returns the types of data that Fit wishes to read from HealthKit.
- (NSSet *)dataTypesToRead {
    HKQuantityType *stepCountType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    HKQuantityType *stairsCountType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierFlightsClimbed];
    HKQuantityType *movingDistanceCountType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    return [NSSet setWithObjects:stepCountType,stairsCountType,movingDistanceCountType, nil];
}
//获取步数
- (void)getHealthUserDateOfBirthCount:(void (^)(NSString *birthString))success
                              failure:(void (^)(NSError *error))failure{
    
    HKQuantityType *type = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    NSPredicate *predicate=[self timeFunction];
    HKStatisticsQuery *squery = [[HKStatisticsQuery alloc]initWithQuantityType:type quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery * _Nonnull query, HKStatistics * _Nullable result, NSError * _Nullable error) {
        
        if (error != nil) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
            
            return;
        }else{

            HKQuantity *quantiy = result.sumQuantity;
            NSInteger stepCount = [quantiy doubleValueForUnit:[HKUnit countUnit]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                success([NSString stringWithFormat:@"%ld",(long)stepCount]);
            });
        }
    }];
    
    [healthStore executeQuery:squery];
}

//获取爬楼梯
- (void)getClimbStairsCount:(void (^)(NSString *climbStairsString))success
                    failure:(void (^)(NSError *error))failure{
    
    HKQuantityType *type = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierFlightsClimbed];
    NSPredicate *predicate=[self timeFunction];
    
    HKStatisticsQuery *squery = [[HKStatisticsQuery alloc]initWithQuantityType:type quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery * _Nonnull query, HKStatistics * _Nullable result, NSError * _Nullable error) {

        if (error != nil) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
            
            return;
            
        }else{
            
            HKQuantity *quantiy = result.sumQuantity;
            NSInteger stepCount = [quantiy doubleValueForUnit:[HKUnit countUnit]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                success([NSString stringWithFormat:@"%ld",(long)stepCount]);
            });
        }
    }];
    
    [healthStore executeQuery:squery];
}

//获取运动距离
- (void)getMovingDistanceCount:(void (^)(NSString *movingDistanceString))success
                       failure:(void (^)(NSError *error))failure{
    
    HKQuantityType *type = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    NSPredicate *predicate=[self timeFunction];
    
    HKStatisticsQuery *squery = [[HKStatisticsQuery alloc]initWithQuantityType:type quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery * _Nonnull query, HKStatistics * _Nullable result, NSError * _Nullable error) {
        
        if (error != nil) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
            
            return;
            
        }else{
            
            HKQuantity *quantiy = result.sumQuantity;
            CGFloat stepCount = [quantiy doubleValueForUnit:[HKUnit meterUnit]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                success([NSString stringWithFormat:@"%.0f",stepCount]);
            });
        }
    }];
    
    [healthStore executeQuery:squery];
    
}

//4、访问商店的请求方法
- (void)fetchMostRecentDataOfQuantityType:(HKQuantityType *)quantityType withCompletion:(void(^)(HKQuantity *mostRecentQuantity, NSError *error))completion{
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:quantityType predicate:nil limit:1 sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery *query,NSArray *results,NSError *error){
        
        HKQuantitySample *quantitySample = results.firstObject;
        HKQuantity *quantity = quantitySample.quantity;
        
        //好一个回调
        completion(quantity,error);
    }];
    [healthStore executeQuery:query];
}

- (NSPredicate *)timeFunction{
    
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calender components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    NSDate *stardate = [calender dateFromComponents:components];
    NSDate *enddate = [calender dateByAddingUnit:NSCalendarUnitDay value:1 toDate:stardate options:0];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:stardate endDate:enddate options:HKQueryOptionStrictStartDate];
    return predicate;
    
}
@end
