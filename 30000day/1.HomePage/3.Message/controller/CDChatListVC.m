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

@interface CDChatListVC ()

//@property (nonatomic, strong) LZStatusView *clientStatusView;

@property (nonatomic, strong) NSMutableArray *conversations;

@property (atomic, assign) BOOL isRefreshing;

@end

static NSMutableArray *cacheConvs;

@implementation CDChatListVC

static NSString *cellIdentifier = @"ContactCell";

/**
 *  lazy load conversations
 *
 *  @return NSMutableArray
 */
- (NSMutableArray *)conversations
{
    if (_conversations == nil) {
        
        _conversations = [[NSMutableArray alloc] init];
    }
    return _conversations;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [LZConversationCell registerCellToTableView:self.tableView];
    
    //添加头部刷新
    [self addHeadRefresh];
    
    // 当在其它 Tab 的时候，收到消息 badge 增加，所以需要一直监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerRefreshing) name:kCDNotificationMessageReceived object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerRefreshing) name:kCDNotificationUnreadsUpdated object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStatusView) name:kCDNotificationConnectivityUpdated object:nil];
    
    //成功的链接上凌云聊天服务器
    [STNotificationCenter addObserver:self selector:@selector(headerRefreshing) name:STDidSuccessConnectLeanCloudViewSendNotification object:nil];
    
    [STNotificationCenter addObserver:self selector:@selector(headerRefreshing) name:STDidSuccessUpdateFriendInformationSendNotification object:nil];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.contentInset =  UIEdgeInsetsMake(64, 0, 0, 0);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 刷新 unread badge 和新增的对话
    [self performSelector:@selector(headerRefreshing) withObject:nil afterDelay:0];
}

- (void)addHeadRefresh {
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    
}

- (void)headerRefreshing {
    
    if (self.isRefreshing) {
        
        return;
    }
    
    self.isRefreshing = YES;
    
    [[CDChatManager manager] findRecentConversationsWithBlock:^(NSArray *conversations, NSInteger totalUnreadCount, NSError *error) {
        
        dispatch_block_t finishBlock = ^{
            
            [self.tableView.mj_header endRefreshing];
            
            if ([self filterError:error]) {
                
                self.conversations = [NSMutableArray arrayWithArray:conversations];
                
                [self.tableView reloadData];
                
                if ([self.chatListDelegate respondsToSelector:@selector(setBadgeWithTotalUnreadCount:)]) {
                    
                    [self.chatListDelegate setBadgeWithTotalUnreadCount:totalUnreadCount];
                    
                }
                
                [self selectConversationIfHasRemoteNotificatoinConvid];
            }
            
            self.isRefreshing = NO;
        };
        
        if ([self.chatListDelegate respondsToSelector:@selector(prepareConversationsWhenLoad:completion:)]) {
            
            [self.chatListDelegate prepareConversationsWhenLoad:conversations completion:^(BOOL succeeded, NSError *error) {
                
                if ([self filterError:error]) {
                    
                    finishBlock();
                    
                } else {
                    
                    [self.tableView.mj_header endRefreshing];
                    
                    self.isRefreshing = NO;
                }
            }];
            
        } else {
            
            finishBlock();
            
        }
    }];
}

#pragma mark - client status view

//- (LZStatusView *)clientStatusView {
//    
//    if (_clientStatusView == nil) {
//        
//        _clientStatusView = [[LZStatusView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), kLZStatusViewHight)];
//        
//    }
//    
//    return _clientStatusView;
//}
//
//- (void)updateStatusView {
//    
//    if ([CDChatManager manager].connect) {
//        
//        self.tableView.tableHeaderView = nil ;
//        
//    } else {
//        
//        self.tableView.tableHeaderView = self.clientStatusView;
//    }
//}

- (UIRefreshControl *)getRefreshControl {
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    refreshControl.tintColor = RGBACOLOR(200, 200, 200, 1);
    
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    return refreshControl;
}

#pragma mark - refresh

//- (void)refresh {
//    [self refresh:nil];
//}

//- (void)refresh:(UIRefreshControl *)refreshControl {
//    
//    if (self.isRefreshing) {
//        
//        return;
//    }
//    
//    self.isRefreshing = YES;
//    
//    [[CDChatManager manager] findRecentConversationsWithBlock:^(NSArray *conversations, NSInteger totalUnreadCount, NSError *error) {
//        
//        dispatch_block_t finishBlock = ^{
//            
//            [self stopRefreshControl:refreshControl];
//            
//            if ([self filterError:error]) {
//                
//                self.conversations = [NSMutableArray arrayWithArray:conversations];
//                
//                for (int i = 0; i < self.conversations.count; i++) {
//                    
//                    AVIMConversation *conversation = [self.conversations objectAtIndex:i];
//                    
//                     UserInformationModel *model = [[UserInformationManager shareUserInformationManager] informationModelWithUserId:conversation.otherId];
//                    
//                    if (!model) {
//                        
//                        [[CDConversationStore store] deleteConversation:conversation];
//                    }
//                    
//                }
//                
//                [self.tableView reloadData];
//                
//                if ([self.chatListDelegate respondsToSelector:@selector(setBadgeWithTotalUnreadCount:)]) {
//                    
//                    [self.chatListDelegate setBadgeWithTotalUnreadCount:totalUnreadCount];
//                    
//                }
//                
//                [self selectConversationIfHasRemoteNotificatoinConvid];
//            }
//            
//            self.isRefreshing = NO;
//        };
//        
//        if ([self.chatListDelegate respondsToSelector:@selector(prepareConversationsWhenLoad:completion:)]) {
//            
//            [self.chatListDelegate prepareConversationsWhenLoad:conversations completion:^(BOOL succeeded, NSError *error) {
//                
//                if ([self filterError:error]) {
//                    
//                    finishBlock();
//                    
//                } else {
//                    
//                    [self stopRefreshControl:refreshControl];
//                    
//                    self.isRefreshing = NO;
//                }
//            }];
//            
//        } else {
//            
//            finishBlock();
//            
//        }
//    }];
//}

