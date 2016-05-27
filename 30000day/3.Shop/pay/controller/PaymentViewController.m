//
//  PaymentViewController.m
//  30000day
//
//  Created by wei on 16/3/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "PaymentViewController.h"
#import "PayTableViewCell.h"
#import "PersonInformationTableViewCell.h"
#import "AppointmentViewController.h"
#import "pay.h"
#import "OrderDetailViewController.h"
#import "DuplicationTableViewCell.h"
#import "MyOrderDetailModel.h"
#import "MTProgressHUD.h"

@interface PaymentViewController () <UITableViewDataSource,UITableViewDelegate,payResultStatusDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) MyOrderDetailModel *detailModel;

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单支付";
    [STNotificationCenter addObserver:self selector:@selector(alipaySuccessAction) name:STDidSuccessPaySendNotification object:nil];
    
    //从服务器下载数据
    [self loadDataFromServer];
}

//从服务器下载订单的所有的数据
- (void)loadDataFromServer {
    
    //下载数据
    [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
    
    [STDataHandler sendFindOrderDetailOrderNumber:self.orderNumber success:^(MyOrderDetailModel *detailModel) {
        
        self.detailModel = detailModel;
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self.tableView reloadData];
            
            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
            
        });
        
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
             [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
            
        });
        
    }];
}

//支付宝支付成功的回调
- (void)alipaySuccessAction {
    
    OrderDetailViewController *controller = [[OrderDetailViewController alloc] init];
    
    controller.orderNumber = self.orderNumber;//订单编号
    
    [self.navigationController pushViewController:controller animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 2 + self.detailModel.orderCourtList.count;
        
    } else if (section == 1) {
        
        return 2 + self.detailModel.prodActivity.activityList.count;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44.0f;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10.0f;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.5f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            PayTableViewCell *cell_first = [tableView dequeueReusableCellWithIdentifier:@"PayTableViewCell"];
            
            if (cell_first == nil) {
                
                cell_first = [[[NSBundle mainBundle] loadNibNamed:@"PayTableViewCell" owner:nil options:nil] firstObject];
            }
            
            cell_first.titleLabel_first.text = self.detailModel.productName;
            
            return cell_first;
            
        } else {
            
            DuplicationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DuplicationTableViewCell"];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"DuplicationTableViewCell" owner:nil options:nil] firstObject];
            }
            
            if (indexPath.row == 1) {
                
                cell.titleLabel_first.text = @"日期";
                
                cell.titleLabel_first.hidden = NO;
                
                cell.contentLabel_first.text = [[Common dateFormatterWithFormatterString:@"yyyy-MM-dd"] stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self.detailModel.orderDate doubleValue]/1000.000000]];
                
            } else if (indexPath.row == 2) {
                
                cell.titleLabel_first.text = @"场次";
                
                cell.titleLabel_first.hidden = NO;
                
                [cell configCellWithAppointmentTimeModel:self.detailModel.orderCourtList[0]];
                
            } else {
 
                cell.titleLabel_first.hidden = YES;
                
                [cell configCellWithAppointmentTimeModel:self.detailModel.orderCourtList[indexPath.row - 2]];
                
            }
            return cell;
        }
        
    } else if (indexPath.section == 1 ) {
    
        DuplicationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DuplicationTableViewCell"];
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DuplicationTableViewCell" owner:nil options:nil] firstObject];
        }
        
        if (indexPath.row == 0) {
            
            cell.titleLabel_first.text = @"原价";
            
            cell.contentLabel_first.textColor = [UIColor redColor];
            
            cell.contentLabel_first.text =[NSString stringWithFormat:@"￥: %.2f",[self.detailModel.prodActivity.originalPrice floatValue]];//原价
            
        } else if (indexPath.row == self.detailModel.prodActivity.activityList.count + 1) {
            
            cell.titleLabel_first.text = @"应付金额";
            
            cell.contentLabel_first.textColor = [UIColor redColor];
            
            cell.contentLabel_first.text = [NSString stringWithFormat:@"￥: %.2f",[self.detailModel.prodActivity.currentPrice floatValue]];//现价
            
        } else {
            
            [cell configCellWithActivityModel:self.detailModel.prodActivity.activityList[indexPath.row - 1]];
        }
        
        return cell;
        
    } else if (indexPath.section == 2 ) {
        
        PayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayTableViewCell"];
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PayTableViewCell" owner:nil options:nil] lastObject];
            
        }
        
        cell.titleLabel_second.text = @"微信支付";
        
        cell.backgroundColor = RGBACOLOR(71, 182, 0, 1);
        
        return cell;
        
    } else if (indexPath.section == 3) {
        
        PayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayTableViewCell"];
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PayTableViewCell" owner:nil options:nil] lastObject];
            
        }
        cell.titleLabel_second.text = @"支付宝支付";
        
        cell.backgroundColor = RGBACOLOR(0, 169, 244, 1);
            
        return cell;
    }
    return nil;
}

#pragma mark - Table view data delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 3 ) {
        
        pay *p = [[pay alloc] init];
        
        p.delegate = self;
        
        [p payWithOrderID:self.orderNumber goodTtitle:self.detailModel.productName goodPrice:@"0.01"];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma ----
#pragma mark --  payResultStatusDelegate

- (void)resultStatus:(NSString *)status {//这个代理是HTML5网页支付时候调用的
    
    if ([status isEqualToString:@"9000"]) {
        
        [STNotificationCenter postNotificationName:STDidSuccessPaySendNotification object:nil];
    }
}

- (void)confirmButtonClick {

    NSLog(@"1");
}

- (void)dealloc {
    
    [STNotificationCenter removeObserver:self];
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
