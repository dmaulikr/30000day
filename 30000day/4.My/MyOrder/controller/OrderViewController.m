//
//  OrderViewController.m
//  30000day
//
//  Created by GuoJia on 16/4/5.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "OrderViewController.h"
#import "MyOrderTableViewCell.h"
#import "MTProgressHUD.h"
#import "OrderDetailViewController.h"

@interface OrderViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableArray *cellArray;

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 0.5f)];
    
    lineView.backgroundColor = RGBACOLOR(230, 230, 230, 1);
    
    [self.view addSubview:lineView];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.isShowFootRefresh = NO;
    
    [self loadDataFromServerWith:_type];

    //成功取消订单要监听
    [STNotificationCenter addObserver:self selector:@selector(reloadData) name:STDidSuccessCancelOrderSendNotification object:nil];
    //成功支付订单要监听
    [STNotificationCenter addObserver:self selector:@selector(reloadData) name:STDidSuccessPaySendNotification object:nil];
}

//监听的通知的selector
- (void)reloadData {
    
    [self loadDataFromServerWith:_type];
}

//根据类型从服务器下载数据
- (void)loadDataFromServerWith:(OrderType)type {
    
    _type = type;
    
    NSNumber *newType = @0;
    
    if (type == OrderTypeAll) {
        
        newType = @0;
        
    } else if (type == OrderTypepaid) {
        
        newType = @2;
        
    } else if (type == OrderTypeWillPay) {
        
        newType = @1;
    }
    
    [self.dataHandler sendFindOrderUserId:STUserAccountHandler.userProfile.userId type:newType success:^(NSMutableArray *success) {
       
        self.dataArray = success;
        
        self.cellArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < self.dataArray.count; i++) {
            
            MyOrderTableViewCell *cell =  [[[NSBundle mainBundle] loadNibNamed:@"MyOrderTableViewCell" owner:self options:nil] lastObject];
            
            cell.orderModel = self.dataArray[i];
            
            [self.cellArray addObject:cell];
        }
        
        [self.tableView.mj_header endRefreshing];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        
        [self loadDataFromServerWith:_type];
        
    }];
}

- (void)headerRefreshing {
    
    [self loadDataFromServerWith:_type];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma ---
#pragma mark ---- UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.cellArray[indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 122;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MyOrderModel *model = self.dataArray[indexPath.row];
    
    OrderDetailViewController *controller = [[OrderDetailViewController alloc] init];
    
    controller.orderNumber = model.orderNumber;
    
    controller.status = model.status;
    
    controller.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:controller animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)dealloc {
    
    [STNotificationCenter removeObserver:self name:STDidSuccessCancelOrderSendNotification object:nil];
    [STNotificationCenter removeObserver:self name:STDidSuccessPaySendNotification object:nil];
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
