//
//  STFriendsViewController.h
//  30000day
//
//  Created by GuoJia on 16/6/14.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STRefreshViewController.h"

@interface STFriendsViewController : STRefreshViewController

/**
 * 输入用户信息模型数组
 *
 */
@property (nonatomic,strong) NSMutableArray *userModelArray;

/** 
 * 点击确定回调
 * viewController      当前控制器
 * memberClientIdArray 里面的装的是 @"123456"类型字符串
 * modifiedArray       里面装的是UserInformationModel
 **/
@property (nonatomic,copy) void (^doneBlock)(UIViewController *viewController,NSMutableArray *memberClientIdArray,NSMutableArray *modifiedArray);

@end
