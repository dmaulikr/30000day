//
//  STCroupSettingViewController.m
//  30000day
//
//  Created by GuoJia on 16/6/15.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STCroupSettingViewController.h"
#import "DeleteRemindTableViewCell.h"
#import "CDChatManager.h"
#import "SettingViewController.h"
#import "CDConversationStore.h"
#import "STGroupNoticeSettingViewController.h"
#import "HeadViewTableViewCell.h"
#import "MTProgressHUD.h"
#import "STGroupTableViewCell.h"
#import "GroupSettingManager.h"

@interface STCroupSettingViewController () <UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong) HeadViewTableViewCell *headViewCell;

@end

@implementation STCroupSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    self.tableViewStyle = STRefreshTableViewGroup;
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//判断是否是群主
- (BOOL)isAdmin {
    
    NSString *creatorId = self.conversation.creator;
    //这地方可能会出bug
    if ([creatorId isEqualToString:[NSString stringWithFormat:@"%@",STUserAccountHandler.userProfile.userId]]) {//是管理者
        
        return YES;
        
    } else {//不是管理者
        
        return NO;
    }
}

//获取群成员模型数组
- (NSMutableArray *)getMemberModelArray {
    
    NSArray *memberArray = self.conversation.members;
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    for (int i = 0;i < memberArray.count; i++) {
        
        NSString *clientId = memberArray[i];
        
        STGroupCellModel *model = [[STGroupCellModel alloc] init];
        
        model.title = [self.conversation memberName:clientId];//获取昵称
        
        model.imageViewURL = [self.conversation headUrl:clientId];

        if ([clientId isEqualToString:self.conversation.creator]) {//表示这人是群主
            
            [dataArray insertObject:model atIndex:0];
            
        } else {
            
            [dataArray addObject:model];
        }
    }
    
    return dataArray;
}

- (HeadViewTableViewCell *)headViewCell {
    
    if (!_headViewCell) {
        
        _headViewCell = [[[NSBundle mainBundle] loadNibNamed:@"HeadViewTableViewCell" owner:nil options:nil] lastObject];
        
    }
    return _headViewCell;
}

