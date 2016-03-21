//
//  ShopTableViewController.m
//  30000day
//
//  Created by GuoJia on 16/1/28.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ShopViewController.h"
#import "DOPDropDownMenu.h"
#import "ShopListTableViewCell.h"
#import "ShopDetailViewController.h"
#import "SearchViewController.h"
#import "SearchViewController.h"
#import "CityViewController.h"
#import "ShopModel.h"
#import "STCoreDataHandler.h"
#import "SubwayModel.h"
#import "PlaceManager.h"

@interface ShopViewController () <DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftBarButton;

@property (nonatomic,assign) BOOL isShowMapView;

@property (nonatomic,strong) UISearchBar *searchBar;

@property (nonatomic,strong) NSMutableArray *subwayArray;

@property (nonatomic,strong) NSMutableArray *placeArray;

@property (nonatomic,strong) DOPDropDownMenu *menuView;

@end

@implementation ShopViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    //1.初始化UI
    [self configUI];
    
    [self configBusinessPlaceWithCityName:@"上海"];
    
    self.leftBarButton.title = @"上海";
    
    [self startFindLocationSucess:^(NSString *cityName) {
        
        [self configBusinessPlaceWithCityName:cityName];
        
        self.leftBarButton.title = cityName;
        
    } failure:^(NSError *error) {
        
        [self configBusinessPlaceWithCityName:@"上海"];
        
        self.leftBarButton.title = @"上海";
        
    }];
}

- (void)configBusinessPlaceWithCityName:(NSString *)cityName {
    
    //2.配置数据库
    PlaceManager *manager = [PlaceManager shareManager];
    
    [manager configManagerSuccess:^(BOOL success) {
        
        [manager countyArrayWithCityName:cityName success:^(NSMutableArray *array) {
            
            //3.配置商圈
            self.placeArray = array;
            
            [self.placeArray insertObject:@"全部市区" atIndex:0];
            
            //4.配置地铁
            [manager placeIdWithPlaceName:cityName success:^(NSNumber *placeId) {
                
                [self configCitySubWayWithCityId:[placeId stringValue]];
                
            }];
            
        }];
        
    } failure:^(NSError *error) {
        
        
    }];
}


//根据Id来配置该城市的地铁
- (void)configCitySubWayWithCityId:(NSString *)cityId {
    
    [self.dataHandler sendCitySubWayWithCityId:cityId Success:^(NSMutableArray *dataArray) {
        
        //保存数据
        self.subwayArray = dataArray;
        
        //配置界面
        self.tableView.frame = CGRectMake(0,44, SCREEN_WIDTH, SCREEN_HEIGHT - 44);
        
        self.tableView.dataSource = self;
        
        self.tableView.delegate = self;
        
        self.isShowMapView = NO;
        
        //初始化搜索界面
        self.menuView = nil;
        
        DOPDropDownMenu *menuView = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:44];
        
        menuView.dataSource = self;
        
        menuView.delegate = self;
        
        menuView.textSelectedColor = RGBACOLOR(0, 93, 193, 1);
        
        self.menuView = menuView;
        
        [self.view addSubview:menuView];
        
    } failure:^(NSError *error) {
        
        [self showToast:error.userInfo[NSLocalizedDescriptionKey]];
    }];
}

//定位并获取获取城市名字
- (void)startFindLocationSucess:(void (^)(NSString *))success
                        failure:(void (^)(NSError *))failure {

    [self.dataHandler startFindLocationSucess:^(NSString *cityName) {
        
        NSMutableString *string = [NSMutableString stringWithString:cityName];
        
        NSRange locatin;
        if ([string containsString:@"市"]) {
            
            locatin = [string rangeOfString:@"市"];
            
        } else if ([string containsString:@"自治区"]) {
            
            locatin = [string rangeOfString:@"自治区"];
            
        }
    
        if (locatin.length != 0) {
            
            [string deleteCharactersInRange:locatin];
            
        }
        
        success(string);
        
    } failure:^(NSError *error) {
        
        failure(error);
        
    }];
}


- (IBAction)leftBarButtonAcion:(id)sender {
    
    CityViewController *controller = [[CityViewController alloc] init];
    
    controller.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)rightBarButtonAcion:(id)sender {
    
    self.isShowMapView = !self.isShowMapView;
    
    if (self.isShowMapView ) {
        
        _mapView.hidden = NO;
        
        self.tableView.hidden = YES;
        
    } else {
        
        _mapView.hidden = YES;
        
        self.tableView.hidden = NO;
        
    }
}

