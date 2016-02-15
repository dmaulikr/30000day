//
//  userInfoViewController.h
//  30000天
//
//  Created by wei on 16/1/19.
//  Copyright © 2016年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoViewController : ShowBackItemViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTable;


@end
