//
//  SearchConditionModel.h
//  30000day
//
//  Created by GuoJia on 16/3/21.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchConditionModel : NSObject

@property (nonatomic,copy) NSString *cityName;//城市

@property (nonatomic,copy) NSString *provinceName;//省

//***********以下两个只能二者选其一*********//
@property (nonatomic,copy) NSString *businessCircle;//商圈
@property (nonatomic,copy) NSString *regional;//地区
//*************************************//
@property (nonatomic,copy) NSString *subwayStation;//地铁站
//******************************************//

@property (nonatomic,strong) NSNumber *sequence;//排序：0默认排序，1评分最高 2离我最近【该参数2的时候，必须传递location】 3价格从低到高排序   4价格从高到低排序  类型:int（可选

@property (nonatomic,strong) NSNumber *longitude;//经度
@property (nonatomic,strong) NSNumber *latitude;//维度

@property (nonatomic,strong) NSNumber *sift;//筛选: 0默认，1健身场馆，2体检中心，3医院，4孕产机构，5家政机构，6育儿培训机构 类型：int  （可选）

@property (nonatomic,copy)  NSString *searchContent;

@end
