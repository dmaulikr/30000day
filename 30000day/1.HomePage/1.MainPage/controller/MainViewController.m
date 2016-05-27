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
#import "JinSuoDetailsViewController.h"
#import "UIImageView+WebCache.h"
#import "SignInViewController.h"
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "QGPickerView.h"
#import "HealthySetUpViewController.h"
#import "SettingBirthdayView.h"
#import "DaysOfAgeOption.h"
#import "PromoteAgeViewController.h"
#import "FactorVerificationView.h"


@interface MainViewController () <UITableViewDataSource,UITableViewDelegate,QGPickerViewDelegate>

@property (nonatomic,strong) WeatherInformationModel *informationModel;

@property (nonatomic,assign) float totalLifeDayNumber;

@property (nonatomic,strong) NSMutableArray *allDayArray;

@property (nonatomic,strong) NSMutableArray *dayNumberArray;

@property (nonatomic,strong) ActivityIndicatorTableViewCell *indicatorCell;

@property (nonatomic,strong) UIView *indicationView;//指示view

@property (nonatomic,strong) SettingBirthdayView *birthdayView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableViewStyle = STRefreshTableViewPlain;
    
    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;

    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44);
    
    [self showHeadRefresh:YES showFooterRefresh:NO];
    
    //定位并获取天气
    [self startFindLocationSucess];

    //监听个人信息管理模型发出的通知
    [STNotificationCenter addObserver:self selector:@selector(reloadData) name:STUserAccountHandlerUseProfileDidChangeNotification object:nil];
}

- (ActivityIndicatorTableViewCell *)indicatorCell {
    
    if (!_indicatorCell) {
        
        _indicatorCell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityIndicatorTableViewCell" owner:self options:nil] lastObject];
    }
    
    return _indicatorCell;
}

- (void)headerRefreshing {
    
    //1.获取个人信息
    [self getUserInformation];
    
    //2.获取天气
    [self startFindLocationSucess];
}

//跳到登录控制器
- (void)jumpToSignInViewController {
    
    SignInViewController *logview = [[SignInViewController alloc] init];
    
    STNavigationController *navigationController = [[STNavigationController alloc] initWithRootViewController:logview];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)reloadData {
    
    //获取用户的天龄
    [self getUserLifeList];
    
    //更新个人运动信息
    [self uploadMotionData];
    
    //获取用户击败的用户
    [self getDefeatDataWithUserId:STUserAccountHandler.userProfile.userId];
    
    //显示设置生日的视图
    [self showSettingBirthdayView];
}

//登录获取个人信息
- (void)getUserInformation {
    
    [self.dataHandler postSignInWithPassword:[Common readAppDataForKey:KEY_SIGNIN_USER_PASSWORD]
                                   loginName:[Common readAppDataForKey:KEY_SIGNIN_USER_NAME]
                          isPostNotification:NO
                            isFromThirdParty:[Common readAppIntegerDataForKey:@"isFromThirdParty"]
                                        type:[Common readAppDataForKey:@"type"]
                                     success:^(BOOL success) {
                                         
                                         //获取用户的天龄
                                         [self getUserLifeList];
                                         
                                         [self.tableView.mj_header endRefreshing];
                                     }
                                     failure:^(NSError *error) {
                                         
                                         NSString *errorString = [error userInfo][NSLocalizedDescriptionKey];
                                         
                                         if ([errorString isEqualToString:@"账户无效，请重新登录"]) {
                                             
                                             [self showToast:@"账户无效"];
                                             
                                             [self jumpToSignInViewController];
                                             
                                         } else  {
                                             
                                             [self showToast:@"网络繁忙，请再次刷新"];
                                         }
                                         
                                         [self.tableView.mj_header endRefreshing];
                                     }];
    
}

