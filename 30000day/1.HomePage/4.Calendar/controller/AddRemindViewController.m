//
//  AddRemindViewController.m
//  30000day
//
//  Created by GuoJia on 16/2/22.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "AddRemindViewController.h"
#import "AddRemindTextTableViewCell.h"
#import "AddTimeTableViewCell.h"

@interface AddRemindViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation AddRemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加提醒";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma ---
#pragma mark ---- UITableViewDelegate / UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *addRemindIdentifier = @"AddRemindTextTableViewCell";
    
    AddRemindTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addRemindIdentifier];
    
    if (cell == nil ) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:addRemindIdentifier owner:nil options:nil] lastObject];
        
    }
    if (indexPath.section == 0) {
        
        cell.contentTextField.placeholder = @"请输入标题";
        
        cell.titleLabel.text = @"标题:";
        
    } else if ( indexPath.section == 1 ){
        
        cell.contentTextField.placeholder = @"请输入内容";
        
        cell.titleLabel.text = @"内容:";
        
    } else if (indexPath.section == 2) {
        
        static NSString *addTimeIdentifier = @"AddTimeTableViewCell";
        
        AddTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addTimeIdentifier];
        
        if (cell == nil ) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:addTimeIdentifier owner:nil options:nil] lastObject];
        
        }
        
        //点击时间回调
        [cell setAddTimeAction:^{
           
            
            
        }];
        
        return cell;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
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
