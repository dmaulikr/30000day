//
//  STGroupNoticeSettingViewController.h
//  30000day
//
//  Created by GuoJia on 16/6/16.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STRefreshViewController.h"

@interface STGroupNoticeSettingViewController : STBaseViewController

@property (nonatomic,assign) BOOL isAdmin;//是否管理者 YES:管理者 NO:不是管理者

@property (nonatomic,copy) NSString *showNotice;//需要显示的公告

@property (nonatomic,copy) void (^doneBlock)(NSString *changedTitle);//点击完成和保存回调

@end
