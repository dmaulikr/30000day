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
#import "CommodityCommentViewController.h"
#import "MyOrderViewController.h"
#import "STTabBarViewController.h"
#import "AppointmentViewController.h"
#import "DuplicationTableViewCell.h"

@interface OrderDetailViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) MyOrderDetailModel *detailModel;

@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;

@property (weak, nonatomic) IBOutlet UIView *backgoudView;

@property (nonatomic,strong) UILabel *rightLabel;

@property (nonatomic,assign) OrderStatus type;//订单类型

@end

@implementation OrderDetailViewController {
    
    NSTimer *_timer;
    long _count;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    
    self.type = OrderStatusWillPay;//初始化等待付款状态

    //配置UI界面
    [self configUI];

    [self loadDataFromServer];
}

//配置UI界面
- (void)configUI {
    
    self.isShowBackItem = YES;
    
    self.tableViewStyle = STRefreshTableViewGroup;
    
    [self showHeadRefresh:YES showFooterRefresh:NO];
    
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50);
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.backgoudView.layer.borderColor = RGBACOLOR(200, 200, 200, 1).CGColor;
    self.backgoudView.layer.borderWidth = 0.5f;
    
    self.leftButton.layer.cornerRadius = 5;
    self.leftButton.layer.masksToBounds = YES;
    
    self.leftButton.layer.borderWidth = 0.5f;
    self.leftButton.layer.borderColor = RGBACOLOR(200, 200, 200, 1).CGColor;
    
    self.rightButton.layer.cornerRadius = 5;
    self.rightButton.layer.masksToBounds = YES;
    
    [self.rightButton setBackgroundImage:[Common imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    [self.leftButton setBackgroundImage:[Common imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    
    self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    
    self.rightLabel.textColor = [UIColor redColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightLabel];
}

- (void)headerRefreshing {
    
    [self loadDataFromServer];
}

//从服务器下载数据
- (void)loadDataFromServer {

    //下载数据
    [STDataHandler sendFindOrderDetailOrderNumber:self.orderNumber success:^(MyOrderDetailModel *detailModel) {
        
        self.detailModel = detailModel;
        //判断按钮是否可用
        [self judgeConformButtonCanUse:self.detailModel.status];
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self.tableView reloadData];
            
            [self.tableView.mj_header endRefreshing];
            
        });
        
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self.tableView.mj_header endRefreshing];
            
        });
        
    }];
}

