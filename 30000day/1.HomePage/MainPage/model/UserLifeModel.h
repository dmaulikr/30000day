//
//  UserLifeModel.h
//  30000day
//  用户天龄模型
//  Created by GuoJia on 16/2/19.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserLifeModel : NSObject

@property (nonatomic ,copy)  NSString   *createTime;//创建时间

@property (nonatomic ,strong) NSNumber *curLife;//当前剩余的天龄

@property (nonatomic ,strong) NSNumber *lastChgLife;//上次减少的天龄

@property (nonatomic ,strong) NSNumber *userId;//用户id

@end
