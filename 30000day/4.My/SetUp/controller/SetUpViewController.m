//
//  setUpTableViewController.m
//  30000天
//
//  Created by wei on 16/1/21.
//  Copyright © 2016年 wei. All rights reserved.
//

#import "SetUpViewController.h"
#import "CDSoundManager.h"

static CGFloat kHorizontalSpacing = 40;
static CGFloat kFooterHeight = 30;

static NSString *kMainText = @"mainText";
static NSString *kDetailText = @"detailText";
static NSString *kTipText = @"tipText";
static NSString *kDetailSwitchOn = @"detailSwitchOn";
static NSString *kDetailSwitchChangeSelector = @"detailSwitchChangeSelector";

@interface SetUpViewController ()

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation SetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";

    UIView *footerview = [[UIView alloc] init];
    
    [self.tableView setTableFooterView:footerview];
    
    NSString *detailText = [self isNotificationEnabled] ? @"已开启" : @"已关闭";
    
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    
    self.dataSource = @[
                        @{kMainText:@"新消息通知",
                          kDetailText:detailText,
                          kTipText:[NSString stringWithFormat:@"如果你要关闭或开启%@的新消息通知，请在 iPhone 的\"设置\"-\"通知\"功能中，找到应用程序%@更改。", appName, appName]},
                        @{kMainText:@"聊天音效",
                          kDetailSwitchOn: @([CDSoundManager manager].needPlaySoundWhenChatting),
                          kDetailSwitchChangeSelector:NSStringFromSelector(@selector(chattingSoundChanged:)),
                          kTipText:@"开启时，将在聊天时播放发送消息和接受消息的提示音"},
                        @{kMainText:@"通知声音",
                          kDetailSwitchOn:@([CDSoundManager manager].needPlaySoundWhenNotChatting),
                          kDetailSwitchChangeSelector:NSStringFromSelector(@selector(notChattingSoundChanged:)),
                          kTipText:@"开启时，在其它页面接收到消息时将播放提示音"},
                        @{kMainText:@"通知振动",
                          kDetailSwitchOn:@([CDSoundManager manager].needVibrateWhenNotChatting),
                          kDetailSwitchChangeSelector:NSStringFromSelector(@selector(vibrateChanged:)),
                          kTipText:@"开启时，在其它页面接收到消息时将振动一下"}];
    
}

#pragma mark - actions or helpers

- (BOOL)isNotificationEnabled {
    
    UIApplication *application = [UIApplication sharedApplication];
    
    BOOL enabled;
    
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
        // ios8
        enabled = [application isRegisteredForRemoteNotifications];
    }
   return enabled;
}

- (void)chattingSoundChanged:(UISwitch *)switchView {
    [CDSoundManager manager].needPlaySoundWhenChatting = switchView.on;
}

- (void)notChattingSoundChanged:(UISwitch *)switchView {
    [CDSoundManager manager].needPlaySoundWhenNotChatting = switchView.on;
}

- (void)vibrateChanged:(UISwitch *)switchView {
    [CDSoundManager manager].needVibrateWhenNotChatting = switchView.on;
}

- (void)friendValidation:(UISwitch *)switchView {

    BOOL isOn = switchView.isOn;
    
    NSMutableDictionary *userConfigure = [NSMutableDictionary dictionaryWithDictionary:[Common readAppDataForKey:USER_CHOOSE_AGENUMBER]];
    
    if (userConfigure == nil) {
        
        userConfigure = [NSMutableDictionary dictionary];
        
    }
    
    [userConfigure setObject:@(isOn) forKey:FRIENDVALIDATION];
    
    [Common saveAppDataForKey:USER_CHOOSE_AGENUMBER withObject:userConfigure];//保存到沙盒里
    
}

- (void)factorVerification :(UISwitch *)switchView {

    BOOL isOn = switchView.isOn;
    
    NSMutableDictionary *userConfigure = [NSMutableDictionary dictionaryWithDictionary:[Common readAppDataForKey:USER_CHOOSE_AGENUMBER]];
    
    if (userConfigure == nil) {
        
        userConfigure = [NSMutableDictionary dictionary];
        
    }
    
    [userConfigure setObject:@(isOn) forKey:FACTORVERIFICATION];
    
    [Common saveAppDataForKey:USER_CHOOSE_AGENUMBER withObject:userConfigure];//保存到沙盒里

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSource.count + 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 12;
    }
    
    return 0.001f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIndentifier = @"cellIndentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.dataSource.count == indexPath.section) {
        
        cell.textLabel.text = @"好友验证";
        
        NSDictionary *userConfigure = [Common readAppDataForKey:USER_CHOOSE_AGENUMBER];
        
        BOOL isOn = [userConfigure[FRIENDVALIDATION] boolValue];
        
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        
        [switchView setOn:isOn];
        
        [switchView addTarget:self action:@selector(friendValidation:) forControlEvents:UIControlEventValueChanged];
        
        cell.accessoryView = switchView;
        
    } else if(self.dataSource.count + 1 == indexPath.section){
        
        cell.textLabel.text = @"健康因素密码验证";
        
        NSDictionary *userConfigure = [Common readAppDataForKey:USER_CHOOSE_AGENUMBER];
        
        BOOL isOn = [userConfigure[FACTORVERIFICATION] boolValue];
        
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        
        [switchView setOn:isOn];
        
        [switchView addTarget:self action:@selector(factorVerification:) forControlEvents:UIControlEventValueChanged];
        
        cell.accessoryView = switchView;

    }else {
        
        NSDictionary *sectionData = self.dataSource[indexPath.section];
        
        NSString *text = sectionData[kMainText];
        
        NSString *detailText = sectionData[kDetailText];
        
        id switchValue = sectionData[kDetailSwitchOn];
        
        if (switchValue) {
            
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            
            BOOL switchOn = [switchValue boolValue];
            
            [switchView setOn:switchOn];
            
            NSString *selectorName = sectionData[kDetailSwitchChangeSelector];
            
            [switchView addTarget:self action:NSSelectorFromString(selectorName) forControlEvents:UIControlEventValueChanged];
            
            cell.accessoryView = switchView;
        }
        
        cell.textLabel.text = text;
        
        cell.detailTextLabel.text = detailText;
    
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
   return kFooterHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (self.dataSource.count == section) {
        
        UILabel *tipLabel = [self tipLabel];
        
        tipLabel.text = @"开启时，别人添加你为好友时需要验证";
        
        return tipLabel;
        
    } else if(self.dataSource.count + 1 == section){
    
        UILabel *tipLabel = [self tipLabel];
        
        tipLabel.text = @"开启时，进入完善健康因素时需填写登陆密码";
        
        return tipLabel;
    
    } else {
    
        NSDictionary *sectionData = self.dataSource[section];
        
        NSString *tipText = sectionData[kTipText];
        
        if (tipText.length > 0) {
            
            UILabel *tipLabel = [self tipLabel];
            
            tipLabel.text = tipText;
            
            return tipLabel;
            
        } else {
            
            return nil;
        }
    }
}


- (UILabel *)tipLabel {
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(kHorizontalSpacing, 0, CGRectGetWidth([UIScreen mainScreen].bounds) - 2 * kHorizontalSpacing, kFooterHeight)];
    
    tipLabel.font = [UIFont systemFontOfSize:11];
    
    tipLabel.textColor = [UIColor grayColor];
    
    tipLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.numberOfLines = 0;
    return tipLabel;
}

@end
