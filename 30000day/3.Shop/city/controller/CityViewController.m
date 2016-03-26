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
}

#pragma ---
#pragma mark --- UITableViewDataSource / UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [STLocationMananger shareManager].locationArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityTableViewCell"];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CityTableViewCell" owner:nil options:nil] lastObject];
    }
    
    ProvinceModel *provinceModel = [STLocationMananger shareManager].locationArray[indexPath.section];
    
    if (self.isOpen && self.selectorIndexPath.section == indexPath.section ) {//打开
        
        if (indexPath.row == 0) {
            
            cell.willShowImageView.hidden = NO;
            
            cell.willShowImageView.image = [UIImage imageNamed:@"navigationbar_arrow_up"];
            
            cell.willShowLabel.text = provinceModel.name;
        
        } else {
            
            cell.willShowImageView.hidden = YES;
            
            CityModel *cityModel = provinceModel.cityList[indexPath.row - 1];
            
            cell.willShowLabel.text = cityModel.name;
        }
    
    } else {//关闭
        
        if (indexPath.row == 0) {
            
            cell.willShowImageView.hidden = NO;
            
            cell.willShowImageView.image = [UIImage imageNamed:@"navigationbar_arrow_down"];
            
            cell.willShowLabel.text = provinceModel.name;
            
        } else {
            
            cell.willShowImageView.hidden = YES;
            
            CityModel *cityModel = provinceModel.cityList[indexPath.row - 1];
            
            cell.willShowLabel.text = cityModel.name;
        }
    }

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        CityHeadView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CityHeadView"];
        
        if (!view) {
            
            view = [[CityHeadView alloc] init];
        }
        view.cityArray = [NSMutableArray arrayWithArray:@[@"上海",@"北京",@"广州",@"深圳",@"天津",@"南京",@"杭州",@"合肥",@"水电费",@"发广告",@"东方闪"]];
        
        [view setButtonActionBlock:^(NSUInteger index) {
           
            NSLog(@"----%d",(int)index);
            
        }];

        return view;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return [CityHeadView cityHeadViewHeightWithButtonCount:10];
        
    } else {
     
        return 0.005f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.005f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        self.isOpen = !self.isOpen;//设置相反
        
        self.selectorIndexPath = indexPath;
        
        [self.tableView reloadData];
        
    } else {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        ProvinceModel *provinceModel = [STLocationMananger shareManager].locationArray[indexPath.section];
        
        CityModel *cityModel = provinceModel.cityList[indexPath.row - 1];
        
        if (self.cityBlock) {//点击回调
            
            self.cityBlock(provinceModel.name,cityModel.name);
            
            [self.navigationController popViewControllerAnimated:YES];
            
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
