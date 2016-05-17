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
#import "LifeDescendFactorsViewController.h"

@interface PromoteAgeViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) PromoteAgeTableViewCell *checkCell;//体检

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

- (PromoteAgeTableViewCell *)checkCell {
    
    if (!_checkCell) {
        
        _checkCell = [[NSBundle mainBundle] loadNibNamed:@"PromoteAgeTableViewCell" owner:nil options:nil][1];
    }
    
    return _checkCell;
}


#pragma ---
#pragma mark --- UITableViewDataSource/UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 4;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        
        if ([Common isObjectNull:self.sportText]) {
            
            return 0.0f;
            
        } else {
            
            return 18.0 + [Common heightWithText:self.sportText width:SCREEN_WIDTH - 24 fontSize:17.0];
        }
    }
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        PromoteAgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sportsRemindCellFirst"];
        
        if (cell == nil) {
            
            cell = [[NSBundle mainBundle] loadNibNamed:@"PromoteAgeTableViewCell" owner:nil options:nil][0];
            
        }
        
        cell.sportTextLableFirst.text = self.sportText;
        
        return cell;
        
    } else if (indexPath.row == 1) {
        
        PromoteAgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sleepCellSecond"];
        
        if (cell == nil) {
            
            cell = [[NSBundle mainBundle] loadNibNamed:@"PromoteAgeTableViewCell" owner:nil options:nil][1];
        }
        cell.row = indexPath.row;
        cell.sleepLableSecond.text = @"健康作息提醒";
        cell.switchButton.on = [Common readAppBoolDataForkey:WORK_REST_NOTIFICATION];
        return cell;

    } else if (indexPath.row == 2) {
        
        self.checkCell.row = indexPath.row;
        
        self.checkCell.sleepLableSecond.text = @"体检提醒";
        
        self.checkCell.switchButton.on = [Common readAppBoolDataForkey:CHECK_NOTIFICATION];
        
        return self.checkCell;
        
    } else if (indexPath.row == 3) {
        
        PromoteAgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ageDeclineCellThird"];
        
        if (cell == nil) {
            
            cell = [[NSBundle mainBundle] loadNibNamed:@"PromoteAgeTableViewCell" owner:nil options:nil][2];
        }
        
        cell.physicalExaminationLableThird.text = @"天龄下降因素";
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 2) {
        
        PhysicalExaminationViewController *controller =  [[PhysicalExaminationViewController alloc] init];
        
        [controller setSetSuccessBlock:^{
           
            [self.checkCell reloadData];
            
        }];
        
        [self.navigationController pushViewController:controller animated:YES];
        
    } else if(indexPath.row == 3) {
    
        LifeDescendFactorsViewController *controller = [[LifeDescendFactorsViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
