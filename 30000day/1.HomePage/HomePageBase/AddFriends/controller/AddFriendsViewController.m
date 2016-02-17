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
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return [[[NSBundle mainBundle] loadNibNamed:@"SearchFriendsTableViewCell" owner:nil options:nil] lastObject];
        
    } else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        cell.textLabel.text = @"通讯录好友";
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
        SearchFriendsViewController *controller = [[SearchFriendsViewController alloc] init];
        
        controller.view.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        [self addChildViewController:controller];
        
        [self.view addSubview:controller.view];
    
    } else {
        
        MailListViewController *mlvc = [[MailListViewController alloc] init];
        
        [self.navigationController pushViewController:mlvc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
