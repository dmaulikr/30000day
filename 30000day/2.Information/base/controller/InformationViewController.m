//
//  InformationViewController.m
//  30000day
//
//  Created by GuoJia on 16/3/14.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "InformationViewController.h"
#import "DOPDropDownMenu.h"
#import "InformationListTableViewCell.h"
#import "SubscribeViewController.h"
#import "InformationDetailViewController.h"
#import "MTProgressHUD.h"

@interface InformationViewController () < UITableViewDataSource,UITableViewDelegate,DOPDropDownMenuDataSource,DOPDropDownMenuDelegate >

@property (nonatomic,strong) NSArray *titleArray;

@property (nonatomic,strong) NSMutableArray *informationModelArray;

@end

@implementation InformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"资讯";
    
    self.titleArray = [NSArray arrayWithObjects:@"全部分类",@"饮食",@"运动",@"作息",@"备孕",@"孕期",@"育儿",@"治未病",@"体检",@"就医", nil];
    //1.设置tableView
    self.tableViewStyle = STRefreshTableViewGroup;
    
    self.tableView.frame = CGRectMake(0, 44 + 54, SCREEN_WIDTH, SCREEN_HEIGHT - 54-44-44);
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    [self loadDataWithCode:@""];
    
    //2.设置mune
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:44];
    
    menu.delegate = self;
    
    menu.dataSource = self;
    
    [self.view addSubview:menu];
}

- (void)headerRefreshing {
    
    [self.tableView.mj_header endRefreshing];
    
}

- (void)footerRereshing {
    
    [self.tableView.mj_footer endRefreshing];
}


//跳转到订阅中心
- (IBAction)swithToSubscribe:(id)sender {
    
    SubscribeViewController *controller = [[SubscribeViewController alloc] init];
    
    controller.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma ----
#pragma mark --- UITableViewDataSource/UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.informationModelArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InformationListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InformationListTableViewCell"];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"InformationListTableViewCell" owner:nil options:nil] lastObject];
    }
    
    InformationModel *informationModel = self.informationModelArray[indexPath.row];
    
    cell.informationModel = informationModel;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    return 100;
}


#pragma ----
#pragma mark --- DOPDropDownMenuDataSource/DOPDropDownMenuDelegate

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    
    return self.titleArray.count;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {

    return self.titleArray[indexPath.row];
}

- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
    
    return 1;
    
}

-(void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {
    
    NSLog(@"%ld",indexPath.row);
    
    NSString *code;
    if (indexPath.row == 0) {
        
        code = @"";
        
    } else {
    
        code = [NSString stringWithFormat:@"%ld",indexPath.row + 9];
    }
    
    [self loadDataWithCode:code];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10.0f;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.5f;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    InformationDetailViewController *controller = [[InformationDetailViewController alloc] init];
    
    controller.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadDataWithCode:(NSString *)code {
    
    [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
    [self.dataHandler sendsearchInfomationsWithWriterId:@"" infoTypeCode:code success:^(NSMutableArray *success) {
        
        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        
        NSLog(@"%@",success);
        
        self.informationModelArray = [NSMutableArray arrayWithArray:success];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
    
    }];

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
