//
//  userInfoViewController.h
//  30000天
//
//  Created by wei on 16/1/19.
//  Copyright © 2016年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoViewController : ShowBackItemViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

//要求:
//1.如果没有修改东西，那么保存按钮不可用
//2.如果修改了东西，但是没点击保存按钮，那么在此进人次界面的话，用户信息要和原来的一样
