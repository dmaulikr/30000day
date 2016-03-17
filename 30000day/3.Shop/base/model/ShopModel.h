//
//  ShopModel.h
//  30000day
//
//  Created by GuoJia on 16/3/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopModel : NSObject

@property (nonatomic,copy) NSString *addrCity;

@property (nonatomic,copy) NSString *addrNear;

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
