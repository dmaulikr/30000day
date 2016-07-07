//
//  SportInformationModel.h
//  30000day
//
//  Created by WeiGe on 16/7/7.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SportInformationModel : NSObject

@property (nonatomic,assign) NSInteger stepNumber; //步数

@property (nonatomic,assign) CGFloat distance; //运动距离

@property (nonatomic,assign) CGFloat calorie;  //消耗的卡路里

@property (nonatomic,assign) NSInteger time; //运动时间

@end
