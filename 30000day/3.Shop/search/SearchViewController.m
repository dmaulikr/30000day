//
//  SearchViewController.m
//  30000day
//
//  Created by GuoJia on 16/3/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SearchViewController.h"
#import "ShopListTableViewCell.h"
#import "ShopDetailViewController.h"

@interface SearchViewController () < UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL isSearch;

@property (nonatomic,strong) NSMutableArray *dataArray;//数据源数组

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isSearch = NO;
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.isShowBackItem = YES;
   
    //搜索框
    UITextField *textField = [[UITextField alloc] init];
    
    textField.frame = CGRectMake(0, 0, SCREEN_WIDTH - 100, 30);
    
    textField.placeholder = @"请输入搜索的关键字";
    
    textField.delegate = self;
    
    textField.font = [UIFont systemFontOfSize:15.0f];
    
    textField.borderStyle = UITextBorderStyleRoundedRect;
    
    textField.returnKeyType = UIReturnKeySearch;
    
    [textField becomeFirstResponder];
    
    self.navigationItem.titleView = textField;
}

#pragma mark --- 调用父类的方法

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([Common isObjectNull:textField.text]) {
        
        self.isSearch = NO;
        
        [self.tableView reloadData];
        
    } else {
        
        self.isSearch = YES;
        
        self.dataArray = [NSMutableArray arrayWithArray:@[@1,@2,@3]];
        
        [self.tableView reloadData];
    }
    
    return YES;
}

#pragma ---
#pragma makr --- UITableViewDataSource/UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isSearch) {
     
        return self.dataArray.count;
        
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.isSearch) {
        
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isSearch) {
        
        ShopListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopListTableViewCell"];
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ShopListTableViewCell" owner:nil options:nil] lastObject];
        }
        
        return cell;
    }
    
    return nil;
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
