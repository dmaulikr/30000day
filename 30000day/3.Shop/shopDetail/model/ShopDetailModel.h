//
//  ShopDetailModel.h
//  30000day
//
//  Created by wei on 16/3/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopDetailModel : NSObject

@property (nonatomic,copy) NSString *addrCity;          //城市地址
@property (nonatomic,copy) NSString *addrNear;          //地址附近
@property (nonatomic,copy) NSString *addrProvince;      //地址省
@property (nonatomic,copy) NSString *address;           //地址
@property (nonatomic,copy) NSString *alias;             //别名
@property (nonatomic,copy) NSString *busInfo;           //公交信息
@property (nonatomic,copy) NSString *businessTime;      //业务时间
@property (nonatomic,copy) NSString *companyName;       //公司名
@property (nonatomic,copy) NSString *shopDetailId;      //公司ID
@property (nonatomic,copy) NSString *telephone;         //公司电话
@property (nonatomic,copy) NSString *type1;             //类型

@end
