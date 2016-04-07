//
//  OrderDetailViewController.m
//  30000day
//
//  Created by GuoJia on 16/4/6.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "MyOrderDetailModel.h"

@interface OrderDetailViewController ()

@property (nonatomic,strong) MyOrderDetailModel *detailModel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    
    //下载数据
    [self.dataHandler sendFindOrderDetailOrderNumber:self.orderNumber success:^(MyOrderDetailModel *detailModel) {
       
        self.detailModel = detailModel;
        
    } failure:^(NSError *error) {

        
    }];
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
