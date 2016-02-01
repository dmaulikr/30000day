
//
//  MyTableViewController.m
//  30000day
//
//  Created by GuoJia on 16/1/28.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "MyTableViewController.h"
#import "myViewCell.h"
#import "UserInfo.h"
#import "UIImageView+WebCache.h"
#import "userInfoViewController.h"
#import "SignInViewController.h"
#import "securityViewController.h"
#import "SetUpViewController.h"
#import "healthySetUpViewController.h"

@interface MyTableViewController ()

@property (nonatomic,strong) UserInfo *userinfo;

@end

@implementation MyTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
     _userinfo = TKAddressBookManager.userInfo;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.tabBarController.tabBar.hidden=NO;
    
    UserInfo *u = TKAddressBookManager.userInfo;
    
    if (u.isfirstlog==1) {
        
        [self.tabBarController setSelectedIndex:0];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma ---
#pragma mark - UITableViewDataSource/UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section==0) {
        
        return 1;
        
    } else if(section==1) {
        
        return 2;
        
    } else if (section==2) {
        
        return 2;
        
    } else if (section==3) {
        
        return 1;
        
    } else {
        
        return 1;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        
        return 105;
        
    } else {
        
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section==3) {
        
        return 100;
        
    } else {
        
        return 12;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 10;
        
    } else {
        
        return 0.1f;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    static NSString *footViewIdentifier = @"UITableViewHeaderFooterView";
    
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footViewIdentifier];
    
    if ( view == nil ) {
        
        view = [[UITableViewHeaderFooterView alloc] init];
        
        view.tintColor = RGBACOLOR(239, 239, 239, 1);
    }
    
    return view;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* ID=@"mainCell";
    
    myViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell==nil) {
    
        cell= [[[NSBundle mainBundle] loadNibNamed:@"myViewCell" owner:self options:nil] lastObject];
      
    }
    
    if (indexPath.section==0) {
        
        [self loadMainTableViewOneSection:cell];
        
    } else if (indexPath.section==1) {
        
        if (indexPath.row==0) {
            
            [cell.leftImage setImage:[UIImage imageNamed:@"healthy.png"]];
            
            [cell.titleLabel setText:@"健康因素"];
            
            cell.seperatorLineView.hidden = NO;
            
            
        } else {
            
            [cell.leftImage setImage:[UIImage imageNamed:@"consumption.png"]];
            
            [cell.titleLabel setText:@"消费记录"];
            
            cell.seperatorLineView.hidden = YES;
        }
        
    } else if (indexPath.section==2) {
        
        if (indexPath.row==0) {
            
            [cell.leftImage setImage:[UIImage imageNamed:@"securityCenter.png"]];
            
            [cell.titleLabel setText:@"安全中心"];
            
            cell.seperatorLineView.hidden = NO;
            
        } else {
            
            [cell.leftImage setImage:[UIImage imageNamed:@"setUp.png"]];
            
            [cell.titleLabel setText:@"设置"];
            
            cell.seperatorLineView.hidden = YES;
        }
        
    } else if (indexPath.section==3) {
        
        [cell.leftImage setImage:[UIImage imageNamed:@"about.png"]];
        
        [cell.titleLabel setText:@"关于"];
        
        cell.seperatorLineView.hidden = YES;
        
    } else if (indexPath.section==4) {
        
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
        cell.seperatorLineView.hidden = YES;
        
        UILabel* Cancellation=[[UILabel alloc]init];
        
        [Cancellation setText:@"注销"];
        
        [cell addSubview:Cancellation];
        
        Cancellation.translatesAutoresizingMaskIntoConstraints=NO;
        
        [cell addConstraint:[NSLayoutConstraint constraintWithItem:Cancellation attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        
        [cell addConstraint:[NSLayoutConstraint constraintWithItem:Cancellation attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        
    }
    
    return cell;
}

- (void)loadMainTableViewOneSection:(UITableViewCell*)cell {
    
    NSURL* imgurl=[NSURL URLWithString:_userinfo.HeadImg];
    
    UIImageView* imgview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 65, 65)];
    
    if ([[NSString stringWithFormat:@"%@",imgurl] isEqualToString:@""] || imgurl==nil ) {
        
        [imgview setImage:[UIImage imageNamed:@"lcon.png"]];
        
    } else {

        [imgview sd_setImageWithURL:imgurl];
    }
    
    [cell addSubview:imgview];
    
    imgview.translatesAutoresizingMaskIntoConstraints=NO;
    
    [imgview addConstraint:[NSLayoutConstraint constraintWithItem:imgview attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:65]];
    
    [imgview addConstraint:[NSLayoutConstraint constraintWithItem:imgview attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:65]];
    
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:imgview attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:imgview attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeLeft multiplier:1.0 constant:15]];
    
    UILabel* nickName=[[UILabel alloc]init];
    
    [nickName setFont:[UIFont systemFontOfSize:20.0 weight:0.3]];
    
    [nickName setText:_userinfo.NickName];
    
    [cell addSubview:nickName];
    
    nickName.translatesAutoresizingMaskIntoConstraints=NO;
    
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:nickName attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:imgview attribute:NSLayoutAttributeRight multiplier:1.0 constant:10]];
    
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:nickName attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeTop multiplier:1.0 constant:30]];
    
    UILabel* PhoneNumber=[[UILabel alloc]init];
    
    [PhoneNumber setFont:[UIFont systemFontOfSize:15.0]];
    
    [PhoneNumber setText:_userinfo.PhoneNumber];
    
    [cell addSubview:PhoneNumber];
    
    PhoneNumber.translatesAutoresizingMaskIntoConstraints = NO;
    
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:PhoneNumber attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:imgview attribute:NSLayoutAttributeRight multiplier:1.0 constant:10]];
    
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:PhoneNumber attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:nickName attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        userInfoViewController *user=[[userInfoViewController alloc]init];
        
        user.title = @"个人信息";
        
        [self.navigationController pushViewController:user animated:YES];
        
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            healthySetUpViewController *hsc=[[healthySetUpViewController alloc]init];
            
            [self.navigationController pushViewController:hsc animated:YES];
            
        }
    } else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            
            securityViewController *stc = [[securityViewController alloc]init];
            
            [self.navigationController pushViewController:stc animated:YES];
            
        } else {
            
            SetUpViewController *suc = [[SetUpViewController alloc] init];
            
            [self.navigationController pushViewController:suc animated:YES];
        }
        
    } else if (indexPath.section==4) {
        
        [self CancellationClick];
    }
}

- (void)CancellationClick {
    
    UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"确定注销？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        TKAddressBookManager.userInfo = nil;
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"username"];
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"password"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        SignInViewController *viewController = [[SignInViewController alloc] init];
        
        [self.navigationController pushViewController:viewController animated:YES];
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
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
