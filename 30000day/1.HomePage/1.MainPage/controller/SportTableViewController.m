//
//  SportTableViewController.m
//  30000day
//
//  Created by WeiGe on 16/7/7.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SportTableViewController.h"
#import "SportTableViewCell.h"
#import "SportTrajectoryViewController.h"
#import "SportInformationTableManager.h"
#import "SportInformationModel.h"
#import "SportTrajectoryLookViewController.h"
#import "SportHeadTableViewCell.h"

@interface SportTableViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *modelArray;

@property (nonatomic,strong) SportInformationTableManager *SFTable;

@end

@implementation SportTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"开始跑步";
    
    self.tableViewStyle = STRefreshTableViewGroup;
    
    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + 38);
    
    [self showHeadRefresh:NO showFooterRefresh:NO];
    
    [self refurbish];
    
    //刷新运动历史记录
    [STNotificationCenter addObserver:self selector:@selector(refurbish) name:STDidSuccessSportInformationSendNotification object:nil];
    
    //登录成功刷新
    [STNotificationCenter addObserver:self selector:@selector(reloadData) name:STUserAccountHandlerUseProfileDidChangeNotification object:nil];
}

- (void)refurbish {

    self.modelArray = [NSArray array];
    
    self.SFTable = [[SportInformationTableManager alloc] init];
    
    self.modelArray = [self.SFTable selectSportInformation:STUserAccountHandler.userProfile.userId];
    
    self.modelArray = [[self.modelArray reverseObjectEnumerator] allObjects];
    
    [self.tableView reloadData];
    
}

- (void)reloadData {

    [self refurbish];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        
        return 1;
        
    } else {
    
        return self.modelArray.count;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        
        return 0.1f;
        
    } else {
    
        return 20;
    
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        return 100;
        
    }
    
    return 74;

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        
        return YES;
        
    }
    
    return NO;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        SportInformationModel *model = self.modelArray[indexPath.row];
        
        [self.SFTable deleteSportInformation:model.lastMaxID];
        
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.modelArray];
        
        [array removeObjectAtIndex:indexPath.row];
        
        self.modelArray = array;
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        //发送通知刷新历史记录
        [STNotificationCenter postNotificationName:STDidSuccessSportInformationSendNotification object:nil];
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        SportHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SportHeadTableViewCell"];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SportHeadTableViewCell" owner:nil options:nil] lastObject];
            
        }

        __weak typeof(cell) weakSelf = cell;
        
        [cell setButtonBlock:^(UIButton *btn) {
            
            if (btn.tag) {
                
                [self.tableView setEditing:!self.tableView.editing animated:YES];
                
                if (self.tableView.editing) {
                    
                    weakSelf.editorLable.text = @"完成";
                    
                } else {
                
                    weakSelf.editorLable.text = @"编辑";
                
                }
                
                [self.tableView reloadData];
                
                NSIndexSet *set = [NSIndexSet indexSetWithIndex:0];
                
                [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
                
            } else {
            
                SportTrajectoryViewController *controller = [[SportTrajectoryViewController alloc] init];
                
                [self.navigationController presentViewController:controller animated:YES completion:nil];
            
            }
            
        }];
        
        return cell;
        
    } else {
        
        SportInformationModel *model = self.modelArray[indexPath.row];
    
        SportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SportTableViewCell"];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SportTableViewCell" owner:nil options:nil] lastObject];
            
        }
        
        cell.sportInformationModel = model;
        
        return cell;
    
    }
    
    return nil;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        
        SportInformationModel *model = self.modelArray[indexPath.row];
        
        if ([Common isObjectNull:model.x] || [Common isObjectNull:model.y]) {
            
            [self showToast:@"无轨迹线路可查看"];
            
            return;
            
        }
        
        SportTrajectoryLookViewController *controller = [[SportTrajectoryLookViewController alloc] init];
        
        controller.sportInformationModel = model;
        
        [self.navigationController presentViewController:controller animated:YES completion:nil];
        
    }

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
