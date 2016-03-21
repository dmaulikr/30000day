//
//  ShopModel.h
//  30000day
//
//  Created by GuoJia on 16/3/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopModel : NSObject

@property (nonatomic,copy) NSString *productName;//产品名称

@property (nonatomic,copy) NSString *productCode;//产品编码

@property (nonatomic,strong) NSNumber *productTypePid;//一级分类

@property (nonatomic,strong) NSNumber *productTypeId;//二级分类

@property (nonatomic,strong) NSNumber *presentPrice;//现价

@property (nonatomic,copy) NSString *productKeyword;//产品关键词

@property (nonatomic,copy) NSString *productPhoto;//产品图片url

@property (nonatomic,copy) NSString *remark;//备注

@property (nonatomic,copy) NSString *graphicDetails;//图文详情

@property (nonatomic,copy) NSString *purchaseNotice;//购买须知

@property (nonatomic,strong) NSNumber *productRebateID;


@end
