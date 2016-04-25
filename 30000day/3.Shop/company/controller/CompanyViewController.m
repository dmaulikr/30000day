//
//  CompanyViewController.m
//  30000day
//
//  Created by wei on 16/3/31.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "CompanyViewController.h"
#import "ShopHeadTableViewCell.h"
#import "ShopOneLineDataTableViewCell.h"
#import "ShopTitleTableViewCell.h"
#import "ProductTypeModel.h"
#import "UIImageView+WebCache.h"
#import "CompanyCommodityViewController.h"
#import "ShopModel.h"
#import "ShopListTableViewCell.h"
#import "ShopDetailViewController.h"
#import "HeaderView.h"
#import "MTProgressHUD.h"

@interface CompanyViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) CompanyModel *companyModel;
@property (nonatomic,strong) NSArray *productTypeModelArray;
@property (nonatomic,strong) NSMutableArray *selectedArr;
@property (nonatomic,strong) NSMutableArray *shopModelArray;
@property (nonatomic,assign) NSInteger selectSection;

@end

@implementation CompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableViewStyle = STRefreshTableViewGroup;
    
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
    self.isShowBackItem = YES;
    
    self.isShowFootRefresh = NO;
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource  = self;
    
    [self.dataHandler sendfindCompanyInfoByIdWithCompanyId:@"2" Success:^(CompanyModel *success) {
        
        self.title = success.companyName;
        
        self.companyModel = success;
        
        NSMutableArray *array = [NSMutableArray array];
        
        for (int i = 0; i < success.productTypeList.count; i++) {
            
            NSDictionary * dataDictionary = success.productTypeList[i];
            
            ProductTypeModel *productTypeModel = [[ProductTypeModel alloc] init];
            
            [productTypeModel setValuesForKeysWithDictionary:dataDictionary];
 
            [array addObject:productTypeModel];
        }
        
        self.productTypeModelArray = [NSArray arrayWithArray:array];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        
        
    }];

    
    self.selectedArr = [NSMutableArray array];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- 上啦刷新和下拉刷新

- (void)headerRefreshing {
    
    [self.tableView.mj_header endRefreshing];
}

