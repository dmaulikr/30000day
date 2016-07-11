//
//  SportInformationModel.h
//  30000day
//
//  Created by WeiGe on 16/7/7.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SportInformationModel : NSObject

@property (nonatomic,strong) NSNumber *lastMaxID; //唯一标示

@property (nonatomic,strong) NSNumber *userId; //用户ID

@property (nonatomic,strong) NSNumber *stepNumber; //步数

@property (nonatomic,strong) NSNumber *distance; //运动距离

@property (nonatomic,strong) NSNumber *calorie;  //消耗的卡路里

@property (nonatomic,strong) NSNumber *time; //运动时间

@property (nonatomic,strong) NSString *x;

@property (nonatomic,strong) NSString *y;

@end
