//
//  STDenounceViewController.m
//  30000day
//
//  Created by GuoJia on 16/9/2.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STDenounceViewController.h"
#import "STDenounceTableViewCell.h"
#import "STSendMediumHeadFootView.h"

@interface STDenounceViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) STSendMediumHeadFootView *footerView;
@property (nonatomic,strong) STDenounceTableViewCell *cell;
@end

@implementation STDenounceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self findDenounceData];//获取类型
}
- (void)configUI {
    self.title = @"举报";
    
    self.tableViewStyle = STRefreshTableViewGroup;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 0);
    [self showHeadRefresh:YES showFooterRefresh:NO];
    self.footerView.sendButton.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)findDenounceData {
    [STDataHandler sendFindDenounceTypesSuccess:^(NSMutableArray <STDenounceModel *>*dataArray) {
        self.dataArray = dataArray;
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [self showToast:[Common errorStringWithError:error optionalString:@"服务器连接失败"]];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)headerRefreshing {
    [self findDenounceData];
}

- (STSendMediumHeadFootView *)footerView {
    
    if (!_footerView) {
        _footerView = [[NSBundle mainBundle] loadNibNamed:@"STSendMediumHeadFootView" owner:nil options:nil][0];
        [_footerView.sendButton setTitle:@"提交" forState:UIControlStateNormal];
        [_footerView.sendButton setBackgroundImage:[Common imageWithColor:RGBACOLOR(200, 200, 200, 1)] forState:UIControlStateDisabled];
        [_footerView.sendButton setBackgroundImage:[Common imageWithColor:LOWBLUECOLOR] forState:UIControlStateNormal];
        //点击发送回调
        __weak typeof(self) weakSelf = self;
        [_footerView setSendActionBlock:^(UIButton *button) {
            [weakSelf sendAction];//开始发送
        }];
    }
    return _footerView;
}

//开始发送
- (void)sendAction {
    [self showHUDWithContent:@"正在提交" animated:YES];
    STChooseItemModel *model = [self.cell getSelectedChooseItemArray][0];
    
    [STDataHandler sendCommitDenounceTypesUserId:STUserAccountHandler.userProfile.userId
                                     denounceeId:self.writerId
                                    denounceType:model.itemTag
                                         content:self.cell.textView.text
                                         success:^(BOOL success) {
                                             [self showToast:@"举报成功"];
                                             [self hideHUD:YES];
                                             [self.navigationController popViewControllerAnimated:YES];
                                         }
                                         failure:^(NSError *error) {
                                             [self showToast:[Common errorStringWithError:error optionalString:@"请求服务器失败"]];
                                             [self hideHUD:YES];
                                         }];
}
//判断发送按钮是否可用
- (void)judgeSendButtonCanUse {
    if ([self.cell getSelectedChooseItemArray].count) {
        self.footerView.sendButton.enabled = YES;
    } else {
        self.footerView.sendButton.enabled = NO;
    }
}

#pragma ---
#pragma mark ----- UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    STDenounceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STDenounceTableViewCell"];
    if (cell == nil) {
        cell = [[STDenounceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"STDenounceTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configCellWith:self.dataArray];
    cell.titleLabel.text = [NSString stringWithFormat:@"被举报者: %@",self.retweeted_status.originalNickName];
    [cell setSelectedBlock:^{
        [self judgeSendButtonCanUse];
    }];
    self.cell = cell;
    [self judgeSendButtonCanUse];//判断发送按钮是否可用
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [STDenounceTableViewCell cellHeightWithDataArray:self.dataArray];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.footerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 64;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.cell.textView endEditing:YES];
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
