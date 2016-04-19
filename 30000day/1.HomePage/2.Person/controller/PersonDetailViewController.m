//
//  PersonDetailViewController.m
//  30000day
//
//  Created by GuoJia on 16/2/29.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "PersonDetailViewController.h"
#import "myFriendsTableViewCell.h"
#import "ActivityIndicatorTableViewCell.h"
#import "ChartTableViewCell.h"
#import "UserLifeModel.h"
#import "CDChatVC.h"
#import "CDIMService.h"
#import "UIImageView+WebCache.h"
#import "UserInformationModel.h"

@interface PersonDetailViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,assign) float totalLifeDayNumber;

@property (nonatomic,strong) NSMutableArray *allDayArray;

@property (nonatomic,strong) NSMutableArray *dayNumberArray;

@property (weak, nonatomic) IBOutlet UIView *backgoudView;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;

@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@end

@implementation PersonDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详细资料";
    
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    
    self.backgoudView.layer.borderColor = RGBACOLOR(200, 200, 200, 1).CGColor;
    self.backgoudView.layer.borderWidth = 0.5f;
    
    self.leftButton.layer.cornerRadius = 5;
    self.leftButton.layer.masksToBounds = YES;
    
    self.leftButton.layer.borderWidth = 0.5f;
    self.leftButton.layer.borderColor = RGBACOLOR(200, 200, 200, 1).CGColor;
    
    self.rightButton.layer.cornerRadius = 5;
    self.rightButton.layer.masksToBounds = YES;
    
    [self reloadData];
}

- (void)reloadData {
    
    //1.获取用户的天龄
    [self.dataHandler sendUserLifeListWithCurrentUserId:self.informationModel.userId endDay:[Common getDateStringWithDate:[NSDate date]] dayNumber:@"7" success:^(NSMutableArray *dataArray) {
        
        UserLifeModel *lastModel = [dataArray lastObject];
        
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
        
        [self.tableView reloadData];
        
    } failure:^(STNetError *error) {
        
    }];
}


- (IBAction)buttonClickAction:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    if (button.tag == 1) {//右按钮
        
        if (self.informationModel.userId) {//这个userId存在的时候才进行push

            //查询conversation
            [[CDChatManager manager] fetchConversationWithOtherId:[NSString stringWithFormat:@"%@",self.informationModel.userId] attributes:[UserInformationModel attributesDictionay:self.informationModel userProfile:STUserAccountHandler.userProfile] callback:^(AVIMConversation *conversation, NSError *error) {
                
                if ([self filterError:error]) {
                    
                    [[CDIMService service] pushToChatRoomByConversation:conversation fromNavigationController:self.navigationController];
                    
                }
            }];
            
        } else {
            
            [self showToast:@"对方的id为空"];
            
        }
    
    } else {//左按钮


    }
}

#pragma --
#pragma mark ---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
      
        myFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myFriendsTableViewCell"];
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"myFriendsTableViewCell" owner:self options:nil] lastObject];
        
        }
        
        cell.upDownImg.hidden = YES;
        
        cell.progressView.hidden = YES;
        
        [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:self.informationModel.headImg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        cell.nameLab.text = self.informationModel.nickName;
        
        cell.logName.text = self.informationModel.mobile;

        return cell;
        
    } else if (indexPath.section == 1) {
        
        ActivityIndicatorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityIndicatorTableViewCell"];
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityIndicatorTableViewCell" owner:nil options:nil] lastObject];
        }
        
        //刷新数据
        [cell reloadData:self.totalLifeDayNumber birthDayString:self.informationModel.birthday showLabelTye:[Common readAppIntegerDataForKey:SHOWLABLETYPE]];
        
        return cell;
        
    } else if (indexPath.section == 2) {
     
        ChartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChartTableViewCell"];
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ChartTableViewCell" owner:nil options:nil] lastObject];
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
    
    if (indexPath.section == 0) {
        
        return 80;
        
    } else if ( indexPath.section == 1) {
        
        return (SCREEN_HEIGHT - 188)/2.0f;
        
    } else if (indexPath.section == 2) {
        
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
