//
//  setUpTableViewController.m
//  30000天
//
//  Created by wei on 16/1/21.
//  Copyright © 2016年 wei. All rights reserved.
//

#import "SetUpViewController.h"
#import "setUpTableViewCell.h"
#import "CDSoundManager.h"

static CGFloat kHorizontalSpacing = 40;
static CGFloat kFooterHeight = 30;

static NSString *kMainText = @"mainText";
static NSString *kDetailText = @"detailText";
static NSString *kTipText = @"tipText";
static NSString *kDetailSwitchOn = @"detailSwitchOn";
static NSString *kDetailSwitchChangeSelector = @"detailSwitchChangeSelector";

@interface SetUpViewController ()

@property (nonatomic,strong) NSArray *titleCellArray;

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation SetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";

    UIView *footerview = [[UIView alloc] init];
    
    [self.tableView setTableFooterView:footerview];
    
    self.titleCellArray = [NSArray arrayWithObjects:@"pm2.5预警",@"天龄下降预警",nil];
    
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
    else {
        UIRemoteNotificationType types = [application enabledRemoteNotificationTypes];
        enabled = types & UIRemoteNotificationTypeAlert;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1 + self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 2;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 12;
        
    } else if(section == 1) {
        
        return 22.0f;
    }
    return 0.001f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        static NSString* ID = @"setUpCell";
        
        setUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            
            NSBundle* bundle=[NSBundle mainBundle];
            
            NSArray *objs=[bundle loadNibNamed:@"setUpTableViewCell" owner:nil options:nil];
            
            cell = [objs lastObject];
        }
        
        cell.textLabel.text = self.titleCellArray[indexPath.row];
        
        UISwitch *sw = [[UISwitch alloc] init];
        
        [cell addSubview:sw];
        
        sw.translatesAutoresizingMaskIntoConstraints = NO;
        
        [cell addConstraint:[NSLayoutConstraint constraintWithItem:sw attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        
        [cell addConstraint:[NSLayoutConstraint constraintWithItem:sw attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeRight multiplier:1.0 constant:-28]];
        
        return cell;

        
    } else {
        
        static NSString *cellIndentifier = @"cellIndentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
            
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDictionary *sectionData = self.dataSource[indexPath.section - 1];
        
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
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
     
        return 0.0001f;
        
    } else {
        
        return kFooterHeight;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return nil;
        
    } else {
        
        NSDictionary *sectionData = self.dataSource[section - 1];
        
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
