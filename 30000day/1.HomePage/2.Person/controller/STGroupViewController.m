//
//  STGroupViewController.m
//  30000day
//
//  Created by GuoJia on 16/6/14.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STGroupViewController.h"
#import "CDChatManager.h"
#import "PersonTableViewCell.h"
#import "AVIMConversation.h"
#import "CDIMService.h"
#import "UIImageView+WebCache.h"
#import "GroupSettingManager.h"
#import "CDIMService.h"
#import "MTProgressHUD.h"

@interface STGroupViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation STGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群组";
    
    self.tableViewStyle = STRefreshTableViewPlain;
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    [self loadGroupConversation];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"新建" style:UIBarButtonItemStylePlain target:self action:@selector(creatNewGroup)];
    
    self.navigationItem.rightBarButtonItem = item;
    
    [STNotificationCenter addObserver:self selector:@selector(reloadGroupChat) name:STDidSuccessGroupChatSettingSendNotification object:nil];
}

//新建一个群聊
- (void)creatNewGroup {
    
    if ([Common isObjectNull:STUserAccountHandler.userProfile.userId]) {
        
        [self showToast:@"用户ID不存在"];
        
        return;
    }
    
    [GroupSettingManager createNewGroupChatFromController:self fromClientId:[NSString stringWithFormat:@"%@",STUserAccountHandler.  userProfile.userId] callBack:^(BOOL success, NSError *error,AVIMConversation *conversation) {
        
        if (success) {
  
            //创建群成功后再去下载所有群
            [self loadGroupConversation];
            
            [[CDIMService service] pushToChatRoomByConversation:conversation fromNavigationController:self.navigationController];
            
        } else {
            
            [self showToast:[Common errorStringWithError:error optionalString:@"新建失败"]];
        }
    }];
}

- (void)reloadGroupChat {
    
    [[CDChatManager sharedManager] findGroupedConversationsWithNetworkFirst:YES block:^(NSArray *objects, NSError *error) {
        
        if ([Common isObjectNull:error]) {
            
            self.dataArray = [NSMutableArray arrayWithArray:objects];
            
            [self.tableView reloadData];
            
        } else {
            
            [self showToast:[Common errorStringWithError:error optionalString:@"发生了未知因素"]];
        }
    }];
}

- (void)loadGroupConversation {//这地方如果没有网络的会崩溃
    
    [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(hideMTProgressHUD:) userInfo:nil repeats:nil];
    
    timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:3.0f];
    
    [[CDChatManager sharedManager] findGroupedConversationsWithNetworkFirst:YES block:^(NSArray *objects, NSError *error) {
       
        if ([Common isObjectNull:error]) {
            
            self.dataArray = [NSMutableArray arrayWithArray:objects];
            
            [self.tableView reloadData];
            
            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
            
        } else {
            
            [self showToast:[Common errorStringWithError:error optionalString:@"发生了未知因素"]];
            
            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        }
    }];
}

- (void)hideMTProgressHUD:(NSTimer *)timer {
    
    [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
    
    [timer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [STNotificationCenter removeObserver:self name:STDidSuccessGroupChatSettingSendNotification object:nil];
}

#pragma ---
#pragma mark -- UITableViewDataSource / UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"PersonTableViewCell_fifth";
    
    PersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"PersonTableViewCell" owner:self options:nil][4];
    }
    
    AVIMConversation *conversation = self.dataArray[indexPath.row];

    if ([Common isObjectNull:[conversation groupChatImageURL]]) {//URL不存在
        
        cell.imageView_fifth.image = conversation.icon;
        
    } else {//URL存在
        
        [cell.imageView_fifth sd_setImageWithURL:[NSURL URLWithString:[conversation groupChatImageURL]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }

    cell.label_fifth.text = conversation.name;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 71.5f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[CDIMService service] pushToChatRoomByConversation:self.dataArray[indexPath.row] fromNavigationController:self.navigationController];
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
