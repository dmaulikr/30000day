//
//  STRestrictingManager.h
//  30000day
//
//  Created by GuoJia on 16/8/24.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STManager.h"

@interface STRestrictingManager : STManager

//添加人
+ (void)addMemberFromController:(UIViewController *)viewController
                         userId:(NSNumber *)userId
                         status:(NSNumber *)status
                           type:(NSNumber *)type
          informationModelArray:(NSMutableArray <UserInformationModel *>*)informationModelArray
                       callBack:(void (^)(BOOL success,NSError *error))callBack;
//踢人
+ (void)removeMemberFromController:(UIViewController *)viewController
                            userId:(NSNumber *)userId
                            status:(NSNumber *)status
                              type:(NSNumber *)type
             informationModelArray:(NSMutableArray <UserInformationModel *>*)informationModelArray
                          callBack:(void (^)(BOOL success,NSError *error))callBack;

@end
