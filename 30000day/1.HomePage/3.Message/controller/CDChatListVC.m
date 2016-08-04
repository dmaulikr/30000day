//
//  CDChatListController.m
//  LeanChat
//
//  Created by Qihe Bian on 7/25/14.
//  Copyright (c) 2014 LeanCloud. All rights reserved.
//

#import "CDChatListVC.h"
#import "LZStatusView.h"
#import "UIView+XHRemoteImage.h"
#import "CDChatManager.h"
#import "AVIMConversation+Custom.h"
#import "UIView+XHRemoteImage.h"
#import "CDEmotionUtils.h"
#import "CDMessageHelper.h"
#import "DateTools.h"
#import "CDConversationStore.h"
#import "CDChatManager_Internal.h"
#import "CDMacros.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CDChatRoomVC.h"
#import "STConversationCell.h"
#import "PersonHeadView.h"
#import "PersonInformationsManager.h"
#import "CDIMService.h"

@interface CDChatListVC () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *conversations;

@property (atomic, assign) BOOL isRefreshing;

/**
 *  来设置 tabbar 的 badge。
 *  @param totalUnreadCount 未读数总和。没有算免打扰对话的未读数。
 */
- (void)setBadgeWithTotalUnreadCount:(NSInteger)totalUnreadCount;

@end

static NSMutableArray *cacheConvs;

@implementation CDChatListVC

static NSString *cellIdentifier = @"ContactCell";

/**
 *  lazy load conversations
 *
 *  @return NSMutableArray
 */
- (NSMutableArray *)conversations {
    
    if (_conversations == nil) {
        
        _conversations = [[NSMutableArray alloc] init];
    }
    return _conversations;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableViewStyle =  STRefreshTableViewPlain;
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self showHeadRefresh:YES showFooterRefresh:NO];
    
    [LZConversationCell registerCellToTableView:self.tableView];
    
    // 当在其它 Tab 的时候，收到消息 badge 增加，所以需要一直监听
    [STNotificationCenter addObserver:self selector:@selector(headerRefreshing) name:kCDNotificationMessageReceived object:nil];
    
    [STNotificationCenter addObserver:self selector:@selector(headerRefreshing) name:kCDNotificationUnreadsUpdated object:nil];
    
    //成功的链接上凌云聊天服务器
    [STNotificationCenter addObserver:self selector:@selector(getMyFriends) name:STDidSuccessConnectLeanCloudViewSendNotification object:nil];
    
    [STNotificationCenter addObserver:self selector:@selector(headerRefreshing) name:STDidSuccessUpdateFriendInformationSendNotification object:nil];
    
    //成功的切换模式
    [STNotificationCenter addObserver:self selector:@selector(headerRefreshing) name:STUserDidSuccessChangeBigOrSmallPictureSendNotification object:nil];
    
    //成功的退出群聊
    [STNotificationCenter addObserver:self selector:@selector(headerRefreshing) name:STDidSuccessQuitGroupChatSendNotification object:nil];
    //修改群资料
    [STNotificationCenter addObserver:self selector:@selector(headerRefreshing) name:STDidSuccessGroupChatSettingSendNotification object:nil];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    //获取我的好友-----目的是取出当前用户是否设置备注头像
    [self getMyFriends];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 刷新 unread badge 和新增的对话
    [self performSelector:@selector(headerRefreshing) withObject:nil afterDelay:0];
}

//获取我的好友-----目的是取出当前用户给其好友了设置的备注头像
- (void)getMyFriends {
    
    [STDataHandler getMyFriendsWithUserId:[NSString stringWithFormat:@"%@",STUserAccountHandler.userProfile.userId] order:@"0" success:^(NSMutableArray *dataArray) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            //给这个好友管理器赋值
            [PersonInformationsManager shareManager].informationsArray = dataArray;
            
            [self.tableView reloadData];
        
        });
        
    } failure:^(NSError *error) {
        
    }];
    
    [self headerRefreshing];
}

- (void)headerRefreshing {
    
    if (self.isRefreshing) {
        
        return;
    }
    
    self.isRefreshing = YES;
    
    [[CDChatManager sharedManager] findRecentConversationsWithBlock:^(NSArray *conversations, NSInteger totalUnreadCount, NSError *error) {
        
        dispatch_block_t finishBlock = ^{
            
            [self.tableView.mj_header endRefreshing];
            
            if (!error) {
                
                self.conversations = [NSMutableArray arrayWithArray:conversations];
                
                [self.tableView reloadData];
                
                [self setBadgeWithTotalUnreadCount:totalUnreadCount];//设置未读消息
                
                [self selectConversationIfHasRemoteNotificatoinConvid];
            }
            
            self.isRefreshing = NO;
        };
        
        finishBlock();
    }];
}

