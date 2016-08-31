//
//  STRelayViewController.m
//  30000day
//
//  Created by GuoJia on 16/8/4.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STRelayViewController.h"
#import "STRelayTableViewCell.h"

@interface STRelayViewController () <UITableViewDataSource,UITableViewDelegate,QGPickerViewDelegate>

@property (nonatomic,strong) UIBarButtonItem *sendButton;
@property (nonatomic,strong) QGPickerView *relationPicker;//关系
@property (nonatomic,strong) QGPickerView *rangePicker;//范围
@property (nonatomic,strong) NSNumber *relationNumber;
@property (nonatomic,strong) STRelayTableViewCell *relayCell;
@end

@implementation STRelayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"转发自媒体";
    
    [self configUI];
}

//配置界面
- (void)configUI {
    self.tableViewStyle = STRefreshTableViewGroup;
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.relationNumber = @1;
    
    //右面的按钮
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonAction)];
    self.sendButton = button;
    self.navigationItem.rightBarButtonItem = button;
    [self.navigationItem.rightBarButtonItem setTintColor:LOWBLUECOLOR];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.navigationItem.leftBarButtonItem setTintColor:LOWBLUECOLOR];
}

- (void)leftAction {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//转发
- (void)rightButtonAction {
    
    [self showHUDWithContent:@"正在转发" animated:YES];
    [self.relayCell.textView endEditing:YES];
    [STDataHandler sendReplayMediaMessageWithUserId:STUserAccountHandler.userProfile.userId weMediaId:self.mediumModel.mediumMessageId visibleType:self.relationNumber content:self.relayCell.textView.text success:^(BOOL success) {
        [self showToast:@"转载成功"];
        [self hideHUD:YES];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        [STNotificationCenter postNotificationName:STWeMediaSuccessSendNotification object:self.relationNumber];
    } failure:^(NSError *error) {
        [self showToast:[Common errorStringWithError:error optionalString:@"转载失败"]];
        [self hideHUD:YES];
    }];
}

- (STRelayTableViewCell *)relayCell {
    
    if (!_relayCell) {
        _relayCell = [[[NSBundle mainBundle] loadNibNamed:@"STRelayTableViewCell" owner:self options:nil] lastObject];
    }
    return _relayCell;
}

#pragma mark --- UITableViewDelegate / UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
        
    } else if (section == 1) {
        
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        self.relayCell.mediumModel = self.mediumModel;
        return self.relayCell;
        
    } else if (indexPath.section == 1) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"谁可以看";
            cell.detailTextLabel.text = [self relationStringWithNumber:self.relationNumber];
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            [self.relayCell.textView endEditing:YES];
            
            QGPickerView *picker = [[QGPickerView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 250, SCREEN_WIDTH, 250)];
            picker.delegate = self;
            picker.titleText = @"谁可以看";
            NSArray *dataArray = @[@"好友",@"公开",@"自己"];
            
            //显示QGPickerView
            [picker showPickView:[UIApplication sharedApplication].keyWindow withPickerViewNum:1 withArray:dataArray withArray:nil withArray:nil selectedTitle:[self relationStringWithNumber:self.relationNumber] selectedTitle:nil selectedTitle:nil];
            self.relationPicker = picker;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 160;
    }
    return 44.0f;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.relayCell.textView endEditing:YES];
}

- (NSString *)relationStringWithNumber:(NSNumber *)relationNumber {
    
    if ([relationNumber isEqualToNumber:@0]) {
        return @"自己";
    } else if ([relationNumber isEqualToNumber:@1]) {
        return @"好友";
    } else if ([relationNumber isEqualToNumber:@2]) {
        return @"公开";
    }
    return @"未知类型";
}

#pragma mark --- QGPickerViewDelegate
- (void)didSelectPickView:(QGPickerView *)pickView  value:(NSString *)value indexOfPickerView:(NSInteger)index indexOfValue:(NSInteger)valueIndex {
    
    if (pickView == self.relationPicker) {
        
        if ([value isEqualToString:@"好友"]) {
            self.relationNumber = @1;
        } else if ([value isEqualToString:@"自己"]) {
            self.relationNumber = @0;
        } else if ([value isEqualToString:@"公开"]){
            self.relationNumber = @2;
        }
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
