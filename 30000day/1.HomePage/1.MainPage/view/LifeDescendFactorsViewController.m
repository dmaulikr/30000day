//
//  LifeDescendFactorsViewController.m
//  30000day
//
//  Created by wei on 16/5/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "LifeDescendFactorsViewController.h"
#import "LifeDescendFactorsTableViewCell.h"
#import "LifeDescendFactorsModel.h"
#import "MTProgressHUD.h"

@interface LifeDescendFactorsViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *modelArray;

@end

@implementation LifeDescendFactorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"可改善因素";
    
    [self.tableView setBackgroundColor:[UIColor redColor]];
    
    self.tableViewStyle = STRefreshTableViewPlain;
    
    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;
    
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
    self.isShowBackItem = YES;
    
    [self showHeadRefresh:NO showFooterRefresh:NO];
    
    [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
    [STDataHandler sendLifeDescendFactorsWithUserId:STUserAccountHandler.userProfile.userId success:^(NSArray *lifeDescendFactorsArray) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (lifeDescendFactorsArray.count == 0) {
                
                self.nilLable.hidden = NO;
                self.tableView.hidden = YES;
                
            } else {
                
                self.nilLable.hidden = YES;
                self.tableView.hidden = NO;
                
                self.modelArray = [NSArray arrayWithArray:lifeDescendFactorsArray];
                
                [self.tableView reloadData];
                
            }
            
            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
            
        });
        
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{

            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
            
            self.nilLable.hidden = NO;
            self.tableView.hidden = YES;
            self.nilLable.text =error.userInfo[@"NSLocalizedDescription"];
            
        });
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LifeDescendFactorsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LifeDescendFactorsTableViewCell" ];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LifeDescendFactorsTableViewCell" owner:self options:nil] lastObject];
    }
    
    LifeDescendFactorsModel *model= self.modelArray[indexPath.row];
    cell.lifeModel = model;
    
    return cell;
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
