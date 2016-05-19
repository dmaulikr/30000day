//
//  AddRemindViewController.h
//  30000day
//
//  Created by GuoJia on 16/2/22.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ShowBackItemViewController.h"

@interface AddRemindViewController : ShowBackItemViewController

@property (nonatomic,strong) RemindModel *oldModel;//这个如果是空表示用户点击的是上面增加提醒按钮,如果不为空表示用户点击的是cell进来的

@property (nonatomic,assign) BOOL changeORAdd;//yes:是表示是来修改的,修改的需要把原来的RemindModel传过来  no:表示是来新增的,新增的不需要

@end
