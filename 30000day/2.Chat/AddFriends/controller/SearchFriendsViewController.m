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
#import "NSString+URLEncoding.h"
#import "MTProgressHUD.h"
#import "NewFriendManager.h"
#import "PersonDetailViewController.h"

@interface SearchFriendsViewController () <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIView *searchBackgroundView;//搜索框的背景视图

@property (nonatomic,strong) NSMutableArray *searchResultArray;//搜索结果数组

@property (nonatomic,assign) BOOL isSearch;//搜索状态

@property (weak, nonatomic) IBOutlet UIView *noResultView;//无搜索结果的时候显示的视图

@property (nonatomic,strong) UITextField *textField; //搜索的textField

@property (nonatomic,assign) NSInteger requestCount; //上拉刷新次数

@end

@implementation SearchFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self footerRereshing];
        
    }];
    [self.view addSubview:self.tableView];
    
    self.requestCount = 1; //默认显示第一页
    self.isSearch = NO;//刚进来的时候不是搜索状态
    self.searchResultArray = [NSMutableArray array];
    self.noResultView.hidden = YES;
    [self setUpUI];
    
    //[self.textField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0];
    [self.textField becomeFirstResponder];
}

- (void)setUpUI {
    
    self.searchBackgroundView.frame = CGRectMake(0, 0,500, 32);
    self.searchBackgroundView.layer.cornerRadius = 5;
    self.searchBackgroundView.layer.masksToBounds = YES;
    self.searchBackgroundView.layer.borderColor = RGBACOLOR(200, 200, 200, 1).CGColor;
    self.searchBackgroundView.layer.borderWidth = 0.5f;
    
    //搜索视图
    UITextField *textField = [[UITextField alloc] init];
    
    textField.returnKeyType = UIReturnKeySearch;
    textField.font = [UIFont systemFontOfSize:15.0f];
    textField.placeholder = @"搜索好友/账号";
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    //[textField becomeFirstResponder];
    textField.delegate = self;
    self.textField = textField;
    [self.searchBackgroundView addSubview:textField];
    
    //右部搜索按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchAction)];
    rightButton.tintColor = LOWBLUECOLOR;
    self.navigationItem.rightBarButtonItem = rightButton;
    
    //左边的搜索图标
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"search"];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.searchBackgroundView addSubview:imageView];
    
    NSArray *contrains_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[imageView(14)]-[textField]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView,textField)];
    NSArray *contrains_imageView_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[imageView(14)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)];
    NSArray *contrains_textField_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[textField(30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(textField)];
    NSLayoutConstraint *contrains_imageView_Y = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.searchBackgroundView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    NSLayoutConstraint *contrains_textField_Y = [NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.searchBackgroundView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    
    [self.searchBackgroundView addConstraints:contrains_H];
    [self.searchBackgroundView addConstraints:contrains_imageView_V];
    [self.searchBackgroundView addConstraints:contrains_textField_V];
    [self.searchBackgroundView addConstraint:contrains_imageView_Y];
    [self.searchBackgroundView addConstraint:contrains_textField_Y];
    //设置title
    self.navigationItem.titleView = self.searchBackgroundView;
    
    //添加点击事件
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
//    [self.noResultView addGestureRecognizer:tap];
//    [self.view addGestureRecognizer:tap];
}

//- (BOOL)becomeFirstResponder {
//    [super becomeFirstResponder];
//    return [self.textField becomeFirstResponder];
//}

- (void)tapAction {
    [self.textField resignFirstResponder];
}

- (void)footerRereshing {

    [self searchActionRequest];
}

- (void)searchActionRequest {

    //意思是如果搜素的string为空那么就是不处于搜索状态，反之亦然
    self.isSearch = [Common isObjectNull:self.textField.text] ? NO : YES;
    
    if (self.isSearch) {
        
        //只要开始搜索先隐藏noResultView
        self.noResultView.hidden = YES;
        [self.view endEditing:YES];
        //currentPage:[NSNumber numberWithInteger:self.requestCount]
        //开始搜索
        [STDataHandler sendSearchUserRequestWithNickName:[self.textField.text urlEncodeUsingEncoding:NSUTF8StringEncoding] currentUserId:[Common readAppDataForKey:KEY_SIGNIN_USER_UID] currentPage:[NSNumber numberWithInteger:self.requestCount]
                                                 success:^(NSMutableArray *dataArray) {
                                                     
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         
                                                         for (int i = 0; i < dataArray.count; i++) {
                                                             
                                                             [self.searchResultArray addObject:dataArray[i]];
                                                             
                                                         }
                                                         
                                                         
                                                         [self.tableView reloadData];
                                                         self.noResultView.hidden = self.searchResultArray.count ? YES : NO;
                                                         [self.tableView.mj_footer endRefreshing];
                                                         self.requestCount ++;
                                                     });
                                                     
                                                 } failure:^(NSError *error) {
                                                     
                                                     self.searchResultArray = [NSMutableArray array];
                                                     
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         
                                                         self.noResultView.hidden = self.searchResultArray.count ? YES : NO;
                                                         [self.tableView reloadData];
                                                         //显示错误信息
                                                         [self showToast:[Common errorStringWithError:error optionalString:@"搜索出现问题"]];
                                                         [self.tableView.mj_footer endRefreshing];
                                                     });
                                                 }];
        
    } else {
        
        //不是搜索状态隐藏noResultView
        self.noResultView.hidden = YES;
    }
    
    [self.tableView reloadData];
    [self.textField resignFirstResponder];
    
}

