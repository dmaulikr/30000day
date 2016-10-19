//
//  InformationWriterHomepageViewController.m
//  30000day
//
//  Created by wei on 16/4/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "InformationWriterHomepageViewController.h"
#import "InformationModel.h"
#import "MTProgressHUD.h"
#import "InformationWriterHeadTableViewCell.h"
#import "InformationListTableViewCell.h"
#import "InformationDetailWebViewController.h"

@interface InformationWriterHomepageViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) InformationWriterModel *informationWriterModel;

@property (nonatomic,strong) NSMutableArray *informationModelArray;

@property (nonatomic,assign) NSInteger isSubscription;

@end

@implementation InformationWriterHomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableViewStyle = STRefreshTableViewGroup;
    
    [self.tableView setDataSource:self];
    
    [self.tableView setDelegate:self];
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [self showHeadRefresh:NO showFooterRefresh:YES];
    
    self.isShowBackItem = YES;

    [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
    [STDataHandler senSearchWriterInfomationsWithWriterId:self.writerId userId:[NSString stringWithFormat:@"%d",STUserAccountHandler.userProfile.userId.intValue] success:^(InformationWriterModel *success) {
        
        self.informationWriterModel = success;
        
        self.isSubscription = success.subscribeCount;
        
        NSMutableArray *array = [NSMutableArray array];
        
        for (int i = 0; i < success.infomationList.count; i++) {
            
            NSDictionary * dataDictionary = success.infomationList[i];
    
            InformationModel *informationModel = [[InformationModel alloc] init];
    
            [informationModel setValuesForKeysWithDictionary:dataDictionary];
            
            [array addObject:informationModel];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            self.title = success.writerName;
        
            [self.tableView reloadData];
            
            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
            
        });
        
        self.informationModelArray = [NSMutableArray arrayWithArray:array];
        
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        
        });

    }];
}

#pragma mark --- 上啦刷新和下拉刷新

- (void)footerRereshing {
    
    [self.tableView.mj_footer endRefreshing];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if (self.informationWriterModel == nil) {
        
        return 0;
        
    }
    
    return 2;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        
        return 1;
        
    }
    
    return self.informationModelArray.count;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        
        return 0.0001;
        
    }
    
    return 10;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 0.0001;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
       CGFloat textHeight = [Common heightWithText:self.informationWriterModel.writerDescription width:[UIScreen mainScreen].bounds.size.width - 16 fontSize:14.0];
        
        return 162 + 20 + textHeight;
        
    }
    
    return 72.1f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        InformationWriterHeadTableViewCell *informationWriterHeadTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"InformationWriterHeadTableViewCell"];
        
        if (informationWriterHeadTableViewCell == nil) {
            
            informationWriterHeadTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"InformationWriterHeadTableViewCell" owner:nil options:nil] lastObject];
            
        }
        
        informationWriterHeadTableViewCell.informationWriterModel = self.informationWriterModel;
        
        __weak typeof(informationWriterHeadTableViewCell) weakCell = informationWriterHeadTableViewCell;
        
        [informationWriterHeadTableViewCell setSubscriptionButtonBlock:^(UIButton *button) {
           
            if (button.tag) {
                
                [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
                
                [STDataHandler sendCancelSubscribeWriterId:self.writerId userId:[NSString stringWithFormat:@"%d",STUserAccountHandler.userProfile.userId.intValue] success:^(BOOL success) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                    
                        if (success) {
                            
                            [button setTitle:@"订阅" forState:UIControlStateNormal];
                            button.tag = 0;
                            
                            self.isSubscription = self.isSubscription - 1;
                            
                            weakCell.subscriptionCountLable.text = [NSString stringWithFormat:@"%d人已订阅",(int)self.isSubscription];
                            
                            [STNotificationCenter postNotificationName:STDidSuccessCancelSubscribeSendNotification object:NSStringFromClass([self class])];
                            
                        }
                        
                        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                    
                    });
                    
                } failure:^(NSError *error) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                    
                        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                        
                    });
                }];

                
            } else {
            
                [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
                [STDataHandler sendSubscribeWithWriterId:self.writerId userId:[NSString stringWithFormat:@"%d",STUserAccountHandler.userProfile.userId.intValue] success:^(BOOL success) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                    
                        if (success) {
                            
                            [button setTitle:@"取消订阅" forState:UIControlStateNormal];
                            button.tag = 1;
                            
                            self.isSubscription = self.isSubscription + 1;
                            
                            weakCell.subscriptionCountLable.text = [NSString stringWithFormat:@"%d人已订阅",(int)self.isSubscription];
                            
                            [STNotificationCenter postNotificationName:STDidSuccessSubscribeSendNotification object:NSStringFromClass([self class])];
                            
                        }
                        
                        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];

                    
                    });
                    
                    
                } failure:^(NSError *error) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                    
                    });
                    
                }];

            
            }
            
        }];
        
        return informationWriterHeadTableViewCell;

        
    } else {
    
        InformationModel *informationModel = self.informationModelArray[indexPath.row];
    
        InformationListTableViewCell *informationListTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"InformationListTableViewCell"];
        
        if (informationListTableViewCell == nil) {
            
            informationListTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"InformationListTableViewCell" owner:nil options:nil] lastObject];
            
        }
        
        informationListTableViewCell.informationModel = informationModel;
        
        return informationListTableViewCell;
    
    }
    
    return nil;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section != 0) {
        
        InformationModel *informationModel = self.informationModelArray[indexPath.row];
        InformationDetailWebViewController *controller = [[InformationDetailWebViewController alloc] init];
        controller.infoId = informationModel.informationId;
        [self.navigationController pushViewController:controller animated:YES];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

@end
