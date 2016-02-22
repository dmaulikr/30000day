//
//  healthySetUpViewController.m
//  30000天
//
//  Created by wei on 16/1/27.
//  Copyright © 2016年 wei. All rights reserved.
//

#import "HealthySetUpViewController.h"
#import "HealthyTableViewCell.h"
#import "GetFactorModel.h"

@interface HealthySetUpViewController () <UITableViewDataSource,UITableViewDelegate,QGPickerViewDelegate>

@property (nonatomic , strong) NSMutableArray *getFactorArray;//从服务器获取到的健康因子

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) UIBarButtonItem *barButton;

@end

@implementation HealthySetUpViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"健康因素";
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveFactor)];
    
    self.barButton = barButton;
    
    barButton.enabled = NO;
    
    self.navigationItem.rightBarButtonItem = barButton;
    
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    
    //下载健康因素
    [self loadFactor];
}

//保存健康因素
- (void)saveFactor {
    
    [self.dataHandler sendSaveUserFactorsWithUserId:[Common readAppDataForKey:KEY_SIGNIN_USER_UID] factorsModelArray:self.getFactorArray success:^(BOOL success) {
        
        [self showToast:@"保存成功"];
        
        self.barButton.enabled = NO;
        
    } failure:^(LONetError *error) {
        
        [self showToast:@"保存失败"];
        
    }];
}

- (void)loadFactor {
    
    //获取所有的健康因子
    [self.dataHandler sendGetFactors:^(NSMutableArray *dataArray) {
       
        self.getFactorArray = dataArray;
        
        [self.tableView reloadData];
        
    } failure:^(LONetError *error) {
        
        [self showToast:error.error.userInfo[NSLocalizedDescriptionKey]];
        
    }];
}

//设置QGPickView,并显示QGPickView
- (void)setQGPickViewWith:(GetFactorModel *)factorModel indexPath:(NSIndexPath *)indexPath {
    
    QGPickerView *picker = [[QGPickerView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 250, SCREEN_WIDTH, 250)];
    
    picker.delegate = self;
    
    picker.titleText = factorModel.title;
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0;  i < factorModel.subFactorArray.count; i++) {
        
        NSString *title = [(SubFactorModel *)factorModel.subFactorArray[i] title];
        
        [array addObject:title];
    }
    
    //显示QGPickerView
    [picker showOnView:[UIApplication sharedApplication].keyWindow withPickerViewNum:1 withArray:array withArray:nil withArray:nil selectedTitle:factorModel.userSubFactorModel.title selectedTitle:nil selectedTitle:nil];
    
    [Common saveAppIntegerDataForKey:HEALTHSETINDICATE withObject:indexPath.row];
}

#pragma ---
#pragma mark --- QGPickerViewDelegate

- (void)didSelectPickView:(QGPickerView *)pickView  value:(NSString *)value indexOfPickerView:(NSInteger)index indexOfValue:(NSInteger)valueIndex {
    
    if (index == 1) {
    
        GetFactorModel *factorModel = self.getFactorArray[[Common readAppIntegerDataForKey:HEALTHSETINDICATE]];
        
        if (![factorModel.userSubFactorModel.title isEqualToString:value] && ![factorModel.userSubFactorModel.data isEqualToNumber:[GetFactorModel dataNumberWithTitleString:value subFactorArray:factorModel.subFactorArray]]) {
            
            self.barButton.enabled = YES;//表示如果本次选择的和上次选择的不一样,那么就打开保存按钮
        }
        
        factorModel.userSubFactorModel.title = value;
        
        factorModel.userSubFactorModel.data  = [GetFactorModel dataNumberWithTitleString:value subFactorArray:factorModel.subFactorArray];
        
        [self.tableView reloadData];
    }
}

#pragma ---
#pragma mark -- UITableViewDelegate / UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.getFactorArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *healthyIdentifier = @"HealthyTableViewCell";

    HealthyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:healthyIdentifier];
    
    if (cell == nil) {
    
        cell = [[[NSBundle mainBundle] loadNibNamed:healthyIdentifier owner:self options:nil] lastObject];
    }
    
    GetFactorModel *factorModel = self.getFactorArray[indexPath.row];
    
    cell.cellIndexPath = indexPath;
    
    cell.factorModel = factorModel;
    
    //按钮点击回调
    [cell setSetButtonClick:^(NSIndexPath *cellIndexPath) {
        
        [self setQGPickViewWith:self.getFactorArray[cellIndexPath.row] indexPath:indexPath];
        
    }];

    return cell;

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