//获取用户的天龄
- (void)getUserLifeList {
    
    if (![Common isObjectNull:STUserAccountHandler.userProfile.userId]) {//表示如果账户的userId为空的话，那么就不获取用户的天龄
        
        [Common dayNumberWithinNumber:7 inputDate:[[Common dateFormatterWithFormatterString:@"yyyy-MM-dd"] dateFromString:STUserAccountHandler.userProfile.birthday] completion:^(NSInteger day) {
           
            [STDataHandler sendUserLifeListWithCurrentUserId:STUserAccountHandler.userProfile.userId endDay:[Common getDateStringWithDate:[NSDate date]] dayNumber:[NSString stringWithFormat:@"%d",(int)day] success:^(NSMutableArray *dataArray) {
                
                UserLifeModel *lastModel = [dataArray firstObject];
                
                self.totalLifeDayNumber = [lastModel.curLife floatValue];
                
                //算出数组
                NSMutableArray *allDayArray = [NSMutableArray array];
                
                NSMutableArray *dayNumberArray = [NSMutableArray array];
                
                if (dataArray.count > 1 ) {
                    
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
                    
                } else {
                    
                    UserLifeModel *model = [dataArray firstObject];
                    
                    if (model) {
                        
                        [allDayArray addObject:model.curLife];
                        
                        [allDayArray addObject:model.curLife];
                        
                        NSArray *array = [model.createTime componentsSeparatedByString:@"-"];
                        
                        NSString *string = array[2];
                        
                        NSString *newString = [[string componentsSeparatedByString:@" "] firstObject];
                        
                        [dayNumberArray addObject:newString];
                        
                        [dayNumberArray addObject:newString];
                        
                        self.allDayArray = [NSMutableArray arrayWithArray:[[allDayArray reverseObjectEnumerator] allObjects]];
                        
                        self.dayNumberArray = [NSMutableArray arrayWithArray:[[dayNumberArray reverseObjectEnumerator] allObjects]];
                    }
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.tableView reloadData];
                    
                    [self.tableView.mj_header endRefreshing];
                    
                });
                
            } failure:^(NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self showToast:@"获取天龄失败，可能是网络繁忙"];
                    
                    [self.tableView.mj_header endRefreshing];
                });
            }];
        }];
    }
}

//上传用户信息
- (void)uploadMotionData {
    
    if (![Common isObjectNull:STUserAccountHandler.userProfile.userId]) {
        
        MotionData *mdata = [[MotionData alloc]init];
        
        [mdata getHealtHequipmentWhetherSupport:^(BOOL scs) {
            
            if (scs) {
                
                //获取步数
                [mdata getHealthUserDateOfBirthCount:^(NSString *birthString) {
                    
                    if (birthString != nil) {
                        //获取爬楼数
                        [mdata getClimbStairsCount:^(NSString *climbStairsString) {
                            
                            if (climbStairsString != nil) {
                                //获取运动距离
                                [mdata getMovingDistanceCount:^(NSString *movingDistanceString) {
                                    
                                    if (movingDistanceString != nil) {
                                        
                                        NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
                                        [dataDictionary setObject:birthString forKey:@"stepNum"];
                                        [dataDictionary setObject:climbStairsString forKey:@"stairs"];
                                        [dataDictionary setObject:movingDistanceString forKey:@"distance"];
                                        
                                        NSString *dataString=[self dataToJsonString:dataDictionary];
                                        
                                        [STDataHandler sendStatUserLifeWithUserId:STUserAccountHandler.userProfile.userId dataString:dataString success:^(BOOL success) {
                                            
                                            if (success) {
                                                
                                            }
                                            
                                        } failure:^(NSError *error) {
                                            
                                        }];
                                    }
                                    
                                } failure:^(NSError *error) {
                                    
                                }];
                            }
                            
                        } failure:^(NSError *error) {
                            
                        }];
                        
                    }
                    
                } failure:^(NSError *error) {
                }];
                
            }else{
                return;
            }
            
        } failure:^(NSError *error) {
            
        }];
    }
    
}

//定位并获取天气情况
- (void)startFindLocationSucess {
    
    //1.开始定位
    [self.dataHandler startFindLocationSucess:^(NSString *cityName,NSString *administrativeArea,CLLocationCoordinate2D coordinate2D) {
        
        //获取天气情况
        [STDataHandler getWeatherInformation:[Common deletedStringWithParentString:cityName] sucess:^(WeatherInformationModel *informationModel) {
            
            self.informationModel = informationModel;
            
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            
        } failure:^(NSError *error) {
            
            [self showToast:@"获取天气失败"];
            
        }];
        
    } failure:^(NSError *error) {
        
    }];
}

