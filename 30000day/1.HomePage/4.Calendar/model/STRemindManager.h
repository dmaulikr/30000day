//
//  STRemindManager.h
//  30000day
//
//  Created by GuoJia on 16/2/23.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemindModel.h"
#import "RemindObject.h"

@interface STRemindManager : NSObject

+ (STRemindManager *)shareRemindManager;

//1.增加一条数据
- (BOOL)addObject:(RemindModel *)model;

//2.修改
- (BOOL)changeObjectWithOldModel:(RemindModel *)oldModel willChangeModel:(RemindModel *)newModel;

//3.删除一条数据
- (BOOL)deleteOjbectWithModel:(RemindModel *)model;

//6.删除若干数据-数组里装的是model
- (BOOL)deleteOjbectWithArray:(NSMutableArray *)modelArray;

//4.用userId获取所有的RemindModel
- (NSMutableArray *)allRemindModelWithUserId:(NSNumber *)userId;

//5.用userI和特定的date来获取到所有的RemindModel
- (NSMutableArray *)allRemindModelWithUserId:(NSNumber *)userId dateString:(NSString *)dateString;

@end
