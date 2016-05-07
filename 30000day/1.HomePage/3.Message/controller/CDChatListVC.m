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

@interface CDChatListVC ()

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
- (NSMutableArray *)conversations {
    
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
    
    //成功的切换模式
    [STNotificationCenter addObserver:self selector:@selector(headerRefreshing) name:STUserDidSuccessChangeBigOrSmallPictureSendNotification object:nil];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
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

- (UIRefreshControl *)getRefreshControl {
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    refreshControl.tintColor = RGBACOLOR(200, 200, 200, 1);
    
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    return refreshControl;
}

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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    static NSString *headViewIndentifier = @"PersonHeadView";
    
    PersonHeadView *view = (PersonHeadView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:headViewIndentifier];
    
    view.titleLabel.hidden = YES;
    
    if (view == nil) {
        
        view = [[[NSBundle mainBundle] loadNibNamed:headViewIndentifier owner:self options:nil] lastObject];
    }
    
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
        
        return 44;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.conversations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([Common readAppIntegerDataForKey:IS_BIG_PICTUREMODEL]) {
        
        STConversationCell *cell = [STConversationCell dequeueOrCreateCellByTableView:tableView];
        
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
            
            [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:conversation.otherHeadUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];

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
                
            } else {
                
                if (conversation.unreadCount >= 100) {
                    
                    cell.badgeView.badgeText = @"99+";
                    
                } else {
                    
                    cell.badgeView.badgeText = [NSString stringWithFormat:@"%@", @(conversation.unreadCount)];
                }
            }
        }
        return cell;
        
    } else {
        
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
}

@end