- (void)setBadgeWithTotalUnreadCount:(NSInteger)totalUnreadCount {
    
    if (totalUnreadCount > 0) {
        
        if (totalUnreadCount >= 100) {
            
            [[self navigationController] tabBarItem].badgeValue = @"99+";
            
        } else {
            
            [[self navigationController] tabBarItem].badgeValue = [NSString stringWithFormat:@"%ld", (long)totalUnreadCount];
            
        }
        
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:totalUnreadCount];
        
    } else {
        
        [[self navigationController] tabBarItem].badgeValue = nil;
        
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
}


#pragma mark - client status view

- (void)selectConversationIfHasRemoteNotificatoinConvid {
    
    if ([CDChatManager sharedManager].remoteNotificationConvid) {
        
        // 进入之前推送弹框点击的对话
        BOOL found = NO;
        
        for (AVIMConversation *conversation in self.conversations) {
            
            if ([conversation.conversationId isEqualToString:[CDChatManager sharedManager].remoteNotificationConvid]) {
                
                [[CDIMService service] pushToChatRoomByConversation:conversation fromNavigationController:self.navigationController];
                
                found = YES;
            }
        }
        
        if (!found) {
            DLog(@"not found remoteNofitciaonID");
        }
        
        [CDChatManager sharedManager].remoteNotificationConvid = nil;
    }
}

