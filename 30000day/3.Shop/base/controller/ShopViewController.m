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
#import "SearchConditionModel.h"
#import <CoreLocation/CoreLocation.h>
#import "STLocationMananger.h"
#import "ProvinceModel.h"
#import "MTProgressHUD.h"
#import "MapShowTitleAnnotationView.h"
#import "ShopAnnotation.h"

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

@property (nonatomic,strong) NSMutableArray *locationArray;

@property (nonatomic,strong) ProvinceModel *provinceModel;

@end

@implementation ShopViewController {
    
    BOOL _isFromCityController;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    //1.初始化UI
    [self configUI];
    
    //2.定位并获取获取城市名字
    [self startFindLocationSucess:^(NSString *cityName,NSString *provinceName) {
        
        self.leftBarButton.title = cityName;
        
        self.conditionModel.provinceName = provinceName;//给获取的到省赋值
        
        self.conditionModel.cityName = cityName;//给获取的到市赋值
        
    } failure:^(NSError *error) {
        
        self.leftBarButton.title = @"上海市";
    
        self.conditionModel.provinceName = @"上海";//给获取的到省赋值

        self.conditionModel.cityName = @"上海市";//给获取的到市赋值

    }];

    //二.用省和市的名字从给定的地址模型中选择筛选列表的数据
    _isFromCityController = NO;
    
    [self chooseCityFromLocationArray:[STLocationMananger shareManager].locationArray withProvinceName:self.conditionModel.provinceName withCityName:self.conditionModel.cityName isFromCityController:_isFromCityController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_mapView viewWillAppear];
    
     _mapView.delegate = self; //不用时，置nil
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_mapView viewWillDisappear];
    
    _mapView.delegate = nil; //不用时，置nil
}

- (void)dealloc {
    
    if (_mapView) {
        
        _mapView = nil;
    }
    
    self.searchBar = nil;
    
    self.subwayArray = nil;
    
    self.placeArray = nil;
    
    self.menuView = nil;
    
    [self.menuView removeFromSuperview];
    
    self.shopListArray = nil;
    
    self.locationArray = nil;
    
    self.conditionModel = nil;
    
    self.provinceModel = nil;
}

 //3.获取列表数据源数组
- (void)getShopListArray {
    
    self.pageNumber = 1;
    
    [self getShopListDataWithSearchCondition:self.conditionModel pageNumber:self.pageNumber];
}

//用省和市的名字从给定的地址模型中选择城市、商圈的数据
- (void)chooseCityFromLocationArray:(NSMutableArray *)locationArray withProvinceName:(NSString *)provinceName withCityName:(NSString *)cityName isFromCityController:(BOOL)isFrom {
    
    self.conditionModel.provinceName = provinceName;
    
    self.conditionModel.cityName = cityName;
    
    NSNumber *cityId;
    
    if (isFrom) {
        
        self.leftBarButton.title = cityName;
    }
    
    for (int i = 0; i < locationArray.count; i++) {
        
        ProvinceModel *provinceModel = locationArray[i];
        
        if ([provinceModel.regionName containsString:[Common deletedStringWithParentString:provinceName]]) {//找到当前的省
            
            for (int i = 0; i < provinceModel.cityList.count; i++) {
                
                CityModel *cityModel = provinceModel.cityList[i];
                
                if ([cityModel.regionName containsString:[Common deletedStringWithParentString:cityName]]) {//找到当前的市
                    
                    self.provinceModel = provinceModel;
                    
                    self.locationArray = cityModel.countyList;//获取城市的区、县
                    
                    cityId = cityModel.cityId;
                    
                    break;
                }
                
            }
        }
    }
    //1.根据城市Id来配置地铁
    [self configCitySubWayWithCityId:[cityId stringValue]];
    
    //三.获取列表数据源数组
    [self getShopListArray];
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
        for (UIView *view in self.view.subviews) {
            
            if ([view isKindOfClass:[DOPDropDownMenu class]]) {
                
                [view removeFromSuperview];
            }
        }
        
        DOPDropDownMenu *menuView = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:44];
        
        menuView.dataSource = self;
        
        menuView.delegate = self;
        
        menuView.textSelectedColor = RGBACOLOR(0, 93, 193, 1);
        
        menuView.isClickHaveItemValid = NO;
        
        self.menuView = menuView;
        
        [self.view addSubview:menuView];
        
    } failure:^(NSError *error) {
        
        [self showToast:error.userInfo[NSLocalizedDescriptionKey]];
        
        //二.用省和市的名字从给定的地址模型中选择筛选列表的数据
        [self chooseCityFromLocationArray:[STLocationMananger shareManager].locationArray withProvinceName:self.conditionModel.provinceName withCityName:self.conditionModel.cityName isFromCityController:_isFromCityController];
    }];
}

