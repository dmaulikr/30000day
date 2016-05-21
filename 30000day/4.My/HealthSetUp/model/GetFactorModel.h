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

@property (nonatomic,strong) NSMutableArray *subFactorArray;//表示点击后出现的选项模型

@property (nonatomic ,strong)SubFactorModel *userSubFactorModel;//用户设置的subFactorModel

@property (nonatomic,copy) NSString *level;//等级

@property (nonatomic,copy) NSString *factor;//名字

@property (nonatomic,strong) NSNumber *pid;//父id

@property (nonatomic , strong) NSNumber *factorId;

@property (nonatomic , strong) NSNumber *gender;//表示该健康因素男的还是女的，还是共有的

/**
  *
  * 用一个subFactorId 来取得subFactorArray里面SubFactorModel的一个string
  *
  **/

+ (NSString *)titleStringWithDataNumber:(NSNumber *)factorId subFactorArray:(NSMutableArray *)subFactorArray;

/**
 *
 * 用一个string 来取得subFactorArray里面SubFactorModel模型里面的一个subFactorId
 *
 **/

+ (NSNumber *)subFactorIdWithTitleString:(NSString *)string subFactorArray:(NSMutableArray *)subFactorArray;

//获取一组数据,身高，体重，平均每日被动吸烟支数，被动吸烟年数
+ (NSMutableArray *)configFactorModelArray;

@end

@interface SubFactorModel : NSObject

@property (nonatomic,strong)   NSNumber *factorId;

@property (nonatomic , strong) NSNumber *pid;

@property (nonatomic , copy)  NSString *factor;

@end