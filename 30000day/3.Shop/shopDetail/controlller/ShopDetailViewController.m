//
//  ShopDetailViewController.m
//  30000day
//
//  Created by GuoJia on 16/3/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ShopDetailViewController.h"
#import "ShopDetailHeadTableViewCell.h"
#import "ShopDetailOneLineDataTableViewCell.h"
#import "ShopListTableViewCell.h"
#import "ShopDetailCommentTableViewCell.h"
#import "ShopDetailOneLineDataNoImageViewTableViewCell.h"
#import "CommentViewController.h"
#import "AppointmentViewController.h"
#import "ShopDetailModel.h"
#import "Height.h"


#define SECTIONSCOUNT 5


@interface ShopDetailViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)ShopDetailModel *shopDetailModel;
@property (nonatomic,strong)NSArray *sourceArray;

@end

@implementation ShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:MM:ss"];
    
    NSDate *date = [formatter dateFromString:@"15601623118"];
    
    NSLog(@"date1:%@",date);
    
    
    self.tableViewStyle = STRefreshTableViewGroup;

    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
    self.isShowBackItem = YES;
    
    self.isShowFootRefresh = NO;
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource  = self;
    
    self.sourceArray = [NSArray arrayWithObjects:@"http://b.hiphotos.baidu.com/album/pic/item/caef76094b36acafe72d0e667cd98d1000e99c5f.jpg?psign=e72d0e667cd98d1001e93901213fb80e7aec54e737d1b867",@"http://pic1.nipic.com/2008-12-25/2008122510134038_2.jpg",@"http://atth.eduu.com/album/201203/12/1475134_1331559643qMzc.jpg",@"http://pic51.nipic.com/file/20141022/19779658_171157758000_2.jpg",@"http://h.hiphotos.baidu.com/image/pic/item/4034970a304e251f8ad847e7a586c9177f3e5385.jpg", nil];
    
    [self showHUD:YES];
    [self.dataHandler sendCompanyDetailsWithCompanyId:@"9" Success:^(ShopDetailModel *model) {
        
        [self hideHUD:YES];
        
        self.shopDetailModel = model;
        
        NSLog(@"%@",model.productTypePName);
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        [self hideHUD:YES];
        
    }];
    
    UIBarButtonItem *barButton =  [[UIBarButtonItem alloc] initWithTitle:@"预约" style:UIBarButtonItemStylePlain target:self action:@selector(appointmentAction)];
    
    self.navigationItem.rightBarButtonItem = barButton;
    
 }

