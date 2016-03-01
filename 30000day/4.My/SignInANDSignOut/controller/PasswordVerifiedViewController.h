//
//  SecondPwd.h
//  30000天
//
//  Created by wei on 15/9/16.
//  Copyright (c) 2015年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewPasswordViewController.h"


@interface PasswordVerifiedViewController: ShowBackItemViewController

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (nonatomic,copy) NSDictionary *PasswordVerifiedDic;

@end
