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
#import "UserLifeModel.h"
#import "MotionData.h"

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
    
    [self uploadMotionData];
    
    //1.开始定位
    [self.dataHandler startFindLocationSucess:^(NSString *cityName) {
       
        //获取天气情况
        [self.dataHandler getWeatherInformation:cityName sucess:^(WeatherInformationModel *informationModel) {
            
            self.informationModel = informationModel;
            
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

- (void)reloadData {
    
    //2.获取用户的天龄

    [self.dataHandler sendUserLifeListWithCurrentUserId:[Common readAppDataForKey:KEY_SIGNIN_USER_UID] endDay:[Common getDateStringWithDate:[NSDate date]] dayNumber:@"7" success:^(NSMutableArray *dataArray) {
        
        UserLifeModel *lastModel = [dataArray lastObject];
        
        self.totalLifeDayNumber = [lastModel.curLife floatValue];
        
        //算出数组
        NSMutableArray *allDayArray = [NSMutableArray array];
        
        NSMutableArray *dayNumberArray = [NSMutableArray array];

        for (int  i = 0; i < dataArray.count ; i++ ) {
            
            UserLifeModel *model = dataArray[i];
            
            [allDayArray addObject:model.curLife];
            
            NSArray *array = [model.createTime componentsSeparatedByString:@"-"];
            
            NSString *string = array[2];
            
            NSString *newString = [[string componentsSeparatedByString:@" "] firstObject];
            
            [dayNumberArray addObject:newString];
            
        }
        self.allDayArray = [NSMutableArray arrayWithArray:[[allDayArray reverseObjectEnumerator] allObjects]];
        self.dayNumberArray = [NSMutableArray arrayWithArray:[[dayNumberArray reverseObjectEnumerator] allObjects]];
        
        [self.tableView reloadData];
        
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
        [cell reloadData:self.totalLifeDayNumber birthDayString:STUserAccountHandler.userProfile.birthday];
        
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

- (void)uploadMotionData{

    MotionData *mdata=[[MotionData alloc]init];
    
    //获取步数
    [mdata getHealthUserDateOfBirthCount:^(NSString *birthString) {
        
        if (birthString != nil) {
            NSLog(@"获取步数  %@",birthString);
            //获取爬楼数
            [mdata getClimbStairsCount:^(NSString *climbStairsString) {
                
                if (climbStairsString != nil) {
                    NSLog(@"获取爬楼数  %@",climbStairsString);
                    //获取运动距离
                    [mdata getMovingDistanceCount:^(NSString *movingDistanceString) {
                        
                        if (movingDistanceString != nil) {
                            NSLog(@"获取运动距离  %@",movingDistanceString);
                            
                            NSMutableDictionary *dataDictionary=[NSMutableDictionary dictionary];
                            [dataDictionary setObject:birthString forKey:@"stepNum"];
                            [dataDictionary setObject:climbStairsString forKey:@"stairs"];
                            [dataDictionary setObject:movingDistanceString forKey:@"distance"];
                            
                            NSString *dataString=[self DataTOjsonString:dataDictionary];
                            
                            [self.dataHandler sendStatUserLifeWithUserId:[Common readAppDataForKey:KEY_SIGNIN_USER_UID] dataString:dataString success:^(BOOL success) {
                                
                                if (success) {
                                    NSLog(@"运动信息上传成功");
                                }
                                
                            } failure:^(NSError *error) {
                                
                                NSLog(@"运动信息上传失败");
                                
                            }];
                        }
                        
                    } failure:^(NSError *error) {
                        NSLog(@"获取运动距离失败");
                    }];
                }
                
            } failure:^(NSError *error) {
                NSLog(@"获取爬楼数失败");
            }];
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"获取步数失败");
    }];
    
}


- (NSString*)DataTOjsonString:(id)object{
    
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
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
