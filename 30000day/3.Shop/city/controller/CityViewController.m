//
//  CityViewController.m
//  30000day
//
//  Created by GuoJia on 16/3/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "CityViewController.h"
#import "CityHeadView.h"
#import "CityTableViewCell.h"
#import "STLocationMananger.h"

@interface CityViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"城市的选择";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 108) style:UITableViewStyleGrouped];

    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    self.searchBar.placeholder = @"输入城市名";
}

#pragma ---
#pragma mark --- UITableViewDataSource / UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityTableViewCell"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CityTableViewCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        CityHeadView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CityHeadView"];
        
        if (!view) {
            
            view = [[CityHeadView alloc] init];
        }
        view.cityArray = [NSMutableArray arrayWithArray:@[@"上海",@"北京",@"广州",@"深圳",@"天津",@"南京",@"杭州",@"合肥",@"水电费",@"发广告",@"东方闪"]];
        
        [view setButtonActionBlock:^(NSUInteger index) {
           
            NSLog(@"----%d",(int)index);
            
        }];

        return view;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return [CityHeadView cityHeadViewHeightWithButtonCount:10];
}

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