#pragma ---
#pragma mark --- UITableViewDataSource/UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
        
    } else if (section == 1) {
        
        return 4;
        
    } else if (section == 2) {
        
        return 1;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        STGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STGroupTableViewCell"];
        
        if (cell == nil) {
            
            cell = [[STGroupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"STGroupTableViewCell"];
        }
        
        cell.isMainGroup = [self isAdmin];//写在前面

        cell.memberMutableArray = [self getMemberModelArray];
        
        [cell setMemberButtonBlock:^(NSInteger imageViewIndex, BOOL isAdmin) {//回调
            
            if (isAdmin) {//群主
                
                if (imageViewIndex == [self getMemberModelArray].count + 1) {//点击了踢人按钮

                    [GroupSettingManager removeMemberFromController:self fromClientId:[NSString stringWithFormat:@"%@",STUserAccountHandler.userProfile.userId] fromConversation:self.conversation callBack:^(BOOL success, NSError *error) {
                       
                        if (success) {
                            
                            [self showToast:@"移除成功"];
                            
                            [self.tableView reloadData];
                            
                        } else {
                            
                            [self showToast:[Common errorStringWithError:error]];
                        }
                        
                    }];
                    
                } else if (imageViewIndex == [self getMemberModelArray].count) {//点击增加人按钮
                    
                    [GroupSettingManager addMemberFromController:self fromClientId:[NSString stringWithFormat:@"%@",STUserAccountHandler.userProfile.userId] fromConversation:self.conversation callBack:^(BOOL success, NSError *error) {
                        
                        if (success) {
                            
                            [self showToast:@"添加成功"];
                            
                            [self.tableView reloadData];
                            
                        } else {
                            
                            [self showToast:[Common errorStringWithError:error]];
                        }
                    }];
                    
                } else {//点击了普通按钮
                    
                }
                
            } else {
                
                if (imageViewIndex == [self getMemberModelArray].count) {//点击了增加人按钮
                    
                     [GroupSettingManager addMemberFromController:self fromClientId:[NSString stringWithFormat:@"%@",STUserAccountHandler.userProfile.userId] fromConversation:self.conversation callBack:^(BOOL success, NSError *error) {
                        
                         if (success) {
                             
                             [self showToast:@"添加成功"];
                             
                             [self.tableView reloadData];
                             
                         } else {
                             
                             [self showToast:[Common errorStringWithError:error]];
                         }
                     }];
                    
                } else {//点击了普通按钮
                    
                    
                    
                }
            }
            
        }];

        return cell;
        
    } else if (indexPath.section == 1 ) {
        
        if (indexPath.row == 0) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            
            if (cell == nil) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
            }
            
            cell.textLabel.text = @"群聊名称";
            
            cell.detailTextLabel.text = [self.conversation conversationDisplayName];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            
            cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0f];
            
            return cell;
            
        } else if (indexPath.row == 1) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            
            if (cell == nil) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
            }
            
            cell.textLabel.text = @"群公告";
            
            cell.detailTextLabel.text = [self.conversation groupChatNotice];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            
            cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0f];
            
            return cell;
            
        } else if (indexPath.row == 2) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            
            if (cell == nil) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
            }
            
            cell.textLabel.text = @"群主";
            
            cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            
            cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0f];
            
            cell.detailTextLabel.text = [self.conversation groupChatAdminName];
            
            return cell;
            
        } else if (indexPath.row == 3) {
            
            if ([Common isObjectNull:[self.conversation groupChatImageURL]]) {
                
                self.headViewCell.headImageView.image = [self.conversation icon];
                
            } else {
                
                self.headViewCell.headImageViewURLString = [self.conversation groupChatImageURL];
            }
            
            self.headViewCell.titleLabel.text = @"群头像";
            
            if ([self isAdmin]) {
                
                self.headViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
            } else {
                
                self.headViewCell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            return self.headViewCell;
        }
        
    } else if (indexPath.section == 2) {
        
        DeleteRemindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeleteRemindTableViewCell"];
        
        if (cell == nil) {
            
            cell = [[NSBundle mainBundle] loadNibNamed:@"DeleteRemindTableViewCell" owner:nil options:nil][0];
        }
        
        cell.titleLabel.text = @"删除并退出";
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return [STGroupTableViewCell groupTableViewCellHeight:[self getMemberModelArray]];
        
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 3) {
            
            return 105;
        }
    }
    
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {//第一组
        
        
        
    } else  if (indexPath.section == 1) {//第二组
        
        if (indexPath.row == 0) {
            
            SettingViewController *controller = [[SettingViewController alloc] init];
            
            controller.hidesBottomBarWhenPushed = YES;
            
            controller.showTitle = [self.conversation conversationDisplayName];
            
            [controller setDoneBlock:^(NSString *conformString) {//点击确定回调
                
                [GroupSettingManager modifiedGroupChatNameWithName:conformString fromConversation:self.conversation fromClientId:[NSString stringWithFormat:@"%@",STUserAccountHandler.userProfile.userId] callback:^(BOOL succeeded, NSError *error) {
                   
                    if (succeeded) {
                        
                        [[CDConversationStore store] updateConversations:@[self.conversation]];
                        
                        [self showToast:@"更新群聊名称成功"];
                        
                        [self.tableView reloadData];
                        
                    } else {
                        
                        [self showToast:[Common errorStringWithError:error]];
                    }
                }];
                
            }];
            
            [self.navigationController pushViewController:controller animated:YES];
            
        } else if (indexPath.row == 1) {
            
            STGroupNoticeSettingViewController *controller = [[STGroupNoticeSettingViewController alloc] init];
            
            NSString *creatorId = self.conversation.creator;
            //这地方可能会出bug
            if ([creatorId isEqualToString:[NSString stringWithFormat:@"%@",STUserAccountHandler.userProfile.userId]]) {//是管理者
                
                controller.isAdmin = YES;
                
            } else {//不是管理者
                
                controller.isAdmin = NO;
            }
            
            controller.hidesBottomBarWhenPushed = YES;
            
            controller.showNotice = [self.conversation groupChatNotice];//给需要显示群公告赋值
            
            [controller setDoneBlock:^(NSString *conformString) {//开始设置群公告
                
                [GroupSettingManager setAttributesKeyValueFromConversation:self.conversation value:conformString key:CONVERSATION_NOTICE successedSentMessageBody:@"更新群聊成功" fromClientId:[NSString stringWithFormat:@"%@",STUserAccountHandler.userProfile.userId] callback:^(BOOL succeeded, NSError *error) {
                   
                    if (succeeded) {
                        
                        [[CDConversationStore store] updateConversations:@[self.conversation]];
                        
                        [self showToast:@"更新群聊名称成功"];
                        
                        [self.tableView reloadData];

                    } else {
                        
                        [self showToast:[Common errorStringWithError:error]];
                    }
                }];
            }];
            
            [self.navigationController pushViewController:controller animated:YES];
            
        } else if (indexPath.row == 2) {
            
            
            
            
            
        } else if (indexPath.row == 3) {
            
            if (![self isAdmin]) {//非群主点击不了
                
                return;
            }
            
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
            
            [controller addAction:action_first];
            
            [controller addAction:action_second];
            
            [controller addAction:action_cancel];
            
            [self presentViewController:controller animated:YES completion:nil];
        }
        
    } else if (indexPath.section == 2) {
        
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"确定退出群聊？" message:@"点击确定会退出该群聊并删除本地聊天记录" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //离开对话
            [[CDChatManager sharedManager] deleteAndDeleteConversation:self.conversation callBack:^(BOOL successed, NSError *error) {
                
                if (successed) {
                    
                    [self showToast:@"退出群聊成功"];
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];//退回到根控制器
                    
                    [STNotificationCenter postNotificationName:STDidSuccessQuitGroupChatSendNotification object:nil];
                    
                } else {
                    
                    [self showToast:@"退出群聊失败"];
                }
            }];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [controller addAction:cancelAction];
        
        [controller addAction:action];
        
        [self presentViewController:controller animated:YES completion:nil];
    }
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
        
        [GroupSettingManager setAttributesKeyValueFromConversation:self.conversation value:imageUrl key:CONVERSATION_IMAGE_URL successedSentMessageBody:@"更新群聊头像成功" fromClientId:[NSString stringWithFormat:@"%@",STUserAccountHandler.userProfile.userId] callback:^(BOOL succeeded, NSError *error) {
           
            if (succeeded) {
                
                [[CDConversationStore store] updateConversations:@[self.conversation]];
                
                [self showToast:@"更新群聊头像成功"];
                
                [self.tableView reloadData];
                
                [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                
            } else {
                
                [self showToast:[Common errorStringWithError:error]];
                
                [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
            }
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
