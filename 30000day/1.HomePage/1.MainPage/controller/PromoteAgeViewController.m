//
//  PromoteAgeViewController.m
//  30000day
//
//  Created by wei on 16/5/10.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "PromoteAgeViewController.h"
#import "PromoteAgeTableViewCell.h"
#import "PhysicalExaminationViewController.h"
#import "SettingBirthdayView.h"

@interface PromoteAgeViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation PromoteAgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提升天龄";
    
    self.tableViewStyle = STRefreshTableViewPlain;
    
    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44);
    
    self.isShowBackItem = YES;
    
    [self showHeadRefresh:NO showFooterRefresh:NO];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 4;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
    
       return 18.0 + [Common heightWithText:self.sportText width:SCREEN_WIDTH - 24 fontSize:17.0];
        
    }
    
    return 44;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PromoteAgeTableViewCell *cell = [PromoteAgeTableViewCell tempTableViewCellWith:tableView indexPath:indexPath];
    
    switch (indexPath.row) {
        case 0: {
             cell.sportTextLableFirst.text = self.sportText;
            break;
        }
        case 1: {
            cell.sleepLableSecond.text = @"健康作息提醒";
            break;
        }
        case 2: {
            cell.sleepLableSecond.text = @"体检提醒";
            break;
        }
        case 3: {
            cell.physicalExaminationLableThird.text = @"天龄下降因素";
            break;
        }
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 2) {
        
        PhysicalExaminationViewController *controller =  [[PhysicalExaminationViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