//取消预约
- (IBAction)leftButtonAction:(id)sender {
    
    if (self.type == OrderStatusPay) {//表示支付完成，去查看订单

        BOOL isExist = NO;
        
        for (UIViewController *controller in self.navigationController.childViewControllers) {
            
            if ([controller isKindOfClass:[MyOrderViewController class]]) {
                
                isExist = YES;
                
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
        
        if (!isExist) {
            
            MyOrderViewController *controller = [[MyOrderViewController alloc] init];
            
            controller.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:controller animated:YES];
        }
    } else {//取消订单
        
        [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
        
        [STDataHandler sendCancelOrderWithOrderNumber:self.detailModel.orderNo
                                                 success:^(BOOL success) {
                                                     
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         
                                                         [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                                                         
                                                         [self canceledOrderSetting];
                                                         
                                                     });

                                                 } failure:^(NSError *error) {
                                                     
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                        
                                                         [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                                                         
                                                         [self showToast:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
                                                         
                                                     });
                                                    
                                                     
                                                 }];
        
    }
}

//底部右边按钮点击事件
- (IBAction)rightButtonAction:(id)sender {
    
    if (self.type == OrderStatusPay) {//表示支付完成
        
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
        STTabBarViewController *controller = [board instantiateInitialViewController];
        
        [controller setSelectedIndex:2];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        window.rootViewController = controller;

    } else {
        
        PaymentViewController *controller = [[PaymentViewController alloc] init];
        
//        controller.selectorDate = [NSDate dateWithTimeIntervalSince1970:[self.detailModel.orderDate doubleValue]/1000.0000000];
//        
//        controller.timeModelArray = self.detailModel.orderCourtList;
//        
//        controller.productId = self.detailModel.productId;
//        
//        controller.productName = self.detailModel.productName;
        
        controller.orderNumber = self.detailModel.orderNo;
        
        [self.navigationController pushViewController:controller animated:YES];
    }
}

//取消订单，修改按钮并发出通知
- (void)canceledOrderSetting {
    
    [self showToast:@"订单取消成功"];
    
    self.rightButton.enabled = NO;
    
    self.leftButton.enabled = NO;
    
    self.rightLabel.text = @"";
    
    [_timer invalidate];
    
    [self.rightButton setTitle:@"已取消" forState:UIControlStateNormal];
    
    //发出更新通知
    [STNotificationCenter postNotificationName:STDidSuccessCancelOrderSendNotification object:nil];
    
    [self loadDataFromServer];//重新从服务器下载数据
}

//判断确认订单是否可用
- (void)judgeConformButtonCanUse:(NSString *)status {
    
    if ([status isEqualToString:@"10"]) {
        
        [self.rightButton setTitle:@"前往付款" forState:UIControlStateNormal];
        
        self.rightButton.enabled = YES;
        
        self.leftButton.enabled = YES;
        
        self.type = OrderStatusWillPay;
        
        [self configOrderLimitTime:self.detailModel.orderDate];

    } else if ([status isEqualToString:@"11"]) {
        
        [self.rightButton setTitle:@"已取消" forState:UIControlStateNormal];
        
        self.rightButton.enabled = NO;
        
        self.leftButton.enabled = NO;
        
        self.type = OrderStatusCancel;
        
    } else if ([status isEqualToString:@"12"]) {
        
        [self.rightButton setTitle:@"已超时" forState:UIControlStateNormal];
        
        self.rightButton.enabled = NO;
        
        self.leftButton.enabled = NO;
        
        self.type = OrderStatusOvertime;
        
    } else if ([status isEqualToString:@"2"]) {
        
        [self.rightButton setTitle:@"返回首页" forState:UIControlStateNormal];
        
        [self.leftButton setTitle:@"查看订单" forState:UIControlStateNormal];
        
        self.rightButton.enabled = YES;
        
        self.leftButton.enabled = YES;
        
        self.type = OrderStatusPay;
    }
}

//配置限时时间
- (void)configOrderLimitTime:(NSNumber *)orderTime {
    
    NSDate *date = [NSDate date];
    
    NSTimeInterval currentTimeInterval = [date timeIntervalSince1970];
    
    NSTimeInterval a = [orderTime doubleValue]/1000;
    
    if ((currentTimeInterval - a ) > 300 ) {//超过5分钟了
        
    } else if ((currentTimeInterval - a ) < 300 ) {//在5分钟之内
        
        NSTimeInterval b = 300 + a - currentTimeInterval;//剩余的时间
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countNumberOfData) userInfo:nil repeats:YES];
        
        _count = (long)b;
        
        [_timer fire];
    }
}

