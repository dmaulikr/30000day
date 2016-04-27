//
//  ShopDetailViewController.m
//  30000day
//
//  Created by GuoJia on 16/3/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ShopDetailViewController.h"
#import "ShopDetailTableViewCell.h"
#import "ShopListTableViewCell.h"
#import "ShopDetailCommentTableViewCell.h"
#import "CommentViewController.h"
#import "AppointmentViewController.h"
#import "ShopDetailModel.h"
#import "CommodityCommentViewController.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import "ShopModel.h"
#import "CompanyViewController.h"
#import "ShopDetailMapViewController.h"
#import "CDChatVC.h"
#import "CDIMService.h"
#import "MTProgressHUD.h"
#import "InformationCommentModel.h"
#import "CommentModel.h"
#import "DiscountCouponViewController.h"

#define SECTIONSCOUNT 6


@interface ShopDetailViewController () <UITableViewDataSource,UITableViewDelegate,MTImagePlayerViewDelegate,MWPhotoBrowserDelegate>

@property (nonatomic,strong) ShopDetailModel *shopDetailModel;
@property (nonatomic,strong) NSArray *sourceArray;
@property (nonatomic,strong) NSMutableArray *photos;
@property (nonatomic,strong) NSMutableArray  *commentArray;//评论列表
@property (nonatomic,strong) NSArray *shopModelKeeperArray;   //店长推荐
@property (nonatomic,strong) NSArray *shopModelTerraceArray;  //平台推荐
@property (nonatomic,strong) UserInformationModel *ownerInformationModel;//店主的个人信息

@end

@implementation ShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableViewStyle = STRefreshTableViewGroup;

    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT  - 50);
    
    self.isShowBackItem = YES;
    
    [self showHeadRefresh:YES showFooterRefresh:NO];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource  = self;
    //添加预约按钮
    [Common addAppointmentBackgroundView:self.view title:@"前往预约" selector:@selector(appointmentAction) controller:self];
    
    [self loadDetailData];
 }

