//
//  SearchVersionManager.m
//  30000day
//
//  Created by GuoJia on 16/5/13.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SearchVersionManager.h"
#import "STLocationMananger.h"

static SearchVersionManager *manager;

@implementation SearchVersionManager

+ (SearchVersionManager *)shareManager {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[SearchVersionManager alloc] init];
        
    });
    
    return manager;
}

- (void)synchronizedDataFromServer {
    
    [SearchVersionManager sendSearchTableVersion:^(NSMutableArray *dataArray) {
        
        NSMutableArray *oldArray = [self decodeObject];
        
        if (oldArray.count == 0 || oldArray == nil) {
            
            //同步省-城市-区、县的数据
            [[STLocationMananger shareManager] synchronizedLocationDataFromServer];
            
            [self encodeDataObject:dataArray];
            
        } else {
            
            if (oldArray.count == dataArray.count) {
                
                for (int i = 0; i < oldArray.count; i++) {
                    
                    SearchTableVersion *oldVersion = oldArray[i];
                    
                    SearchTableVersion *newVersion = dataArray[i];
                    
                    if (![oldVersion.version isEqualToString:newVersion.version] && [oldVersion.tableName isEqualToString:newVersion.tableName] && [oldVersion.searchTableVersionId isEqualToNumber:@1]) {//城市的表

                        //同步省-城市-区、县的数据
                        [[STLocationMananger shareManager] synchronizedLocationDataFromServer];
                        
                        [self encodeDataObject:dataArray];
                        
                    } else if (![oldVersion.version isEqualToString:newVersion.version] && [oldVersion.tableName isEqualToString:newVersion.tableName] && [oldVersion.searchTableVersionId isEqualToNumber:@2]) {//健康因子
                        
                        
                        
                    } else if (![oldVersion.version isEqualToString:newVersion.version] && [oldVersion.tableName isEqualToString:newVersion.tableName] && [oldVersion.searchTableVersionId isEqualToNumber:@3]) {//健康因子的条件
                        
                        
                        
                    }
                }
            }

        }
        
    } failure:^(NSError *error) {
        
    }];
}

//*********************************获取后台数据表格跟新版本信息*************************/
+ (void)sendSearchTableVersion:(void (^)(NSMutableArray *dataArray))success
                       failure:(void (^)(NSError *error))failure {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ST_API_SERVER,GET_SEARCHTABLEVERSIION]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    request.HTTPMethod = @"GET";
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (connectionError) {//链接出现问题
            
            failure(connectionError);
            
        } else {//链接没有问题
            
            NSError *localError = nil;
            
            id parsedObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&localError];
            
            if (localError == nil) {
                
                NSDictionary *recvDic = (NSDictionary *)parsedObject;
                
                if ([recvDic[@"code"] isEqualToNumber:@0]) {
                    
                    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
                    
                    NSArray *array = recvDic[@"value"];
                    
                    for (int i = 0; i < array.count; i++) {
                        
                        NSDictionary *dictionary = array[i];
                        
                        SearchTableVersion *commentModel = [[SearchTableVersion alloc] init];
                        
                        [commentModel setValuesForKeysWithDictionary:dictionary];
                        
                        [dataArray addObject:commentModel];
                        
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
                    
                    failure(localError);
                    
                });
            }
        }
    }];
}

@end

@implementation SearchTableVersion

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"id"]) {
        
        self.searchTableVersionId = value;
    }
}

#pragma mark --- NSCoding的协议
- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if ([self init]) {
        
        self.searchTableVersionId = [aDecoder decodeObjectForKey:@"searchTableVersionId"];
        
        self.tableName = [aDecoder decodeObjectForKey:@"tableName"];
        
        self.version = [aDecoder decodeObjectForKey:@"version"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.searchTableVersionId forKey:@"searchTableVersionId"];
    
    [aCoder encodeObject:self.tableName forKey:@"tableName"];
    
    [aCoder encodeObject:self.version forKey:@"version"];
}

@end
