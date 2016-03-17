//
//  CityViewController.m
//  30000day
//
//  Created by GuoJia on 16/3/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "CityViewController.h"

@interface CityViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"城市的选择";
    self.searchBar.placeholder = @"输入城市名";
}

#pragma ---
#pragma mark --- UITableViewDataSource / UITableViewDelegate




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
