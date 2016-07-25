//
//  SportsFunctionViewController.m
//  30000day
//
//  Created by WeiGe on 16/7/21.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SportsFunctionViewController.h"
#import "SportsFunctionManager.h"

@interface SportsFunctionViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) SportsFunctionManager *sportsFunctionManager;

@end

@implementation SportsFunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SportsFunctionManager *sportsFunctionManager = [[SportsFunctionManager alloc] init];
    
    self.sportsFunctionManager = sportsFunctionManager;
    
    
    [self.view setBackgroundColor:VIEWBORDERLINECOLOR];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    
    [view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:view];
    
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 80) / 2, 34, 80, 20)];
    
    [lable setTextAlignment:NSTextAlignmentCenter];
    
    if (self.type) [lable setText:@"地图设置"];else [lable setText:@"播报距离"];
    
    [view addSubview:lable];

    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64.5, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    [tableView setDataSource:self];
    
    [tableView setDelegate:self];
    
    tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    if (indexPath.row == self.selectIndex) {
        
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        
    }
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    if (self.type) {

        //修改数据
        [self.sportsFunctionManager updateSportsFunction:STUserAccountHandler.userProfile.userId mapType:[NSString stringWithFormat:@"%ld",indexPath.row]];
        
        [self dismissViewControllerAnimated:YES completion:^{
            
            [STNotificationCenter postNotificationName:STSelectSportsFunctionMapSendNotification object:@(indexPath.row)];
            
        }];
        
    } else {
    
        [self.sportsFunctionManager updateSportsFunction:STUserAccountHandler.userProfile.userId speechDistance:[NSString stringWithFormat:@"%ld",indexPath.row]];
        
        [self dismissViewControllerAnimated:YES completion:^{
            
            [STNotificationCenter postNotificationName:STSelectSportsFunctionSpeechDistanceSendNotification object:@(indexPath.row)];
            
        }];
    
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
