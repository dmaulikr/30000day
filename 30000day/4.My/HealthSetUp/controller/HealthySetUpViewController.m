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
#import "GetFactorObject.h"
#import "MTProgressHUD.h"

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
    
    barButton.tintColor = LOWBLUECOLOR;
    
    self.barButton = barButton;
    
    barButton.enabled = NO;
    
    self.navigationItem.rightBarButtonItem = barButton;
    
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    
    
    NSString *isFirstStartString = [Common readAppDataForKey:FIRSTHEALTH];
    
    if ([Common isObjectNull:isFirstStartString]) {
        
        [Common saveAppDataForKey:FIRSTHEALTH withObject:@"1"];
        
        //提示用户
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"为您的隐私着想，您可以在 我的->设置->打开健康因素密码验证，密码为您的登录密码。" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        
        [alertView show];
        
    }
    
    //下载健康因素
    [self loadFactor];
}

//保存健康因素
- (void)saveFactor {
    
    //判断是否可以保存
    GetFactorModel *heightModel = self.getFactorArray[self.getFactorArray.count - 4];//身高
    
    GetFactorModel *weightModel = self.getFactorArray[self.getFactorArray.count - 3];//体重
    
    GetFactorModel *numberModel = self.getFactorArray[self.getFactorArray.count - 2];//被动吸烟根数
    
    GetFactorModel *yearModel = self.getFactorArray[self.getFactorArray.count - 1];//被动吸烟年数
    
    if ([Common isObjectNull:heightModel.userSubFactorModel.factor] && ![Common isObjectNull:weightModel.userSubFactorModel.factor]) {
        
        [self showToast:@"请完善身高（身高和体重须同时存在）"];
        
        return;
        
    } else if (![Common isObjectNull:heightModel.userSubFactorModel.factor] && [Common isObjectNull:weightModel.userSubFactorModel.factor]) {
        
        [self showToast:@"请完善体重（身高和体重须同时存在）"];
        
        return;
    }
    
    if ([Common isObjectNull:numberModel.userSubFactorModel.factor] && ![Common isObjectNull:yearModel.userSubFactorModel.factor]) {
        
        [self showToast:@"请完善被动吸烟根数（被动吸烟根数和年数须同时存在）"];
        
        return;
        
    } else if (![Common isObjectNull:numberModel.userSubFactorModel.factor] && [Common isObjectNull:yearModel.userSubFactorModel.factor]) {
        
        [self showToast:@"请完善被动吸烟年数（被动吸烟根数和被动吸烟年数须同时存在）"];
        
        return;
    }
    
    [STDataHandler sendSaveUserFactorsWithUserId:STUserAccountHandler.userProfile.userId factorsModelArray:self.getFactorArray success:^(NSString *dataString) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self showToast:@"保存成功"];
            
            self.barButton.enabled = NO;
        });

    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self showToast:error.userInfo[NSLocalizedDescriptionKey]];
        });
    }];
}

//下载健康因素
- (void)loadFactor {
    
    [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"factorId" ascending:YES];
    
    NSArray *factorArray = [GetFactorObject filterWithContext:[STCoreDataHandler shareCoreDataHandler].mainObjectContext predicate:[NSPredicate predicateWithFormat:@"level == 1"] orderby:@[sort] offset:0 limit:0];
    
    self.getFactorArray = [[NSMutableArray alloc] init];
    
    for (GetFactorObject *object in factorArray) {
        
        if (![Common isObjectNull:STUserAccountHandler.userProfile.gender]) {//当前已经登录
            
            if ([object.gender isEqualToNumber:@2] || [object.gender isEqualToNumber:STUserAccountHandler.userProfile.gender]) {//过滤当前性别
                
                GetFactorModel *model = [[GetFactorModel alloc] init];
                model.factorId = object.factorId;
                model.factor = object.factor;
                model.level = object.level;
                model.pid = object.pid;
                
                NSArray *subFactorArray = [GetFactorObject filterWithContext:[STCoreDataHandler shareCoreDataHandler].mainObjectContext predicate:[NSPredicate predicateWithFormat:@"level == 2 AND pid == %@",model.factorId] orderby:@[sort] offset:0 limit:0];
                model.subFactorArray  = [[NSMutableArray alloc] init];
                
                for (int j = 0; j < subFactorArray.count; j++) {
                    
                    GetFactorObject *_object = subFactorArray[j];
                    
                    GetFactorModel *_model = [[GetFactorModel alloc] init];
                    
                    _model.factorId = _object.factorId;
                    
                    _model.factor = _object.factor;
                    
                    _model.level = _object.level;
                    
                    _model.pid = _object.pid;
                    
                    [model.subFactorArray addObject:_model];
                }
                
                [self.getFactorArray addObject:model];
            }
            
        }
    }
    //先把数据源后面4个加上去【身高、体重、被动吸烟数、 被动吸烟年数】
    [self.getFactorArray addObjectsFromArray:[GetFactorModel configFactorModelArray]];
    
    [STDataHandler sendGetUserFactorsWithUserId:STUserAccountHandler.userProfile.userId factorsModelArray:self.getFactorArray success:^(NSMutableArray *dataArray) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.getFactorArray = dataArray;
            
            [self.tableView reloadData];
            
            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        });
        
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        });
    }];
}

