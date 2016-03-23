//
//  MailListViewController.m
//  30000day
//
//  Created by wei on 16/2/2.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "MailListViewController.h"
#import "MailListTableViewCell.h"
#import "ChineseString.h"
#import "ShareAnimatonView.h"
#import <MessageUI/MessageUI.h>

#import "UMSocial.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"

@interface MailListViewController () <UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UMSocialUIDelegate>

@property (nonatomic,assign) BOOL isSearch;

@property (nonatomic ,strong) NSMutableArray *indexArray;//里面装的NSSting(A,B,C,D.......)

@property (nonatomic ,strong) NSMutableArray *chineseStringArray;//该数组里面装的是chineseString这个模型
@property (nonatomic ,strong) NSMutableArray *cellArray;//存储的MailListTableViewCell

@property (nonatomic ,strong) NSMutableArray *searchResultArray;//存储的是搜索后的MailListTableViewCell

@end

@implementation MailListViewController

@synthesize searchResultArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"所有联系人";
    
    self.isSearch = NO;
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    //1.下载通信录好友
    [self.dataHandler sendAddressBooklistRequestCompletionHandler:^(NSMutableArray *chineseStringArray,NSMutableArray *sortArray,NSMutableArray *indexArray) {
        
        self.cellArray = [NSMutableArray array];
        
        self.chineseStringArray = [NSMutableArray arrayWithArray:chineseStringArray];
        
        self.indexArray = [NSMutableArray arrayWithArray:indexArray];
        
        for (int i = 0 ; i < chineseStringArray.count ; i++) {
            
            NSMutableArray *subDataArray = chineseStringArray[i];
            
            NSMutableArray *subArray = [NSMutableArray array];
            
            for (int j = 0; j < subDataArray.count; j++) {
                
                ChineseString *chineseString = subDataArray[j];
                
                MailListTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"MailListTableViewCell" owner:self options:nil] lastObject];
                
                cell.titleLabel.text = chineseString.string;
                
                [subArray addObject:cell];
            }
            
            [self.cellArray addObject:subArray];
        }
        
        [self.tableView reloadData];
        
    }];
    
}

#pragma ---
#pragma mark ---- 父视图的生命周期方法
- (void)searchBarDidBeginRestore:(BOOL)isAnimation  {
    
    [super searchBarDidBeginRestore:isAnimation];
    
     self.isSearch = NO;
    
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    [super searchBar:searchBar textDidChange:searchText];
    
    self.isSearch = [searchText isEqualToString:@""] ? NO : YES;
    
    //开始搜索
    self.searchResultArray = [NSMutableArray array];
    
    for (int i = 0; i < self.chineseStringArray.count; i++ ) {
        
        NSMutableArray *dataArray = self.chineseStringArray[i];
        
        for (int j = 0; j < dataArray.count; j++ ) {
            
            ChineseString *chineseString = dataArray[j];
            
            if ([chineseString.string containsString:searchText]) {
                
                [self.searchResultArray addObject:chineseString];
            }
            
        }
        
    }
    
    [self.tableView reloadData];
    
}

#pragma ---
#pragma mark --- UITableViewDelegate/UITableViewDataSource

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    if (!self.isSearch) {
        
        return self.indexArray;
    }
    
    return [NSMutableArray array];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (!self.isSearch) {
        
        NSString *key = [self.indexArray objectAtIndex:section];
        
        return key;
    }
    
    return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.isSearch) {
        
        return 1;
        
    } else {
        
        return self.cellArray.count;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isSearch) {
        
        return self.searchResultArray.count;
        
    }  else {
        
        NSMutableArray *array = self.cellArray[section];
        
        return array.count;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (self.isSearch) {
        
        return 0;
        
    } else {
        
        return 30;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    
    view.backgroundColor = RGBACOLOR(230, 230, 230, 1);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH, 20)];
    
    label.text = [self.indexArray objectAtIndex:section];
    
    label.textColor = [UIColor darkGrayColor];
    
    [view addSubview:label];
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    return index;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isSearch) {
        
        MailListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MailListTableViewCell"];
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MailListTableViewCell" owner:self options:nil] lastObject];
        }
        
        ChineseString *chineseString = self.searchResultArray[indexPath.row];
        
        cell.titleLabel.text = chineseString.string;
        
        //按钮点击回调
        [cell setInvitationButtonBlock:^{
            
            [self.view endEditing:YES];
            
            //显示分享界面
            [self showShareAnimatonView:indexPath];
            
        }];
        
        return cell;
        
    } else {
        
        NSMutableArray *array = self.cellArray[indexPath.section];
        
        MailListTableViewCell *cell = array[indexPath.row];
        
        //按钮点击回调
        [cell setInvitationButtonBlock:^{
            
            [self.view endEditing:YES];
            
            //显示分享界面
            [self showShareAnimatonView:indexPath];
            
        }];
        
        return cell;
    }
}

