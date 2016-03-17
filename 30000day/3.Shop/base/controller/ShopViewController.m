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

@interface ShopViewController () <DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftBarButton;

@property (nonatomic,assign) BOOL isShowMapView;

@property (nonatomic,strong) UISearchBar *searchBar;

@end

@implementation ShopViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.frame = CGRectMake(0,44, SCREEN_WIDTH, SCREEN_HEIGHT - 44);
    
    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;
    
    self.isShowMapView = NO; 
    
    [self configUI];
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
    
    //2.初始化搜索界面
    
    DOPDropDownMenu *menuView = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:44];
    
    menuView.dataSource = self;
    
    menuView.delegate = self;
    
    [self.view addSubview:menuView];
    
    //3.初始化百度地图
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
    
    return 4;
}

/**
 *  返回 menu 第column列有多少行
 */
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    
    if (column == 0) {
        
        return 8;
        
    } else if (column == 1) {
        
        return 10;
        
    }
    return 5;
}

/**
 *  返回 menu 第column列 每行title
 */
- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        
        if (indexPath.row == 0) {
            
            return @"全部商区";
            
        } else if (indexPath.row == 1) {
            
            return @"浦东新区";
            
        } else if (indexPath.row == 2) {
            
            return @"徐汇区";
            
        }  else if (indexPath.row == 3) {
            
            return @"黄浦区";
            
        } else if (indexPath.row == 4) {
            
            return @"卢湾区";
            
        } else if (indexPath.row == 5) {
            
            return @"静安区";
            
        } else if (indexPath.row == 6) {
            
            return @"长宁区";
            
        } else if (indexPath.row == 7) {
            
            return @"闵行区";
            
        }
        
    } else if (indexPath.column == 1) {
        
        
        if (indexPath.row == 0) {
            
            return @"地铁";
            
        } else if (indexPath.row == 1) {
            
            return @"1号线 ";
            
        } else if (indexPath.row == 2) {
            
            return @"2号线 ";
            
        } else if (indexPath.row == 3 ) {
            
            return @"3号线 ";
            
        } else if (indexPath.row == 4) {
            
            return @"4号线 ";
            
        } else if (indexPath.row == 5) {
            
            return @"7号线 ";
            
        } else if (indexPath.row == 6) {
            
            return @"8号线 ";
            
        } else if (indexPath.row == 7) {
            
            return @"9号线 ";
            
        } else if (indexPath.row == 8) {
            
            return @"10号线 ";
            
        } else if (indexPath.row == 9) {
            
            return @"11号线 ";
            
        }

    } else if (indexPath.column == 2) {
        
        if (indexPath.row == 0) {
            
            return @"全部";
            
        } else {
            
            return @"等待赋值";
        }
        
    } else if (indexPath.column == 3) {
        
        if (indexPath.row == 0) {
            
            return @"排序";
            
        } else {
            
            return @"等待赋值";
        }
        
    } else if (indexPath.column == 4) {
        
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
        
        return 8;
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
            
            return @"陆家嘴";
            
        } else if (indexPath.item == 2) {
            
            return @"八佰伴";
            
        } else if (indexPath.item == 3) {
            
            return @"上南地区";
            
        } else if (indexPath.item == 4) {
            
            return @"徐汇区";
            
        } else if (indexPath.item == 5) {
            
            return @"人民广场";
            
        } else if (indexPath.item == 6) {
            
            return @"世纪公园";
            
        } else if (indexPath.item == 7) {
            
            return @"淮海路";
        }
        
    }
    
    return @"";
}

#pragma ---
#pragma mark -- UITableViewDataSource/UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *shopListIdentifier = @"ShopListTableViewCell";
    
    ShopListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:shopListIdentifier];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:shopListIdentifier owner:nil options:nil] lastObject];
    }
    
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
