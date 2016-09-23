//
//  STChooseSettingController.m
//  30000day
//
//  Created by GuoJia on 16/8/16.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STChooseSettingController.h"
#import "STChooseItemSettingCell.h"
#import "STChooseSettingHeadView.h"
#import "STChooseItemController.h"
#import "STRestrctingViewController.h"
#import "PersonInformationsManager.h"

@interface STChooseSettingController () <UITableViewDataSource,UITableViewDelegate,QGPickerViewDelegate>

//@property (nonatomic,strong) STChooseItemSettingCell *firstCell;
//@property (nonatomic,strong) STChooseItemSettingCell *secondCell;
//@property (nonatomic,strong) STChooseItemSettingCell *thirdCell;
@property (nonatomic,strong) QGPickerView *picker_1;

@end

@implementation STChooseSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableViewStyle = STRefreshTableViewPlain;
    self.tableView.frame = CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
//    [STNotificationCenter addObserver:self selector:@selector(reloadData) name:@"reloadScrollView" object:nil];
    [STNotificationCenter addObserver:self selector:@selector(reloadDataWhenSuccessSignIn) name:STUserAccountHandlerUseProfileDidChangeNotification object:nil];
    //从服务器下载好友的数据(用来设置好友查看自媒体的一些权限)
    [self synchronizedFriendsDataFromServer];
}

//- (void)reloadData {
//    [self.firstCell reloadData];
//    [self.secondCell reloadData];
//    [self.thirdCell reloadData];
//    [self.tableView reloadData];
//}

- (void)reloadDataWhenSuccessSignIn {
//    [self reloadData];
    [self synchronizedFriendsDataFromServer];
}

- (void)synchronizedFriendsDataFromServer {
    [[PersonInformationsManager shareManager] synchronizedLocationDataFromServerWithUserId:STUserAccountHandler.userProfile.userId];
}

//- (STChooseItemSettingCell *)firstCell {
//    if (!_firstCell) {
//        _firstCell = [[STChooseItemSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"STChooseItemSettingCell" visibleType:@(0)];
//        _firstCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
//    return _firstCell;
//}
//
//- (STChooseItemSettingCell *)secondCell {
//    
//    if (!_secondCell) {
//        _secondCell  = [[STChooseItemSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"STChooseItemSettingCell" visibleType:@(1)];
//        _secondCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
//    return _secondCell;
//}
//
//- (STChooseItemSettingCell *)thirdCell {
//    
//    if (!_thirdCell) {
//        _thirdCell = [[STChooseItemSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"STChooseItemSettingCell" visibleType:@(2)];
//        _thirdCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
//    return _thirdCell;
//}

#pragma mark -- UITableViewDataSource / UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 3;
    } else if (section == 2) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
//        __weak typeof(self) weakSelf = self;
//        [self.firstCell setCallback:^{
//            [weakSelf.tableView reloadData];
//        }];
//        return self.firstCell;
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        }
        cell.textLabel.text = @"消息分类";
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
        
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
//            __weak typeof(self) weakSelf = self;
//            [self.secondCell setCallback:^{
//                [weakSelf.tableView reloadData];
//            }];
//            return self.secondCell;
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
            }
            cell.textLabel.text = @"消息分类";
            cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
            
        } else if (indexPath.row == 1) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
            }
            cell.textLabel.text = @"不看他（她）的自媒体";
            cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
            }
            cell.textLabel.text = @"不让他（她）看我的自媒体";
            cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
    } else if (indexPath.section == 2) {
        
//        __weak typeof(self) weakSelf = self;
//        [self.thirdCell setCallback:^{
//            [weakSelf.tableView reloadData];
//        }];
//        return self.thirdCell;
        if (indexPath.row == 0) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
            }
            cell.textLabel.text = @"消息分类";
            cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
            
        } else if (indexPath.row == 1) {
         
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell_1"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell_1"];
            }
            cell.textLabel.text = @"排序类型";
            cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            cell.detailTextLabel.text = [self getStringWithInterge:[Common readAppIntegerDataForKey:SAVE_CHOOSE_TYPE]];
            return cell;
            
        } else if (indexPath.row == 2) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell_1"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell_1"];
            }
            cell.textLabel.text = @"热点时间段";
            cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            return cell;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
//       return [self.firstCell chooseItemCellHeight];
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
//            return [self.secondCell chooseItemCellHeight];
        } else{
            return 44;
        }
    } else if (indexPath.section == 2) {
//        return [self.thirdCell chooseItemCellHeight];
    }
    return 44.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    STChooseSettingHeadView *view = (STChooseSettingHeadView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"STChooseSettingHeadView"];
    if (view == nil) {
        view = [[NSBundle mainBundle] loadNibNamed:@"STChooseSettingHeadView" owner:self options:nil][0];
    }
    if (section == 0) {
        view.titleLabel.text = @"自己";
    } else if (section == 1) {
        view.titleLabel.text = @"好友";
    } else if (section == 2) {
        view.titleLabel.text = @"公开";
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            STChooseItemController *controller = [[STChooseItemController alloc] init];
            controller.visibleType = @(indexPath.section);
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            STChooseItemController *controller = [[STChooseItemController alloc] init];
            controller.visibleType = @(indexPath.section);
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
            
        } else if (indexPath.row == 1) {
            
            STRestrctingViewController *controller = [[STRestrctingViewController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.type = @0;
            controller.title = @"不看他（她）的自媒体";
            [self.navigationController pushViewController:controller animated:YES];
            
        } else if (indexPath.row == 2) {
            
            STRestrctingViewController *controller = [[STRestrctingViewController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.type = @1;
            controller.title = @"不让他（她）看我的自媒体";
            [self.navigationController pushViewController:controller animated:YES];
        }
        
    } else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            STChooseItemController *controller = [[STChooseItemController alloc] init];
            controller.visibleType = @(indexPath.section);
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
            
        } else if (indexPath.row == 1) {
         
            QGPickerView *picker = [[QGPickerView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 250, SCREEN_WIDTH, 250)];
            picker.delegate = self;
            picker.titleText = @"排序类型";
            NSArray *array = @[@"普通(正常时间排序自媒体)",@"热点(当天最热门自媒体)"];
            [picker showPickView:[UIApplication sharedApplication].keyWindow withPickerViewNum:1 withArray:array withArray:nil withArray:nil selectedTitle:[self getPickerViewShowStringWithInterge:[Common readAppIntegerDataForKey:SAVE_CHOOSE_TYPE]] selectedTitle:nil selectedTitle:nil];
            self.picker_1 = picker;
        }
    }
}

- (NSString *)getStringWithInterge:(NSInteger)index {
    if (index == 1) {
        return @"热点";
    } else {
        return @"普通";
    }
}

- (NSString *)getPickerViewShowStringWithInterge:(NSInteger)index {
    if (index == 1) {
        return @"热点(当天最热门自媒体)";
    } else {
        return @"普通(正常时间排序自媒体)";
    }
}

#pragma mark --- QGPickerViewDelegate

- (void)didSelectPickView:(QGPickerView *)pickView  value:(NSString *)value indexOfPickerView:(NSInteger)index indexOfValue:(NSInteger)valueIndex {
 
    if (self.picker_1 == pickView) {
        [Common saveAppIntegerDataForKey:SAVE_CHOOSE_TYPE withObject:valueIndex];
        [self.tableView reloadData];
        [STNotificationCenter postNotificationName:STWeMediumOpenControllerFetchTypeChange object:@2];
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
