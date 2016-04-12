//
//  CityViewController.m
//  30000day
//
//  Created by GuoJia on 16/3/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "CityViewController.h"
#import "CityHeadView.h"
#import "CityTableViewCell.h"
#import "STLocationMananger.h"
#import "ProvinceModel.h"

@interface CityViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL isOpen;//是否是展开的

@property (nonatomic,strong) NSIndexPath *selectorIndexPath;//选中的indexPath

@property (nonatomic,assign) BOOL isSearch;

@property (nonatomic,strong) NSMutableArray *searchResultArray;

@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"城市的选择";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 108) style:UITableViewStyleGrouped];

    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    self.searchBar.placeholder = @"输入城市名";
    
    self.isOpen = NO;//默认不是展开的
    
    self.isSearch = NO;//默认是不搜索的
}

#pragma ---
#pragma mark ---- 父视图的生命周期方法
- (void)searchBarDidBeginRestore:(BOOL)isAnimation  {
    
    [super searchBarDidBeginRestore:isAnimation];
    
    self.isSearch = NO;
    
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    [super searchBar:searchBar textDidChange:searchText];
    
    self.isSearch = [searchText isEqualToString:@""] ? NO : YES;
    
    //开始搜索
    self.searchResultArray = [NSMutableArray array];
    
    for (int i = 0; i < [STLocationMananger shareManager].locationArray.count; i++ ) {
        
        ProvinceModel *provinceModel = [STLocationMananger shareManager].locationArray[i];
        
        for (int j = 0; j < provinceModel.cityList.count; j++) {
            
            CityModel *cityModel = provinceModel.cityList[j];
            
            if ([cityModel.regionName containsString:searchText]) {
                
                HotCityModel *model = [[HotCityModel alloc] init];
                
                model.provinceName = provinceModel.regionName;
                
                model.cityName = cityModel.regionName;
                
                [self.searchResultArray addObject:model];
            }
        }
    }
    
    [self.tableView reloadData];
}

#pragma ---
#pragma mark --- UITableViewDataSource / UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.isSearch) {//正在搜索
     
        return 1;
        
    } else {//没有搜索
        
        return [STLocationMananger shareManager].locationArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isSearch) {//正在搜索
        
        return self.searchResultArray.count;//搜索的数组
        
    } else {//没有搜索
        
        if (self.isOpen) {//打开
            
            if (self.selectorIndexPath.section == section) {
                
                ProvinceModel *provinceModel = [STLocationMananger shareManager].locationArray[section];
                
                return provinceModel.cityList.count + 1;
                
            } else {
                
                return 1;
            }
            
        } else {
            
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isSearch) {//正在搜索
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
            
            cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            
            cell.textLabel.textColor = [UIColor darkGrayColor];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
        
        HotCityModel *model = self.searchResultArray[indexPath.row];
        
        cell.textLabel.text = model.cityName;
        
        return cell;
        
    } else {//没有搜索
        
        CityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityTableViewCell"];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CityTableViewCell" owner:nil options:nil] lastObject];
        }
        
        ProvinceModel *provinceModel = [STLocationMananger shareManager].locationArray[indexPath.section];
        
        if (self.isOpen && self.selectorIndexPath.section == indexPath.section ) {//当选中的sectin是当前的secion才打开
            
            if (indexPath.row == 0) {
                
                cell.willShowImageView.hidden = NO;
                
                cell.willShowImageView.image = [UIImage imageNamed:@"navigationbar_arrow_down"];
                
                cell.willShowLabel.text = provinceModel.regionName;
                
            } else {
                
                cell.willShowImageView.hidden = YES;
                
                CityModel *cityModel = provinceModel.cityList[indexPath.row - 1];
                
                cell.willShowLabel.text = cityModel.regionName;
            }
            
        } else {//关闭
            
            if (indexPath.row == 0) {
                
                cell.willShowImageView.hidden = NO;
                
                cell.willShowImageView.image = [UIImage imageNamed:@"navigationbar_arrow_up"];
                
                cell.willShowLabel.text = provinceModel.regionName;
                
            } else {
                
                cell.willShowImageView.hidden = YES;
                
                CityModel *cityModel = provinceModel.cityList[indexPath.row - 1];
                
                cell.willShowLabel.text = cityModel.regionName;
            }
        }
        
        return cell;
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.isSearch) {//搜索状态
        
        return nil;
        
    } else {//不是搜索状态
        
        if (section == 0) {
            
            CityHeadView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CityHeadView"];
            
            if (!view) {
                
                view = [[CityHeadView alloc] init];
            }
            
            //取出热门城市并赋值
            NSMutableArray *cityArray = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < [STLocationMananger shareManager].hotCityArray.count; i++) {
                
                HotCityModel *model = [STLocationMananger shareManager].hotCityArray[i];
                
                [cityArray addObject:model.cityName];
            }
            
            view.cityArray = cityArray;
            
            [view setButtonActionBlock:^(NSUInteger index) {
                
                if (self.cityBlock) {
                    
                    HotCityModel *model = [STLocationMananger shareManager].hotCityArray[index];
                    
                    self.cityBlock(model.provinceName,model.cityName);
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
                
            }];
            
            return view;
        }
        
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (self.isSearch) {//搜索状态
        
        return 0.005f;
        
    } else {//不是搜索状态
        
        if (section == 0) {
            
            return [CityHeadView cityHeadViewHeightWithButtonCount:[STLocationMananger shareManager].hotCityArray.count];
            
        } else {
            
            return 0.005f;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.005f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isSearch) {//搜索状态
        
        HotCityModel *model = self.searchResultArray[indexPath.row];
        
        if (self.cityBlock) {
            
            self.cityBlock(model.provinceName,model.cityName);
            
            [self searchBarDidBeginRestore:NO];//恢复之前的状态
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } else {//不是搜索状态
        
        if (indexPath.row == 0) {
            
            self.isOpen = !self.isOpen;//设置相反
            
            self.selectorIndexPath = indexPath;
            
            [self.tableView reloadData];
            
        } else {

            ProvinceModel *provinceModel = [STLocationMananger shareManager].locationArray[indexPath.section];
            
            CityModel *cityModel = provinceModel.cityList[indexPath.row - 1];
            
            if (self.cityBlock) {//点击回调
                
                self.cityBlock(provinceModel.regionName,cityModel.regionName);
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
