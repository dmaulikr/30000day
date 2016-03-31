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
#import "CommodityCommentViewController.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import "ShopModel.h"


#define SECTIONSCOUNT 5


@interface ShopDetailViewController () <UITableViewDataSource,UITableViewDelegate,MTImagePlayerViewDelegate,MWPhotoBrowserDelegate>

@property (nonatomic,strong) ShopDetailModel *shopDetailModel;
@property (nonatomic,strong) NSArray *sourceArray;
@property (nonatomic,strong) NSMutableArray *photos;
@property (nonatomic,strong) NSArray *commitPhotos;
@property (nonatomic,strong) CommentModel *commentModel;
@property (nonatomic,strong) NSArray *shopModelKeeperArray;   //店长推荐
@property (nonatomic,strong) NSArray *shopModelTerraceArray;  //平台推荐

@end

@implementation ShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableViewStyle = STRefreshTableViewGroup;

    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
    self.isShowBackItem = YES;
    
    self.isShowFootRefresh = NO;
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource  = self;
    
    [self showHUD:YES];
    [self.dataHandler sendCompanyDetailsWithProductId:@"8" Success:^(ShopDetailModel *model) {
        
        if (model.productPhotos != nil) {
            
            self.sourceArray = [model.productPhotos componentsSeparatedByString:@","];
            
        }
        
        self.title = model.productName;
        self.shopDetailModel = model;
        
        //model.productTypePid
        [self.dataHandler sendShopOwnerRecommendWithCompanyId:@"2" count:3 Success:^(NSMutableArray *success) {
            
            self.shopModelKeeperArray = [NSArray arrayWithArray:success];
            [self.tableView reloadData];
            
        } failure:^(NSError *error) {
            
            NSLog(@"获取店长推荐失败");
            
        }];
        
        
        [self.dataHandler sendPlatformRecommendWithProductTypeId:@"6" count:3 Success:^(NSMutableArray *success) {
            
            self.shopModelTerraceArray = [NSArray arrayWithArray:success];
            [self.tableView reloadData];
            
        } failure:^(NSError *error) {
            
            NSLog(@"获取平台推荐失败");
            
        }];
        
        [self.dataHandler sendsaveCommentWithDefaultShowCount:1 Success:^(NSMutableArray *success) {
            
            [self hideHUD:YES];
            
            if (success > 0) {
                
                self.commentModel = success[0];
                self.commitPhotos = [self.commentModel.commentPhotos componentsSeparatedByString:@","];
                [self.tableView reloadData];
                
            }
            
        } failure:^(NSError *error) {
            
            [self hideHUD:YES];
            
        }];
        
        
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
        
        if (self.shopModelKeeperArray.count == 0 || self.shopModelKeeperArray == nil) {
            
            return 0;
            
        } else {
        
            return self.shopModelKeeperArray.count + 2;
        }
        
    } else if (section == 3) {
        
        return 3;
        
    } else if (section == 4) {
        
        if (self.shopModelTerraceArray.count == 0 || self.shopModelTerraceArray == nil) {
            
            return 0;
            
        } else {
            
            return self.shopModelTerraceArray.count + 2;
        }
        
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return 355;
        
    } else if (indexPath.section == 1) {
        
        return 44;
        
    } else if (indexPath.section == 2) {
        
        
        if (self.shopModelKeeperArray == nil || self.shopModelKeeperArray.count == 0) {
            
            return 0;
            
        } else if (indexPath.row != 0 && indexPath.row != self.shopModelKeeperArray.count + 1) {
            
            return 110;
            
        }
        
    } else if (indexPath.section == 3) {
        
        if (indexPath.row == 1) {
            
            return 228 + [Common heightWithText:self.commentModel.remark width:[UIScreen mainScreen].bounds.size.width fontSize:15.0];
            
        }
        
    } else if (indexPath.section == 4) {
        
        if (self.shopModelKeeperArray == nil || self.shopModelKeeperArray.count == 0) {
            
            return 0;
            
        } else if (indexPath.row != 0 && indexPath.row != self.shopModelKeeperArray.count + 1) {
            
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
        
        [shopDetailHeadTableViewCell.rollImageView setMTImagePlayerViewDelegate:self];
        shopDetailHeadTableViewCell.rollImageView.sourceArray = self.sourceArray;
        shopDetailHeadTableViewCell.shopDetailModel = self.shopDetailModel;
        
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
            
            shopDetailOneLineDataNoImageViewTableViewCell.textLabel.text = @"店长推荐（321）";
            
            [shopDetailOneLineDataNoImageViewTableViewCell setAccessoryType:UITableViewCellAccessoryNone];
            
            return shopDetailOneLineDataNoImageViewTableViewCell;
            
        } else if (indexPath.row == self.shopModelKeeperArray.count + 1) {
            
            shopDetailOneLineDataNoImageViewTableViewCell.textLabel.text = @"全部推荐";
            
            return shopDetailOneLineDataNoImageViewTableViewCell;
            
        } else {
            
            ShopModel *shopModel = self.shopModelKeeperArray[indexPath.row - 1];
            
            ShopListTableViewCell *shopListTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopListTableViewCell"];
            
            if (shopListTableViewCell == nil) {
                
                shopListTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopListTableViewCell" owner:nil options:nil] lastObject];
            }
            
            shopListTableViewCell.shopModel = shopModel;
            
            return shopListTableViewCell;

            
        }
        
        
    } else if (indexPath.section == 3) {
        
        if (indexPath.row == 0) {
            
            ShopDetailOneLineDataNoImageViewTableViewCell *shopDetailOneLineDataNoImageViewTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailOneLineDataNoImageViewTableViewCell"];
            
            if (shopDetailOneLineDataNoImageViewTableViewCell == nil) {
                
                shopDetailOneLineDataNoImageViewTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailOneLineDataNoImageViewTableViewCell" owner:nil options:nil] lastObject];
                
            }
            [shopDetailOneLineDataNoImageViewTableViewCell setAccessoryType:UITableViewCellAccessoryNone];
            
            shopDetailOneLineDataNoImageViewTableViewCell.textLabel.text = @"网友点评（321）";
            
            return shopDetailOneLineDataNoImageViewTableViewCell;
            
        } else if (indexPath.row == 1){
            
            ShopDetailCommentTableViewCell *shopDetailCommentTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailCommentTableViewCell"];
            
            if (shopDetailCommentTableViewCell == nil) {
                
                shopDetailCommentTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailCommentTableViewCell" owner:nil options:nil] lastObject];
                
            }
            
            shopDetailCommentTableViewCell.checkReply.hidden = YES;
            shopDetailCommentTableViewCell.commentZambiaButton.hidden = YES;
            shopDetailCommentTableViewCell.commentButton.hidden = YES;
            shopDetailCommentTableViewCell.commentModel = self.commentModel;
            shopDetailCommentTableViewCell.commentPhotosArray = self.commitPhotos;
            
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
            
            shopDetailOneLineDataNoImageViewTableViewCell.textLabel.text = @"推荐列表（321）";
            
            [shopDetailOneLineDataNoImageViewTableViewCell setAccessoryType:UITableViewCellAccessoryNone];
            
            return shopDetailOneLineDataNoImageViewTableViewCell;
            
        } else if (indexPath.row == self.shopModelTerraceArray.count + 1) {
            
            shopDetailOneLineDataNoImageViewTableViewCell.textLabel.text = @"全部推荐";
            
            return shopDetailOneLineDataNoImageViewTableViewCell;
            
        } else {
            
            ShopModel *shopModel = self.shopModelTerraceArray[indexPath.row - 1];
            
            ShopListTableViewCell *shopListTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopListTableViewCell"];
            
            if (shopListTableViewCell == nil) {
                
                shopListTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopListTableViewCell" owner:nil options:nil] lastObject];
            }
            
            shopListTableViewCell.shopModel = shopModel;
            
            return shopListTableViewCell;
            
            
        }
        
        return shopDetailOneLineDataNoImageViewTableViewCell;
        
    }
    
    
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 3) {
        
        if (indexPath.row != 0) {
            
            CommentViewController *controller = [[CommentViewController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
            
        } else {
            
            CommodityCommentViewController *commodityCommentViewController = [[CommodityCommentViewController alloc] init];
            commodityCommentViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:commodityCommentViewController animated:YES];
        
        }
        
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)imagePlayerView:(MTImagePlayView *)imagePlayerView didTapAtIndex:(NSInteger)index {

    self.photos = [[NSMutableArray alloc] init];

    for (int i = 0; i < self.sourceArray.count; i++) {
        
        MWPhoto *photo = [[MWPhoto alloc] initWithURL:[NSURL URLWithString:self.sourceArray[i]]];
        [self.photos addObject:photo];
        
    }
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    [browser setCurrentPhotoIndex:index];
    [self.navigationController pushViewController:browser animated:NO];

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
