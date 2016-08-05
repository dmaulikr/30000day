//
//  ProblemTypesViewController.m
//  30000day
//
//  Created by wei on 16/8/5.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ProblemTypesViewController.h"
#import "ProblemTypesModel.h"
#import "MTProgressHUD.h"
#import "SubmitSuggestViewController.h"

@interface ProblemTypesViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *dataArray;

@end

@implementation ProblemTypesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择建议类型";
    
    self.tableViewStyle = STRefreshTableViewPlain;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self showHeadRefresh:NO showFooterRefresh:NO];
    
    [self loadData];
    
}

- (void)loadData {
    
    [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
    [STDataHandler sendFindAdviceTypes:^(NSArray *array) {
       
        self.dataArray = array;
        [self.tableView reloadData];
        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        
    } failure:^(NSError *error) {
        
        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        
    }];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    
    ProblemTypesModel *model = self.dataArray[indexPath.row];
    
    cell.textLabel.text = model.value;
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProblemTypesModel *model = self.dataArray[indexPath.row];
    
    SubmitSuggestViewController *controller = [[SubmitSuggestViewController alloc] init];
    
    controller.problemTypesModel = model;

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

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
