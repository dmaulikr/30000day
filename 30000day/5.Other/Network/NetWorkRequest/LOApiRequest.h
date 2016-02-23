//
//  LOApiRequest.h
//  30000day
//
//  Created by GuoJia on 15/12/11.
//  Copyright © 2015年 GuoJia. All rights reserved.
//

#import "LORequest.h"

@interface LOApiRequest : LORequest

+ (LOApiRequest *)requestWithMethod:(LORequestMethod)requestMethod
                                url:(NSString *)requesturl
                         parameters:(id)parameters
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(LONetError *error))failure;


+ (LOApiRequest *)requestWithMethod:(LORequestMethod)requestMethod
                                url:(NSString *)requesturl
                         parameters:(id)parameters
              constructingBodyBlock:(AFConstructingBlock)constructingBodyBlock
                           progress:(LORequestProgressBlock)progress
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(LONetError *error))failure;

@end
