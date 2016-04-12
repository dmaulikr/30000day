//
//  ShopModel.h
//  30000day
//
//  Created by GuoJia on 16/3/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopModel : NSObject

@property (nonatomic,copy)   NSString *productName;//产品名称

@property (nonatomic,strong) NSNumber *presentPrice;//现价

@property (nonatomic,strong) NSNumber *originalPrice;//原价

@property (nonatomic,copy)   NSString *productPhoto;//产品图片url

@property (nonatomic,strong) NSNumber *productId;//商品Id

@property (nonatomic,copy)   NSString *productCode;//产品编码

@property (nonatomic,copy)   NSString *address;//产品地址

@property (nonatomic,copy)   NSString *productKeyWord;//产品关键字

@property (nonatomic,strong) NSNumber *twoPointsDistance;//离我的距离

@property (nonatomic,strong) NSNumber *avgNumberStar;//评分

@property (nonatomic,strong) NSNumber *longitude;//经度

@property (nonatomic,strong) NSNumber *latitude;//维度

@end