//根据用户id去获取打败的数据
- (void)getDefeatDataWithUserId:(NSNumber *)userId {
    
    [STDataHandler sendGetDefeatDataWithUserId:userId success:^(NSString *dataString) {
        
        self.indicatorCell.titleLabel.text = [NSString stringWithFormat:@"您的总天龄已经击败%.1f%%用户",[dataString floatValue] * 100];
        
    } failure:^(NSError *error) {
        
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
        
        [cell.ageLable setText:[NSString stringWithFormat:@"%ld岁",(long)[self daysToYear]]];
        [cell.jinSuoImageView setImage:[self lifeToYear]];
        
        [cell setChangeStateBlock:^() {
            [self lifeImagePush];
        }];
        
        cell.informationModel = self.informationModel;
        
        //下载头像
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:STUserAccountHandler.userProfile.headImg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        return cell;
        
    } else if (indexPath.row == 1) {
            
        //刷新数据
        [self.indicatorCell reloadData:self.totalLifeDayNumber birthDayString:STUserAccountHandler.userProfile.birthday showLabelTye:[Common readAppIntegerDataForKey:SHOWLABLETYPE]];
        
        return self.indicatorCell;
        
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
    
    if (indexPath.row == 1) {
        
        QGPickerView *picker = [[QGPickerView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 250, SCREEN_WIDTH, 250)];
        
        picker.delegate = self;
        
        picker.titleText = @"设置天龄显示方式";
        
        NSArray *dataArray = @[@"剩余天龄+总天龄",@"过去天龄+总天龄",@"过去天龄+剩余天龄"];
        
        NSString *selectorString = @"";
        if ([Common readAppIntegerDataForKey:SHOWLABLETYPE] == ShowLabelPastAgeAndSurplusAgeType) {
            
            selectorString = [dataArray objectAtIndex:2];
            
        } else if ([Common readAppIntegerDataForKey:SHOWLABLETYPE] == ShowLabelPastAgeAndAllAgeType){

            selectorString = [dataArray objectAtIndex:1];

        } else {
            
            selectorString = [dataArray objectAtIndex:0];
        }
        
        //显示QGPickerView
        [picker showPickView:[UIApplication sharedApplication].keyWindow withPickerViewNum:1 withArray:dataArray withArray:nil withArray:nil selectedTitle:selectorString selectedTitle:nil selectedTitle:nil];
        
    } else if (indexPath.row == 2) {
        
        [self loadDaysOfAgeOptionView];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark --- QGPickerViewDelegate
- (void)didSelectPickView:(QGPickerView *)pickView  value:(NSString *)value indexOfPickerView:(NSInteger)index indexOfValue:(NSInteger)valueIndex {
    
    if (valueIndex == 0) {
        
        [Common saveAppIntegerDataForKey:SHOWLABLETYPE withObject:ShowLabelSurplusAgeAndAllAgeType];
        [self.indicatorCell reloadData:self.totalLifeDayNumber birthDayString:STUserAccountHandler.userProfile.birthday showLabelTye:ShowLabelSurplusAgeAndAllAgeType];

        [self animationShowLabelWithTpye:ShowLabelSurplusAgeAndAllAgeType];
        
    } else if (valueIndex == 1) {
        [Common saveAppIntegerDataForKey:SHOWLABLETYPE withObject:ShowLabelPastAgeAndAllAgeType];
        [self.indicatorCell reloadData:self.totalLifeDayNumber birthDayString:STUserAccountHandler.userProfile.birthday showLabelTye:ShowLabelPastAgeAndAllAgeType];
        
        [self animationShowLabelWithTpye:ShowLabelPastAgeAndAllAgeType];
        
    } else if (valueIndex == 2) {
        [Common saveAppIntegerDataForKey:SHOWLABLETYPE withObject:ShowLabelPastAgeAndSurplusAgeType];
        [self.indicatorCell reloadData:self.totalLifeDayNumber birthDayString:STUserAccountHandler.userProfile.birthday showLabelTye:ShowLabelPastAgeAndSurplusAgeType];
        
        [self animationShowLabelWithTpye:ShowLabelPastAgeAndSurplusAgeType];
    }
}

- (NSString *)dataToJsonString:(id)object {
    
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
       
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}


- (NSInteger)daysToYear {
    
    NSInteger day = [[self.allDayArray lastObject] integerValue];
    
    NSNumber *year = [NSNumber numberWithFloat:day/365];
    
    NSInteger yearInt = [year integerValue];
    
    return yearInt;
}

- (UIImage *)lifeToYear {
    
    NSInteger life = [self daysToYear];
    
    if ([[STUserAccountHandler userProfile].gender intValue] == 0) {
        
        if (life <= 20) {
            
            return [UIImage imageNamed:@"age_1_f"];
            
        } else if (life <= 30) {
            
            return [UIImage imageNamed:@"age_2_f"];
            
        } else if (life <= 40) {
            
            return [UIImage imageNamed:@"age_3_f"];
            
        } else if (life <= 50) {
            
            return [UIImage imageNamed:@"age_4_f"];
            
        } else if (life <= 60) {
            
            return [UIImage imageNamed:@"age_5_f"];
            
        } else if (life <= 70) {
            
            return [UIImage imageNamed:@"age_6_f"];
            
        } else if (life <= 80) {
            
            return [UIImage imageNamed:@"age_7_f"];
            
        } else if (life <= 90) {
            
            return [UIImage imageNamed:@"age_8_f"];
            
        } else if (life <= 100 || life > 100) {
            
            return [UIImage imageNamed:@"age_9_f"];
            
        } else {
            return nil;
        }
    }
    
    if ([[STUserAccountHandler userProfile].gender intValue] == 1) {
        
        if (life <= 20) {
            return [UIImage imageNamed:@"age_1"];
        } else if (life <= 30) {
            return [UIImage imageNamed:@"age_2"];
        } else if (life <= 40) {
            return [UIImage imageNamed:@"age_3"];
        } else if (life <= 50) {
            return [UIImage imageNamed:@"age_4"];
        } else if (life <= 60) {
            return [UIImage imageNamed:@"age_5"];
        } else if (life <= 70) {
            return [UIImage imageNamed:@"age_6"];
        } else if (life <= 80) {
            return [UIImage imageNamed:@"age_7"];
        } else if (life <= 90) {
            return [UIImage imageNamed:@"age_8"];
        } else if (life <= 100 || life > 100) {
            return [UIImage imageNamed:@"age_9"];
        } else {
            return nil;
        }
    }
    return nil;
}

- (void)lifeImagePush {
    
    JinSuoDetailsViewController *controller = [[JinSuoDetailsViewController alloc] init];
    
    controller.averageAge = [self daysToYear];
    
    controller.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:controller animated:YES];
}

//动画般的显示用户设置天龄的方法
- (void)animationShowLabelWithTpye:(ShowLabelType )type {
    
    //显示之前先把之前的view先移除
    if (self.indicationView) {
        
        [self.indicationView removeFromSuperview];
        
        self.indicationView = nil;
    }
    
    UIView *view = [[UIView alloc] init];
    
    self.indicationView = view;
    
    view.backgroundColor = RGBACOLOR(83, 128, 196, 1);
    
    [self.navigationController.view insertSubview:view belowSubview:self.navigationController.navigationBar];
    //显示标题的label
    UILabel *label = [[UILabel alloc] init];
    
    label.textColor = [UIColor whiteColor];

    [view addSubview:label];
    
    label.backgroundColor = RGBACOLOR(83, 128, 196, 1);
    
    view.width = SCREEN_WIDTH;
    
    view.x = 0;

    view.height = 70;
    
    view.y = 64 - view.height;
    
    label.width = SCREEN_WIDTH - 5;
    
    label.height = 70;
    
    label.y = 0;
    
    label.x = 5;
    
    label.textAlignment = NSTextAlignmentLeft;
    
    label.font = [UIFont systemFontOfSize:15.0f];
    
    label.lineBreakMode = NSLineBreakByWordWrapping;
    
    label.numberOfLines = 2;
    //添加知道了按钮
    UILabel *cancelLabel = [[UILabel alloc] init];
    
    cancelLabel.text = @"知道了";
    
    cancelLabel.textColor = [UIColor whiteColor];
    
    cancelLabel.font = [UIFont systemFontOfSize:14.0f];
    
    cancelLabel.frame = CGRectMake(SCREEN_WIDTH - 65.0f, 40, 60, 28.0f);
    
    cancelLabel.layer.cornerRadius = 5;
    
    cancelLabel.layer.masksToBounds = YES;
    
    cancelLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    
    cancelLabel.layer.borderWidth = 1.0f;
    
    cancelLabel.backgroundColor = RGBACOLOR(83, 128, 196, 1);
    
    cancelLabel.textAlignment = NSTextAlignmentCenter;
    
    [view addSubview:cancelLabel];
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAction:)];
    [view addGestureRecognizer:tap];
    if (type == ShowLabelSurplusAgeAndAllAgeType) {
        
        label.text = @"  已切换成【过去天龄+剩余天龄】并同步作用于好友详细资料";
        
    } else if (type == ShowLabelPastAgeAndAllAgeType) {
        
        label.text = @"  已切换成【过去天龄+总天龄】并同步作用于好友详细资料";
        
    } else if (type == ShowLabelPastAgeAndSurplusAgeType) {
    
        label.text = @"  已切换成【过去天龄+剩余天龄】并同步作用于好友详细资料";
    }

    [UIView animateWithDuration:0.5f animations:^{
        //label.y += label.height;
        
        view.transform = CGAffineTransformMakeTranslation(0, view.height);
        
    } completion:nil];
}

- (void)cancelAction:(UITapGestureRecognizer *)tap {
    
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.indicationView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        [self.indicationView removeFromSuperview];
        
        self.indicationView = nil;
    }];
}