//下载详细数据
- (void)loadDetailData {
    
    [self.dataHandler sendCompanyDetailsWithProductId:self.productId Success:^(ShopDetailModel *model) {
        
        if (model.productPhotos != nil) {
            
            self.sourceArray = [model.productPhotos componentsSeparatedByString:@","];
            
        }
        
        self.title = model.productName;
        
        self.shopDetailModel = model;
        //店长推荐
        [self.dataHandler sendShopOwnerRecommendWithCompanyId:model.companyId count:3 Success:^(NSMutableArray *success) {
            
            self.shopModelKeeperArray = [NSArray arrayWithArray:success];
            
            [self.tableView reloadData];
            
            [self.tableView.mj_header endRefreshing];
            
        } failure:^(NSError *error) {
            
            [self.tableView.mj_header endRefreshing];
            
        }];
        
        //平台推荐
        [self.dataHandler sendPlatformRecommendWithProductTypeId:model.productTypePid count:3 Success:^(NSMutableArray *success) {
            
            self.shopModelTerraceArray = [NSArray arrayWithArray:success];
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
            
        } failure:^(NSError *error) {
            
            [self.tableView.mj_header endRefreshing];
            
        }];
        //商品详情评论
        [self.dataHandler sendDefaultCommentWithBusiId:[NSNumber numberWithInteger:[self.productId integerValue]] Success:^(NSMutableArray *success) {
           
            self.commentArray = success;
            
            [self.tableView.mj_header endRefreshing];
            
            [self.tableView reloadData];
            
        } failure:^(NSError *error) {
            
            [self.tableView.mj_header endRefreshing];
        }];
        
        //下载店主的个人信息
        [self.dataHandler sendUserInformtionWithUserId:self.shopDetailModel.ownerId success:^(UserInformationModel *model) {
           
            self.ownerInformationModel = model;
            
        } failure:^(NSError *error) {
            
        }];
        
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)appointmentAction {
    
    AppointmentViewController *controller = [[AppointmentViewController alloc] init];
    
    controller.hidesBottomBarWhenPushed = YES;
    
    controller.productId = [NSNumber numberWithLongLong:[self.productId longLongValue]];
    
    controller.productName = self.shopDetailModel.productName;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma ---
#pragma mark --- 上啦刷新和下拉刷新

- (void)headerRefreshing {
    
    [self loadDetailData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return SECTIONSCOUNT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
        
    } else if (section == 1) {
        
        return 3;
        
    } else if (section == 2) {
        
        return self.shopDetailModel.activityList.count;
        
    } else if (section == 3) {
        
        if (self.shopModelKeeperArray.count == 0) {
            
            return 0;
            
        } else {
        
            return self.shopModelKeeperArray.count + 2;
        }
        
    } else if (section == 4) {
        
        if (self.commentArray.count) {
            
            return self.commentArray.count + 2;
            
        } else {
            
            return 0;
        }
        
    } else if (section == 5) {
        
        if (self.shopModelTerraceArray.count == 0) {
            
            return 0;
            
        } else {
            
            return self.shopModelTerraceArray.count + 1;
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
        
        return 44;
        
    } else if (indexPath.section == 3) {

        if ( self.shopModelKeeperArray.count == 0) {
            
            return 0;
            
        } else if (indexPath.row != 0 && indexPath.row != self.shopModelKeeperArray.count + 1) {
            
            return 86.0f;
            
        }
        
    } else if (indexPath.section == 4) {
        
        if (indexPath.row == 0) {
            
            return 44.0f;
            
        } else if (indexPath.row == self.commentArray.count) {
            
            CommentModel *model = self.commentArray[indexPath.row - 1];
            
            if (![Common isObjectNull:model.commentPhotos]) {//不为空
                
                return 95 + ((SCREEN_WIDTH - 58) / 3) + [Common heightWithText:model.remark width:SCREEN_WIDTH fontSize:15.0];
                
            } else {
                
                return 75 + [Common heightWithText:model.remark width:SCREEN_WIDTH fontSize:15.0];
                
            }
            
            return 228 + [Common heightWithText:model.remark width:SCREEN_WIDTH fontSize:15.0];
            
            
        } else {
            
            
            return 44.0f;
            
        }
        
    } else if (indexPath.section == 5) {
        
        if (self.shopModelKeeperArray.count == 0) {
            
            return 0;
            
        } else if (indexPath.row != 0 && indexPath.row != self.shopModelKeeperArray.count + 1) {
            
            return 110;
            
        }
    }
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 5) {
        
        return 0.5f;
        
    }
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.5f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        ShopDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailTableViewCell"];
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailTableViewCell" owner:nil options:nil] firstObject];
        }
        
        [cell.rollImageView setMTImagePlayerViewDelegate:self];
        
        cell.rollImageView.sourceArray = self.sourceArray;
        
        cell.shopDetailModel = self.shopDetailModel;
        
        return cell;
    
    } else if (indexPath.section == 1) {
        
        ShopDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailOneLineDataTableViewCell"];
        
        if (cell == nil) {
            
            cell = [[NSBundle mainBundle] loadNibNamed:@"ShopDetailTableViewCell" owner:nil options:nil][1];
        }
        
        if (indexPath.row == 0) {
            
            cell.leftTitleLable.text = self.shopDetailModel.address == nil || [self.shopDetailModel.address isEqualToString:@""] ? @"地址不详":self.shopDetailModel.address;
            [cell.leftImageView setImage:[UIImage imageNamed:@"icon_location"]];
            
        } else if (indexPath.row == 1){
            
            cell.leftTitleLable.text = self.shopDetailModel.telephone;
            [cell.leftImageView setImage:[UIImage imageNamed:@"icon_phone"]];
            
        } else if (indexPath.row == 2) {
            
            cell.leftTitleLable.text = @"联系商家";
            [cell.leftImageView setImage:[UIImage imageNamed:@"shortMessage"]];
        }
        
        return cell;
        
    } else if (indexPath.section == 2){
        
        ShopDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailOneLineDataTableViewCell"];
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailTableViewCell" owner:nil options:nil] lastObject];
        }
        
        cell.activityModel = self.shopDetailModel.activityList[indexPath.row];
        
        return cell;
        
    } else if (indexPath.section == 3) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        }
        
        if (indexPath.row == 0) {
            
            cell.textLabel.text = @"店长推荐";
            
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
            
        } else if (indexPath.row == self.shopModelKeeperArray.count + 1) {
            
            cell.textLabel.text = @"查看店铺";
            
            return cell;
            
        } else {
    
            ShopListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopListTableViewCell"];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ShopListTableViewCell" owner:nil options:nil] lastObject];
            }
            
            cell.shopModel = self.shopModelKeeperArray[indexPath.row - 1];
            
            return cell;
        }

    } else if (indexPath.section == 4) {
        
        if (indexPath.row == 0) {
  
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            
            if (cell == nil) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
            }
            
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.textLabel.text = @"网友点评";
            
            return cell;
            
        } else if (indexPath.row == self.commentArray.count){
            
            ShopDetailCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailCommentTableViewCell"];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailCommentTableViewCell" owner:nil options:nil] lastObject];
                
            }
            
            cell.isHideBelowView = YES;
            
            cell.informationCommentModel = self.commentArray[indexPath.row - 1];
            
            return cell;
            
        } else {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            
            if (cell == nil) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
            }
            
            cell.textLabel.text = @"查看全部评论";
            
            return cell;
        }
        
    } else if (indexPath.section == 5) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        }
        
        if (indexPath.row == 0) {
            
            cell.textLabel.text = @"推荐列表";
            
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            
        } else if (indexPath.row == self.shopModelTerraceArray.count + 1) {
            
            cell.textLabel.text = @"全部推荐";
            
        } else {
            
            ShopListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopListTableViewCell"];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ShopListTableViewCell" owner:nil options:nil] lastObject];
            }
            
            cell.shopModel = self.shopModelTerraceArray[indexPath.row - 1];
        }
        
        return cell;
    }
    
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {//查看商家地址
      
        if (indexPath.row == 0) {
            
            ShopDetailMapViewController *controller = [[ShopDetailMapViewController alloc] init];
            
            controller.hidesBottomBarWhenPushed = YES;
            
            controller.detailModel = self.shopDetailModel;
            
            [self.navigationController pushViewController:controller animated:YES];
            
        } else if (indexPath.row == 1 ){//拨打商家的热线电话
 
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"确定拨打%@?",self.shopDetailModel.telephone] message:@"该电话为商家联系电话" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.shopDetailModel.telephone]]];
                
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            [controller addAction:action];
            
            [controller addAction:cancelAction];
            
            [self presentViewController:controller animated:YES completion:nil];
            
        } else if (indexPath.row == 2) {//开启与商家聊天之旅
            
            if ([Common isObjectNull:self.ownerInformationModel]) {//空
                
                [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
                
                [self.dataHandler sendUserInformtionWithUserId:self.shopDetailModel.ownerId success:^(UserInformationModel *model) {
                    
                    [[CDChatManager manager] fetchConversationWithOtherId:[NSString stringWithFormat:@"%@",self.shopDetailModel.ownerId] attributes:[UserInformationModel attributesDictionay:model userProfile:STUserAccountHandler.userProfile] callback:^(AVIMConversation *conversation, NSError *error) {
                        
                        if (!error) {
                            
                            [[CDIMService service] pushToChatRoomByConversation:conversation fromNavigationController:self.navigationController];
                        }
                    }];
                    
                    [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                    
                } failure:^(NSError *error) {
                    
                    [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                    
                }];

            } else {//非空
                
                [[CDChatManager manager] fetchConversationWithOtherId:[NSString stringWithFormat:@"%@",self.shopDetailModel.ownerId] attributes:[UserInformationModel attributesDictionay:self.ownerInformationModel userProfile:STUserAccountHandler.userProfile] callback:^(AVIMConversation *conversation, NSError *error) {
                  
                    if (!error) {
                        
                        [[CDIMService service] pushToChatRoomByConversation:conversation fromNavigationController:self.navigationController];
                    }
                }];
            }

        }
        
    } else if (indexPath.section == 2) {
        
        ActivityModel *model = self.shopDetailModel.activityList[indexPath.row];
        
        if ([model.activityType isEqualToString:@"02"]) {
            
            DiscountCouponViewController *controller = [[DiscountCouponViewController alloc] init];
            
            [self.navigationController pushViewController:controller animated:YES];
        }
    
    } else if (indexPath.section == 3) {
        
        if (indexPath.row == self.shopModelKeeperArray.count + 1) {
            
            CompanyViewController *companyViewController = [[CompanyViewController alloc] init];
            
            companyViewController.productId = self.productId;
            
            [self.navigationController pushViewController:companyViewController animated:YES];
        }
        
        if (indexPath.row != 0 && indexPath.row != self.shopModelKeeperArray.count + 1) {
            
            ShopModel *shopModel = self.shopModelKeeperArray[indexPath.row - 1];
            
            ShopDetailViewController *shopDetailViewController = [[ShopDetailViewController alloc] init];
            
            shopDetailViewController.productId = [NSString stringWithFormat:@"%d",shopModel.productId.intValue];
            
            [self.navigationController pushViewController:shopDetailViewController animated:YES];
            
        }
        
    } else if (indexPath.section == 4) {
        
        if (indexPath.row != 0) {
            
            CommentViewController *controller = [[CommentViewController alloc] init];
            
            controller.hidesBottomBarWhenPushed = YES;
            
            controller.productId = self.productId.integerValue;
            
            [self.navigationController pushViewController:controller animated:YES];
            
        } else {
            
            CommodityCommentViewController *commodityCommentViewController = [[CommodityCommentViewController alloc] init];
            
            commodityCommentViewController.productId = self.productId;
            
            commodityCommentViewController.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:commodityCommentViewController animated:YES];
        
        }
        
    } else if (indexPath.section == 5) {
    
        if (indexPath.row != 0 && indexPath.row != self.shopModelKeeperArray.count + 1) {
            
            ShopDetailViewController *shopDetailViewController = [[ShopDetailViewController alloc] init];
            
            [self.navigationController pushViewController:shopDetailViewController animated:YES];
            
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
