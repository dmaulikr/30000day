//
//  STLocationMananger.m
//  30000day
//
//  Created by GuoJia on 16/3/24.
//  Copyright © 2016年 GuoJia. All rights reserved.
//  写入文件的本地缓存

#import "STLocationMananger.h"

@interface STLocationMananger ()

@end

@implementation STLocationMananger

+ (STLocationMananger *)shareManager {
    
    static STLocationMananger *manager;
    
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
       
        manager = [[STLocationMananger alloc] init];
        
    });
    
    return manager;
}

- (void)synchronizedLocationDataFromServer {
    
    [self sendPlaceSuccess:^(NSMutableArray *dataArray) {
        
        if (dataArray.count > 0) {
        
        }
        
    } failure:^(NSError *error) {
        
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
                        
//                        DataModel *model = [[DataModel alloc] init];
//                        
//                        NSDictionary *dataDictionary = array[i];
//                        
//                        [model setValuesForKeysWithDictionary:dataDictionary];
//                        
//                        [dataArray addObject:model];
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

- (void)encodeDataWithLocationModel:(LocationModel *)model {
    
    NSMutableData *data = [[NSMutableData alloc] init];
    
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    //3.用该归档对象，把自定义类的对象，转为二进制流
    [archiver encodeObject:model forKey:@"locationManager"];
    //4归档完毕
    [archiver finishEncoding];
    
    [data writeToFile:[self getFilePath] atomically:YES];
}

- (NSString *)getFilePath {
    
    return [NSHomeDirectory() stringByAppendingPathComponent:@"locationManager.src"];
}

- (LocationModel *)decodeData {
    
    NSMutableData *data = [NSMutableData dataWithContentsOfFile:[self getFilePath]];
    //2.创建一个反归档对象，将二进制数据解成正行的oc数据
    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    LocationModel *model = [unArchiver decodeObjectForKey:@"locationManager"];
    
    return model;
}

- (NSMutableArray *)getHotCity {
    
    LocationModel *model =  [self decodeData];
    
    return nil;
}



@end
