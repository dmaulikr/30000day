//
//  SearchFriendsViewController.m
//  30000day
//
//  Created by GuoJia on 16/2/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SearchFriendsViewController.h"
#import "SearchResultTableViewCell.h"
#import "UserInformationModel.h"

@interface SearchFriendsViewController () <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *searchBackgroundView;//搜索框的背景视图

@property (weak, nonatomic) IBOutlet UIView *backgroundView;//模态视图

@property (weak, nonatomic) IBOutlet UITableView *tableView;//主表格视图

@property (nonatomic,strong) NSMutableArray *searchResultArray;//搜索结果数组

@property (nonatomic,assign) BOOL isSearch;//搜索状态

@property (weak, nonatomic) IBOutlet UIView *noResultView;//无搜索结果的时候显示的视图

@property (weak, nonatomic) IBOutlet UITextField *textField;//搜索的textField

@end

@implementation SearchFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBackgroundView.layer.cornerRadius = 5;
    
    self.searchBackgroundView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    
    [self.backgroundView addGestureRecognizer:tap];
    
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    
    self.isSearch = NO;//刚进来的时候不是搜索状态
    
    self.noResultView.hidden = YES;
    
    [self.textField becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChangeText) name:UITextFieldTextDidChangeNotification object:nil];
}

//点击事件
- (void)tapAction {
    
    [self cancelControllerAndView];
}

//移除本控制器和本视图
- (void)cancelControllerAndView {
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self removeFromParentViewController];
    
    [self.view removeFromSuperview];
    
    [self.view endEditing:YES];
}

//取消按钮点击方法
- (IBAction)cancelAction:(id)sender {
    
    [self cancelControllerAndView];
}

#pragma ---
#pragma mark --- UITextFieldTextDidChangeNotification

- (void)textFieldChangeText {
    
    //意思是如果搜素的string为空那么就是不处于搜索状态，反之亦然
    self.isSearch = [Common isObjectNull:self.textField.text] ? NO : YES;
    
    if (self.isSearch) {
        
        //只要开始搜索先隐藏noResultView
        self.noResultView.hidden = YES;
        
        //只要开始搜索先隐藏backgroundView
        self.backgroundView.hidden = YES;
         
        //开始搜索
        [self.dataHandler sendSearchUserRequestWithNickName:self.textField.text
                                              currentUserId:[Common readAppDataForKey:KEY_SIGNIN_USER_UID]
                                                    success:^(NSMutableArray *dataArray) {
            
            self.searchResultArray = [NSMutableArray arrayWithArray:dataArray];
            
            self.noResultView.hidden = self.searchResultArray.count ? YES : NO;
            
            [self.tableView reloadData];
            
        } failure:^(LONetError *error) {
            
            self.searchResultArray = [NSMutableArray array];
            
            self.noResultView.hidden = self.searchResultArray.count ? YES : NO;
            
            [self.tableView reloadData];
            
        }];
        
    } else {
        
        //不是搜索状态隐藏noResultView
        self.noResultView.hidden = YES;
        
        //不是搜索状态显示backgroundView
        self.backgroundView.hidden = NO;
    }
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    static NSString *searchResultIdentifier = @"SearchResultTableViewCell";
    
    SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchResultIdentifier];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:searchResultIdentifier owner:self options:nil] lastObject];
    }
    
    cell.userInformationModel = self.searchResultArray[indexPath.row];
    
    //点击添加按钮回调
    [cell setAddUserBlock:^(UserInformationModel *userInformationModel){
        
        //添加好友,接口
        [self.dataHandler sendAddUserRequestWithcurrentUserId:[Common readAppDataForKey:KEY_SIGNIN_USER_UID] userId:[userInformationModel.userId stringValue] nickName:userInformationModel.nickName success:^(BOOL success) {
            
            [self showToast:@"添加成功"];
            
        } failure:^(LONetError *error) {
            
            [self showToast:@"添加失败"];
            
        }];
        
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
