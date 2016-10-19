//
//  PersonSettingViewController.m
//  30000day
//
//  Created by GuoJia on 16/5/3.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "PersonSettingViewController.h"
#import "HeadViewTableViewCell.h"
#import "PayTableViewCell.h"
#import "MTProgressHUD.h"
#import "SettingViewController.h"
#import "PersonInformationsManager.h"

@interface PersonSettingViewController () <UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) HeadViewTableViewCell *headViewCell;

@property (nonatomic,strong) UITableViewCell *cell;

@end

@implementation PersonSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"好友设置";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (HeadViewTableViewCell *)headViewCell {
    
    if (!_headViewCell) {
        
        _headViewCell = [[[NSBundle mainBundle] loadNibNamed:@"HeadViewTableViewCell" owner:nil options:nil] lastObject];
        
    }
    return _headViewCell;
}

- (UITableViewCell *)cell {
    
    if (!_cell) {
        
        _cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    
    return _cell;
}


#pragma ---
#pragma mark --- UITableViewDelegate / UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {

        self.headViewCell.headImageViewURLString = [[[PersonInformationsManager shareManager] infoWithFriendId:self.friendUserId] showHeadImageUrlString];
        
        self.headViewCell.titleLabel.text = @"备注头像";
        
        return self.headViewCell;
        
    } else if (indexPath.section == 1) {
        
        self.cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.cell.textLabel.text = @"备注";
        
        self.cell.detailTextLabel.text = [[[PersonInformationsManager shareManager] infoWithFriendId:self.friendUserId] showNickName];
        
        self.cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        
        self.cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0f];
        
        return self.cell;
        
    } else {
        
        PayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayTableViewCell"];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PayTableViewCell" owner:nil options:nil] lastObject];
        }
        
        cell.backgroundColor = LOWBLUECOLOR;
        
        cell.titleLabel_second.text = @"删除好友";
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return 105;
    }
    
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil
                                                                            message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *action_cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *action_first = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIImagePickerController *pickCtrl = [[UIImagePickerController alloc] init];
            //设置代理
            pickCtrl.delegate = self;
            //设置允许编辑
            pickCtrl.allowsEditing = YES;
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ) {
                
                pickCtrl.sourceType = UIImagePickerControllerSourceTypeCamera;
            }
            
            //显示图片选择器
            [self presentViewController:pickCtrl animated:YES completion:nil];
 
        }];
        
        UIAlertAction *action_second = [UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIImagePickerController *pickCtrl = [[UIImagePickerController alloc] init];
            //设置代理
            pickCtrl.delegate = self;
            //设置允许编辑
            pickCtrl.allowsEditing = YES;
            
            pickCtrl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //显示图片选择器
            [self presentViewController:pickCtrl animated:YES completion:nil];
            
        }];
        
        UIAlertAction *action_third = [UIAlertAction actionWithTitle:@"清除备注头像" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [STDataHandler sendUpdateFriendInformationWithUserId:STUserAccountHandler.userProfile.userId friendUserId:self.friendUserId friendNickName:nil friendHeadImageUrlString:@"" success:^(BOOL success) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                    
                    [[PersonInformationsManager shareManager] infoWithFriendId:self.friendUserId].headImg = @"";
                    
                    [self showToast:@"清除备注头像成功"];
                    
                    self.headViewCell.headImageViewURLString = [[[PersonInformationsManager shareManager] infoWithFriendId:self.friendUserId] showHeadImageUrlString];
                    
                    //成功的更新好友信息发出的通知
                    [STNotificationCenter postNotificationName:STDidSuccessUpdateFriendInformationSendNotification object:nil];
                    
                });
                
            } failure:^(NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                    
                    [self showToast:[error userInfo][NSLocalizedDescriptionKey]];
                    
                });
            }];
            
        }];
        
        [controller addAction:action_first];
        
        [controller addAction:action_second];
        
        [controller addAction:action_third];
        
        [controller addAction:action_cancel];
        
        [self presentViewController:controller animated:YES completion:nil];
        
    } else if (indexPath.section == 1) {
        
        SettingViewController *controller  = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    
        controller.showTitle = [[[PersonInformationsManager shareManager] infoWithFriendId:self.friendUserId] showNickName];
        
        //修改昵称
        [controller setDoneBlock:^(NSString *changedTitle) {
           
            [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
            
            [STDataHandler sendUpdateFriendInformationWithUserId:STUserAccountHandler.userProfile.userId friendUserId:self.friendUserId friendNickName:changedTitle friendHeadImageUrlString:nil success:^(BOOL success) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                    //给管理器赋值
                    [[PersonInformationsManager shareManager] infoWithFriendId:self.friendUserId].nickName = changedTitle;
                    
                    //成功的更新好友信息发出的通知
                    [STNotificationCenter postNotificationName:STDidSuccessUpdateFriendInformationSendNotification object:nil];
                    
                    [self showToast:@"设置昵称成功"];
                    
                    self.cell.detailTextLabel.text = changedTitle;
                    
                });
                
            } failure:^(NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                
                    [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                    
                    [self showToast:[error userInfo][NSLocalizedDescriptionKey]];
                    
                });
            }];
            
        }];
        
        controller.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:controller animated:YES];
        
    } else {
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"确定要删除%@吗",[[[PersonInformationsManager shareManager] infoWithFriendId:self.friendUserId] showNickName]]
     message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
         UIAlertAction *action_cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
        UIAlertAction *action_first = [UIAlertAction actionWithTitle:@"删除好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [STDataHandler sendDeleteFriendWithUserId:STUserAccountHandler.userProfile.userId friendUserId:self.friendUserId success:^(BOOL success) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                    [STNotificationCenter postNotificationName:STUseDidSuccessDeleteFriendSendNotification object:nil];
                
                });

            } failure:^(NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                
                    [self showToast:error.userInfo[NSLocalizedDescriptionKey]];
                
                });

            }];
        }];
        
        [controller addAction:action_first];
        
        [controller addAction:action_cancel];
        
        [self presentViewController:controller animated:YES completion:nil];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    //保存headImage字段
    [self updateImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateImage:(UIImage *)image {
    
    [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
    
    [STDataHandler sendUpdateUserHeadPortrait:STUserAccountHandler.userProfile.userId headImage:image success:^(NSString *imageUrl) {
        
        [STDataHandler sendUpdateFriendInformationWithUserId:STUserAccountHandler.userProfile.userId friendUserId:self.friendUserId friendNickName:nil friendHeadImageUrlString:imageUrl success:^(BOOL success) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                
                //给管理器赋值
                [[PersonInformationsManager shareManager] infoWithFriendId:self.friendUserId].headImg = imageUrl;
                
                [self showToast:@"设置备注头像成功"];
                
                //成功的更新好友信息发出的通知
                [STNotificationCenter postNotificationName:STDidSuccessUpdateFriendInformationSendNotification object:nil];
                
                self.headViewCell.headImageView.image = image;
                
            });
            
        } failure:^(NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
            
                [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                
                [self showToast:[error userInfo][NSLocalizedDescriptionKey]];
                
            });
            
        }];
        
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self showToast:[error userInfo][NSLocalizedDescriptionKey]];
            
            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
            
        });
    }];
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
