//
//  RemindModel.h
//  30000day
//
//  Created by GuoJia on 16/2/23.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemindModel : NSObject

@property (nullable, nonatomic, copy) NSString *title;

@property (nullable, nonatomic, copy) NSString *content;

@property (nullable, nonatomic, copy) NSDate *date;//这个提醒添加的具体时间

@property (nullable, nonatomic, copy) NSNumber *userId;//当前用户的userId

@property (nullable, nonatomic, copy) NSString *dateString;//格式2016-01-12用来查询某一天的提醒

@end
