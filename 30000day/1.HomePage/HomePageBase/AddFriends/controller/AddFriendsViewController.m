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
#import "QRReaderViewController.h"
#import "ShareAnimatonView.h"
#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>

#import "UMSocial.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "ShareTableViewCell.h"

@interface AddFriendsViewController () <UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UMSocialUIDelegate>

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
    
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 3) {
        
        CGFloat h = ((SCREEN_WIDTH - 104) / 4) * 2 + 50;
        
        return h;
        
    }
    
    return 44;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    if (section == 3) {
        
        return @"分享";
        
    }
    
    return nil;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return [[[NSBundle mainBundle] loadNibNamed:@"SearchFriendsTableViewCell" owner:nil options:nil] lastObject];
        
    } else if(indexPath.section == 1) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.text = @"通讯录好友";
        
        return cell;
        
    } else if (indexPath.section == 2) {
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SweepCell"];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SweepCell"];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.text = @"扫一扫";
        
        return cell;
    
    } else {
        
        ShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShareTableViewCell"];
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ShareTableViewCell" owner:nil options:nil] lastObject];
        }
        
        [cell setButtonBlock:^(NSInteger tag) {
            
            [self share:tag];
            
        }];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        SearchFriendsViewController *controller = [[SearchFriendsViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];

    } else if(indexPath.section == 1) {
        
        if ([Common needBind]) {
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"绑定手机" message:@"请绑定手机号并设置昵称，方便通讯录联系人互相发现" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController pushViewController:(UIViewController *)[Common getBindController] animated:YES];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [controller addAction:action];
            [controller addAction:cancelAction];
            [self presentViewController:controller animated:YES completion:nil];
        } else {
            MailListViewController *controller = [[MailListViewController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
        
    } else if (indexPath.section == 2) {
        
        QRReaderViewController *QRController = [[QRReaderViewController alloc] init];
        QRController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:QRController animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ---- MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    [controller dismissViewControllerAnimated:NO completion:nil];
    
    switch ( result ) {
            
        case MessageComposeResultCancelled: {
            
            [controller dismissViewControllerAnimated:YES completion:nil];
        }
            break;
            
        case MessageComposeResultFailed:// send failed
            
            [self showToast:@"短信发送失败"];
            
            [controller dismissViewControllerAnimated:YES completion:nil];
            
            break;
            
        case MessageComposeResultSent: {
            
            [self showToast:@"短信发送成功"];
            
            [controller dismissViewControllerAnimated:YES completion:nil];
        }
            break;
            
        default:
            
            break;
    }
}

#pragma mark ---- MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    
    [controller dismissViewControllerAnimated:NO completion:nil];
    
    if (result == MFMailComposeResultSent) {
        
        [self showToast:@"邮件发送成功"];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else if (result == MFMailComposeResultCancelled) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else if (result == MFMailComposeResultFailed) {
        
        [self showToast:@"邮件发送失败"];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else if (result == MFMailComposeResultSaved) {
        
        [self showToast:@"邮件已经保存"];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)share:(NSInteger)tag {

    NSString *shareString = @"人生只有30000天，想要保值增值，下载30000天APP吧";
    
    if (tag == 8) {
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = @"http://www.30000day.com";
        [self showToast:@"已经复制到剪贴板"];
        
    } else if (tag == 7) {//发送短信
        
        
    } else if (tag == 6) {//发送邮件
        
        if ([MFMailComposeViewController canSendMail]) {
            
            MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
            
            controller.mailComposeDelegate = self;
            
            [controller setSubject:@"My Subject"];
            
            [controller setMessageBody:shareString isHTML:NO];
            
            if (controller) {
                
                [self presentViewController:controller animated:YES completion:nil];
            }
            
        } else {
            
            [self showToast:@"该设备没有设置邮箱账号"];
        }
        
    } else if (tag == 5) {
        [UMSocialData defaultData].extConfig.qqData.title = @"30000天";
        [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@,%@",shareString,@"苹果http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1086080481&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8 安卓http://a.app.qq.com/o/simple.jsp?pkgname=com.shutian.ttd"] shareImage:[UIImage imageNamed:@"sharePicture"] socialUIDelegate:self];        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        
    }  else if (tag == 4) {
        
        [UMSocialData defaultData].extConfig.qqData.title = @"30000天";
        [[UMSocialControllerService defaultControllerService] setShareText:shareString shareImage:[UIImage imageNamed:@"sharePicture"] socialUIDelegate:self];        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        
    } else if (tag == 3) {
        
        [UMSocialData defaultData].extConfig.qzoneData.title = @"30000天";
        [[UMSocialControllerService defaultControllerService] setShareText:shareString shareImage:[UIImage imageNamed:@"sharePicture"] socialUIDelegate:self];        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQzone].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        
    } else if (tag == 2 ) {
        
        [UMSocialData defaultData].extConfig.wechatSessionData.title = @"30000天";
        [[UMSocialControllerService defaultControllerService] setShareText:shareString shareImage:[UIImage imageNamed:@"sharePicture"] socialUIDelegate:self];        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        
    } else if (tag == 1 ) {
        
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareString;
        [[UMSocialControllerService defaultControllerService] setShareText:@"30000天" shareImage:[UIImage imageNamed:@"sharePicture"] socialUIDelegate:self];        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    }
    
}

#pragma mark --- UMSocialUIDelegate

- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
    
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess) {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}


@end
