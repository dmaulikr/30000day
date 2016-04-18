//
//  STApiRequest.h
//  30000day
//
//  Created by GuoJia on 16/4/16.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STRequest.h"

@interface STApiRequest : STRequest

+ (STApiRequest *)requestWithMethod:(STRequestMethod)requestMethod
                                url:(NSString *)requesturl
                         parameters:(id)parameters
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(STNetError *error))failure;


+ (STApiRequest *)requestWithMethod:(STRequestMethod)requestMethod
                                url:(NSString *)requesturl
                         parameters:(id)parameters
              constructingBodyBlock:(AFConstructingBlock)constructingBodyBlock
                           progress:(LORequestProgressBlock)progress
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(STNetError *error))failure;
@end