//定位并获取获取城市名字
- (void)startFindLocationSucess:(void (^)(NSString *,NSString *))success
                        failure:(void (^)(NSError *))failure {

    [self.dataHandler startFindLocationSucess:^(NSString *locality,NSString *administrativeArea,CLLocationCoordinate2D coordinate2D) {
        
        self.coordinate2D = coordinate2D;
        
        success(locality,administrativeArea);
        
    } failure:^(NSError *error) {
        
        failure(error);
        
    }];
}

- (IBAction)leftBarButtonAcion:(id)sender {
    
    CityViewController *controller = [[CityViewController alloc] init];
    
    controller.hidesBottomBarWhenPushed = YES;
    
    //点击了市cell回调
    [controller setCityBlock:^(NSString *provinceName, NSString *cityName) {
       
        _isFromCityController = YES;
        
        [self chooseCityFromLocationArray:[STLocationMananger shareManager].locationArray withProvinceName:provinceName withCityName:cityName isFromCityController:_isFromCityController];
        
    }];
    
    [self.navigationController pushViewController:controller animated:YES];
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
    
    _mapView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64- 50);
    
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(31.19,121.70)];
    
    _mapView.showsUserLocation = NO;
    
    _mapView.zoomLevel = 15;//地图等级
    
    _mapView.delegate = self;
    
    _mapView.hidden = YES;
    
    [self.view addSubview:_mapView];
    
    //初始化rightButton
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_map"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                                                                              style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAcion:)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)rightBarButtonAcion:(UIBarButtonItem *)rightButton {
    
    if (self.isShowMapView ) {
        
        _mapView.hidden = YES;
        
        self.tableView.hidden = NO;
        
        rightButton.image = [[UIImage imageNamed:@"icon_map"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
  
    } else {
    
        _mapView.hidden = NO;
        
        self.tableView.hidden = YES;
        
        rightButton.image = [[UIImage imageNamed:@"icon_list"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    self.isShowMapView = !self.isShowMapView;
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
        
        [self.dataHandler sendShopListWithSearchConditionModel:conditionModel isSearch:![Common isObjectNull:self.searchBar.text] pageNumber:pageNumber Success:^(NSMutableArray *dataArray) {
            
            [self.shopListArray addObjectsFromArray:dataArray];
            
            [self.tableView reloadData];
            
            if (!dataArray.count) {
                
                [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                
            } else {
                
                [self.tableView.mj_footer setState:MJRefreshStateIdle];
            }
            
            self.pageNumber += 1;//数据下载成功加1
            
            //在百度地图上显示
            NSMutableArray *annotation = [[NSMutableArray alloc] init];
            
            [_mapView removeAnnotations:[NSArray arrayWithArray:_mapView.annotations]];
            
            for (int i = 0; i < self.shopListArray.count; i++) {
                
                ShopModel *model = self.shopListArray[i];
                
                ShopAnnotation *item = [[ShopAnnotation alloc] init];
                
                item.coordinate = CLLocationCoordinate2DMake([model.latitude doubleValue], [model.longitude doubleValue]);
                
                item.title = model.productName;
                
                item.subtitle = model.address;
            
                item.model = model;
                
                [annotation addObject:item];
                
                if (i == 0) {//把第一个经纬度作为中心
                    
                    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake([model.latitude doubleValue], [model.longitude doubleValue])];
                    _mapView.zoomLevel = 15;
                }
            }

            [_mapView addAnnotations:annotation];
            [_mapView showAnnotations:annotation animated:NO];
            _mapView.zoomLevel = 15;
            
        } failure:^(NSError *error) {
            
            [self.tableView.mj_footer endRefreshing];
            
            [self.tableView.mj_footer setState:MJRefreshStateIdle];
            
        }];
    } else {//下拉刷新和首次刷新
    
        [self.dataHandler sendShopListWithSearchConditionModel:conditionModel
                                                      isSearch:![Common isObjectNull:self.searchBar.text]
                                                    pageNumber:pageNumber
                                                       Success:^(NSMutableArray *dataArray) {
            
           self.shopListArray = dataArray;
            
           [self.tableView reloadData];
                                                           
           [self.tableView.mj_header endRefreshing];
           
           [self.tableView.mj_footer setState:MJRefreshStateIdle];
           
           self.pageNumber = 1;//下拉刷新当前的页数是1
                                                           
           //在百度地图上显示
           NSMutableArray *annotation = [[NSMutableArray alloc] init];
           
           // 清楚屏幕中所有的annotation
           [_mapView removeAnnotations:[NSArray arrayWithArray:_mapView.annotations]];
                                                           
           for (int i = 0; i < dataArray.count; i++) {
               
               ShopModel *model = dataArray[i];
               
               ShopAnnotation *item = [[ShopAnnotation alloc] init];
               
               item.coordinate = CLLocationCoordinate2DMake([model.latitude doubleValue], [model.longitude doubleValue]);
               
               item.title = model.productName;
               
               item.subtitle = model.address;
               
               item.model = model;
               
               [annotation addObject:item];
               
               if (i == 0) {//把第一个经纬度作为中心
                   
                   [_mapView setCenterCoordinate:CLLocationCoordinate2DMake([model.latitude doubleValue], [model.longitude doubleValue])];
                   _mapView.zoomLevel = 15;
               }
           }
                                                           
           [_mapView addAnnotations:annotation];
                                                           
           [_mapView showAnnotations:annotation animated:NO];
                                                           
            _mapView.zoomLevel = 15;
          
        } failure:^(NSError *error) {
            
            [self.tableView.mj_header endRefreshing];
            
            [self.tableView.mj_footer setState:MJRefreshStateIdle];
            
        }];
    }
}

#pragma ---
#pragma mark --- 上啦刷新和下拉刷新

- (void)headerRefreshing {
    
    [self getShopListDataWithSearchCondition:self.conditionModel pageNumber:1];
}

- (void)footerRereshing {
    
    [self getShopListDataWithSearchCondition:self.conditionModel pageNumber:self.pageNumber + 1];
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
        
        return self.locationArray.count + 1;
        
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
        
        if (indexPath.row == 0) {//第一行需要显示所有的商圈
            
            return @"全部商圈";
            
        } else {//非第一行
        
            RegionalModel *model = self.locationArray[indexPath.row - 1 ];
            
            return model.regionName;
        }

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
        
        if (row == 0) {
            
            return 1;
            
        } else {
            
            RegionalModel *model = self.locationArray[row - 1];
            
            return model.businessCircleList.count;
        }
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
            
        }
        
    } else if (indexPath.column == 0) {
        
        RegionalModel *model = self.locationArray[indexPath.row - 1];
        
        BusinessCircleModel *circleModel = model.businessCircleList[indexPath.item];
        
        return circleModel.regionName;
        
    }
    
    return @"";
}

- (NSInteger)guoJiaMenu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column {
    
    if (column == 0 ) {
        
        if (self.subwayArray.count) {
            
            SubwayModel *subWay = self.subwayArray[row];
            
            return subWay.list.count;
            
        }
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
        
        if (indexPath.row == 0) {
            
            self.conditionModel.businessCircle = @"全部商区";
            
        } else {
            
            RegionalModel *model = self.locationArray[indexPath.row - 1];
            
            if (model.businessCircleList.count) {
                
                BusinessCircleModel *circleModel = model.businessCircleList[indexPath.item];
                
                self.conditionModel.businessCircle = circleModel.regionName;
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
    
    [self.searchBar resignFirstResponder];
    
    ShopDetailViewController *controller = [[ShopDetailViewController alloc] init];
    
    ShopModel *model = self.shopListArray[indexPath.row];
    
    controller.productId = [model.productId stringValue];
    
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
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    self.conditionModel.searchContent = searchBar.text;
    
    [self getShopListDataWithSearchCondition:self.conditionModel pageNumber:1];
    
    [self.searchBar resignFirstResponder];
}

#pragma mark -
#pragma mark implement BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation {
    
    static NSString *identifier = @"MapShowTitleAnnotationView";
    
    MapShowTitleAnnotationView *titleView = (MapShowTitleAnnotationView *)[view dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (titleView == nil) {
       
        titleView = [[MapShowTitleAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    }
    
    titleView.draggable = YES;
    
    titleView.annotation = annotation;
    
    titleView.centerOffset = CGPointMake(0, 5);
    
    titleView.canShowCallout = YES;
    
    titleView.title = annotation.title;
    
    titleView.size = [MapShowTitleAnnotationView titleSize:annotation.title];//设置坐标
    
    return titleView;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    
    [mapView bringSubviewToFront:view];
    
    [mapView setNeedsDisplay];
}

//点击气泡代理
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view {
    
    ShopAnnotation *annotation = view.annotation;
    
    ShopModel *model = annotation.model;
    
    [self.searchBar resignFirstResponder];
    
    ShopDetailViewController *controller = [[ShopDetailViewController alloc] init];
    
    controller.productId = [model.productId stringValue];
    
    controller.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    
    NSLog(@"didAddAnnotationViews");
}



/**
 *地图初始化完毕时会调用此接口
 *@param mapview 地图View
 */
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    //百度地图显示等级
    _mapView.zoomLevel = 15;
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
