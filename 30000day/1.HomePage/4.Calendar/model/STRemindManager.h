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

//1.修改或者增加
- (BOOL)changeORAddObject:(RemindModel *)model;

//2.删除一条数据
- (void)deleteOjbectWithModel:(RemindModel *)model;

//3.用userId获取所有的RemindModel
- (NSMutableArray *)allRemindModelWithUserId:(NSNumber *)userId;

@end
