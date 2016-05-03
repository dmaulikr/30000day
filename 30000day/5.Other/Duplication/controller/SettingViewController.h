//
//  SettingViewController.h
//  30000day
//
//  Created by GuoJia on 16/5/3.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ShowBackItemViewController.h"

@interface SettingViewController : ShowBackItemViewController

@property (nonatomic,copy) NSString *showTitle;

@property (nonatomic,copy) void (^doneBlock)(NSString *changedTitle);//点击完成和保存回调

@end
