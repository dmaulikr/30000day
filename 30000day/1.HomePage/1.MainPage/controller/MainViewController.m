//
//  MainViewController.m
//  30000day
//
//  Created by GuoJia on 16/2/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "MainViewController.h"
#import "WeatherTableViewCell.h"
#import "ActivityIndicatorTableViewCell.h"
#import "ChartTableViewCell.h"
#import "WeatherInformationModel.h"
#import "jk.h"
#import "UserLifeModel.h"

@interface MainViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) WeatherInformationModel *informationModel;

@property (nonatomic,assign) float totalLifeDayNumber;

@property (nonatomic,strong) NSMutableArray *allDayArray;

@property (nonatomic,strong) NSMutableArray *dayNumberArray;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    
    //1.开始定位
    [self.dataHandler startFindLocationSucess:^(NSString *cityName) {
       
        //获取天气情况
        [self.dataHandler getWeatherInformation:cityName sucess:^(WeatherInformationModel *informationModel) {
            
            self.informationModel = informationModel;
            
            [self calculateMoreAge:informationModel.pm25Quality];
            
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            
        } failure:^(NSError *error) {
            
            [self showToast:@"获取天气失败"];
            
        }];
        
    } failure:^(NSError *error) {
        
        [self showToast:@"定位失败"];
        
    }];
    
    //刷新页面信息
    [self reloadData];
    
    //监听个人信息管理模型发出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:UserAccountHandlerUseProfileDidChangeNotification object:nil];
}

//将pm2.5数据计算加至天龄
- (void)calculateMoreAge:(NSString *)pm25 {
    
    NSString *sumDay = @"0";//总加减天数
    
    if ([pm25 isEqualToString:@"优"]) {
        
        sumDay = @"+0.05";
        
    } else if ([pm25 isEqualToString:@"良"]) {
        
        sumDay = @"+0.03";
        
    } else if ([pm25 isEqualToString:@"轻度污染"]) {
        
        sumDay = @"+0.00";
        
    } else if ([pm25 isEqualToString:@"中度污染"]) {
        
        sumDay=@"-0.02";
        
    } else if ([pm25 isEqualToString:@"重度污染"]) {
        
        sumDay = @"-0.05";
        
    } else if ([pm25 isEqualToString:@"严重污染"]) {
        
        sumDay = @"-0.10";
        
    }
    
    jk *j = [[jk alloc] init];
    
    j.sumDay = sumDay;
    
}

- (void)reloadData {
    
    //2.获取用户的天龄

    [self.dataHandler sendUserLifeListWithCurrentUserId:[Common readAppDataForKey:KEY_SIGNIN_USER_UID] endDay:[Common getDateStringWithDate:[NSDate date]] dayNumber:@"8" success:^(NSMutableArray *dataArray) {
        
        UserLifeModel *lastModel = [dataArray lastObject];
        
        self.totalLifeDayNumber = [lastModel.curLife floatValue];
        
        //算出数组
        self.allDayArray = [NSMutableArray array];
        
        self.dayNumberArray = [NSMutableArray array];

        
    [self.dataHandler sendUserLifeListWithCurrentUserId:[Common readAppDataForKey:KEY_SIGNIN_USER_UID] endDay:[Common getDateStringWithDate:[NSDate date]] dayNumber:@"8" success:^(NSMutableArray *dataArray) {
        
        UserLifeModel *lastModel = [dataArray lastObject];
        
        self.totalLifeDayNumber = [lastModel.curLife floatValue];
        
        //算出数组
        self.allDayArray = [NSMutableArray array];
        
        self.dayNumberArray = [NSMutableArray array];
        
//        for (int  i = 0; i < dataArray.count ; i++ ) {
//            
//            UserLifeModel *model = dataArray[i];
//            
//            [self.allDayArray addObject:model.curLife];
//            
//            NSArray *array = [model.createTime componentsSeparatedByString:@"-"];
//            
//            NSString *string = array[2];
//            
//            NSString *newString = [[string componentsSeparatedByString:@" "] firstObject];
//            
//            [self.dayNumberArray addObject:newString];
//            
//        }
        
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0],[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        
    } failure:^(LONetError *error) {
        
    }];

        
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0],[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        
    } failure:^(LONetError *error) {
        
    }];

}

#pragma ---
#pragma mark --- UITableViewDataSource / UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
   }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        static NSString *weatherCellIndentifier = @"WeatherTableViewCell";
        
        WeatherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:weatherCellIndentifier];
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:weatherCellIndentifier owner:nil options:nil] lastObject];
        }
        
        cell.informationModel = self.informationModel;
        
        //下载头像
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:STUserAccountHandler.userProfile.headImg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        return cell;
        
    } else if (indexPath.row == 1) {
        
        static NSString *activityIndicatorCellIndentifier = @"ActivityIndicatorTableViewCell";
        
        ActivityIndicatorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:activityIndicatorCellIndentifier];
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:activityIndicatorCellIndentifier owner:nil options:nil] lastObject];
        }
        
        //刷新数据
        [cell reloadData:self.totalLifeDayNumber];
        
        return cell;
        
    } else if (indexPath.row == 2) {
        
        static NSString *chartCellIndentifier = @"ChartTableViewCell";
        
        ChartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chartCellIndentifier];
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:chartCellIndentifier owner:nil options:nil] lastObject];
        }
        
        cell.allDayArray = self.allDayArray;
        
        cell.dayNumberArray = self.dayNumberArray;
        
        if (self.allDayArray && self.dayNumberArray) {
            
             [cell reloadData];
        }
       
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return 80;
        
    } else if ( indexPath.row == 1) {
        
        return (SCREEN_HEIGHT - 188)/2.0f;
        
    } else if (indexPath.row == 2) {
        
        return (SCREEN_HEIGHT - 188)/2.0f;
    }
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
