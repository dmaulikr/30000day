//
//  PriceModel.h
//  30000day
//
//  Created by GuoJia on 16/4/28.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriceModel : NSObject

@property (nonatomic,copy) NSString *originalPrice;

@property (nonatomic,copy) NSString *currentPrice;

@property (nonatomic,strong) NSMutableArray *activityList;

@end