//设置QGPickView,并显示QGPickView
- (void)setQGPickViewWith:(GetFactorModel *)factorModel indexPath:(NSIndexPath *)indexPath {
    
    QGPickerView *picker = [[QGPickerView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 250, SCREEN_WIDTH, 250)];
    
    picker.delegate = self;
    
    picker.titleText = factorModel.factor;
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0;  i < factorModel.subFactorArray.count; i++) {
        
        NSString *title = [(GetFactorModel *)factorModel.subFactorArray[i] factor];
        
        [array addObject:title];
    }
    
    if (indexPath.row == self.getFactorArray.count - 3) {//体重
        
        [picker showPickView:[UIApplication sharedApplication].keyWindow withPickerViewNum:1 withArray:array withArray:nil withArray:nil selectedTitle:[Common isObjectNull:factorModel.userSubFactorModel.factor] ? @"66" : factorModel.userSubFactorModel.factor selectedTitle:nil selectedTitle:nil];
    
    } else if (indexPath.row == self.getFactorArray.count - 4) {//身高
        
        [picker showPickView:[UIApplication sharedApplication].keyWindow withPickerViewNum:1 withArray:array withArray:nil withArray:nil selectedTitle:[Common isObjectNull:factorModel.userSubFactorModel.factor] ? @"177" : factorModel.userSubFactorModel.factor selectedTitle:nil selectedTitle:nil];
        
    } else {//其余的
        
        [picker showPickView:[UIApplication sharedApplication].keyWindow withPickerViewNum:1 withArray:array withArray:nil withArray:nil selectedTitle:factorModel.userSubFactorModel.factor selectedTitle:nil selectedTitle:nil];
    }
    
    [Common saveAppIntegerDataForKey:HEALTHSETINDICATE withObject:indexPath.row];
}

#pragma ---
#pragma mark --- QGPickerViewDelegate

- (void)didSelectPickView:(QGPickerView *)pickView  value:(NSString *)value indexOfPickerView:(NSInteger)index indexOfValue:(NSInteger)valueIndex {
    
    if (index == 1) {
        
        GetFactorModel *factorModel = self.getFactorArray[[Common readAppIntegerDataForKey:HEALTHSETINDICATE]];
        
        if (([Common readAppIntegerDataForKey:HEALTHSETINDICATE] <= self.getFactorArray.count - 1) && (self.getFactorArray.count - 4<= [Common readAppIntegerDataForKey:HEALTHSETINDICATE])) {
            
            if (![factorModel.userSubFactorModel.factor isEqualToString:value]) {
                
                self.barButton.enabled = YES;//表示如果本次选择的和上次选择的不一样,那么就打开保存按钮
            }
            
            factorModel.userSubFactorModel.factor = value;
            
            [self.tableView reloadData];
            
        } else {
            
            if (![factorModel.userSubFactorModel.factor isEqualToString:value] && ![factorModel.userSubFactorModel.factorId isEqualToNumber:[GetFactorModel subFactorIdWithTitleString:value subFactorArray:factorModel.subFactorArray]]) {
                
                self.barButton.enabled = YES;//表示如果本次选择的和上次选择的不一样,那么就打开保存按钮
            }
            
            factorModel.userSubFactorModel.factor = value;
            
            factorModel.userSubFactorModel.factorId  = [GetFactorModel subFactorIdWithTitleString:value subFactorArray:factorModel.subFactorArray];
            
            [self.tableView reloadData];
        }
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
