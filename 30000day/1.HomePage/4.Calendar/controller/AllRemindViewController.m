//
//  AllRemindViewController.m
//  30000day
//
//  Created by GuoJia on 16/5/16.
//  Copyright © 2016年 GuoJia. All rights reserved.
//  所有的提醒界面

#import "AllRemindViewController.h"
#import "STRemindManager.h"
#import "RemindContentTableViewCell.h"
#import "AddRemindViewController.h"

@interface AllRemindViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableArray *removeListArray;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backgroudViewHeightConstaints;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@end

@implementation AllRemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    
    self.title = @"所有的提醒";
    
    [self loadRemindDataFromCoreData];
    
    [STNotificationCenter addObserver:self selector:@selector(loadRemindDataFromCoreData) name:STDidSuccessDeleteRemindSendNotification object:nil];
    
    [STNotificationCenter addObserver:self selector:@selector(loadRemindDataFromCoreData) name:STDidSuccessChangeOrAddRemindSendNotification object:nil];
    
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction:)];
    
    saveButtonItem.tintColor = LOWBLUECOLOR;
    
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    
    self.backgroudViewHeightConstaints.constant = 0;
#pragma mark --- 设置左右按钮
    self.leftButton.layer.cornerRadius = 3;
    
    self.leftButton.layer.masksToBounds = YES;
    
    self.rightButton.layer.cornerRadius = 3;
    
    self.rightButton.layer.masksToBounds = YES;
}

- (void)saveAction:(UIBarButtonItem *)saveButtonItem {
    
    [self.tableView setEditing:!self.tableView.editing animated:NO];//勾选删除
    
    if (self.tableView.editing) {
        
        [self.navigationItem.rightBarButtonItem setTitle:@"取消"];
        
        self.backgroudViewHeightConstaints.constant = 55;
        
        self.removeListArray = [NSMutableArray array];
        
        [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
           
            [self loadViewIfNeeded];
            
        } completion:nil];
        
    } else {
        
        [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
        
        [self becomeBefore];
    
        [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            [self loadViewIfNeeded];
            
        } completion:nil];
    }
}

- (void)becomeBefore {
    
    [self.leftButton setTitle:@"全选" forState:UIControlStateNormal];
    
    self.leftButton.tag = 10;
    
    self.backgroudViewHeightConstaints.constant = 0;
    
    [self.removeListArray removeAllObjects];
}

- (IBAction)buttonClickAction:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    if (button.tag == 10) {//左边的
        
        [button setTitle:@"取消全选" forState:UIControlStateNormal];
        
        button.tag = 12;
        
        for (int i = 0; i < self.dataArray.count; i++) {
            
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            
            if (![self.removeListArray containsObject:self.dataArray[i]]) {//不包含 才加进去
                
                [self.removeListArray addObject:self.dataArray[i]];
            }
        }
        
    } else if (button.tag == 11) {//删除操作
        
        if (self.removeListArray.count > 0) {

            [self.dataArray removeObjectsInArray:self.removeListArray];//删除已经勾选的数据

            //删除数据库里面的东西
            if ([[STRemindManager shareRemindManager] deleteOjbectWithArray:self.removeListArray]) {//删除成功

                [self showToast:@"批量删除成功"];

                [STNotificationCenter postNotificationName:STDidSuccessDeleteRemindSendNotification object:nil];
                
                [self saveAction:self.navigationItem.rightBarButtonItem];
                
                [self becomeBefore];

            } else {//删除失败

                [self showToast:@"批量删除失败"];
            }
        }
    } else if (button.tag == 12) {//全选状态
        
        button.tag = 10;
        
        [button setTitle:@"全选" forState:UIControlStateNormal];
        
        for (int i = 0; i < self.dataArray.count; i++) {
            
            [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES];
        }
        
        [self.removeListArray removeAllObjects];
    }
}

- (void)loadRemindDataFromCoreData {
    
    self.dataArray = [[STRemindManager shareRemindManager] allRemindModelWithUserId:STUserAccountHandler.userProfile.userId];
    
    [self.tableView reloadData];
}

- (void)dealloc {
    
    [STNotificationCenter removeObserver:self name:STDidSuccessDeleteRemindSendNotification object:nil];
    
    [STNotificationCenter removeObserver:self name:STDidSuccessChangeOrAddRemindSendNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma ---
#pragma mark -- UITableViewDataSource/UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RemindContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemindContentTableViewCell"];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RemindContentTableViewCell" owner:nil options:nil] lastObject];
    }
    
    RemindModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    cell.model = model;
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        RemindModel *model = self.dataArray[indexPath.row];
        
        //删除数据库里面的东西
        if ([[STRemindManager shareRemindManager] deleteOjbectWithModel:model]) {//删除成功
            
            [self showToast:@"删除成功"];
            
            [STNotificationCenter postNotificationName:STDidSuccessDeleteRemindSendNotification object:nil];
            
        } else {//删除失败
            
            [self showToast:@"删除失败"];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.editing) {
        
        RemindModel *deleteObject = [self.dataArray objectAtIndex:indexPath.row];
        
        if (![self.removeListArray containsObject:deleteObject]) {//不包含 才加进去
            
            [self.removeListArray addObject:deleteObject];
        }
        
    } else {
        
        AddRemindViewController *controller = [[AddRemindViewController alloc] init];
        
        controller.oldModel = [self.dataArray objectAtIndex:indexPath.row];
        
        controller.changeORAdd = YES;//表示修改的
        
        controller.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:controller animated:YES];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

//取消一项
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RemindModel *deleteObject = [self.dataArray objectAtIndex:indexPath.row];
    
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
