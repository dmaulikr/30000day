//
//  GetFactorModel.h
//  30000day
//  从服务器获取的健康因子
//  Created by GuoJia on 16/2/20.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SubFactorModel;

@interface GetFactorModel : NSObject

@property (nonatomic , strong) NSNumber *factorId;

@property (nonatomic , copy) NSString *title;

@property (nonatomic,strong) NSMutableArray *subFactorArray;//表示点击后出现的选项模型

@property (nonatomic ,strong)SubFactorModel *userSubFactorModel;//用户设置的subFactorModel

/**
  *
  * 用一个subFactorId 来取得subFactorArray里面SubFactorModel的一个string
  *
  **/

+ (NSString *)titleStringWithDataNumber:(NSNumber *)subFactorId subFactorArray:(NSMutableArray *)subFactorArray;

/**
 *
 * 用一个string 来取得subFactorArray里面SubFactorModel模型里面的一个subFactorId
 *
 **/

+ (NSNumber *)subFactorIdWithTitleString:(NSString *)string subFactorArray:(NSMutableArray *)subFactorArray;

@end

@interface SubFactorModel : NSObject

@property (nonatomic,strong)   NSNumber *subFactorId;

@property (nonatomic , strong) NSNumber *factorId;

@property (nonatomic , copy)  NSString *title;

@end