//
//  LogPwd.h
//  30000天
//
//  Created by wei on 15/9/17.
//  Copyright (c) 2015年 wei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogPwd : NSObject
@property (nonatomic,strong)NSString* log;
@property (nonatomic,strong)NSString* pwd;
+(LogPwd*)sharedLogPwd;

@end