//显示设置生日的视图
- (void)showSettingBirthdayView {
    
    if ([Common isObjectNull:STUserAccountHandler.userProfile.birthday]) {
        
        if (!self.birthdayView) {
            
            SettingBirthdayView *view = [[SettingBirthdayView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            
            view.backgroundColor = RGBACOLOR(230, 230, 230,1);
            
            __weak typeof(view) weakView = view;
    
            //按钮点击回调
            [view setSaveBlock:^(NSDate *selectorDate, NSNumber *gentNumber) {
                
                [self.dataHandler sendUpdateUserInformationWithUserId:STUserAccountHandler.userProfile.userId
                                                             nickName:STUserAccountHandler.userProfile.nickName
                                                               gender:gentNumber
                                                             birthday:[[Common dateFormatterWithFormatterString:@"yyyy-MM-dd"] stringFromDate:selectorDate]
                                                   headImageUrlString:nil
                                                                 memo:nil
                                                              success:^(BOOL success) {
                                                                  
                                                                  [weakView removeBirthdayView];
                                                                  
                                                                  self.birthdayView = nil;
                                                              }
                                                              failure:^(NSError *error) {
                                                                  
                                                                  [weakView removeBirthdayView];
                                                                  
                                                                  self.birthdayView = nil;
                                                                  
                                                              }];
                
            }];
            
            [[UIApplication sharedApplication].keyWindow addSubview:view];
            
            self.birthdayView = view;
        }
    }
}

- (void)loadDaysOfAgeOptionView {

    DaysOfAgeOption *shareAnimationView = [[[NSBundle mainBundle] loadNibNamed:@"DaysOfAgeOption" owner:self options:nil] lastObject];
    
    //封装的动画般推出视图
    [shareAnimationView animateWindowsAddSubView];
    
    __weak DaysOfAgeOption *weakSelf = shareAnimationView;
    
    [shareAnimationView setShareButtonBlock:^(NSInteger tag, DaysOfAgeOption *daysOfAgeOptionView) {
       
        [weakSelf annimateRemoveFromSuperView];
        
        if (tag == 1) {
            
            NSDictionary *userConfigure = [Common readAppDataForKey:USER_CHOOSE_AGENUMBER];
            
            BOOL isOn = [userConfigure[FACTORVERIFICATION] boolValue];

            if (isOn) {
                
                FactorVerificationView *view = [[[NSBundle mainBundle] loadNibNamed:@"FactorVerificationView" owner:self options:nil] lastObject];
                
                [view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                
                 __weak FactorVerificationView *weakSelf = view;
                
                [view setButtonBlock:^(UIButton *button) {
                   
                    if ([Common isObjectNull:weakSelf.passWordTextFiled.text]) {
                        
                        [self showToast:@"密码不能为空"];
                        
                        return;
                        
                    }
                    
                    [STDataHandler sendCheckPasswordWithUserId:STUserAccountHandler.userProfile.userId password:weakSelf.passWordTextFiled.text success:^(BOOL success) {
                        
                        if (success) {
                            
                            [weakSelf removeFromSuperview];
                            
                            HealthySetUpViewController *controller = [[HealthySetUpViewController alloc] init];
                            
                            controller.hidesBottomBarWhenPushed = YES;
                            
                            [self.navigationController pushViewController:controller animated:YES];
                            
                        } else {
                        
                            [self showToast:@"密码错误"];
                        
                        }
                        
                    } failure:^(NSError *error) {
                        
                        [self showToast:@"服务器繁忙"];
                        
                    }];
                    
                }];
                
                
                [[[UIApplication sharedApplication].delegate window] addSubview:view];
            
            } else {
            
                HealthySetUpViewController *controller = [[HealthySetUpViewController alloc] init];
                
                controller.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController pushViewController:controller animated:YES];
            
            }
            

        
        } else {
            
            PromoteAgeViewController *controller = [[PromoteAgeViewController alloc] init];
            
            controller.sportText = self.informationModel.sport;
            
            controller.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:controller animated:YES];
        
        }
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [STNotificationCenter removeObserver:self];
    
    self.indicationView = nil;
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
