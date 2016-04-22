//
//  SubscribeCentreViewController.m
//  30000day
//
//  Created by GuoJia on 16/4/21.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SubscribeCentreViewController.h"
#import "SubscribeTableViewCell.h"
#import "SearchWriterViewController.h"
#import "UIImage+WF.h"
#import "InformationWriterModel.h"
#import "InformationWriterHomepageViewController.h"

@interface SubscribeCentreViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *leftTableView;//左边标题

@property (weak, nonatomic) IBOutlet UITableView *rightTableView;//右面的内容

@property (nonatomic,assign) NSInteger selectRow;//选中的row

@property (nonatomic,strong) NSArray *titleArray;

@property (nonatomic,copy) NSString  *suscribeType;//类型

@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation SubscribeCentreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订阅中心";
    
    [self.leftTableView setTableFooterView:[[UIView alloc] init]];
    
    [self.rightTableView setTableFooterView:[[UIView alloc] init]];
    
    self.titleArray = [NSArray arrayWithObjects:@"热门",@"饮食",@"运动",@"作息",@"备孕",@"孕期",@"育儿",@"治未病",@"体检",@"就医", nil];
    
    self.selectRow = 0;
    
    //设置右按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:[[UIImage imageNamed:@"search"] imageWithTintColor:LOWBLUECOLOR] forState:UIControlStateNormal];
    
    button.frame = CGRectMake(0, 0, 28, 28);
    
    UIBarButtonItem *rightItem  = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [button addTarget:self action:@selector(rightClickAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //默认是下载热门的
    self.suscribeType = @"00";
    
    [self loadDataWithUserId:STUserAccountHandler.userProfile.userId suscribeType:self.suscribeType];
    
    //监听通知
    [STNotificationCenter addObserver:self selector:@selector(reloadSubscribeList) name:STDidSuccessSubscribeSendNotification object:nil];
    
    [STNotificationCenter addObserver:self selector:@selector(reloadSubscribeList) name:STDidSuccessCancelSubscribeSendNotification object:nil];
}

//监听通知的方法
- (void)reloadSubscribeList {
    
    [self loadDataWithUserId:STUserAccountHandler.userProfile.userId suscribeType:self.suscribeType];
}

- (void)rightClickAction {
    
    SearchWriterViewController *controller = [[SearchWriterViewController alloc] init];
    
    controller.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)loadDataWithUserId:(NSNumber *)userId suscribeType:(NSString *)suscribeType {
    
    [self.dataHandler sendWriterListWithUserId:userId suscribeType:suscribeType success:^(NSMutableArray *dataArray) {
       
        self.dataArray = dataArray;
        
        [self.rightTableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  ---
#pragma mark ---- UITableViewDelegate / UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.leftTableView) {
        
        return 10;
        
    } else {
        
        return self.dataArray.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView == self.leftTableView) {
        
        return 1;
        
    } else {
        
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.leftTableView) {
        
        static NSString *indentifier_first = @"SubscribeTableViewCell_first";
        
        SubscribeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier_first];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SubscribeTableViewCell" owner:self options:nil] firstObject];
        }
        
        if (indexPath.row == self.selectRow) {
            
             cell.titleLabel.textColor = LOWBLUECOLOR;
            
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        
        cell.titleLabel.text = self.titleArray[indexPath.row];
        
        return cell;
        
    } else {
        
        static NSString *indentifier_second = @"SubscribeTableViewCell_second";
        
        SubscribeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier_second];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SubscribeTableViewCell" owner:self options:nil] lastObject];
            
        }
        
        InformationWriterModel *model = self.dataArray[indexPath.row];
        
        //点击订阅回调
        [cell setClickActionBlock:^(UIButton *subcribeButton) {
            
            if (model.isMineSubscribe == 0) {//订阅操作
                
                [self.dataHandler sendSubscribeWithWriterId:model.writerId userId:[STUserAccountHandler.userProfile.userId stringValue] success:^(BOOL success) {
                    
                    model.isMineSubscribe = 1;
                    
                    [subcribeButton setTitle:@"取消订阅" forState:UIControlStateNormal];
                    
                } failure:^(NSError *error) {
                    
                    [self showToast:@"订阅失败"];
                    
                }];
                
            } else {
                
                [self.dataHandler sendCancelSubscribeWriterId:model.writerId userId:[STUserAccountHandler.userProfile.userId stringValue] success:^(BOOL success) {

                    model.isMineSubscribe = 0;
                    
                    [subcribeButton setTitle:@"订阅" forState:UIControlStateNormal];
                    
                } failure:^(NSError *error) {
                   
                    [self showToast:@"取消失败"];
                    
                }];
            }
            
        }];

        cell.writerModel = model;
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.leftTableView ) {
        
        return 44.0f;
        
    } else {
    
        return 90.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.leftTableView ) {
        
        self.selectRow = indexPath.row;
        
        [tableView reloadData];
        
        if (indexPath.row == 0) {//热门
            
            self.suscribeType = @"00";
            
            [self loadDataWithUserId:STUserAccountHandler.userProfile.userId suscribeType:self.suscribeType];
            
        } else {//非热门
            
            self.suscribeType = [NSString stringWithFormat:@"%d",(int)indexPath.row + 9];
            
            [self loadDataWithUserId:STUserAccountHandler.userProfile.userId suscribeType:self.suscribeType];
        }

    } else {
        
        InformationWriterModel *writerModel = self.dataArray[indexPath.row];
        
        InformationWriterHomepageViewController *controller = [[InformationWriterHomepageViewController alloc] init];
        
        controller.writerId = writerModel.writerId;
        
        [self.navigationController pushViewController:controller animated:YES];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)dealloc {
    
    [STNotificationCenter removeObserver:self name:STDidSuccessSubscribeSendNotification object:nil];
    
    [STNotificationCenter removeObserver:self name:STDidSuccessCancelSubscribeSendNotification object:nil];
    
    self.titleArray = nil;
    
    self.dataArray = nil;
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
