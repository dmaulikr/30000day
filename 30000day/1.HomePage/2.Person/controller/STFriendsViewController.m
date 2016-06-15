//
//  STFriendsViewController.m
//  30000day
//
//  Created by GuoJia on 16/6/14.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STFriendsViewController.h"
#import "PersonInformationsManager.h"
#import "PersonTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "CDChatManager.h"

@interface STFriendsViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableArray *removeListArray;

@end

@implementation STFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择联系人";
    
    self.tableViewStyle = STRefreshTableViewPlain;
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    [self.tableView setEditing:YES animated:NO];//编辑状态
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *confirmButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirmAction)];
    
    self.navigationItem.rightBarButtonItem = confirmButton;
    
    self.dataArray = [PersonInformationsManager shareManager].informationsArray;//拿到之前赋值的
    
    self.removeListArray = [NSMutableArray array];
}

//取消操作
- (void)cancelAction {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//确定操作
- (void)confirmAction {
    
    
    
//    [CDChatManager sharedManager] createConversationWithMembers:<#(NSArray *)#> type:<#(CDConversationType)#> unique:<#(BOOL)#> attributes:<#(NSDictionary *)#> callback:^(AVIMConversation *conversation, NSError *error) {
//        
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma ---
#pragma mark --- UITableViewDataSource/UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *indentifier = @"PersonTableViewCell_group";
    
    PersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    
    if (cell == nil) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"PersonTableViewCell" owner:nil options:nil][4];
    }
        
    UserInformationModel *model = _dataArray[indexPath.row];
    
    [cell.imageView_fifth sd_setImageWithURL:[NSURL URLWithString:[model showHeadImageUrlString]] placeholderImage:[UIImage imageNamed:@"placeholder"]];//显示图片
    
    cell.label_fifth.text = [model showNickName];//显示昵称
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 71.5f;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserInformationModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    if (![self.removeListArray containsObject:model]) {//不包含 才加进去
        
        [self.removeListArray addObject:model];
    }
}

//取消一项
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserInformationModel *deleteObject = [self.dataArray objectAtIndex:indexPath.row];
    
    if ([self.removeListArray containsObject:deleteObject]) {//不包含 才加进去
        
        [self.removeListArray removeObject:deleteObject];
    }
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
