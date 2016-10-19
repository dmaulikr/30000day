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

@property (nonatomic,strong) NSMutableArray *modifiedArray;
//
//@property (nonatomic,strong) NSMutableArray *removeListArray;

@end

@implementation STFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableViewStyle = STRefreshTableViewPlain;
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    [self.tableView setEditing:YES animated:NO];//编辑状态
    
//    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
//    
//    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *confirmButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirmAction)];
    
    confirmButton.enabled = NO;
    
    self.navigationItem.rightBarButtonItem = confirmButton;
    
    self.modifiedArray = [NSMutableArray array];
}

//取消操作
- (void)cancelAction {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//确定操作
- (void)confirmAction {

    NSMutableArray *membersArrray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.modifiedArray.count; i++) {
        
        UserInformationModel *model = self.modifiedArray[i];
        
        [membersArrray addObject:[NSString stringWithFormat:@"%@",model.userId]];
    }
    
    if (self.doneBlock) {
        
        self.doneBlock(self,membersArrray,self.modifiedArray);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma ---
#pragma mark --- UITableViewDataSource/UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.userModelArray.count;
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
        
    UserInformationModel *model = self.userModelArray[indexPath.row];
    
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
    
    UserInformationModel *model = [self.userModelArray objectAtIndex:indexPath.row];
    
    if (![self.modifiedArray containsObject:model]) {//不包含 才加进去
        
        [self.modifiedArray addObject:model];
        
        [self judgeBarButtonCanUse:self.modifiedArray];//判断按钮是否可用
    }
}

//取消一项
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserInformationModel *deleteObject = [self.userModelArray objectAtIndex:indexPath.row];
    
    if ([self.modifiedArray containsObject:deleteObject]) {//不包含 才加进去
        
        [self.modifiedArray removeObject:deleteObject];
        
        [self judgeBarButtonCanUse:self.modifiedArray];//判断按钮是否可用
    }
}

- (void)judgeBarButtonCanUse:(NSMutableArray *)removeListArray {
    
    if (removeListArray.count > 0) {
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
//        self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"确定(%d)",(int)removeListArray.count];
        
    } else {
        
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
//        self.navigationItem.rightBarButtonItem.title = @"确定";
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
