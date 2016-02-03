//
//  PersonViewController.m
//  30000day
//
//  Created by GuoJia on 16/1/29.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "PersonViewController.h"

@interface PersonViewController () <UITableViewDataSource,UITableViewDelegate>

{
    NSMutableArray *_dataArray;
}

@property (nonatomic,assign) NSInteger state;

@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.state = 0;//列表

    [self.tableView setTableFooterView:[[UIView alloc] init]];
    
    //获取我的好友
    [self getMyFriends];
    
//    //监听个人信息管理模型发出的通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMyFriends) name:@"UserAccountHandlerUseProfileDidChangeNotification" object:nil];
    
}

//获取我的好友
- (void)getMyFriends {
    
    [self.dataHandler getMyFriendsWithPassword:[Common readAppDataForKey:KEY_SIGNIN_USER_PASSWORD] phoneNumber:[Common readAppDataForKey:KEY_SIGNIN_USER_NAME] success:^(id responseObject) {
        
        NSError *localError = nil;
        
       id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];

        NSArray  *recvArray = (NSArray *)parsedObject;
        
        NSMutableArray *array = [NSMutableArray array];
        
        for (NSDictionary *dic in recvArray) {
            
            FriendListInfo *ff = [[FriendListInfo alloc] init];
            
            [ff setValuesForKeysWithDictionary:dic];
            
            [array addObject:ff];
        }
        
        _dataArray = array;
        
       dispatch_async(dispatch_get_main_queue(), ^{
           
           self.friendsNumLabel.text = [NSString stringWithFormat:@"当前共有 %ld 位自己人哦！",(unsigned long)_dataArray.count];
           
           [self.tableView reloadData];
       });
        
    } failure:^(LONetError *error) {
        
        
    }];

}

- (IBAction)switchModeButtonClick:(id)sender {
    
    if (self.state == 0) {
        
        self.state = 1;
        
        [self.switchModeButton setImage:[UIImage imageNamed:@"bigPicture.png"] forState:UIControlStateNormal];
        
        [self.switchModeButton setTitle:@" 列表" forState:UIControlStateNormal];
        
    } else {
        
        self.state = 0;
        
        [self.switchModeButton setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
        
        [self.switchModeButton setTitle:@" 大图" forState:UIControlStateNormal];
        
    }
    
    [self.tableView reloadData];
}

#pragma ---
#pragma mark ----- UITableViewDelegate/UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.state) {
        
        return 425;
        
    } else {
        
        return 81;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FriendListInfo *friendInfo = _dataArray[indexPath.row];
    
    myFriendsTableViewCell *cell;
    
    if (self.state) {
        
        static NSString *ID=@"friendsBigIMGCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell==nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MyFriendsBigIMGTableViewCell" owner:nil options:nil] lastObject];
        }
        
    } else {
        
        static NSString *ID = @"myFriendsCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"myFriendsTableViewCell" owner:nil options:nil] lastObject];
        }
    }
    
    if ( [friendInfo.HeadImg length] > 0) {
        
        [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:friendInfo.HeadImg]];
        
    } else {
        
        [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:friendInfo.FriendHeadImg]];
    }
    
    if (friendInfo.Remarks != nil && ![friendInfo.Remarks isEqualToString:@""]) {
        
        cell.nameLab.text = friendInfo.Remarks;
        
    } else {
        
        cell.nameLab.text = friendInfo.FriendSelfNickName;
        
    }
    
    cell.logName.text = @"暂无简介";
    
    int birthday = [self pastDay:[friendInfo.Birthday stringByAppendingString:@" 00:00:00"]];
    
    cell.progressView.progress = (double)birthday/[friendInfo.TotalDays doubleValue];
    
    return cell;
    
}

- (int)pastDay:(NSString *)theDate {
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *d = [date dateFromString:theDate];
    
    NSTimeInterval late = [d timeIntervalSince1970]*1;
    
    NSDate *adate = [NSDate date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: adate];
    
    NSDate *localeDate = [adate  dateByAddingTimeInterval: interval];
    
    NSTimeInterval now = [localeDate timeIntervalSince1970]*1;
    
    NSString *timeString = @"";
    
    NSTimeInterval cha = now-late;
    
    timeString = [NSString stringWithFormat:@"%f", cha/86400];
    
    timeString = [timeString substringToIndex:timeString.length-7];
    
    int iDays = [timeString intValue];
    
    return iDays;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
