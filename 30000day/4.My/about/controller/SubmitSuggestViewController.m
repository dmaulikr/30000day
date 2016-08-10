//
//  SubmitSuggestViewController.m
//  30000day
//
//  Created by wei on 16/8/8.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SubmitSuggestViewController.h"
#import "SubmitSuggestTableViewCell.h"
#import "MTProgressHUD.h"
#import "AboutTableViewController.h"

@interface SubmitSuggestViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation SubmitSuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"意见反馈";
    
    self.tableViewStyle = STRefreshTableViewPlain;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self showHeadRefresh:NO showFooterRefresh:NO];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 200;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        
        SubmitSuggestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubmitSuggestTableViewCell"];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SubmitSuggestTableViewCell" owner:nil options:nil] lastObject];
            
        }
        
        __weak typeof(cell) weakSelf = cell;
        
        [cell setSubMitBlock:^{
           
            [self subMitData:weakSelf.textView.text];
            
        }];
        
        return cell;
    
    }
    
    return nil;

}


- (void)subMitData:(NSString *)text {

    [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
    [STDataHandler sendCommitAdviceWithUserId:STUserAccountHandler.userProfile.userId content:text adviceType:[self.problemTypesModel.problemTypesID integerValue] success:^(BOOL success) {
        
        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        
        if (success) {
            
            [self showToast:@"谢谢您的宝贵建议，我们会尽快处理。"];
            
            [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
            
        }
        
    } failure:^(NSError *error) {
        
        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        
    }];

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