//显示分享界面
- (void)showShareAnimatonView:(NSIndexPath *)indexPath {
    
    ShareAnimatonView *shareAnimationView = [[[NSBundle mainBundle] loadNibNamed:@"ShareAnimatonView" owner:self options:nil] lastObject];
    
    //封装的动画般推出视图
    [ShareAnimatonView animateWindowsAddSubView:shareAnimationView];
    
    //按钮点击回调
    [shareAnimationView setShareButtonBlock:^(NSInteger tag,ShareAnimatonView *animationView) {
        
        [ShareAnimatonView annimateRemoveFromSuperView:animationView];
        
        if (tag == 7) {//发送短信
            
            if ([MFMessageComposeViewController canSendText] ) {

                //调用短信接口
                MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
                
                picker.messageComposeDelegate = self;
                
                ChineseString *chineseSting = ((NSMutableArray *)self.chineseStringArray[indexPath.section])[indexPath.row];
                
                picker.recipients = [NSArray arrayWithObject:chineseSting.phoneNumber];
                
                picker.body = @"我们正在玩30000day,你也来玩吧http://www.baidu.com(别激动测试下短信分享)";
                
                if (picker) {
                    
                    [self presentViewController:picker animated:YES completion:nil];
                }
                
            } else {
                
                [self showToast:@"该设备不支持短信功能"];
            }
            
        } else if (tag == 6) {//发送邮件
            
            if ([MFMailComposeViewController canSendMail]) {
                
                MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
                
                controller.mailComposeDelegate = self;
                
                [controller setSubject:@"My Subject"];
                
                [controller setMessageBody:@"我们正在玩30000day，你也来玩吧" isHTML:NO];
                
                if (controller) {
                    
                    [self presentViewController:controller animated:YES completion:nil];
                }
                
            } else {
                
                [self showToast:@"该设备没有设置邮箱账号"];
            }
            
        } else if (tag == 5) {
            
            [[UMSocialControllerService defaultControllerService] setShareText:@"我只是测试下分享" shareImage:[UIImage imageNamed:@"00"] socialUIDelegate:self];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            
        } else if (tag == 3) {
            
            [[UMSocialControllerService defaultControllerService] setShareText:@"测试QQ空间分享" shareImage:[UIImage imageNamed:@"IMG_1613"] socialUIDelegate:self];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQzone].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            
        } else if (tag == 4) {
            
            [[UMSocialControllerService defaultControllerService] setShareText:@"测试QQ分享" shareImage:[UIImage imageNamed:@"IMG_1613"] socialUIDelegate:self];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            
        }
    }];

}

#pragma mark ---- MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    
    [controller dismissViewControllerAnimated:NO completion:nil];
    
    switch ( result ) {
            
        case MessageComposeResultCancelled:
        {
            [controller dismissViewControllerAnimated:YES completion:nil];
        }
            break;
            
        case MessageComposeResultFailed:// send failed
            
            [self showToast:@"短信发送失败"];
            
            [controller dismissViewControllerAnimated:YES completion:nil];
            
            break;
            
        case MessageComposeResultSent:
        {
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
                        error:(NSError*)error;
{
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


#pragma mark --- UMSocialUIDelegate

- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
    
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}


@end
