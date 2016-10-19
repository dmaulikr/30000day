//
//  SportInformationModel.h
//  30000day
//
//  Created by WeiGe on 16/7/7.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SportInformationModel : NSObject

@property (nonatomic,strong) NSNumber *lastMaxID; //本地唯一标示

@property (nonatomic,strong) NSNumber *sportId; //服务器唯一标示

@property (nonatomic,strong) NSNumber *userId; //用户ID

@property (nonatomic,strong) NSNumber *steps; //步数

@property (nonatomic,copy) NSString *distance; //运动距离

@property (nonatomic,copy) NSString *calorie;  //消耗的卡路里

@property (nonatomic,copy) NSString *period; //运动时长

@property (nonatomic,copy) NSString *xcoordinate; //坐标x

@property (nonatomic,copy) NSString *ycoordinate; //坐标y

@property (nonatomic,copy) NSString *startTime; //开始时间

@property (nonatomic,strong) NSNumber *isSave; //是否保存至服务器

@property (nonatomic,strong) NSString *sportNo; //本地数据库编号

@end