- (void)appointmentAction {
    
    AppointmentViewController *controller = [[AppointmentViewController alloc] init];
    
    controller.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma ---
#pragma mark --- 上啦刷新和下拉刷新

- (void)headerRefreshing {
    
    [self.tableView.mj_header endRefreshing];
}

- (void)footerRereshing {
    
    [self.tableView.mj_footer endRefreshing];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SECTIONSCOUNT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
        
    } else if (section == 1) {
        
        return 2;
        
    } else if (section == 2) {
        
        return 4;
        
    } else if (section == 3) {
        
        return 4;
        
    } else if (section == 4) {
        
        return 4;
        
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return 355;
        
    } else if (indexPath.section == 1) {
        
        return 44;
        
    } else if (indexPath.section == 2) {
        
        if (indexPath.row == 1 || indexPath.row == 2){
            
            return 110;
            
        }
        
    } else if (indexPath.section == 3) {
        
        if (indexPath.row == 1 || indexPath.row == 2) {
            
            return 228 + [Height heightWithText:@"环境挺不错，装修也很考究，就是人太多了，需要排队，下次提前预约好了.好好好好好好好好好好好好好好好好好好好好好好好好好" width:[UIScreen mainScreen].bounds.size.width fontSize:15.0];
            
        }
        
    } else if (indexPath.section == 4) {
        
        if (indexPath.row == 1 || indexPath.row == 2) {
            return 110;
        }
        
    }
    
    return 44;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 4) {
        
        return 0.5f;
        
    }
    return 10.f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.5f;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        ShopDetailHeadTableViewCell *shopDetailHeadTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailHeadTableViewCell"];
        
        if (shopDetailHeadTableViewCell == nil) {
            
            shopDetailHeadTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailHeadTableViewCell" owner:nil options:nil] lastObject];
        }
        
        //[shopDetailHeadTableViewCell.rollImageView setMTImagePlayerViewDelegate:self];
        shopDetailHeadTableViewCell.rollImageView.sourceArray = self.sourceArray;
        shopDetailHeadTableViewCell.storeLable.text = self.shopDetailModel.productName;
        shopDetailHeadTableViewCell.positionLable.text = self.shopDetailModel.productKeyword;
        
        return shopDetailHeadTableViewCell;
        
        
    } else if (indexPath.section == 1) {
        
        ShopDetailOneLineDataTableViewCell *shopDetailOneLineDataTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailOneLineDataTableViewCell"];
        
        if (shopDetailOneLineDataTableViewCell == nil) {
            
            shopDetailOneLineDataTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailOneLineDataTableViewCell" owner:nil options:nil] lastObject];
            
        }
        
        if (indexPath.row == 0) {
            
            shopDetailOneLineDataTableViewCell.leftTitleLable.text = @"浦东小道888号科技大楼12楼";
            [shopDetailOneLineDataTableViewCell.leftImageView setImage:[UIImage imageNamed:@"icon_location"]];
            
        } else if (indexPath.row == 1){
            
            shopDetailOneLineDataTableViewCell.leftTitleLable.text = self.shopDetailModel.telephone;
            [shopDetailOneLineDataTableViewCell.leftImageView setImage:[UIImage imageNamed:@"icon_phone"]];
        }
        
        return shopDetailOneLineDataTableViewCell;
        
        
    } else if (indexPath.section == 2) {
        
        ShopDetailOneLineDataNoImageViewTableViewCell *shopDetailOneLineDataNoImageViewTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailOneLineDataNoImageViewTableViewCell"];
        
        if (shopDetailOneLineDataNoImageViewTableViewCell == nil) {
            
            shopDetailOneLineDataNoImageViewTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailOneLineDataNoImageViewTableViewCell" owner:nil options:nil] lastObject];
            
        }
        
        if (indexPath.row == 0) {
            
            shopDetailOneLineDataNoImageViewTableViewCell.textLabel.text = @"店长推存（321）";
            
        } else if (indexPath.row == 1 || indexPath.row == 2){
            
            ShopListTableViewCell *shopListTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopListTableViewCell"];
            
            if (shopListTableViewCell == nil) {
                
                shopListTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopListTableViewCell" owner:nil options:nil] lastObject];
            }
            
            return shopListTableViewCell;
            
        } else {
            
            shopDetailOneLineDataNoImageViewTableViewCell.textLabel.text = @"查看全部推存";
            
        }
        
        return shopDetailOneLineDataNoImageViewTableViewCell;
        
        
    } else if (indexPath.section == 3) {
        
        if (indexPath.row == 0) {
            
            ShopDetailOneLineDataNoImageViewTableViewCell *shopDetailOneLineDataNoImageViewTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailOneLineDataNoImageViewTableViewCell"];
            
            if (shopDetailOneLineDataNoImageViewTableViewCell == nil) {
                
                shopDetailOneLineDataNoImageViewTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailOneLineDataNoImageViewTableViewCell" owner:nil options:nil] lastObject];
                
            }
            
            shopDetailOneLineDataNoImageViewTableViewCell.textLabel.text = @"网友点评（321）";
            
            return shopDetailOneLineDataNoImageViewTableViewCell;
            
        } else if (indexPath.row == 1 || indexPath.row == 2){
            
            ShopDetailCommentTableViewCell *shopDetailCommentTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailCommentTableViewCell"];
            
            if (shopDetailCommentTableViewCell == nil) {
                
                shopDetailCommentTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailCommentTableViewCell" owner:nil options:nil] lastObject];
                
            }
            
            return shopDetailCommentTableViewCell;
            
        } else {
            
            ShopDetailOneLineDataNoImageViewTableViewCell *shopDetailOneLineDataNoImageViewTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailOneLineDataNoImageViewTableViewCell"];
            
            if (shopDetailOneLineDataNoImageViewTableViewCell == nil) {
                
                shopDetailOneLineDataNoImageViewTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailOneLineDataNoImageViewTableViewCell" owner:nil options:nil] lastObject];
                
            }
            
            shopDetailOneLineDataNoImageViewTableViewCell.textLabel.text = @"查看全部评论";
            
            return shopDetailOneLineDataNoImageViewTableViewCell;
            
        }
        
        
    } else if (indexPath.section == 4) {
        
        ShopDetailOneLineDataNoImageViewTableViewCell *shopDetailOneLineDataNoImageViewTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailOneLineDataNoImageViewTableViewCell"];
        
        if (shopDetailOneLineDataNoImageViewTableViewCell == nil) {
            
            shopDetailOneLineDataNoImageViewTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailOneLineDataNoImageViewTableViewCell" owner:nil options:nil] lastObject];
            
        }
        
        if (indexPath.row == 0) {
            
            shopDetailOneLineDataNoImageViewTableViewCell.textLabel.text = @"推存列表（321）";
            
        } else if (indexPath.row == 1 || indexPath.row == 2){
            
            ShopListTableViewCell *shopListTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopListTableViewCell"];
            
            if (shopListTableViewCell == nil) {
                
                shopListTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopListTableViewCell" owner:nil options:nil] lastObject];
            }
            
            return shopListTableViewCell;
            
        } else {
            
            shopDetailOneLineDataNoImageViewTableViewCell.textLabel.text = @"查看全部推存";
            
        }
        
        return shopDetailOneLineDataNoImageViewTableViewCell;
        
    }
    
    
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 3) {
        
        if (indexPath.row == 0 || indexPath.row == 3) {
            
            CommentViewController *controller = [[CommentViewController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
            
        }
        
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
