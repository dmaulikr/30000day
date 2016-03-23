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
#import "SearchConditionModel.h"
#import <CoreLocation/CoreLocation.h>

@interface ShopViewController () <DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftBarButton;

@property (nonatomic,assign) BOOL isShowMapView;//是否显示百度地图

@property (nonatomic,strong) UISearchBar *searchBar;

@property (nonatomic,strong) NSMutableArray *subwayArray;//存储地铁线路模型

@property (nonatomic,strong) NSMutableArray *placeArray;//存储地方模型

@property (nonatomic,strong) DOPDropDownMenu *menuView;

@property (nonatomic,strong) SearchConditionModel *conditionModel;//搜索的条件

@property (nonatomic,strong) NSMutableArray *shopListArray;//商品列表的数据源

@property (nonatomic,assign) CLLocationCoordinate2D coordinate2D;//保存从系统定位获取到的经纬度

@property (nonatomic,assign) NSUInteger pageNumber;

@end

@implementation ShopViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    //1.初始化UI
    [self configUI];

    
    //2.定位并获取获取城市名字
    [self startFindLocationSucess:^(NSString *cityName,NSString *provinceName) {

        
        [self configBusinessPlaceWithCityName:cityName];
        
        self.leftBarButton.title = cityName;
        
        self.conditionModel.provinceName = provinceName;//给获取的到省赋值
        
        self.conditionModel.cityName = cityName;//给获取的到市赋值
        
    } failure:^(NSError *error) {
        
        [self configBusinessPlaceWithCityName:@"上海"];
        
        self.leftBarButton.title = @"上海";
        
    }];
    
    self.pageNumber = 1;
    
    //3.获取列表数据源数组
    [self getShopListDataWithSearchCondition:self.conditionModel pageNumber:self.pageNumber];
}

