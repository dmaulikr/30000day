//
//  jk.h
//  30000天
//
//  Created by wei on 15/11/9.
//  Copyright © 2015年 wei. All rights reserved.
//

#import <Foundation/Foundation.h>
@import HealthKit;
@interface jk : NSObject
@property(nonatomic,strong)NSString* StepCount;//步数
@property(nonatomic,strong)NSString* ExerciseDistance;//运动距离
@property(nonatomic,strong)NSString* FloorCount;//爬楼
@property(nonatomic,strong)NSString* Height;//身高
@property(nonatomic,strong)NSString* Weight;//体重
@property(nonatomic,strong)NSString* sumDay;
@end
