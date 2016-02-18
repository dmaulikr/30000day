//
//  PersonViewController.m
//  30000day
//
//  Created by GuoJia on 16/1/29.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "PersonViewController.h"
#import "PersonHeadView.h"

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
}

//获取我的好友
- (void)getMyFriends {
    
    [self.dataHandler getMyFriendsWithPassword:[Common readAppDataForKey:KEY_SIGNIN_USER_PASSWORD] loginName:[Common readAppDataForKey:KEY_SIGNIN_USER_NAME] success:^(NSMutableArray * dataArray) {
        
        _dataArray = dataArray;
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}


#pragma ---
#pragma mark ----- UITableViewDelegate/UITableViewDatasource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    static NSString *headViewIndentifier = @"PersonHeadView";
    
    PersonHeadView *view = (PersonHeadView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:headViewIndentifier];
    
    if (view == nil) {
        
        view = [[[NSBundle mainBundle] loadNibNamed:headViewIndentifier owner:self options:nil] lastObject];
    }

    view.titleLabel.text = [NSString stringWithFormat:@"当前共有 %ld 位自己人哦！",(unsigned long)_dataArray.count];
    
    [view setChangeStateBlock:^(UIButton *changeStatusButton){
       
        self.state = self.state ? 0 : 1 ;
        
        [self.tableView reloadData];
        
    }];
    
    if (self.state == 1) {
        
        [view.changeStatusButton setImage:[UIImage imageNamed:@"bigPicture.png"] forState:UIControlStateNormal];
        
        [view.changeStatusButton setTitle:@" 列表" forState:UIControlStateNormal];
        
    } else {
        
        [view.changeStatusButton setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
        
        [view.changeStatusButton setTitle:@" 大图" forState:UIControlStateNormal];
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 44;
    }
    return 0;
}

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
        
        static NSString *ID = @"friendsBigIMGCell";
        
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
    
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