- (void)searchAction {
    
    [self.textField resignFirstResponder];
    
    self.requestCount = 1;
    
    //意思是如果搜素的string为空那么就是不处于搜索状态，反之亦然
    self.isSearch = [Common isObjectNull:self.textField.text] ? NO : YES;
    
    if (self.isSearch) {
        
        //只要开始搜索先隐藏noResultView
        self.noResultView.hidden = YES;
        [self.view endEditing:YES];
        //currentPage:[NSNumber numberWithInteger:self.requestCount]
        //开始搜索
        [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
        [STDataHandler sendSearchUserRequestWithNickName:[self.textField.text urlEncodeUsingEncoding:NSUTF8StringEncoding] currentUserId:[Common readAppDataForKey:KEY_SIGNIN_USER_UID] currentPage:[NSNumber numberWithInteger:self.requestCount]
                                                 success:^(NSMutableArray *dataArray) {
                                                     
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         self.searchResultArray = dataArray;
                                                        [self.tableView reloadData];
                                                         self.noResultView.hidden = self.searchResultArray.count ? YES : NO;
                                                         [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                                                         self.requestCount = 2;
       
                                                     });

                                                 } failure:^(NSError *error) {
                                                     
                                                     self.searchResultArray = [NSMutableArray array];
                                                     
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         
                                                         self.noResultView.hidden = self.searchResultArray.count ? YES : NO;
                                                         [self.tableView reloadData];
                                                         //显示错误信息
                                                         [self showToast:[Common errorStringWithError:error optionalString:@"搜索出现问题"]];
                                                         [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                                                     });
                                                 }];
        
    } else {
        
        //不是搜索状态隐藏noResultView
        self.noResultView.hidden = YES;
    }
    
    [self.tableView reloadData];
}

- (UIView *)searchBackgroundView {
    
    if (!_searchBackgroundView) {
        
        _searchBackgroundView = [[UIView alloc] init];
        _searchBackgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _searchBackgroundView;
}

//移除本控制器和本视图
- (void)cancelControllerAndView {
    
    [self.view endEditing:YES];
}

#pragma ---
#pragma mark --- UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self searchAction];
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
    
    static NSString *searchResultIdentifier = @"SearchResultTableViewCell";
    SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchResultIdentifier];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:searchResultIdentifier owner:self options:nil] lastObject];
    }
    
    UserInformationModel *model = self.searchResultArray[indexPath.row];
    cell.userInformationModel = model;
    __weak typeof(cell) weakCell = cell;
    
    //点击添加按钮回调
    [cell setAddUserBlock:^{
        
        [self.view endEditing:YES];
        
        if ([Common isObjectNull:STUserAccountHandler.userProfile.userId] || [Common isObjectNull:model.userId]) {
            
            [self showToast:@"对方或自己的id为空~"];
            return;
        }
        
        if ([STUserAccountHandler.userProfile.userId isEqualToNumber:model.userId]) {
            
            [self showToast:@"不能添加自己~"];
            
            return;
        }
        
        [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
        //添加好友,接口, @1请求   @2接受   @3拒绝
        [STDataHandler sendPushMessageWithCurrentUserId:STUserAccountHandler.userProfile.userId
                                                       userId:model.userId
                                                    messageType:@1
                                                      success:^(BOOL success) {
  
                                                       if ([Common isObjectNull:[UserInformationModel errorStringWithModel:model userProfile:STUserAccountHandler.userProfile]]) {
                                                              
                                                              if ([model.friendSwitch isEqualToString:@"1"]) {//打开的
                                                              
                                                                  [NewFriendManager drictRefresh:model andCallback:^(BOOL succeeded, NSError *error) {
                                                                     
                                                                      if (succeeded) {
                                                                          
                                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                                              
                                                                              [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                                                                              [self showToast:@"好友添加成功"];
                                                                              [STNotificationCenter postNotificationName:STDidApplyAddFriendSuccessSendNotification object:nil];
                                                                          });
                                                                          
                                                                      } else {
                                                                          
                                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                                              
                                                                              [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                                                                              [self showToast:@"消息发送失败"];
                                                                              
                                                                          });
                                                                      }
                                                                      
                                                                  }];

                                                              } else {//等于0，获取没设置
                                                                  
                                                                  [NewFriendManager subscribePresenceToUserWithUserProfile:model andCallback:^(BOOL succeeded, NSError *error) {
                                                                      
                                                                      if (succeeded) {
                                                                          
                                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                                              
                                                                              [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                                                                              [self showToast:@"请求发送成功"];
                                                                              
                                                                          });
                                                                          
                                                                      } else {
                                                                          
                                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                                              
                                                                              [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                                                                              [self showToast:error.userInfo[NSLocalizedDescriptionKey]];
                                                                              
                                                                          });
                                                                      }
                                                                  }];
                                                              }
                                                              
                                                          } else {
                                                              
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  
                                                                  [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                                                                  [self showToast:[UserInformationModel errorStringWithModel:model userProfile:STUserAccountHandler.userProfile]];
                                                              });
                                                          }

        } failure:^(NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
            
                [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                [self showToast:[error userInfo][NSLocalizedDescriptionKey]];
                weakCell.addButton.hidden = NO;

            });
            
        }];
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 72.1f;
}

- (void)dealloc {
    
    [STNotificationCenter removeObserver:self];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.textField resignFirstResponder];
    
    UserInformationModel *model = self.searchResultArray[indexPath.row];
    
    PersonDetailViewController *controller = [[PersonDetailViewController alloc] init];
    
    controller.informationModel = model;
    
    controller.isShowRightBarButton = NO;
    
    controller.isStranger = YES;
    
    [self.navigationController pushViewController:controller animated:YES];

    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.textField resignFirstResponder];
}

@end