-  (void)configUI {
    
    //1.初始化searchBar
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    searchBar.placeholder = @"搜索";
    
    searchBar.delegate = self;
    
    searchBar.translucent = YES;
    
    self.searchBar = searchBar;
    
    self.navigationItem.titleView = searchBar;

    //2.初始化百度地图
    _mapView = [[BMKMapView alloc] init];
    
    _mapView.frame = CGRectMake(0, 64 + 44, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44 - 50);
    
    _mapView.hidden = YES;
    
    [self.view addSubview:_mapView];
    
}

#pragma ---
#pragma mark --- 上啦刷新和下拉刷新

- (void)headerRefreshing {
    
    [self.tableView.mj_header endRefreshing];
}

- (void)footerRereshing {
    
    [self.tableView.mj_footer endRefreshing];
    
}

#pragma ---
#pragma mark --- DOPDropDownMenuDataSource/DOPDropDownMenuDelegate

- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
    
    return 3;
}

/**
 *  返回 menu 第column列有多少行
 */
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    
    if (column == 0) {
        
        return self.placeArray.count;
        
    } else if (column == 1) {
        
        return 2;
        
    }
    return 2;
}

/**
 *  返回 menu 第column列 每行title
 */
- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        
        return self.placeArray[indexPath.row];
        
    } else if (indexPath.column == 1) {
        
        if (indexPath.row == 0) {
            
            return @"全部";
            
        } else {
            
            return @"等待赋值";
        }
        
    } else if (indexPath.column == 2) {
        
        if (indexPath.row == 0) {
            
            return @"排序";
            
        } else {
            
            return @"等待赋值";
        }
        
    } else if (indexPath.column == 3) {
        
        if (indexPath.row == 0) {
            
            return @"筛选";
            
        } else {
            
            return @"等待赋值";
        }
    }
    return @"";
}

/** 新增
 *  当有column列 row 行 返回有多少个item ，如果>0，说明有二级列表 ，=0 没有二级列表
 *  如果都没有可以不实现该协议
 */
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column {
    
    if (column == 0 ) {
        
        return 2;
    }
    return 0;
}

/** 新增
 *  当有column列 row 行 item项 title
 *  如果都没有可以不实现该协议
 */
- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath {
    
    if (indexPath.column == 0 && indexPath.row == 0) {
        
        if (indexPath.item == 0) {
            
            return @"全部商区";
            
        } else if (indexPath.item == 1) {
            
            return @"等待赋值";
            
        }
    }
    return @"";
}

- (NSInteger)guoJiaMenu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column {
    
    if (column == 0 ) {
    
        SubwayModel *subWay = self.subwayArray[row];
        
        return subWay.list.count;
        
    }
    return 0;
}

- (NSInteger)guoJiaMenu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    
    if (column == 0) {
        
        return self.subwayArray.count;
        
    } else if (column == 1) {
        
        return 2;
        
    }
    
    return 2;
}

- (NSString *)guoJiaMenu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath {
    
    if (indexPath.column == 0 ) {
        
        SubwayModel *subWay = self.subwayArray[indexPath.row];
        
        platformModel *model = subWay.list[indexPath.item];
        
        return model.name;
    }
    return @"";
}

- (NSString *)guoJiaMenu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        
        SubwayModel *subwayModel = self.subwayArray[indexPath.row];
        
        return subwayModel.lineName;
        
    } else if (indexPath.column == 1) {
        
        if (indexPath.row == 0) {
            
            return @"全部";
            
        } else {
            
            return @"等待赋值";
        }
        
    } else if (indexPath.column == 2) {
        
        if (indexPath.row == 0) {
            
            return @"排序";
            
        } else {
            
            return @"等待赋值";
        }
        
    } else if (indexPath.column == 3) {
        
        if (indexPath.row == 0) {
            
            return @"筛选";
            
        } else {
            
            return @"等待赋值";
        }
    }
    return @"";
}

- (void)guoJiaMenu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {

    
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {
    
    
}


#pragma ---
#pragma mark -- UITableViewDataSource/UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.subwayArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *shopListIdentifier = @"ShopListTableViewCell";
    
    ShopListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:shopListIdentifier];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:shopListIdentifier owner:nil options:nil] lastObject];
    }
    
//    cell.shopModel = self.dataArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 113;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ShopDetailViewController *controller = [[ShopDetailViewController alloc] init];
    
    controller.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma ---
#pragma mark --- UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.searchBar resignFirstResponder];
}

#pragma ---
#pragma mark -- UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    SearchViewController *controller = [[SearchViewController alloc] init];
    
    controller.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:controller animated:YES];
    
    return NO;
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