- (void)selectConversationIfHasRemoteNotificatoinConvid {
    
    if ([CDChatManager manager].remoteNotificationConvid) {
        
        // 进入之前推送弹框点击的对话
        BOOL found = NO;
        
        for (AVIMConversation *conversation in self.conversations) {
            
            if ([conversation.conversationId isEqualToString:[CDChatManager manager].remoteNotificationConvid]) {
                
                if ([self.chatListDelegate respondsToSelector:@selector(viewController:didSelectConv:)]) {
                    
                    [self.chatListDelegate viewController:self didSelectConv:conversation];
                    
                    found = YES;
                }
            }
        }
        
        if (!found) {
            DLog(@"not found remoteNofitciaonID");
        }
        
        [CDChatManager manager].remoteNotificationConvid = nil;
    }
}

#pragma mark - utils

- (void)stopRefreshControl:(UIRefreshControl *)refreshControl {
    
    if (refreshControl != nil && [[refreshControl class] isSubclassOfClass:[UIRefreshControl class]]) {
        
        [refreshControl endRefreshing];
    }
}

- (BOOL)filterError:(NSError *)error {
    if (error) {
        
        [[[UIAlertView alloc]
          initWithTitle:nil message:[NSString stringWithFormat:@"%@", error] delegate:nil
          cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        
        return NO;
    }
    return YES;
}


#pragma mark - table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.conversations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LZConversationCell *cell = [LZConversationCell dequeueOrCreateCellByTableView:tableView];
    
    AVIMConversation *conversation = [self.conversations objectAtIndex:indexPath.row];
    
    if (conversation.type == CDConversationTypeSingle) {
        
        cell.nameLabel.text = conversation.displayName;
        
        //长按手势，长按后删除该cell
        [cell setLongPressBlock:^{
    
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"删除消息" message:@"点击确定会删除该条消息" preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [[CDConversationStore store] deleteConversation:conversation];
                
                [self headerRefreshing];
                
            }];

            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            [controller addAction:cancelAction];
            
            [controller addAction:action];
            
            [self presentViewController:controller animated:YES completion:nil];
        }];
        
        if ([self.chatListDelegate respondsToSelector:@selector(defaultAvatarImageView)]) {
            
            [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:conversation.otherHeadUrl] placeholderImage:[self.chatListDelegate defaultAvatarImageView]];
            
        } else {
            
            [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:conversation.otherHeadUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        }
        
    } else {
        
        [cell.avatarImageView setImage:conversation.icon];
        
        cell.nameLabel.text = conversation.displayName;
    }
    
    if (conversation.lastMessage) {
        
        cell.messageTextLabel.attributedText = [[CDMessageHelper helper] attributedStringWithMessage:conversation.lastMessage conversation:conversation];
        
        cell.timestampLabel.text = [[NSDate dateWithTimeIntervalSince1970:conversation.lastMessage.sendTimestamp / 1000] timeAgoSinceNow];
    }
    
    if (conversation.unreadCount > 0) {
        
        if (conversation.muted) {
            
            cell.litteBadgeView.hidden = NO;
            
        } else {
            
            if (conversation.unreadCount >= 100) {
                
                cell.badgeView.badgeText = @"99+";
                
            } else {
                
                cell.badgeView.badgeText = [NSString stringWithFormat:@"%@", @(conversation.unreadCount)];
            }
        }
    }
    
    if ([self.chatListDelegate respondsToSelector:@selector(configureCell:atIndexPath:withConversation:)]) {
        
        [self.chatListDelegate configureCell:cell atIndexPath:indexPath withConversation:conversation];
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        AVIMConversation *conversation = [self.conversations objectAtIndex:indexPath.row];
        
        [[CDConversationStore store] deleteConversation:conversation];
        
        [self headerRefreshing];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return true;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    AVIMConversation *conversation = [self.conversations objectAtIndex:indexPath.row];
    
    [conversation markAsReadInBackground];
    
    [self headerRefreshing];
    
    if ([self.chatListDelegate respondsToSelector:@selector(viewController:didSelectConv:)]) {
        
        [self.chatListDelegate viewController:self didSelectConv:conversation];
        
    }
    
    //push到聊天界面
//    CDChatRoomVC *controller = [[CDChatRoomVC alloc] initWithConversation:conversation];
//    
//    controller.hidesBottomBarWhenPushed = YES;
//    
//    [self.navigationController pushViewController:controller animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [LZConversationCell heightOfCell];
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCDNotificationConnectivityUpdated object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCDNotificationMessageReceived object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCDNotificationUnreadsUpdated object:nil];
    
    [STNotificationCenter removeObserver:self name:STUserAccountHandlerUseProfileDidChangeNotification object:nil];
    
    [STNotificationCenter removeObserver:self name:STDidSuccessUpdateFriendInformationSendNotification object:nil];
}

@end