#pragma mark - table view

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    static NSString *headViewIndentifier = @"PersonHeadView";
    
    PersonHeadView *view = (PersonHeadView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:headViewIndentifier];

    if (view == nil) {
        
        view = [[[NSBundle mainBundle] loadNibNamed:headViewIndentifier owner:self options:nil] lastObject];
    }
    
    view.sortButton.hidden = YES;
    
    view.titleLabel.hidden = YES;
    
    [view setChangeStateBlock:^(UIButton *changeStatusButton) {
        
        [self.tableView reloadData];
        
        [STNotificationCenter postNotificationName:STUserDidSuccessChangeBigOrSmallPictureSendNotification object:nil];
    }];
    
    if ([Common readAppIntegerDataForKey:IS_BIG_PICTUREMODEL]) {
        
        [view.changeStatusButton setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
        
        [view.changeStatusButton setTitle:@" 列表" forState:UIControlStateNormal];
        
    } else {
        
        [view.changeStatusButton setImage:[UIImage imageNamed:@"bigPicture.png"] forState:UIControlStateNormal];
        
        [view.changeStatusButton setTitle:@" 大图" forState:UIControlStateNormal];
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 54;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.conversations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([Common readAppIntegerDataForKey:IS_BIG_PICTUREMODEL]) {
        
        STConversationCell *cell = [STConversationCell dequeueOrCreateCellByTableView:tableView];
        AVIMConversation *conversation = [self.conversations objectAtIndex:indexPath.row];
        //长按手势，长按后删除该cell
        [cell setLongPressBlock:^{
            
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"删除消息" message:@"点击确定会删除该条消息" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [[CDChatManager sharedManager] deleteAndDeleteConversation:conversation callBack:^(BOOL successed, NSError *error) {
                    
                    if (successed) {
                        [self showToast:@"删除消息成功"];
                    } else {
                        [self showToast:[Common errorStringWithError:error optionalString:@"删除消息失败"]];
                    }
                    [self headerRefreshing];
                }];
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [controller addAction:cancelAction];
            [controller addAction:action];
            [self presentViewController:controller animated:YES completion:nil];
        }];
        
        if (conversation.type == CDConversationTypeSingle) {
            
            cell.nameLabel.text = [conversation conversationDisplayName];
            [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[conversation headUrl:conversation.otherId]] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
                [cell.indicatorView startAnimating];
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                [cell.indicatorView stopAnimating];
                
            }];

        } else {
        
            if ([Common isObjectNull:[conversation groupChatImageURL]]) {//不存在
                cell.avatarImageView.image = conversation.icon;
            } else {
                [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[conversation groupChatImageURL]] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                    [cell.indicatorView startAnimating];
                    
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    [cell.indicatorView stopAnimating];
                }];
            }
            cell.nameLabel.text = [conversation conversationDisplayName];
        }
        
        if (conversation.lastMessage) {
            
            cell.messageTextLabel.attributedText = [[CDMessageHelper helper] attributedStringWithMessage:conversation.lastMessage conversation:conversation];
            cell.timestampLabel.text = [[NSDate dateWithTimeIntervalSince1970:conversation.lastMessage.sendTimestamp / 1000] timeAgoSinceNow];
        }
        
        if ([[NSString stringWithFormat:@"%@",conversation.unreadCount] intValue] > 0) {
            
            if (conversation.muted) {
                
            } else {
                
                if ([[NSString stringWithFormat:@"%@",conversation.unreadCount] intValue] >= 100) {
                    
                    cell.badgeView.badgeText = @"99+";
                    
                } else {
                    
                    cell.badgeView.badgeText = [NSString stringWithFormat:@"%@", conversation.unreadCount];
                }
            }
        }
        return cell;
        
    } else {
        
        LZConversationCell *cell = [LZConversationCell dequeueOrCreateCellByTableView:tableView];
        AVIMConversation *conversation = [self.conversations objectAtIndex:indexPath.row];
        //长按手势，长按后删除该cell
        [cell setLongPressBlock:^{
            
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"删除消息" message:@"点击确定会删除本地缓存的消息" preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [[CDChatManager sharedManager] deleteAndDeleteConversation:conversation callBack:^(BOOL successed, NSError *error) {
                    
                    if (successed) {
                        [self showToast:@"删除消息成功"];
                    } else {
                        [self showToast:[Common errorStringWithError:error optionalString:@"删除消息失败"]];
                    }
                    [self headerRefreshing];
                }];
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [controller addAction:cancelAction];
            [controller addAction:action];
            [self presentViewController:controller animated:YES completion:nil];
        }];
        
        if (conversation.type == CDConversationTypeSingle) {
            
            cell.nameLabel.text = [conversation conversationDisplayName];
            [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[conversation headUrl:conversation.otherId]] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
                [cell.indicatorView startAnimating];
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                [cell.indicatorView stopAnimating];
            }];
            
        } else {
            if ([Common isObjectNull:[conversation groupChatImageURL]]) {//不存在
                cell.avatarImageView.image = conversation.icon;
            } else {
                
                [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[conversation groupChatImageURL]] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                    [cell.indicatorView startAnimating];
                    
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    [cell.indicatorView stopAnimating];
                }];
            }
            cell.nameLabel.text = [conversation conversationDisplayName];
        }
        
        if (conversation.lastMessage) {
            cell.messageTextLabel.attributedText = [[CDMessageHelper helper] attributedStringWithMessage:conversation.lastMessage conversation:conversation];
            cell.timestampLabel.text = [[NSDate dateWithTimeIntervalSince1970:conversation.lastMessage.sendTimestamp / 1000] timeAgoSinceNow];
        }
        
        if ([[NSString stringWithFormat:@"%@",conversation.unreadCount] intValue] > 0) {
            
            if (conversation.muted) {
                cell.litteBadgeView.hidden = NO;
            } else {
                if ([[NSString stringWithFormat:@"%@",conversation.unreadCount] intValue] >= 100) {
                    cell.badgeView.badgeText = @"99+";
                } else {
                    cell.badgeView.badgeText = [NSString stringWithFormat:@"%@", conversation.unreadCount];
                }
            }
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    AVIMConversation *conversation = [self.conversations objectAtIndex:indexPath.row];
    
    [conversation markAsReadInBackground];
    
    [self headerRefreshing];
    
    [[CDIMService service] pushToChatRoomByConversation:conversation fromNavigationController:self.navigationController];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([Common readAppIntegerDataForKey:IS_BIG_PICTUREMODEL]) {
        
        return [STConversationCell heightOfCell];
        
    } else {
        
       return [LZConversationCell heightOfCell];
    }
}

- (void)dealloc {
    
    [STNotificationCenter removeObserver:self name:kCDNotificationConnectivityUpdated object:nil];
    
    [STNotificationCenter removeObserver:self name:kCDNotificationMessageReceived object:nil];
    
    [STNotificationCenter removeObserver:self name:kCDNotificationUnreadsUpdated object:nil];
    
    [STNotificationCenter removeObserver:self name:STUserAccountHandlerUseProfileDidChangeNotification object:nil];
    
    [STNotificationCenter removeObserver:self name:STDidSuccessUpdateFriendInformationSendNotification object:nil];
    
    [STNotificationCenter removeObserver:self name:STUserDidSuccessChangeBigOrSmallPictureSendNotification object:nil];
    
    [STNotificationCenter removeObserver:self name:STDidSuccessQuitGroupChatSendNotification object:nil];
    
    [STNotificationCenter removeObserver:self name:STDidSuccessGroupChatSettingSendNotification object:nil];
}

@end
