//
//  ShopDetailModel.h
//  30000day
//
//  Created by wei on 16/3/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopDetailModel : NSObject

@property (nonatomic,copy) NSString *graphicDetails;       //细节
@property (nonatomic,copy) NSString *shopDetailId;         //商店详情ID
@property (nonatomic,copy) NSString *originalPrice;        //原价
@property (nonatomic,copy) NSString *presentPrice;         //现价
@property (nonatomic,copy) NSString *productCode;          //商品编码
@property (nonatomic,copy) NSString *productKeyword;       //产品关键词
@property (nonatomic,copy) NSString *productName;          //产品名称
@property (nonatomic,copy) NSString *productPhoto;         //产品照片
@property (nonatomic,copy) NSString *productRebateID;      //产品折扣标识
@property (nonatomic,copy) NSString *productTypeId;        //产品类型标识
@property (nonatomic,copy) NSString *productTypePName;     //产品类型名称
@property (nonatomic,copy) NSString *productTypePid;       //产品类型ID
@property (nonatomic,copy) NSString *purchaseNotice;       //购买须知
@property (nonatomic,copy) NSString *remark;               //注意
@property (nonatomic,copy) NSString *startTime;            //开始时间
@property (nonatomic,copy) NSString *telephone;            //电话

@end
