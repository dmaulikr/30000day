
//
//  MyTableViewController.m
//  30000day
//
//  Created by GuoJia on 16/1/28.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "MyTableViewController.h"
#import "myViewCell.h"
#import "userInfoViewController.h"
#import "SignInViewController.h"
#import "SecurityViewController.h"
#import "SetUpViewController.h"
#import "HealthySetUpViewController.h"
#import "UserHeadViewTableViewCell.h"
#import "LogoutTableViewCell.h"
#import "CDChatManager.h"
#import "CDSettingVC.h"

@interface MyTableViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation MyTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"我的";
    
    [self loadEmail];
    
    self.tableViewStyle = STRefreshTableViewGroup;
    
    [self.tableView setDataSource:self];
    
    [self.tableView setDelegate:self];
    
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
    self.isShowHeadRefresh = NO;
    
    self.isShowFootRefresh = NO;
    
    self.isShowBackItem = NO;
    
    //监听个人信息管理模型发出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:STUserAccountHandlerUseProfileDidChangeNotification object:nil];

}

- (void)reloadData:(NSNotification *)notification {
    
    [self.tableView reloadData];
}

- (void)loadEmail {
    
    //获取用户绑定的邮箱
    [self showHUD:YES];
    [self.dataHandler sendVerificationUserEmailWithUserId:[Common readAppDataForKey:KEY_SIGNIN_USER_UID] success:^(NSDictionary *verificationDictionary) {
        
        if ([Common isObjectNull:verificationDictionary]){
            [STUserAccountHandler userProfile].email = @"未绑定邮箱";
        } else {
            [STUserAccountHandler userProfile].email = verificationDictionary[@"email"];
        }
        
        [self hideHUD:YES];
    } failure:^(NSError *error) {
        [self hideHUD:YES];
        NSLog(@"获取绑定邮箱出错");
    }];
    
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
    
    if (section == 0) {
        
        return 1;
        
    } else if(section==1) {
        
        return 2;
        
    } else if (section == 2) {
        
        return 3;
        
    } else if (section == 3) {
        
        return 1;
        
    } else {
        
        return 1;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return 105;
        
    } else {
        
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 3 ) {
        
        return 85;
        
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

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* ID = @"mainCell";
    
    myViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
    
        cell= [[[NSBundle mainBundle] loadNibNamed:@"myViewCell" owner:self options:nil] lastObject];
      
    }
    
    if (indexPath.section == 0) {
        
        UserHeadViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserHeadViewTableViewCell"];
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UserHeadViewTableViewCell" owner:self options:nil] lastObject];
        }
        
        cell.userProfile = STUserAccountHandler.userProfile;
        
        return cell;
        
    } else if (indexPath.section == 1) {
        
        if (indexPath.row==0) {
            
            [cell.leftImage setImage:[UIImage imageNamed:@"healthy.png"]];
            
            [cell.titleLabel setText:@"健康因素"];
            
            cell.seperatorLineView.hidden = NO;
            
        } else {
            
            [cell.leftImage setImage:[UIImage imageNamed:@"consumption.png"]];
            
            [cell.titleLabel setText:@"消费记录"];
            
            cell.seperatorLineView.hidden = YES;
            
          
        }
         return cell;
        
    } else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            
            [cell.leftImage setImage:[UIImage imageNamed:@"securityCenter.png"]];
            
            [cell.titleLabel setText:@"安全中心"];
            
            cell.seperatorLineView.hidden = NO;
            
        } else if (indexPath.row == 1) {
            
            [cell.leftImage setImage:[UIImage imageNamed:@"setUp.png"]];
            
            [cell.titleLabel setText:@"设置"];
            
            cell.seperatorLineView.hidden = YES;
            
        } else {
            
            [cell.leftImage setImage:[UIImage imageNamed:@"setUp.png"]];
            
            [cell.titleLabel setText:@"消息设置"];
            
            cell.seperatorLineView.hidden = YES;
        }
        
        return cell;
        
    } else if (indexPath.section == 3) {
        
        [cell.leftImage setImage:[UIImage imageNamed:@"about.png"]];
        
        [cell.titleLabel setText:@"关于"];
        
        cell.seperatorLineView.hidden = YES;
        
        return cell;
        
    } else if (indexPath.section == 4 ) {
        
        LogoutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LogoutTableViewCell"];
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"LogoutTableViewCell" owner:self options:nil] lastObject];
            
        }
        
        return cell;
        
    }
    
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        UserInfoViewController *user = [[UserInfoViewController alloc] init];
        
        user.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:user animated:YES];
        
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            HealthySetUpViewController *hsc = [[HealthySetUpViewController alloc]init];
            
            hsc.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:hsc animated:YES];
            
        }
    } else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            
            SecurityViewController *stc = [[SecurityViewController alloc] init];
            
            stc.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:stc animated:YES];
            
        } else if (indexPath.row == 1) {
          
            SetUpViewController *suc = [[SetUpViewController alloc] init];
            
            suc.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:suc animated:YES];
        
        } else if (indexPath.row == 2 ){
            
            CDSettingVC *controller = [[CDSettingVC alloc] init];
            
            controller.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:controller animated:YES];

        }
        
    } else if (indexPath.section == 4) {
        
        [self cancelAction];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)cancelAction {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定注销？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        //***********退出登录  *****/
        [Common removeAppDataForKey:KEY_SIGNIN_USER_UID];
        
        [Common removeAppDataForKey:KEY_SIGNIN_USER_NAME];
        
        [Common removeAppDataForKey:KEY_SIGNIN_USER_PASSWORD];
    
        SignInViewController *logview = [[SignInViewController alloc] init];
        
        STNavigationController *navigationController = [[STNavigationController alloc] initWithRootViewController:logview];
        
        [self presentViewController:navigationController animated:YES completion:nil];
        
        [[CDChatManager manager] closeWithCallback: ^(BOOL succeeded, NSError *error) {
            
        }];
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
