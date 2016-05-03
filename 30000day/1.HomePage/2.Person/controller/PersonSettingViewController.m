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

@interface PersonSettingViewController () <UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

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
        
        HeadViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeadViewTableViewCell"];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HeadViewTableViewCell" owner:nil options:nil] lastObject];
        }
        
        cell.headImageViewURLString = self.informationModel.headImg;
        
        cell.titleLabel.text = @"备注头像";
        
        return cell;
        
    } else if (indexPath.section == 1) {
        
        UITableViewCell *cell = cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
            
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.text = @"备注";
        
        cell.detailTextLabel.text = self.informationModel.nickName;
        
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0f];
        
        return cell;
        
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
            
            [self.dataHandler sendUpdateFriendInformationWithUserId:STUserAccountHandler.userProfile.userId friendUserId:self.informationModel.userId friendNickName:self.informationModel.nickName friendHeadImageUrlString:@"" success:^(BOOL success) {
                
                [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                
                [self showToast:@"清除备注头像成功"];
                
            } failure:^(NSError *error) {
                
                [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                
                [self showToast:[error userInfo][NSLocalizedDescriptionKey]];
            }];
            
        }];
        
        [controller addAction:action_first];
        
        [controller addAction:action_second];
        
        [controller addAction:action_third];
        
        [controller addAction:action_cancel];
        
        [self presentViewController:controller animated:YES completion:nil];
        
    } else if (indexPath.section == 1) {
        
        
        
        
        
    } else {
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"确定要删除%@吗",self.informationModel.nickName]
     message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
         UIAlertAction *action_cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
        UIAlertAction *action_first = [UIAlertAction actionWithTitle:@"删除好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.dataHandler sendDeleteFriendWithUserId:STUserAccountHandler.userProfile.userId friendUserId:self.informationModel.userId success:^(BOOL success) {
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            } failure:^(NSError *error) {
                
                [self showToast:error.userInfo[NSLocalizedDescriptionKey]];
                
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
    
    UIImage *originImage = info[UIImagePickerControllerOriginalImage];
    
    //保存图片到本地相册
    UIImageWriteToSavedPhotosAlbum(originImage, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    
    //保存headImage字段
    [self updateImage:image];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *message = @"呵呵";
    
    if (!error) {
        
        message = @"成功保存到相册";
        
    } else {
        
        message = [error description];
    }
}

- (void)updateImage:(UIImage *)image {
    
    [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
    
    [self.dataHandler sendUpdateUserHeadPortrait:STUserAccountHandler.userProfile.userId headImage:image success:^(NSString *imageUrl) {
        
        [self.dataHandler sendUpdateFriendInformationWithUserId:STUserAccountHandler.userProfile.userId friendUserId:self.informationModel.userId friendNickName:self.informationModel.nickName friendHeadImageUrlString:imageUrl success:^(BOOL success) {
            
            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
            
            [self showToast:@"设置备注头像成功"];
            
        } failure:^(NSError *error) {
            
            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
            
            [self showToast:[error userInfo][NSLocalizedDescriptionKey]];
        }];
        
    } failure:^(NSError *error) {
        
        [self showToast:[error userInfo][NSLocalizedDescriptionKey]];
        
        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
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
