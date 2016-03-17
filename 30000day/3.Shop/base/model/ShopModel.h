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

@property (nonatomic,copy) NSString *addrProvince;

@property (nonatomic,copy) NSString *address;

@property (nonatomic,copy) NSString *alias;

@property (nonatomic,copy) NSString *busInfo;

@property (nonatomic,copy) NSString *businessTime;

@property (nonatomic,copy) NSString *companyName;

@property (nonatomic,strong) NSNumber *shopId;

@property (nonatomic,copy) NSString *telephone;

@property (nonatomic,copy) NSString *type1;

@end