- (void)configBusinessPlaceWithCityName:(NSString *)cityName {
    
    //配置数据库
    PlaceManager *manager = [PlaceManager shareManager];
    
    [manager configManagerSuccess:^(BOOL success) {
        
        [manager countyArrayWithCityName:cityName success:^(NSMutableArray *array) {
            
            //配置商圈
            self.placeArray = array;
            
            [self.placeArray insertObject:@"全部商区" atIndex:0];
            
            //配置地铁
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
        
        menuView.isClickHaveItemValid = NO;
        
        self.menuView = menuView;
        
        [self.view addSubview:menuView];
        
    } failure:^(NSError *error) {
        
        [self showToast:error.userInfo[NSLocalizedDescriptionKey]];
        
    }];
}

//剪切字符串，吧市、自治区、省
- (NSMutableString *)mutableStringWithString:(NSString *)sting {
    
    NSMutableString *mutableString = [NSMutableString stringWithString:sting];
    
    NSRange locatin;
    
    if ([mutableString containsString:@"市"]) {
        
        locatin = [mutableString rangeOfString:@"市"];
        
    } else if ([mutableString containsString:@"自治区"]) {
        
        locatin = [mutableString rangeOfString:@"自治区"];
        
    } else if ([mutableString containsString:@"省"]) {
        
        locatin = [mutableString rangeOfString:@"省"];
    }

    if (locatin.length != 0) {
        
        [mutableString deleteCharactersInRange:locatin];
    }
    
    return mutableString;
}

//定位并获取获取城市名字
- (void)startFindLocationSucess:(void (^)(NSString *,NSString *))success
                        failure:(void (^)(NSError *))failure {

    [self.dataHandler startFindLocationSucess:^(NSString *locality,NSString *administrativeArea,CLLocationCoordinate2D coordinate2D) {
        
        self.coordinate2D = coordinate2D;
        
        success([self mutableStringWithString:locality],[self mutableStringWithString:administrativeArea]);
        
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

- (void)configUI {
    
    //初始化searchBar
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    searchBar.placeholder = @"搜索";
    
    searchBar.delegate = self;
    
    searchBar.translucent = YES;
    
    self.searchBar = searchBar;
    
    self.navigationItem.titleView = searchBar;

    //初始化百度地图
    _mapView = [[BMKMapView alloc] init];
    
    _mapView.frame = CGRectMake(0, 64 + 44, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44 - 50);
    
    _mapView.hidden = YES;
    
    [self.view addSubview:_mapView];
}

- (SearchConditionModel *)conditionModel {
    
    if (!_conditionModel) {
        
        _conditionModel = [[SearchConditionModel alloc] init];
        
        _conditionModel.provinceName = @"上海";
        
        _conditionModel.cityName = @"上海";
    }
    return _conditionModel;
}

//获取整个列表的数据
- (void)getShopListDataWithSearchCondition:(SearchConditionModel *)conditionModel pageNumber:(NSInteger)pageNumber {
    
    if (pageNumber != 1) {//上拉刷新
        
        [self.dataHandler sendShopListWithSearchConditionModel:conditionModel Success:^(NSMutableArray *dataArray) {
            
            for (int i = 0; i < dataArray.count; i++) {
                
                [self.shopListArray addObject:dataArray[i]];
            };
            
            [self.tableView reloadData];
            
            if (!dataArray.count) {
                
                [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
            }
            
            [self.tableView.mj_footer endRefreshing];
            
            self.pageNumber += 1;//上拉刷新后增加页数
            
        } failure:^(NSError *error) {
            
             [self.tableView.mj_footer endRefreshing];
            
        }];
        
    } else {//下拉刷新和首次刷新

        [self.dataHandler sendShopListWithSearchConditionModel:conditionModel Success:^(NSMutableArray *dataArray) {
            
            self.shopListArray = dataArray;
            
            [self.tableView reloadData];

            [self.tableView.mj_header endRefreshing];
            
            self.pageNumber = 1;//下拉刷新后重置页数
            
        } failure:^(NSError *error) {
            
            [self.tableView.mj_header endRefreshing];
            
        }];
    }
}

#pragma ---
#pragma mark --- 上啦刷新和下拉刷新

- (void)headerRefreshing {
    
    [self getShopListDataWithSearchCondition:self.conditionModel pageNumber:1];
}

- (void)footerRereshing {
    
    [self getShopListDataWithSearchCondition:self.conditionModel pageNumber:self.shopListArray.count];
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
        
        return 5;
        
    }
    return 7;
}

/**
 *  返回 menu 第column列 每行title
 */
- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        
        return self.placeArray[indexPath.row];
        
    } else if (indexPath.column == 1) {
        
        if (indexPath.row == 0) {
            
            return @"排序";
            
        } else if (indexPath.row == 1) {
            
            return @"评分最高";
            
        }  else if (indexPath.row == 2) {
            
            return @"离我最近";
            
        } else if (indexPath.row == 3) {
            
            return @"价格升序";
            
        } else if (indexPath.row == 4) {
            
            return @"价格降序";
        }
        
    } else if (indexPath.column == 2) {
        
        if (indexPath.row == 0) {
            
            return @"筛选";
            
        } else if(indexPath.row == 1){
            
            return @"健身场馆";
            
        } else if (indexPath.row == 2) {
            
            return @"体检中心";
            
        } else if (indexPath.row == 3) {
            
            return @"医院";
            
        } else if (indexPath.row == 4) {
            
            return @"孕产机构";
            
        } else if (indexPath.row == 5) {
            
            return @"家政机构";
            
        } else if (indexPath.row == 6) {
            
            return @"育儿培训机构";
            
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
        
    } else if (indexPath.column == 0 && indexPath.row == 1) {
        
        if (indexPath.item == 0) {
            
            return @"黄埔商圈";
            
        } else if (indexPath.item == 1) {
            
            return @"黄埔军校";
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
        
        return 4;
        
    } else if (column == 2) {
        
        return 6;
        
    }
    return 0;
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
            
            return @"排序";
            
        } else if (indexPath.row == 1) {
            
            return @"评分最高";
            
        }  else if (indexPath.row == 2) {
            
            return @"离我最近";
            
        } else if (indexPath.row == 3) {
            
            return @"价格升序";
            
        } else if (indexPath.row == 4) {
            
            return @"价格降序";
        }
        
    } else if (indexPath.column == 2) {
        
        if (indexPath.row == 0) {
            
            return @"筛选";
            
        } else if(indexPath.row == 1){
            
            return @"健身场馆";
            
        } else if (indexPath.row == 2) {
            
            return @"体检中心";
            
        } else if (indexPath.row == 3) {
            
            return @"医院";
            
        } else if (indexPath.row == 4) {
            
            return @"孕产机构";
            
        } else if (indexPath.row == 5) {
            
            return @"家政机构";
            
        } else if (indexPath.row == 6) {
            
            return @"育儿培训机构";
            
        }
    }
    return @"";
}

- (void)guoJiaMenu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {

    if (indexPath.column == 0) {
        
        //赋值并下载数据
        SubwayModel *subwayModel = self.subwayArray[indexPath.row];
        
        platformModel *model = subwayModel.list[indexPath.item];
        
        self.conditionModel.subwayStation = model.name;
        
        self.conditionModel.regional = @"";
        
        self.conditionModel.businessCircle = @"";
        
        [self getShopListDataWithSearchCondition:self.conditionModel pageNumber:1];
    }
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {
    
    if (indexPath.column == 0 ) {//点击商圈
        
        self.conditionModel.regional = self.placeArray[indexPath.row];
        
        if (indexPath.row == 0) {
            
            if (indexPath.item == 0) {
                
                self.conditionModel.businessCircle = @"全部商区";
                
            } else if (indexPath.item == 1) {
                
                self.conditionModel.businessCircle = @"等待赋值";
            }
            
        } else if (indexPath.row == 1) {
            
            if (indexPath.item == 0) {
                
                self.conditionModel.businessCircle = @"黄埔商圈";
                
            } else if (indexPath.item == 1) {
                
                self.conditionModel.businessCircle = @"黄埔军校";
            }
        }
        
        self.conditionModel.subwayStation = @"";
        
        [self getShopListDataWithSearchCondition:self.conditionModel pageNumber:1];
    
    } else if (indexPath.column == 1) {//点击了排序
        
        self.conditionModel.sequence = [NSNumber numberWithInteger:indexPath.row];
        
        if (indexPath.row == 2) {
            
            self.conditionModel.longitude = [NSNumber numberWithDouble:self.coordinate2D.longitude];
            
            self.conditionModel.latitude = [NSNumber numberWithDouble:self.coordinate2D.latitude];
        }
        
        [self getShopListDataWithSearchCondition:self.conditionModel pageNumber:1];
        
    } else if (indexPath.column == 2) {//点击了筛选
        
        self.conditionModel.sift = [NSNumber numberWithInteger:indexPath.row];

        [self getShopListDataWithSearchCondition:self.conditionModel pageNumber:1];
    }
}

#pragma ---
#pragma mark -- UITableViewDataSource/UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.shopListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *shopListIdentifier = @"ShopListTableViewCell";
    
    ShopListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:shopListIdentifier];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:shopListIdentifier owner:nil options:nil] lastObject];
    }
    
    cell.shopModel = self.shopListArray[indexPath.row];
    
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
