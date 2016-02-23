//
//  RemindModel.h
//  30000day
//
//  Created by GuoJia on 16/2/23.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemindModel : NSObject

@property (nullable, nonatomic, copy) NSString *title;

@property (nullable, nonatomic, copy) NSString *content;

@property (nullable, nonatomic, copy) NSDate *date;

@property (nullable, nonatomic, copy) NSNumber *userId;

@end
