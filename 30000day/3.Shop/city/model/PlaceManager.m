//
//  PlaceManager.m
//  30000day
//
//  Created by GuoJia on 16/3/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "PlaceManager.h"
#import "STCoreDataHandler.h"
#import "DataModel.h"
#import "PlaceObject.h"

@implementation PlaceManager

+ (PlaceManager *)shareManager {
    
    static dispatch_once_t onceToken;
    
    static PlaceManager *manager;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[PlaceManager alloc] init];
        
    });
    
    return manager;
}

- (void)configManagerSuccess:(void (^)(BOOL))success
                     failure:(void (^)(NSError *error))failure {
    
    [[STCoreDataHandler shareCoreDataHandler] configModel:@"PlaceModel" DbFile:@"PlaceModel.sqlite"];
    
    [self sendPlaceSuccess:^(NSMutableArray *dataArray) {
        
        if (dataArray.count > 0) {
            
            [PlaceObject filter:nil orderby:nil offset:0 limit:0 on:^(NSArray *result, NSError *error) {
                
                if (result.count > 0) {
                    
                    for (PlaceObject *object in result) {
                        
                        [PlaceObject delobject:object];
                    }
                }

                for (DataModel *model  in dataArray) {
                    
                    [self addPlaceObject:model];
                    
                }
                
                [PlaceObject save:^(NSError *error) {
                    
                    if (error) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            failure(error);
                        });
            
                    } else {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            success(YES);
                        });

                    }
                    
                }];
            }];
        }
    
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            failure(error);
            
        });
    }];
}

- (void)addPlaceObject:(DataModel *)dataModel {
    
    PlaceObject *object = [PlaceObject createNew];
    
    object.averageLife = dataModel.averageLife;
    
    object.code = dataModel.code;
    
    object.fraction = dataModel.fraction;
    
    object.dataId = dataModel.dataId;
    
    object.level = dataModel.level;
    
    object.name = dataModel.name;
    
    object.pCode = dataModel.pCode;
    
    object.rootCode = dataModel.rootCode;
}

- (void)countyArrayWithCityName:(NSString *)cityName success:(void (^)(NSMutableArray *))success {
    
    [PlaceObject async:^id(NSManagedObjectContext *ctx, NSString *className) {
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:className];
        
        request.predicate = [NSPredicate predicateWithFormat:@"name==%@",cityName];
        
        NSError *error;
        
        NSArray *dataArray = [ctx executeFetchRequest:request error:&error];
        
        if (error) {
            
            return error;
            
        } else {
            
            return dataArray;
        }
        
    } result:^(NSArray *result, NSError *error) {
        
        PlaceObject *object = [result firstObject];
        
        [PlaceObject async:^id(NSManagedObjectContext *ctx, NSString *className) {
           
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:className];
            
            request.predicate = [NSPredicate predicateWithFormat:@"pCode==%@",object.code];
            
            NSError *error;
            
            NSArray *dataArray = [ctx executeFetchRequest:request error:&error];
            
            if (error) {
                
                return error;
                
            } else {
                
                return dataArray;
            }
            
        } result:^(NSArray *result, NSError *error) {
            
            
            NSMutableArray *placeNameArray = [NSMutableArray array];
            
            for (int i = 0; i < result.count; i++) {
                
                PlaceObject *object = result[i];
                
                [placeNameArray addObject:object.name];
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                success(placeNameArray);
                
            });
            
        }];

    }];
    
}

- (void)placeIdWithPlaceName:(NSString *)placeName success:(void (^)(NSNumber *))success {
    
    [PlaceObject async:^id(NSManagedObjectContext *ctx, NSString *className) {
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:className];
        
        request.predicate = [NSPredicate predicateWithFormat:@"name==%@",placeName];
        
        NSError *error;
        
        NSArray *dataArray = [ctx executeFetchRequest:request error:&error];
        
        if (error) {
            
            return error;
            
        } else {
            
            return dataArray;
        }
        
    } result:^(NSArray *result, NSError *error) {
        
        PlaceObject *object = [result firstObject];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            success(object.dataId);
            
        });

    }];
}

//获取省和城市
- (void)sendPlaceSuccess:(void (^)(NSMutableArray *))success
                failure:(void (^)(NSError *error))failure {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ST_API_SERVER,GET_PLACE_LIST]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    request.HTTPMethod = @"GET";
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
       
        if (connectionError) {//链接出现问题
            
            failure(connectionError);
            
        } else {//链接没有问题
            
            NSError *localError = nil;
            
            id parsedObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&localError];
            
            if (localError == nil) {
                
                NSDictionary *recvDictionary = (NSDictionary *)parsedObject;
                
                if ([recvDictionary[@"code"] isEqualToNumber:@0]) {
                    
                    NSArray *array = recvDictionary[@"value"];
                    
                    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
                    
                    for (int i = 0; i < array.count; i++) {
                        
                        DataModel *model = [[DataModel alloc] init];
                    
                        NSDictionary *dataDictionary = array[i];
                        
                        [model setValuesForKeysWithDictionary:dataDictionary];
                    
                        [dataArray addObject:model];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        success(dataArray);
                    });
                    
                } else {
                    
                    NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:parsedObject[@"msg"]}];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        failure(failureError);
                        
                    });
                }
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        failure(localError);
                        
                    });
                    
                });
            }
            
        }
        
    }];

}


- (NSString *)stringValueWithString:(id)value {
    
    return [NSString stringWithFormat:@"%@",value];
    
}

@end
