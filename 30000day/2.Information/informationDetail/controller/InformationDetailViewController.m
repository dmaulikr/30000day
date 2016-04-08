//
//  InformationDetailViewController.m
//  30000day
//
//  Created by GuoJia on 16/3/14.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "InformationDetailViewController.h"
#import "InformationTableViewCell.h"
#import "InformationDetailImageTableViewCell.h"
#import "InformationDetailDownTableViewCell.h"
#import "InformationDetailModel.h"
#import "MTProgressHUD.h"
#import "InformationCommentViewController.h"

#import "ReportViewController.h"
#import "ShareInformationView.h"
#import <MessageUI/MessageUI.h>
#import "ChineseString.h"
#import "UMSocial.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"

#import "MWPhoto.h"
#import "MWPhotoBrowser.h"

@interface InformationDetailViewController () <UITableViewDelegate,UITableViewDataSource,UMSocialUIDelegate,MWPhotoBrowserDelegate>

@property (nonatomic,strong) NSMutableArray *chineseStringArray;//该数组里面装的是chineseString这个模型

@property (nonatomic,strong) InformationDetailModel *informationDetailModel;

@property (nonatomic,strong) NSMutableArray *imageURLArray;

@property (nonatomic,strong) NSMutableArray *photos;

@end

@implementation InformationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";

    self.tableViewStyle = STRefreshTableViewGroup;
    
    self.isShowBackItem = YES;
    
    self.isShowFootRefresh = NO;
    
    self.isShowHeadRefresh = NO;
    
    self.tableView.frame = CGRectMake(0, 54, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_more"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(barButtonAction)];
    
    self.navigationItem.rightBarButtonItem = barButton;
    
    self.isShowInputView = YES;
    
    [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
    [self.dataHandler sendInfomationDetailWithInfoId:@"2" success:^(InformationDetailModel *informationDetailModel) {
    
        self.informationDetailModel = informationDetailModel;
        
        NSArray *array = [informationDetailModel.detailPhotos componentsSeparatedByString:@","];
        
        self.imageURLArray = [NSMutableArray arrayWithArray:array];
        
        [self.tableView reloadData];
        
        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        
        NSLog(@"%@",informationDetailModel);
        
    } failure:^(NSError *error) {
        
        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        
    }];
    
}

#pragma ---
#pragma mark --- 上啦刷新和下拉刷新

- (void)headerRefreshing {
    
    [self.tableView.mj_header endRefreshing];
}

- (void)footerRereshing {
    
    [self.tableView.mj_footer endRefreshing];
}

- (void)barButtonAction {
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *first_action = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        ReportViewController *controller = [[ReportViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        controller.success = YES;
        [self.navigationController pushViewController:controller animated:YES];
        
    }];
                                     
    UIAlertAction *second_action = [UIAlertAction actionWithTitle:@"转载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];
    
    UIAlertAction *third_action = [UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [controller addAction:first_action];
    
    [controller addAction:second_action];
    
    [controller addAction:third_action];
    
    [controller addAction:cancelAction];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma --
#pragma mark --- UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.informationDetailModel == nil) {
        
        return 0;
        
    }
    
    return self.imageURLArray.count + 2;
        
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.5f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        CGFloat height = [Common heightWithText:self.informationDetailModel.infoName width:SCREEN_WIDTH fontSize:16.0] + [Common heightWithText:self.informationDetailModel.infoContent width:SCREEN_WIDTH fontSize:15.0] + 70;
        
        return height;
        
    } else if (indexPath.row == self.imageURLArray.count + 1) {
    
        return 44;
    
    }
    
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        InformationTableViewCell *informationTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"InformationTableViewCell"];
        
        if (informationTableViewCell == nil) {
            
            informationTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"InformationTableViewCell" owner:nil options:nil] lastObject];
        }
        
        informationTableViewCell.informationDetailModel = self.informationDetailModel;
        
        return informationTableViewCell;
        
    } else if (indexPath.row == self.imageURLArray.count + 1) {
        
        InformationDetailDownTableViewCell *informationDetailDownTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"InformationDetailDownTableViewCell"];
        
        if (informationDetailDownTableViewCell == nil) {
            
            informationDetailDownTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"InformationDetailDownTableViewCell" owner:nil options:nil] lastObject];
        }
        
        [informationDetailDownTableViewCell setShareButtonBlock:^(UIButton *shareButton) {
            
            [self showShareAnimatonView];
            
        }];
        
        [informationDetailDownTableViewCell setCommentButtonBlock:^{
           
            InformationCommentViewController *informationCommentViewController = [[InformationCommentViewController alloc] init];
            informationCommentViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:informationCommentViewController animated:YES];
            
        }];
        
        return informationDetailDownTableViewCell;
        
    } else {
        
        InformationDetailImageTableViewCell *informationDetailImageTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"InformationDetailImageTableViewCell"];
        
        if (informationDetailImageTableViewCell == nil) {
            
            informationDetailImageTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"InformationDetailImageTableViewCell" owner:nil options:nil] lastObject];
        }
        
        informationDetailImageTableViewCell.imageViewURLString = self.imageURLArray[indexPath.row - 1];
        
        [informationDetailImageTableViewCell setLookPhoto:^(UIImageView *imageView) {
           
            self.photos = [NSMutableArray array];
            
            for (int i = 0; i < self.imageURLArray.count; i++) {
                
                MWPhoto *photo = [[MWPhoto alloc] initWithURL:[NSURL URLWithString:self.imageURLArray[i]]];
                [self.photos addObject:photo];
                
            }
            
            MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
            browser.displayActionButton = NO;
            [self.navigationController pushViewController:browser animated:NO];
            
        }];
        
        return informationDetailImageTableViewCell;

    }
    
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//显示分享界面
- (void)showShareAnimatonView {
    
    ShareInformationView *shareAnimationView = [[[NSBundle mainBundle] loadNibNamed:@"ShareInformationView" owner:self options:nil] lastObject];
    
    //封装的动画般推出视图
    [ShareInformationView animateWindowsAddSubView:shareAnimationView];
    
    //按钮点击回调
    [shareAnimationView setShareButtonBlock:^(NSInteger tag,ShareInformationView *animationView) {
        
        [ShareInformationView annimateRemoveFromSuperView:animationView];
        
        if (tag == 3) {
            
            [[UMSocialControllerService defaultControllerService] setShareText:@"我只是测试下分享" shareImage:[UIImage imageNamed:@"00"] socialUIDelegate:self];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            
        } else if (tag == 4) {
            
            [[UMSocialControllerService defaultControllerService] setShareText:@"测试QQ分享" shareImage:[UIImage imageNamed:@"IMG_1613"] socialUIDelegate:self];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            
        }
        
    }];
    
}

#pragma mark --- UMSocialUIDelegate

- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
    
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}


- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id )photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}


@end
