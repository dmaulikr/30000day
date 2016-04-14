//
//  SubscriptionCentralityViewController.m
//  30000day
//
//  Created by wei on 16/4/14.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SubscriptionCentralityViewController.h"
#import "SubscribeListTableViewCell.h"

@interface SubscriptionCentralityViewController () <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *searchBackgroundView;//搜索框的背景视图

@property (weak, nonatomic) IBOutlet UITableView *tableView;//主表格视图

@property (nonatomic,strong) NSMutableArray *searchResultArray;//搜索结果数组

@property (nonatomic,assign) BOOL isSearch;//搜索状态

@property (weak, nonatomic) IBOutlet UIView *noResultView;//无搜索结果的时候显示的视图

@property (weak, nonatomic) IBOutlet UITextField *textField;//搜索的textField

@end

@implementation SubscriptionCentralityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.searchBackgroundView.layer.cornerRadius = 5;
    
    self.searchBackgroundView.layer.masksToBounds = YES;
    
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    
    self.isSearch = NO;//刚进来的时候不是搜索状态
    
    self.noResultView.hidden = YES;
    
    [self.textField becomeFirstResponder];
    
}

- (IBAction)cancelAction:(UIButton *)sender {
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma ---
#pragma mark --- UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //意思是如果搜素的string为空那么就是不处于搜索状态，反之亦然
    self.isSearch = [Common isObjectNull:self.textField.text] ? NO : YES;
    
    if (self.isSearch) {
        
        
        
    } else {
        
        
    }
    
    [self.tableView reloadData];
    
    return YES;
}

#pragma ---
#pragma mark --- UITableViewDelegate / UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.isSearch ? self.searchResultArray.count : 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    static NSString *searchResultIdentifier = @"SearchResultTableViewCell";
//    
//    SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchResultIdentifier];
//    
//    if (cell == nil) {
//        
//        cell = [[[NSBundle mainBundle] loadNibNamed:searchResultIdentifier owner:self options:nil] lastObject];
//    }
//    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70;
}

- (void)dealloc {
    
    [STNotificationCenter removeObserver:self];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