- (void)footerRereshing {
    
    [self.tableView.mj_footer endRefreshing];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4 + self.productTypeModelArray.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
        
    } else if (section == 1) {
        
        return 2;
        
    } else if (section == 2) {
        
        return 1;
        
    } else if (section == 4 + self.productTypeModelArray.count - 1) {
        
        return 1;
        
    } else if (self.selectSection != 0 && self.selectSection == section) {
    
        return self.shopModelArray.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return 355;
        
    } else if (indexPath.section > 2 && indexPath.section < 4 + self.productTypeModelArray.count - 1) {
        
        return 86.0f;
        
    }
    
    return 44;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 4 + self.productTypeModelArray.count - 1) {
        
        return 0.5f;
        
    } else if (section > 1 && section < 4 + self.productTypeModelArray.count - 2) {
        
        return 0.001f;
    
    }
    
    return 10.f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section > 2 && section < 4 + self.productTypeModelArray.count - 1) {
        
        return 44;
        
    }
    
    return 0.5f;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (section > 2 && section < 4 + self.productTypeModelArray.count - 1) {
        
        ProductTypeModel *productTypeModel = self.productTypeModelArray[section - 3];
    
        HeaderView *headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        headerView.productTypeName = productTypeModel.name;
        headerView.section = section;
        headerView.selectedArr = self.selectedArr;
        
        
        [headerView setChangeStateBlock:^(UIButton *button) {
           
            NSString *string = [NSString stringWithFormat:@"%ld",button.tag - 10000];
            
            if ([self.selectedArr containsObject:string]){
                
                [self.selectedArr removeObject:string];
                [self.shopModelArray removeAllObjects];
                [self.tableView reloadData];
                
            }else{
                
                [self.selectedArr removeAllObjects];
                self.selectSection = button.tag - 10000;
                [self.selectedArr addObject:string];
                [self loadShopList];
                
            }
            
        }];
        
        [headerView loadView];
        
        return headerView;
        
    }
    
    return nil;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        ShopHeadTableViewCell *shopHeadTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopHeadTableViewCell"];
        
        if (shopHeadTableViewCell == nil) {
            
            shopHeadTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopHeadTableViewCell" owner:nil options:nil] lastObject];
        }
        
        [shopHeadTableViewCell.headImageView sd_setImageWithURL:[NSURL URLWithString:self.companyModel.placePhoto]];
        shopHeadTableViewCell.storeNameLable.text = self.companyModel.companyName;
        shopHeadTableViewCell.keywordLable.text = self.companyModel.alias;
        shopHeadTableViewCell.businessHoursLable.text = self.companyModel.businessTime;
        
        return shopHeadTableViewCell;
        
        
    } else if (indexPath.section == 1) {
        
        ShopOneLineDataTableViewCell *shopOneLineDataTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopOneLineDataTableViewCell"];
        
        if (shopOneLineDataTableViewCell == nil) {
            
            shopOneLineDataTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopOneLineDataTableViewCell" owner:nil options:nil] lastObject];
            
        }
        
        if (indexPath.row == 0) {
            
            shopOneLineDataTableViewCell.leftTitleLable.text = self.companyModel.address;
            [shopOneLineDataTableViewCell.leftImageView setImage:[UIImage imageNamed:@"icon_location"]];
            
        } else if (indexPath.row == 1){
            
            shopOneLineDataTableViewCell.leftTitleLable.text = self.companyModel.telephone;
            [shopOneLineDataTableViewCell.leftImageView setImage:[UIImage imageNamed:@"icon_phone"]];
        }
        
        return shopOneLineDataTableViewCell;
        
        
    } else if (indexPath.section == 2) {
        
        ShopTitleTableViewCell *shopTitleTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopTitleTableViewCell"];
        
        if (shopTitleTableViewCell == nil) {
            
            shopTitleTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopTitleTableViewCell" owner:nil options:nil] lastObject];
            
        }
            
        shopTitleTableViewCell.textLabel.text = @"商品类别";
            
        [shopTitleTableViewCell setAccessoryType:UITableViewCellAccessoryNone];

        return shopTitleTableViewCell;
        
        
    } else if (indexPath.section == 4 + self.productTypeModelArray.count - 1) {
        
        ShopTitleTableViewCell *shopTitleTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopTitleTableViewCell"];
        
        if (shopTitleTableViewCell == nil) {
            
            shopTitleTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopTitleTableViewCell" owner:nil options:nil] lastObject];
            
        }
        
        shopTitleTableViewCell.textLabel.text = @"商店信息";
        
        return shopTitleTableViewCell;
        
    } else {
    
        ShopListTableViewCell *shopListTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopListTableViewCell"];
        
        if (shopListTableViewCell == nil) {
            
            shopListTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopListTableViewCell" owner:nil options:nil] lastObject];
            
        }
        
        ShopModel *shopModel = self.shopModelArray[indexPath.row];
        
        shopListTableViewCell.shopModel = shopModel;
        
        return shopListTableViewCell;
    
    }
    
    return nil;
}

- (void)loadShopList {
    
    ProductTypeModel *productTypeModel = self.productTypeModelArray[self.selectSection - 3];
    
    [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
    [self.dataHandler sendFindProductsByIdsWithCompanyId:self.companyModel.companyId productTypeId:productTypeModel.productTypeId Success:^(NSMutableArray *success) {
        
        self.shopModelArray = [NSMutableArray arrayWithArray:success];
        
        [self.tableView reloadData];
        
        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        
    } failure:^(NSError *error) {
        
        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        
        [self.selectedArr removeAllObjects];
        
    }];

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section > 2 && indexPath.section < 4 + self.productTypeModelArray.count - 1) {
        
        ShopModel *model = self.shopModelArray[indexPath.row];
        
        ShopDetailViewController *shopDetailViewController = [[ShopDetailViewController alloc] init];
        
        shopDetailViewController.productId = [NSString stringWithFormat:@"%ld",model.productId.integerValue];
        
        [self.navigationController pushViewController:shopDetailViewController animated:YES];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




@end
