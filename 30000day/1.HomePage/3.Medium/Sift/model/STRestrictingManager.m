//
//  STRestrictingManager.m
//  30000day
//
//  Created by GuoJia on 16/8/24.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STRestrictingManager.h"
#import "STFriendsViewController.h"
#import "PersonInformationsManager.h"

@implementation STRestrictingManager

//添加人
+ (void)addMemberFromController:(UIViewController *)viewController
                         userId:(NSNumber *)userId
                         status:(NSNumber *)status
                           type:(NSNumber *)type
          informationModelArray:(NSMutableArray <UserInformationModel *>*)informationModelArray
                       callBack:(void (^)(BOOL success,NSError *error))callBack {
    
    if ([Common isObjectNull:userId]) {//如果用户ID不存在，则返回
        callBack(NO,[Common errorWithString:@"用户ID不存在"]);
        return;
    }
    
    STFriendsViewController *controller = [[STFriendsViewController alloc] init];
    controller.title = @"添加(不显示已有成员)";
    
    //过滤已有的成员
    NSMutableArray *dataArray = [NSMutableArray arrayWithArray:[PersonInformationsManager shareManager].informationsArray];
    NSMutableArray *indexArray = [NSMutableArray array];//用来暂时存储标记的model
    
    for (int i = 0; i < dataArray.count; i++) {
        
        UserInformationModel *model = dataArray[i];

        for (int j = 0; j < informationModelArray.count; j++) {
            UserInformationModel *subModel = informationModelArray[j];
            if ([subModel.userId isEqualToNumber:model.userId]) {
                [indexArray addObject:model];
                break;//打断循环
            }
        }
    }
    
    [dataArray removeObjectsInArray:indexArray];
    controller.userModelArray = dataArray;//拿到之前赋值的
    [viewController.navigationController pushViewController:controller animated:YES];
    
    __weak typeof(controller) weakController = controller;
    //添加好友入群
    [controller setDoneBlock:^(UIViewController *viewController, NSMutableArray *memberClientIdArray, NSMutableArray *modifiedArray) {
        
        for (int i = 0; i < informationModelArray.count; i++) {
            UserInformationModel *model = informationModelArray[i];
            [memberClientIdArray addObject:[NSString stringWithFormat:@"%@",model.userId]];
        }
        
        NSString *string = @"";
        for (int i = 0; i < memberClientIdArray.count; i++) {
            if ( i == memberClientIdArray.count - 1) {//最后一个
                string = [string stringByAppendingString:memberClientIdArray[i]];
            } else {
                string = [string stringByAppendingString:[NSString stringWithFormat:@"%@,",memberClientIdArray[i]]];
            }
        }
        
        [STDataHandler sendSetWemediaSwitchWithUserId:userId
                                               status:status
                                                 type:type
                                              userIds:string
                                              success:^(BOOL success) {
                                                  
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      callBack(YES,nil);
                                                      [weakController.navigationController popViewControllerAnimated:YES];
                                                  });
                                              }
                                              failure:^(NSError *error) {
                                                  
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      callBack(NO,error);
                                                  });
                                                  
                                              }];
    }];
}

//踢人
+ (void)removeMemberFromController:(UIViewController *)viewController
                            userId:(NSNumber *)userId
                            status:(NSNumber *)status
                              type:(NSNumber *)type
             informationModelArray:(NSMutableArray <UserInformationModel *>*)informationModelArray
                          callBack:(void (^)(BOOL success,NSError *error))callBack {
    
    if ([Common isObjectNull:userId]) {//如果用户ID不存在，则返回
        callBack(NO,[Common errorWithString:@"用户ID不存在"]);
        return;
    }
    
    STFriendsViewController *controller = [[STFriendsViewController alloc] init];
    controller.title = @"移除(显示已有成员)";
    controller.userModelArray = informationModelArray;//拿到之前赋值的
    [viewController.navigationController pushViewController:controller animated:YES];
    
    __weak typeof(controller) weakController = controller;
    //添加好友入群
    [controller setDoneBlock:^(UIViewController *viewController, NSMutableArray *memberClientIdArray, NSMutableArray *modifiedArray) {
        
        NSMutableArray *userIdArray = [[NSMutableArray alloc] init];
        for (int i = 0 ; i < informationModelArray.count; i++) {
            UserInformationModel *model = informationModelArray[i];
            [userIdArray addObject:[NSString stringWithFormat:@"%@",model.userId]];
        }
        
        [userIdArray removeObjectsInArray:memberClientIdArray];
        
        NSString *string = @"";
        for (int i = 0; i < userIdArray.count; i++) {
            if ( i == userIdArray.count - 1) {//最后一个
                string = [string stringByAppendingString:userIdArray[i]];
            } else {
                string = [string stringByAppendingString:[NSString stringWithFormat:@"%@,",userIdArray[i]]];
            }
        }
        
        [STDataHandler sendSetWemediaSwitchWithUserId:userId
                                               status:status
                                                 type:type
                                              userIds:string
                                              success:^(BOOL success) {
                                                  
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      callBack(YES,nil);
                                                      [weakController.navigationController popViewControllerAnimated:YES];
                                                  });
                                              }
                                              failure:^(NSError *error) {
                                                  
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      callBack(NO,error);
                                                  });
                                                  
                                              }];
        
    }];
}

@end
