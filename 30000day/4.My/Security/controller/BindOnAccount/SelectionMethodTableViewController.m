//
//  SelectionMethodTableViewController.m
//  30000day
//
//  Created by wei on 16/3/7.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SelectionMethodTableViewController.h"
#import "SelectionMethodTableViewCell.h"
#import "EmailBindViewController.h"

@interface SelectionMethodTableViewController ()

@property (nonatomic) NSArray *selectionFactorArray;

@end

@implementation SelectionMethodTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectionFactorArray = [NSArray arrayWithObjects:@"邮箱绑定",@"QQ绑定",@"微信绑定",@"微博绑定", nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.selectionFactorArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SelectionMethodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectionMethodTableViewCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SelectionMethodTableViewCell" owner:nil options:nil] lastObject];
    }
    
    cell.textLabel.text=self.selectionFactorArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        [self.dataHandler sendVerificationUserEmailWithUserId:[Common readAppDataForKey:KEY_SIGNIN_USER_UID] success:^(NSDictionary *verificationDictionary) {
            
            
            if ([Common isObjectNull:verificationDictionary]) {
                
                EmailBindViewController *controller =[[EmailBindViewController alloc]init];
                
                controller.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController pushViewController:controller animated:YES];
                
            }else {
                
                [self showToast:@"您已经绑定过邮箱！"];
                
            }

            
        }failure:^(NSError *error) {
            
            [self showToast:@"验证出错，请稍后再试。"];
            
        }];


        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
