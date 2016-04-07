//
//  OrderDetailViewController.m
//  30000day
//
//  Created by GuoJia on 16/4/6.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "MyOrderDetailModel.h"
#import "PaymentViewController.h"
#import "OrderDetailTableViewCell.h"
#import "PersonInformationTableViewCell.h"
#import "ShopDetailViewController.h"
#import "MTProgressHUD.h"

@interface OrderDetailViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) MyOrderDetailModel *detailModel;

@property (weak, nonatomic) IBOutlet UIButton *conformButton;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet UIView *backgoudView;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    
    //配置UI界面
    [self configUI];

    [self judgeConformButtonCanUse];
    
    [self loadDataFromServer];
}

//配置UI界面
- (void)configUI {
    
    self.isShowBackItem = YES;
    
    self.tableViewStyle = STRefreshTableViewGroup;
    
    self.isShowFootRefresh = NO;
    
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44);
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.backgoudView.layer.borderColor = RGBACOLOR(200, 200, 200, 1).CGColor;
    self.backgoudView.layer.borderWidth = 0.5f;
    
    self.cancelButton.layer.cornerRadius = 5;
    self.cancelButton.layer.masksToBounds = YES;
    
    self.cancelButton.layer.borderWidth = 0.5f;
    self.cancelButton.layer.borderColor = RGBACOLOR(200, 200, 200, 1).CGColor;
    
    self.conformButton.layer.cornerRadius = 5;
    self.conformButton.layer.masksToBounds = YES;
    
    [self.conformButton setBackgroundImage:[Common imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    [self.cancelButton setBackgroundImage:[Common imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
}

- (void)headerRefreshing {
    
    [self loadDataFromServer];
    
}

//从服务器下载数据
- (void)loadDataFromServer {
    
    [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
    //下载数据
    [self.dataHandler sendFindOrderDetailOrderNumber:self.orderNumber success:^(MyOrderDetailModel *detailModel) {
        
        self.detailModel = detailModel;
        
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        
        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        
    } failure:^(NSError *error) {
        
        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        
        [self.tableView.mj_header endRefreshing];
        
    }];
}

//取消预约
- (IBAction)leftButtonAction:(id)sender {
    
    [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
    
    [self.dataHandler sendCancelOrderWithOrderNumber:self.detailModel.orderNo
                                             success:^(BOOL success) {
                                                 
                                                 [self showToast:@"订单取消成功"];
                                                 
                                                 self.conformButton.enabled = NO;
                                                 
                                                 self.cancelButton.enabled = NO;
                                                 
                                                 [self.conformButton setTitle:@"已取消" forState:UIControlStateNormal];
                                                 
                                                 [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                                                 
                                             } failure:^(NSError *error) {
                                                 
                                                 [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                                                 
                                             }];
}

//前往预约
- (IBAction)rightButtonAction:(id)sender {
    
    PaymentViewController *controller = [[PaymentViewController alloc] init];
    
    controller.selectorDate = [NSDate dateWithTimeIntervalSince1970:[self.detailModel.orderDate doubleValue]/1000.0000000];
    
    controller.timeModelArray = self.detailModel.orderCourtList;
    
    controller.productName = self.detailModel.productName;
    
    [self.navigationController pushViewController:controller animated:YES];
}

//判断确认订单是否可用
- (void)judgeConformButtonCanUse {
    
    if ([self.status isEqualToString:@"10"]) {
        
        [self.conformButton setTitle:@"等待付款" forState:UIControlStateNormal];
        
        self.conformButton.enabled = YES;
        
        self.cancelButton.enabled = YES;

    } else if ([self.status isEqualToString:@"11"]) {
        
        [self.conformButton setTitle:@"已取消" forState:UIControlStateNormal];
        
        self.conformButton.enabled = NO;
        
        self.cancelButton.enabled = NO;
        
    } else if ([self.status isEqualToString:@"12"]) {
        
        [self.conformButton setTitle:@"已超时" forState:UIControlStateNormal];
        
        self.conformButton.enabled = NO;
        
        self.cancelButton.enabled = NO;
        
    } else if ([self.status isEqualToString:@"2"]) {
        
        [self.conformButton setTitle:@"支付成功" forState:UIControlStateNormal];
        
        self.conformButton.enabled = NO;
        
        self.cancelButton.enabled = NO;
    }
}

#pragma ----
#pragma mark ---- UITableViewDataSource/UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
        
    } else if (section == 1) {
        
        return 1;
        
    } else if (section == 2) {
        
        return 2 + self.detailModel.orderCourtList.count;
        
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 ) {
        
        return 134;
        
    } else if (indexPath.section == 1) {
        
        return 140;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     OrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailTableViewCell"];
    
    if (indexPath.section == 0) {
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderDetailTableViewCell" owner:nil options:nil] firstObject];
        }
        
        [cell configContactPersonInformation:self.detailModel];
        
        return cell;
        
    } else if ( indexPath.section == 1 ) {
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderDetailTableViewCell" owner:nil options:nil] lastObject];
        }
        
        [cell configProductInformation:self.detailModel];
        
        return cell;
        
    } else if (indexPath.section == 2) {
        
         PersonInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInformationTableViewCell"];
        
        if (indexPath.row == 0) {
            
            if (cell == nil) {
                
                cell = [[NSBundle mainBundle] loadNibNamed:@"PersonInformationTableViewCell" owner:nil options:nil][2];
            }
            cell.firstTitleLabel.text = @"日期";
            
            cell.firstTitleLabel.hidden = NO;
            
            cell.contentLabel.text = [[Common dateFormatterWithFormatterString:@"yyyy-MM-dd"] stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self.detailModel.orderDate doubleValue]/1000.0000000]];
            
        } else if (indexPath.row == 1) {
            
            if (cell == nil) {
                
                cell = [[NSBundle mainBundle] loadNibNamed:@"PersonInformationTableViewCell" owner:nil options:nil][2];
            }
            
            AppointmentTimeModel *timeModel = self.detailModel.orderCourtList[0];
            
            cell.firstTitleLabel.text = @"场次";
            
            cell.firstTitleLabel.hidden = NO;
            
            [cell configOrderWithAppointmentTimeModel:timeModel];
            
        } else if  (indexPath.row == 1 + self.detailModel.orderCourtList.count) {//总计
            
            if (cell == nil) {
                
                cell = [[NSBundle mainBundle] loadNibNamed:@"PersonInformationTableViewCell" owner:nil options:nil][3];
            }
            
            cell.titleLabel.text = @"支付总额";
            
            //配置总价格
            [cell configTotalPriceWith:self.detailModel.orderCourtList];
            
            return cell;
            
        } else {
            
            if (cell == nil) {
                
                cell = [[NSBundle mainBundle] loadNibNamed:@"PersonInformationTableViewCell" owner:nil options:nil][2];
            }
            
            AppointmentTimeModel *timeModel = self.detailModel.orderCourtList[indexPath.row - 1];
            
            cell.firstTitleLabel.hidden = YES;
            
            [cell configOrderWithAppointmentTimeModel:timeModel];
        }
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10.0f;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.5f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        
        ShopDetailViewController *controller = [[ShopDetailViewController alloc] init];
        
        controller.productId = [NSString stringWithFormat:@"%@",self.detailModel.productId];
        
        [self.navigationController pushViewController:controller animated:YES];
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