- (void)countNumberOfData {
    
    _count--;
    
    self.rightLabel.text = [NSString stringWithFormat:@"%02li:%02li",_count/60,_count%60];
    
    if (_count == 0) {
        
        [_timer invalidate];
        
        //发出更新通知
        [STNotificationCenter postNotificationName:STDidSuccessCancelOrderSendNotification object:nil];
        
        //修改时间显示
        self.rightLabel.text = @"";
        
        self.rightButton.enabled = NO;
        
        self.leftButton.enabled = NO;
        
        [self.rightButton setTitle:@"已超时" forState:UIControlStateNormal];
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
        
        return 1 + self.detailModel.orderCourtList.count;
        
    } else if (section == 3) {
        
        return self.detailModel.prodActivity.activityList.count + 2;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.type == OrderStatusPay && section == 0) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        
        view.backgroundColor = RGBACOLOR(74, 124, 200, 1);
    
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH, 80)];
        
        [view addSubview:label];
        
        label.backgroundColor = RGBACOLOR(74, 124, 200, 1);
        
        label.text = @"付款成功";
        
        label.font = [UIFont systemFontOfSize:15.0f];
        
        label.textColor = [UIColor whiteColor];
    
        return view;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 ) {
        
        return 134;
        
    } else if (indexPath.section == 1) {
        
        if (self.type == OrderStatusPay) {
            
            return 222;
            
        } else {
            
           return 169;
        }
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
        
        if (self.type == OrderStatusPay) {//支付成功
            
            cell.firstButton.hidden = NO;
            
            cell.secondButton.hidden = NO;
            
            cell.thirdButton.hidden = NO;
            
            [cell setButtonClick:^(NSInteger index) {
                
                if (index == 1) {//第一个按钮
                    
                    CommodityCommentViewController *controller = [[CommodityCommentViewController alloc] init];
                    
                    controller.orderNumber = self.orderNumber;
                    
                    controller.productName = self.detailModel.productName;
                    
                    controller.hidesBottomBarWhenPushed = YES;
                    
                    [self.navigationController pushViewController:controller animated:YES];
                    
                } else if (index == 2) {//第二个按钮
                    
                    BOOL isExist = NO;
                    
                    for (UIViewController *controller in self.navigationController.childViewControllers) {
                        
                        if ([controller isKindOfClass:[AppointmentViewController class]]) {
                            
                            isExist = YES;
                            
                            [self.navigationController popToViewController:controller animated:YES];
                        }
                    }
                    
                    if (!isExist) {
                        
                        AppointmentViewController *controller = [[AppointmentViewController alloc] init];
                        
                        controller.hidesBottomBarWhenPushed = YES;
                        
                        controller.productName = self.detailModel.productName;
                        
                        controller.productId = self.detailModel.productId;
                        
                        [self.navigationController pushViewController:controller animated:YES];
                    }
                    
                } else if (index == 3) {//第三个按钮
                    
                    [self showToast:@"正在开发"];
                }
                
            }];
            
        } else {
            
            cell.firstButton.hidden = YES;
            
            cell.secondButton.hidden = YES;
            
            cell.thirdButton.hidden = YES;
        }
        
        return cell;
        
    } else if (indexPath.section == 2) {
        
        DuplicationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DuplicationTableViewCell"];
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DuplicationTableViewCell" owner:nil options:nil] firstObject];
        }
        
        if (indexPath.row == 0) {
            
            cell.titleLabel_first.text = @"预约日期";
            
            cell.titleLabel_first.hidden = NO;
            
            cell.contentLabel_first.text = [[Common dateFormatterWithFormatterString:@"yyyy-MM-dd"] stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self.detailModel.orderDate doubleValue]/1000]];
            
        } else if (indexPath.row == 1) {
            
            AppointmentTimeModel *timeModel = self.detailModel.orderCourtList[0];
            
            cell.titleLabel_first.text = @"场次";
            
            cell.titleLabel_first.hidden = NO;
            
            [cell configCellWithAppointmentTimeModel:timeModel];
            
        } else {
            
            AppointmentTimeModel *timeModel = self.detailModel.orderCourtList[indexPath.row - 1];
            
            cell.titleLabel_first.hidden = YES;
            
            [cell configCellWithAppointmentTimeModel:timeModel];
        }
        
        return cell;
    } else if (indexPath.section == 3) {
        
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
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (self.type == OrderStatusPay && section == 0) {
        
        return 80.0f;
        
    }
    
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.5f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 1) {
        
        ShopDetailViewController *controller = [[ShopDetailViewController alloc] init];
        
        controller.productId = [NSString stringWithFormat:@"%@",self.detailModel.productId];
        
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
