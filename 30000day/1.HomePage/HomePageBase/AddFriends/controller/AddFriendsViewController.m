//
//  AddFriendsViewController.m
//  30000day
//
//  Created by wei on 16/2/2.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "MailListViewController.h"
#import "SearchFriendsViewController.h"
#import "QRReaderViewController.h"

@interface AddFriendsViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation AddFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = @"添加好友";
}

#pragma ---
#pragma mark --- UITableViewDataSource/UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return [[[NSBundle mainBundle] loadNibNamed:@"SearchFriendsTableViewCell" owner:nil options:nil] lastObject];
        
    } else if(indexPath.section == 1) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.text = @"通讯录好友";
        
        return cell;
        
    } else {
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SweepCell"];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SweepCell"];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.text = @"扫一扫";
        
        return cell;
    
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        SearchFriendsViewController *controller = [[SearchFriendsViewController alloc] init];

        controller.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:controller animated:YES];
    
    } else if(indexPath.section == 1) {
        
        MailListViewController *mlvc = [[MailListViewController alloc] init];
        
        [self.navigationController pushViewController:mlvc animated:YES];
        
    } else {
    
        QRReaderViewController *QRController = [[QRReaderViewController alloc] init];
        
        QRController.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:QRController animated:YES];
    
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
