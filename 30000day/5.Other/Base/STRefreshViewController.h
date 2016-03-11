//
//  STRefreshViewController.h
//  30000day
//
//  Created by GuoJia on 16/3/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STBaseViewController.h"
#import "MJRefresh.h"

typedef enum {
    
    STRefreshTableViewPlain,
    STRefreshTableViewGroup
    
}STRefreshTableViewStyle;

@interface STRefreshViewController : STBaseViewController

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) STRefreshTableViewStyle tableViewStyle;

- (void)headerRefreshing;

- (void)footerRereshing;


@end
