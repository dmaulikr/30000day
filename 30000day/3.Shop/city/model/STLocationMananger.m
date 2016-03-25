//
//  STLocationMananger.m
//  30000day
//
//  Created by GuoJia on 16/3/24.
//  Copyright © 2016年 GuoJia. All rights reserved.
//  写入文件的本地缓存

#import "STLocationMananger.h"
#import "ProvinceModel.h"

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
    
    [self sendPlaceSuccess:^(NSMutableArray *provinceArray) {
        
        if (provinceArray.count) {
            
            [self encodeDataWithProvinceArray:provinceArray];
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
                
                    for (int i = 0; i < array.count; i++) {
                        
                        ProvinceModel *model = [[ProvinceModel alloc] init];
                        
                        NSDictionary *dataDictionary = array[i];
    
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
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

- (void)encodeDataWithProvinceArray:(NSMutableArray *)provinceArray {
    
    NSMutableData *data = [[NSMutableData alloc] init];
    
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];

    [archiver encodeObject:provinceArray forKey:@"provinceArray"];

    [archiver finishEncoding];
    
    [data writeToFile:[self getFilePath] options:NSUTF8StringEncoding error:nil];
}

- (NSString *)getFilePath {
    
    return [NSHomeDirectory() stringByAppendingPathComponent:@"provinceArray.src"];
}

- (NSMutableArray *)decodeProvinceArray {
    
    NSMutableData *data = [NSMutableData dataWithContentsOfFile:[self getFilePath]];

    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    NSMutableArray *provinceArray = [unArchiver decodeObjectForKey:@"provinceArray"];
    
    return provinceArray;
}

- (NSMutableArray *)getHotCity {
    
    return nil;
}



@end
